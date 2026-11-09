{
  lib,
  stdenv,
  fetchurl,
  callPackage,
}:
let
  pname = "ibis-office-bin";
  version = "0.8.6";

  # The asset and hash of every supported platform, kept together so
  # update.sh can refresh them all in one go.
  sources = {
    "x86_64-linux" = {
      asset = "ibisOffice-${version}-Linux-x86_64.flatpak";
      hash = "sha256-XkV/CSlMManLPazEnFZ6n2nYJ34hCIDRr5bUkKnuPrk=";
    };
    "aarch64-linux" = {
      asset = "ibisOffice-${version}-Linux-aarch64.flatpak";
      hash = "sha256-44qZmn6SCiqmIWMPiHRyabGTvz1jlca5I5dXI4RV6fM=";
    };
    "aarch64-darwin" = {
      asset = "ibisOffice-${version}-macOS.zip";
      hash = "sha256-zGOx8g9wxDvd6sqaOkr5stSsJ7qoD3I3kmIfR/pxSjw=";
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
