# This is home-manager module
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    flatten
    mkEnableOption
    mkIf
    mkOption
    splitString
    types
    ;
  cfg = config.services.yaskkserv2;
in
{
  options = {
    services.yaskkserv2 = {
      enable = mkEnableOption ''
        enable yaskkserv2 service
      '';
      package = mkOption {
        type = types.package;
        default = pkgs.yaskkserv2;
        description = "Packages to install for yaskkserv2";
      };
      dictionary = mkOption {
        type = types.str;
        default = "${pkgs.yaskkserv2-dict}/share/dictionary.yaskkserv2";
        description = "Path to yaskkserv2 dictionary";
      };
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [
          "--google-japanese-input notfound"
          "--google-cache-filename=/tmp/yaskkserv2.cache"
        ];
        description = "Extra arguments to pass to yaskkserv2";
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.user.services = {
      yaskkserv2 = {
        Unit = {
          Description = "Launch yaskkserv2";
        };
        Service = {
          Type = "simple";
          ExecStart = "${cfg.package}/bin/yaskkserv2 --no-daemonize ${lib.concatStringsSep " " cfg.extraArgs} ${cfg.dictionary}";
          Restart = "on-failure";
        };
        Install.WantedBy = [
          "graphical-session.target"
          "fcitx5-daemon.service"
        ];
      };
    };
    launchd.agents.yaskkserv2 = {
      enable = true;
      config = {
        ProgramArguments = [
          "${cfg.package}/bin/yaskkserv2"
          "--no-daemonize"
        ]
        ++ flatten (map (x: splitString " " x) cfg.extraArgs)
        ++ [
          "${cfg.dictionary}"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/yaskkserv2/stdout";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/yaskkserv2/stderr";
      };
    };
  };
}
