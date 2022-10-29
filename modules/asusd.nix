# This conf from https://github.com/NixOS/nixpkgs/pull/146751
self: { config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.asusd;
  tomlFormat = pkgs.formats.toml {};
in
{
  options = {
    services.asusd = {
      enable = mkEnableOption ''
          an interface for rootless control of system functions for Asus ROG-like laptops.
          This will allow usage of <code>asusctl</code> to control hardware such as fan speeds, keyboard LEDs and graphics modes
        '';
      ledmodes = mkOption {
        type = tomlFormat.type;
        description = ''
          <filename>asusd-ledmodes.toml</filename> as a Nix attribute set.
          See <link xlink:href="https://gitlab.com/asus-linux/asusctl/-/blob/main/data/asusd-ledmodes.toml">asusd-ledmodes.toml</link> for examples.
        '';
        default = {};
      };
    };
  };

  config = mkIf cfg.enable {
    # Set the ledmodes to the packaged ledmodes by default.
    services.asusd.ledmodes = mkDefault (
      let
        # Convert packaged asusd-ledmodes.toml to JSON.
        json = pkgs.runCommand "asusd-ledmodes.json" {
            nativeBuildInputs = [ pkgs.remarshal ];
          } ''
            toml2json "${pkgs.asusctl}/etc/asusd/asusd-ledmodes.toml" "$out"
          '';
        # Convert JSON to Nix attribute-set.
        attrs = builtins.fromJSON (builtins.readFile json);
      in attrs
    );

    environment.systemPackages = with pkgs; [ asusctl ];
    services.dbus.packages = with pkgs; [ asusctl ];

    # Avoiding adding udev rules file of asusctl as-is due to the reference to systemd.
    # services.udev.packages = with pkgs; [ asusctl ];

    # See ${pkgs.asusctl}/lib/udev/rules.d/99-asusd.rules
    services.udev.extraRules = ''
      ACTION=="add|change", SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="0b05", ENV{ID_MODEL_ID}=="1[89][a-zA-Z0-9][a-zA-Z0-9]|193b", ENV{ID_TYPE}=="hid", TAG+="systemd", ENV{SYSTEMD_WANTS}="asusd.service"
      # ACTION=="add|remove", SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="0b05", ENV{ID_MODEL_ID}=="1[89][a-zA-Z0-9][a-zA-Z0-9]|193b", RUN+="systemctl restart asusd.service"
      # ENV{DMI_VENDOR}="$attr{[dmi/id]sys_vendor}"
      # ENV{DMI_VENDOR}!="ASUSTeK COMPUTER INC.", GOTO="asusd_end"

      # ENV{DMI_FAMILY}="$attr{[dmi/id]product_family}"
      # ENV{DMI_FAMILY}=="*TUF*", GOTO="asusd_start"
      # ENV{DMI_FAMILY}=="*ROG*", GOTO="asusd_start"
      # ENV{DMI_FAMILY}=="*Zephyrus*", GOTO="asusd_start"
      # ENV{DMI_FAMILY}=="*Strix*", GOTO="asusd_start"
      # # No match so
      # GOTO="asusd_end"

      # LABEL="asusd_start"
      # ACTION=="add|change", DRIVER=="asus-nb-wmi", TAG+="systemd", ENV{SYSTEMD_WANTS}="asusd.service"
      # ACTION=="add|remove", DRIVER=="asus-nb-wmi", TAG+="systemd", RUN+="systemctl restart asusd.service"

      # LABEL="asusd_end"
    '';

    environment.etc."asusd/asusd-ledmodes.toml".source = tomlFormat.generate "asusd-ledmodes.toml" cfg.ledmodes;

    systemd.services.asusd = {
      description = "Asus Control Daemon";
      before = [ "multi-user.target" ];
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
        ExecStart = "${pkgs.asusctl}/bin/asusd";
        # ConfigurationDirectory = "asusd";
        Restart = "on-failure";
        RestartSec = "1";
      };
    };
  };
}

