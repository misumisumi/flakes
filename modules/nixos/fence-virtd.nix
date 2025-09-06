# This conf from https://github.com/NixOS/nixpkgs/pull/146751
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.fence-virtd;
in
{
  options = {
    services.fence-virtd = {
      enable = mkEnableOption ''
        Enable Fence-Virt system host daemon.
      '';
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra Fence-Virt configuration.
          Run `fence-virtd -c` and write the displayed config here.
          `module_path` should be `${config.services.fence-virtd.package}/lib/fence-virt`.
        '';
      };
      package = mkOption {
        type = types.package;
        default = pkgs.fence-agents.override { agents = "virt"; };
        defaultText = literalExpression "pkgs.asusctl-latest";
        example = literalExpression "pkgs.fence-agents.override { agents = " virt "; }";
        description = lib.mdDoc ''
          package of fence-agents.
          By default only fence-virt is installed.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.etc."fence_virt.conf" = {
      text = cfg.extraConfig;
      mode = "0600";
    };

    systemd.services.fence_virtd = {
      description = "Fence-Virt system host daemon";
      wantedBy = [ "multi-user.target" ];
      after = [
        "basic.target"
        "network.target"
        "syslog.target"
        "libvirt-qmf.service"
        "libvirtd.service"
        "corosync.service"
      ];
      requires = [
        "basic.target"
        "network.target"
      ];
      environment = {
        FENCE_VIRTD_ARGS = "-w";
      };
      serviceConfig = {
        Type = "forking";
        ExecStart = "${cfg.package}/bin/fence_virtd $FENCE_VIRTD_ARGS";
        Restart = "on-failure";
      };
    };
  };
}
