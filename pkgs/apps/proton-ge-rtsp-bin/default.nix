{
  proton-ge-bin,
  nix-update-script,
}:
proton-ge-bin.overrideAttrs (
  oldAttrs:
  let
    pname = "proton-ge-rtsp-bin";
    version = "GE-Proton10-33-rtsp24-1";
    src = fetchTarball {
      url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${version}/${version}.tar.gz";
      sha256 = "sha256-eAJjw575cJlj7qLsPC1LgRsVMW4O754Q6SO7IV74EyE=";
    };
  in
  {
    inherit pname version src;
    passthru = (oldAttrs.passthru or { }) // {
      updateScript = nix-update-script {
        extraArgs = [
          "--flake"
          "--override-filename"
          "pkgs/apps/proton-ge-rtsp-bin/default.nix"
          "--url"
          "https://github.com/SpookySkeletons/proton-ge-rtsp"
        ];
      };
    };
  }
)
