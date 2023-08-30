{ stdenv
, lib
, name
, pkgSources
, fetchurl
, autoPatchelfHook
, makeDesktopItem
, writeShellApplication
, glibc
, libGL
, libX11
, libXi
, libXinerama
, libXrandr
, libXtst
, libsForQt5
, libusb1
, xorg
}:
let
  pkg_url = (with builtins; fromJSON (readFile ../../../_sources/generated.json))."xp-pen-tablet".src.url;
  pkg_sha256 = (with builtins; fromJSON (readFile ../../../_sources/generated.json))."xp-pen-tablet".src.sha256;
  mkDerivation = libsForQt5.callPackage ({ mkDerivation }: mkDerivation) { };
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

  buildInputs = [ glibc libGL libX11 libXi libXinerama libXrandr libXtst libsForQt5.qtx11extras libusb1 stdenv.cc.cc.lib ];

  desktopItems = [
    (makeDesktopItem {
      name = "xp-pen-driver";
      exec = "xp-pen-driver-indicator";
      icon = "pentablet";
      comment = "XPPen driver";
      desktopName = "xppentablet";
      categories = [ "Application" "Utility" ];
    })
  ];
  run_script = writeShellApplication {
    name = "xp-pen-driver";
    text = ''
      sudo sh -c "xp-pen-driver &"
    '';
  };
  indicator = writeShellApplication {
    name = "xp-pen-driver-indicator";
    text = ''
      sudo sh -c "xp-pen-driver /mini &"
    '';
  };
  installPhase = ''
    runHook preInstall
    mkdir -p $out/{opt,bin,share}
    cp -r App/usr/lib/pentablet/{pentablet,resource.rcc,conf} $out/opt
    chmod +x $out/opt/pentablet
    cp -r App/lib $out/lib
    sed -i 's#usr/lib/pentablet#${dataDir}#g' $out/opt/pentablet
    cp -r $run_script/bin/* $out/bin
    cp -r $indicator/bin/* $out/bin
    sed -i "s#xp-pen-driver#$out/opt/xp-pen-driver#g" $out/bin/xp-pen-driver
    sed -i "s#xp-pen-driver#$out/opt/xp-pen-driver#g" $out/bin/xp-pen-driver-indicator

    cp -r App/usr/share/icons $out/share/icons
    cp -r $desktopItems/share/applications $out/share/applications
    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/pentablet $out/opt/xp-pen-driver \
    "''${qtWrapperArgs[@]}" \
      --run 'if [ ! -d /${dataDir} ]; then mkdir -p /${dataDir}; cp -r '$out'/opt/conf /${dataDir}; chmod u+w -R /${dataDir}; fi'
  '';

  meta = with lib; {
    description = "XP-Pen (Official) Linux utility (New UI driver)";
    homepage = "https://www.xp-pen.com/download/index.html";
    license = licenses.lgpl3Only;
  };
}
