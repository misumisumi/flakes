{
  lib,
  fetchurl,
  nix-update-script,
  stdenv,
}@args:
let
  inherit (lib) mapAttrs;

  buildZoteroXpiAddon = lib.makeOverridable (
    {
      stdenv ? args.stdenv,
      pname,
      version,
      src,
      addonId,
      homepage,
      description,
      license,
      updateOptions ? [ ],
      ...
    }:
    stdenv.mkDerivation {
      inherit pname version src;

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = { inherit addonId; };

      buildCommand = ''
        dst="$out/share/zotero/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
      passthru.updateScript = nix-update-script {
        extraArgs = [
          "--flake"
          "--use-github-releases"
        ]
        ++ updateOptions;
      };
      meta = {
        inherit version homepage description;
        license = lib.licenses.${license};
      };
    }
  );
  addonSources = import ./addons.nix {
    inherit fetchurl;
  };
in
rec {
  override = mapAttrs (
    name: source:
    buildZoteroXpiAddon {
      inherit stdenv;
      inherit (source)
        pname
        version
        src
        addonId
        homepage
        description
        license
        ;
      updateOptions = source.updateOptions or [ ];
    }
  ) addonSources;
  packages = nixpkgs: mapAttrs (n: v: nixpkgs.zotero-addons.${n}) override;
}
