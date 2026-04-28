{
  proton-ge-bin,
  fetchzip,
  nix-update-script,
}:
proton-ge-bin.overrideAttrs (
  oldAttrs:
  let
    pname = "proton-ge-rtsp-bin";
    version = "GE-Proton10-33-rtsp24-1";
  in
  {
    inherit pname version;
    src = fetchzip {
      url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-KVc5YXJea0eQImKUPg6eW7uSSe1e+mncB4cSBV4IKME=";
    };
    passthru = (oldAttrs.passthru or { }) // {
      updateScript = nix-update-script {
        extraArgs = [
          "--flake"
          "--version-regex"
          "(GE-Proton.*)"
          "--override-filename"
          "pkgs/apps/proton-ge-rtsp-bin/default.nix"
          "--url"
          "https://github.com/SpookySkeletons/proton-ge-rtsp"
        ];
      };
    };
  }
)
