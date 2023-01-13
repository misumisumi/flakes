# This conf from https://github.com/NixOS/nixpkgs/pull/146751
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.flake-asusd;
  tomlFormat = pkgs.formats.toml { };
in
{
  options = {
    services.flake-asusd = {
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
        default = { };
      };
      package = mkOption {
        type = types.package;
        default = pkgs.asusctl-latest;
        defaultText = literalExpression "pkgs.asusctl-latest";
        example = literalExpression "pkgs.asusctl-latest";
        description = lib.mdDoc ''
          package of asusctl
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Set the ledmodes to the packaged ledmodes by default.
    services.flake-asusd.ledmodes = mkDefault (
      let
        # Convert packaged asusd-ledmodes.toml to JSON.
        json = pkgs.runCommand "asusd-ledmodes.json"
          {
            nativeBuildInputs = [ pkgs.remarshal ];
          } ''
          toml2json "${pkgs.asusctl-latest}/etc/asusd/asusd-ledmodes.toml" "$out"
        '';
        # Convert JSON to Nix attribute-set.
        attrs = builtins.fromJSON (builtins.readFile json);
      in
      attrs
    );

    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];

    # Avoiding adding udev rules file of asusctl as-is due to the reference to systemd.
    # services.udev.packages = with pkgs; [ asusctl ];

    # See ${pkgs.asusctl}/lib/udev/rules.d/99-asusd.rules
    services.udev.extraRules = ''
      ACTION=="add|change", SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="0b05", ENV{ID_MODEL_ID}=="1[89][a-zA-Z0-9][a-zA-Z0-9]|193b", ENV{ID_TYPE}=="hid", TAG+="systemd", ENV{SYSTEMD_WANTS}="asusd.service"
      # ACTION=="add|remove", SUBSYSTEM=="input", ENV{ID_VENDOR_ID}=="0b05", ENV{ID_MODEL_ID}=="1[89][a-zA-Z0-9][a-zA-Z0-9]|193b", RUN+="systemctl restart asusd.service"
    '';

    environment.etc."asusd/asusd-ledmodes.toml".source = tomlFormat.generate "asusd-ledmodes.toml" cfg.ledmodes;

    systemd.services.asusd = {
      description = "Asus Control Daemon";
      wantedBy = [ "multi-user.target" ];
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
        ExecStart = "${cfg.package}/bin/asusd";
        # ConfigurationDirectory = "asusd";
        Restart = "on-failure";
        RestartSec = "1";
      };
    };
  };
}

