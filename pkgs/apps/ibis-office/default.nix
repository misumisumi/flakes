{
  lib,
  stdenv,
  fetchgit,
  alsa-lib,
  cmake,
  fontconfig,
  freetype,
  glib,
  libGL,
  libgit2,
  libx11,
  libxcb,
  libxext,
  libxkbcommon,
  libxrandr,
  makeWrapper,
  openssl,
  pkg-config,
  rustPlatform,
  sqlite,
  vulkan-loader,
  wayland,
  zlib,
  zstd,
}:
let
  inherit (lib) licenses platforms optionals;
  pname = "ibis-office";
  version = "0.8.4";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchgit {
    url = "https://github.com/ibisjp/ibis-office";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-esCu+LtAEsX5H1Yo4LDib2nDMmOZu6gq+48oZMOOWBY=";
  };

  cargoLock.lockFile = ./Cargo.lock;
  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace crates/ibis-office-app/src/shell/update.rs \
      --replace-fail \
      'settings::get(CHECK_KEY).as_deref() != Some("0")' \
      'settings::get(CHECK_KEY).as_deref() == Some("1")'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ]
  ++ optionals stdenv.hostPlatform.isLinux [ makeWrapper ];

  buildInputs = [
    libgit2
    openssl
    sqlite
    zlib
    zstd
  ]
  ++ optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    fontconfig
    freetype
    glib
    libGL
    libx11
    libxcb
    libxext
    libxkbcommon
    libxrandr
    vulkan-loader
    wayland
  ];

  postInstall = optionals stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/ibisOffice \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  doCheck = false;

  meta = {
    description = "The next-gen Office suite built with Rust & GPUI. Blazing-fast, memory-safe, and highly accurate editing for DOCX, XLSX, and PPTX with pixel-perfect rendering. Powered by DirectX, Metal, Vulkan & WebGPU for peak performance across Windows, macOS, Linux, and Web (Wasm).";
    homepage = "https://ibisjp.github.io/ibis-office/";
    license = licenses.agpl3Only;
    mainProgram = "ibisOffice";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
