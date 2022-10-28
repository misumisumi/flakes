self: { config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.asus-notify;
in
{
  options = {
    services.asus-notify = {
      enable = mkEnableOption ''
          Notication for asusctl.
        '';
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ asusctl ];
    services.dbus.packages = with pkgs; [ asusctl ];

    systemd.services.asus-notify = {
      description = "Notication for asusctl";
      wantedBy = [ "multi-user.target" ];
      wants = [ "dbus.socket" ];
      environment.IS_SERVICE = "1";
      unitConfig = {
        StartLimitInterval = 200;
        StartLimitBurst = 2;
      };
      serviceConfig = {
        Type = "dbus";
        BusName = "org.asuslinux.Daemon";
        SELinuxContext = "system_u:system_r:unconfined_t:s0";
        ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 2";
        ExecStart = "${pkgs.asusctl}/bin/asus-notify";
        ConfigurationDirectory = "asusd";
        Restart="on-failure";
      };
    };
  };
}
