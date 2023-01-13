{ config, lib, pkgs, ... }:

let
  cfg = config.services.supergfxd-latest;
  json = pkgs.formats.json { };
in
{
  options = {
    services.supergfxd-latest = {
      enable = lib.mkEnableOption (lib.mdDoc "Enable the supergfxd service");

      settings = lib.mkOption {
        type = lib.types.nullOr json.type;
        default = null;
        description = lib.mdDoc ''
          The content of /etc/supergfxd.conf.
          See https://gitlab.com/asus-linux/supergfxctl/#config-options-etcsupergfxdconf.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.supergfxctl-latest ];

    environment.etc."supergfxd.conf" = lib.mkIf (cfg.settings != null) {
      source = json.generate "supergfxd.conf" cfg.settings;
      mode = "0644";
    };

    services.dbus.enable = true;

    systemd.packages = [ pkgs.supergfxctl-latest ];
    systemd.services.supergfxd.wantedBy = [ "multi-user.target" ];

    services.dbus.packages = [ pkgs.supergfxctl-latest ];
    services.udev.packages = [ pkgs.supergfxctl-latest ];
  };

  meta.maintainers = pkgs.supergfxctl-latest.meta.maintainers;
}
