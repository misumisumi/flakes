{ fetchgit, fetchurl, fetchFromGitHub, dockerTools, lib, stdenv }@args:

let

  buildZoteroXpiAddon = lib.makeOverridable (
    { stdenv ? args.stdenv, pname, version, src, addonId, homepage, description, license, ... }:
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
      meta = {
        inherit version homepage description;
        license = lib.licenses.${license};
      };
    }
  );
  addonSources = import ./generated.nix { inherit fetchgit fetchurl fetchFromGitHub dockerTools; };
in
lib.mapAttrs
  (name: source: buildZoteroXpiAddon {
    inherit stdenv; inherit (source) pname version src addonId homepage description license;
  })
  addonSources
