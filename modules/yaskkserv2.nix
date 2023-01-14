# This is home-manager module
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.yaskkserv2;
in
{
  options = {
    services.yaskkserv2 = {
      enable = mkEnableOption ''
        Notication for asusctl.
      '';
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ yaskkserv2 yaskkserv2-dict ];

    systemd.user.services = {
      yaskkserv2 = {
        Unit = {
          Description = "Launch yaskkserv2";
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.yaskkserv2}/bin/yaskkserv2 --midashi-utf8 --no-daemonize ${yaskkserv2-dict}/share/dictionary.yaskkserv2";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}

