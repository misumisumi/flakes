{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.virtualisation.libvirtd.antiAntiCheat;
  libvirtdConfigScript = config.systemd.services.libvirtd-config.script;

  inherit (lib)
    optionalString
    mkEnableOption
    ;
in
{
  #NOTE: This module uses general BIOS and ACPI information during the build.
  # This is done to enable caching by keeping patched QEMU or OVMF within the same derivation.
  # If you want to apply the same BIOS or ACPI information as the host to a VM, these settings can be configured in each VM's XML.
  # See the following for details.
  # ACPI: https://libvirt.org/formatdomain.html#common-os-element-configuration
  # SMBIOS: https://libvirt.org/formatdomain.html#smbios-system-information
  options.virtualisation.libvirtd.antiAntiCheat = {
    amd.enable = mkEnableOption "Anti-Anti-Cheat patches for OVMF and QEMU on AMD CPU";
    intel.enable = mkEnableOption "Anti-Anti-Cheat patches for OVMF and QEMU on Intel CPU";
  };
  config = {
    assertions = [
      {
        assertion = !(cfg.amd.enable && cfg.intel.enable);
        message = "Only one of amd.enable and intel.enalbe can be enabled";
      }
    ];
    systemd.services.aac-libvirtd-config = {
      after = [ "libvirtd-config.service" ];
      script =
        optionalString cfg.amd.enable ''
          mkdir /run/libvirt/{aac-emulators,aac-ovmf}

          find ${pkgs.aac-qemu-amd}/bin -type f -name "qemu-*" -exec ln -sf {} /run/libvirt/aac-emulators/ \;
          find ${pkgs.aac-OVMF-amd.fd}/FV -type f -name "*.fd" -exec ln -sf {} /run/libvirt/aac-ovmf/ \;
        ''
        + optionalString cfg.intel.enable ''
          mkdir /run/libvirt/{aac-emulators,aac-ovmf}

          find ${pkgs.aac-qemu-intel}/bin -type f -name "qemu-*" -exec ln -sf {} /run/libvirt/aac-emulators/ \;
          find ${pkgs.aac-OVMF-intel.fd}/FV -type f -name "*.fd" -exec ln -sf {} /run/libvirt/aac-ovmf/ \;
        '';
    };
  };
}
