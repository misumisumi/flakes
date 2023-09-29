{ pkgSources
, name
, stdenv
, lib
, nukeReferences
, linuxPackages
, kernel ? linuxPackages.kernel
}:

stdenv.mkDerivation {
  inherit (pkgSources."${name}") pname version src;

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = [ nukeReferences ] ++ kernel.moduleBuildDependencies;

  kernel = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "ARCH=x86"
    "DESTDIR=$(out)"
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/$kernelVersion/updates
      for x in $(find . -name '*.ko'); do
        nuke-refs $x
        cp $x $out/lib/modules/$kernelVersion/updates/
      done
  '';

  meta = with lib; {
    description = "A kernel module of drbd9";
    homepage = "https://github.com/LINBIT/drbd";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
