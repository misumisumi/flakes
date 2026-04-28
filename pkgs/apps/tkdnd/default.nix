{
  lib,
  nix-update-script,
  fetchFromGitHub,
  stdenv,
  cmake,
  libXcursor,
  tcl,
  tk,
}:
let
  inherit (lib) licenses;
  pname = "tkdnd";
  version = "2.9.5";
in
stdenv.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "petasis";
    repo = pname;
    rev = "tkdnd-release-test-v${version}";
    sha256 = "sha256-VF1f9HSEThyFy3u7d3Kvo7EIpoosz6KpLOiHkf89PQI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    tk
    tcl
    libXcursor
  ];

  configurePhase = ''
    cd ./cmake
    chmod +x build.sh
    ./build.sh
  '';
  buildPhase = ''
    cd ../cmake/release-nmake-x86_32
    make install
  '';
  installPhase = ''
    mkdir -p $out/lib
    cp -r ../runtime/tkdnd* $out/lib
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version-regex"
      "tkdnd-release-test-v(.*)"
    ];
  };

  meta = {
    description = "TkDND is an extension that adds native drag & drop capabilities to the Tk toolkit.";
    homepage = "https://github.com/petasis/tkdnd";
    license = licenses.free;
    platforms = [ "x86_64-linux" ];
  };
}
