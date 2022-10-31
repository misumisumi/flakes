{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.supergfxd;
in
{
  options = {
    services.supergfxd= {
      enable = mkEnableOption ''
          Enable supergfxd systemd unit
        '';
    };
  };

  config = mkIf cfg.enable {
    # Set the ledmodes to the packaged ledmodes by default.
    environment.systemPackages = with pkgs; [ supergfxctl ];
    services.dbus.packages = with pkgs; [ supergfxctl ];

    services.udev.extraRules = ''
      # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
      ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
      ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"

      # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
      ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="on"
    '';

    systemd.services.supergfxd = {
      description = "GPU control for asus laptops";
      wantedBy = [ "multi-user.target" ];
      environment.IS_SUPERGFX_SERVICE = "1";
      unitConfig = {
        StartLimitInterval = 200;
        StartLimitBurst = 2;
      };
      serviceConfig = {
        Type = "dbus";
        BusName = "org.supergfxctl.Daemon";
        SELinuxContext = "system_u:system_r:unconfined_t:s0";
        ExecStart = "${pkgs.supergfxctl}/bin/supergfxd";
        Restart = "on-failure";
        RestartSec = "1";
      };
    };
  };
}

