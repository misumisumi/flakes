{ stdenv,
  lib,
  name,
  pkgSources,
  fetchurl,
  autoPatchelfHook,
  libsForQt5,
  libusb1,
  glibc,
  libGL,
  xorg,
  libX11,
  libXtst,
  libXi,
  libXrandr,
  libXinerama,
}:
let
  pkg_url = (with builtins; fromJSON (readFile ../../_sources/generated.json))."xp-pen-tablet".src.url;
  pkg_sha256 = (with builtins; fromJSON (readFile ../../_sources/generated.json))."xp-pen-tablet".src.sha256;
  mkDerivation = libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};
  dataDir = "var/lib/xppend1v2";
in
mkDerivation rec {
  inherit (pkgSources."${name}") pname version;
  src = fetchurl {
    url = pkg_url;
    sha256 = pkg_sha256;
    name = "xp-pen-tablet-${version}.x86_64.tar.gz";
  };

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    autoPatchelfHook
  ];

  dontBuild = true;

  dontWrapQtApps = true; # this is done manually

  buildInputs = [
    libusb1
    libX11
    libXtst
    libXi
    libXrandr
    libXinerama
    glibc
    libGL
    stdenv.cc.cc.lib
    libsForQt5.qtx11extras
  ];
  desktopItems = [ 
    (makeDesktopItem {
      inherit name;
      exec = "xp-pen-driver /mini";
      icon = "pentablet";
      comment = "XPPen driver";
      desktopName = "xppentablet";
      categories = [ "Application" "Utility" ];
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{opt,bin,share}
    cp -r App/usr/lib/pentablet/{pentablet,resource.rcc,conf} $out/opt
    chmod +x $out/opt/pentablet
    cp -r App/lib $out/lib
    cp -r App/usr/share/* $out/share

    #fix license permissions
    chmod 644 $out/lib/pentablet/LGPL

    cp $desktopItems/share/applications $out/share/applications

    #config is global so everyone needs write access
    chmod 666 $out/lib/pentablet/conf/xppen/config.xml

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/pentablet $out/bin/xp-pen-driver \
      "''${qtWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "XP-Pen (Official) Linux utility (New UI driver)";
    homepage = "https://www.xp-pen.com/download/index.html";
    license = licenses.lgpl3Only;
  };
}
