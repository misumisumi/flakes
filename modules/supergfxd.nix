self: { config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.asusd;
  tomlFormat = pkgs.formats.toml {};
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

    # Avoiding adding udev rules file of asusctl as-is due to the reference to systemd.
    # services.udev.packages = with pkgs; [ asusctl ];

    # See ${pkgs.asusctl}/lib/udev/rules.d/99-asusd.rules
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
      before = [ "multi-user.target" ];
      environment.IS_SERVICE = "1";
      Unit = {
        StartLimitInterval = 200;
        StartLimitBurst = 2;
      };
      Service = {
        Type = "dbus";
        BusName = "org.supergfxctl.Daemon";
        SELinuxContext = "system_u:system_r:unconfined_t:s0";
        ExecStart = "${pkgs.asusctl}/bin/asusd";
        Restart = "on-failure";
        RestartSec = "1s";
      };
      Install = {
        WantedBy = [ "multi-user.target" ];
      };
    };
  };
}

