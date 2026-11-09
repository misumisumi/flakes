{
  stdenvNoCC,
  pname,
  version,
  src,
  meta,
  updateScript,
  unzip,
}:
stdenvNoCC.mkDerivation {
  inherit pname version src meta;

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    runHook preUnpack
    unzip -q $src
    find . -name '._*' -delete
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R ibisOffice.app $out/Applications/
    mkdir -p $out/bin
    ln -s $out/Applications/ibisOffice.app/Contents/MacOS/ibisOffice $out/bin/ibisOffice
    runHook postInstall
  '';

  passthru.updateScript = updateScript;
}
