{ stdenv,
  lib,
  rustPlatform,
  name,
  pkgSources,
  makeWrapper,
  cargo,
  gcc,
  kmod,
  pkg-config,
  rustc,
  rustfmt,
  udev
}:

rustPlatform.buildRustPackage rec {
  inherit (pkgSources."${name}") pname version src;
  cargoLock = pkgSources."${name}".cargoLock."Cargo.lock";

  buildInputs = [ makeWrapper cargo gcc kmod pkg-config rustc rustfmt udev ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = false;
  buildPhase = ''
    make -j $NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir -p $out/tmp
    make DESTDIR=$out/tmp install
    mv $out/tmp/usr/* $out/
    rm -r $out/tmp
  '';

  postFixup = ''
    wrapProgram $out/bin/supergfxd \
      --prefix PATH : ${lib.makeBinPath [ kmod ]}
  '';

  meta = with lib; {
    inherit version;
    description = "A utility for Linux graphics switching on Intel/AMD iGPU + nVidia dGPU laptops";
    homepage = "https://gitlab.com/asus-linux/supergfxctl";
    license = licenses.mpl20;
  };
}
