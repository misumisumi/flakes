{
  proton-ge-bin,
  fetchzip,
  nix-update-script,
}:
proton-ge-bin.overrideAttrs (
  oldAttrs:
  let
    pname = "proton-ge-rtsp-bin";
    version = "11.0-20260609-4";
    tag = "proton-rtsp-${version}";
  in
  {
    inherit pname version;
    src = fetchzip {
      url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${tag}/${tag}.tar.gz";
      hash = "sha256-ENLAPkz6PhqBpGibwjnWJE8NEnUnmoM81IuPQB9Ufoc=";
    };
    passthru = (oldAttrs.passthru or { }) // {
      updateScript = nix-update-script {
        extraArgs = [
          "--flake"
          "--version-regex"
          "proton-rtsp-(.*)"
          "--override-filename"
          "pkgs/apps/proton-ge-rtsp-bin/default.nix"
          "--url"
          "https://github.com/SpookySkeletons/proton-ge-rtsp"
        ];
      };
    };
    # `variants` is consumed by mkProtonBinDerivation before overrideAttrs
    # runs, so the tool name inside the derivation has to be overridden
    # directly.
    toolName = tag;
    meta.platforms = [ "x86_64-linux" ];
  }
)
