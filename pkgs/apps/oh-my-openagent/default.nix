{
  lib,
  stdenvNoCC,
  fetchurl,
  stdenv,
  patchelf,
}:
stdenvNoCC.mkDerivation rec {
  pname = "oh-my-openagent";
  version = "5.1.38";

  src = fetchurl {
    url = "https://github.com/code-yeongyu/oh-my-openagent/releases/download/v${version}/omo-linux-x64";
    hash = "sha256-y+VqgX1xtf3Ln47oXHJLOTDEIFqB4olH/wCBEiPLrVU=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ patchelf ];

  buildInputs = [ stdenv.cc.cc.lib ];

  dontAutoPatchelf = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/omo
    runHook postInstall
  '';

  # autoPatchelfHook rewrites sections and breaks the payload embedded in the
  # bun-compiled executable, so only patch the ELF interpreter.
  postFixup = ''
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} $out/bin/omo
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$(mktemp -d)
    $out/bin/omo --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "OmO Native - standalone AI coding assistant with the OMO extension built in";
    homepage = "https://github.com/code-yeongyu/oh-my-openagent";
    changelog = "https://github.com/code-yeongyu/oh-my-openagent/releases/tag/v${version}";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "omo";
    platforms = [ "x86_64-linux" ];
  };
}
