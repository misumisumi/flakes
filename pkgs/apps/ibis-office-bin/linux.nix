{
  lib,
  stdenv,
  pname,
  version,
  src,
  meta,
  updateScript,
  autoPatchelfHook,
  makeWrapper,
  ostree,
  fontconfig,
  freetype,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
}:
stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    ostree
  ];

  buildInputs = [
    fontconfig
    freetype
    libxcb
    libxkbcommon
  ];

  unpackPhase = ''
    runHook preUnpack
    ostree init --repo=repo --mode=archive-z2
    ostree static-delta apply-offline --repo=repo $src
    commit=$(cd repo/objects && echo */*.commit | sed -E 's_/|\.commit$__g')
    ostree checkout --repo=repo -U "$commit" contents
    cp -r contents/files/. .
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/ibisOffice $out/bin/ibisOffice
    mkdir -p $out/share
    cp -r share/applications share/doc share/ibisOffice share/icons share/metainfo $out/share/
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/ibisOffice \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader wayland ]}
  '';

  passthru.updateScript = updateScript;
}
