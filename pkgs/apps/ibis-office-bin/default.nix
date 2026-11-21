{
  lib,
  stdenv,
  fetchurl,
  callPackage,
}:
let
  pname = "ibis-office-bin";
  version = "0.8.9";

  # The asset and hash of every supported platform, kept together so
  # update.sh can refresh them all in one go.
  sources = {
    "x86_64-linux" = {
      asset = "ibisOffice-${version}-Linux-x86_64.flatpak";
      hash = "sha256-hL0VGY3zb10+TFu4JuLBoqHWPAOQbov9Kw79zppf3bE=";
    };
    "aarch64-linux" = {
      asset = "ibisOffice-${version}-Linux-aarch64.flatpak";
      hash = "sha256-KUqw963+bwC5DsPgfWvYQ3I8VWdnKOz4K93Wc8ikYBg=";
    };
    "aarch64-darwin" = {
      asset = "ibisOffice-${version}-macOS.zip";
      hash = "sha256-/U4cDpwjExw8xY6OCWU0i9F7+LD101oCg8XZIbJNwRo=";
    };
  };

  system = stdenv.hostPlatform.system;
  source = sources.${system} or (throw "${pname}: unsupported system ${system}");

  src = fetchurl {
    url = "https://github.com/ibisjp/ibis-office/releases/download/v${version}/${source.asset}";
    inherit (source) hash;
  };

  meta = {
    description = "The next-gen Office suite built with Rust & GPUI (prebuilt Flatpak/macOS app)";
    homepage = "https://ibisjp.github.io/ibis-office/";
    license = lib.licenses.agpl3Only;
    mainProgram = "ibisOffice";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit pname version src meta;
    updateScript = ./update.sh;
  }
else
  callPackage ./linux.nix {
    inherit pname version src meta;
    updateScript = ./update.sh;
  }
