{ clangStdenv
, lib
, name
, pkgSources
, python3Packages
, fetchpatch
, ninja
, pkg-config
, protobuf
, zinnia
, qt5
, fcitx5
, jsoncpp
, gtest
, which
, gtk2
, unzip
, abseil-cpp
, breakpad
, ruby
}:
let
  inherit (python3Packages) python gyp six;

  japanese_usage_dictionary = pkgSources.japanese-usage-dictionary.src;
  jigyosyo = pkgSources.mozc-dict-jigyosyo.src;
  x-ken-all = pkgSources.mozc-dict-x-ken-all.src;
  neologd = pkgSources.mecab-ipadic-neologd.src;

  mozcdict-ext = pkgSources.mozcdict-ext.src;

in
clangStdenv.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;

  nativeBuildInputs = [ gyp ninja python pkg-config qt5.wrapQtAppsHook six which unzip ruby ];

  buildInputs = [ protobuf zinnia qt5.qtbase fcitx5 abseil-cpp jsoncpp gtest gtk2 ];

  patches = [
    # Support linking system abseil-cpp
    (fetchpatch {
      url = "https://salsa.debian.org/debian/mozc/-/raw/debian/sid/debian/patches/0007-Update-src-base-absl.gyp.patch";
      sha256 = "UiS0UScDKyAusXOhc7Bg8dF8ARQQiVTylEhAOxqaZt8=";
    })

  ];

  postUnpack = ''
    unzip ${x-ken-all} -d $sourceRoot/src/
    unzip ${jigyosyo} -d $sourceRoot/src/
    rmdir $sourceRoot/src/third_party/breakpad/
    ln -s ${breakpad} $sourceRoot/src/third_party/breakpad
    rmdir $sourceRoot/src/third_party/gtest/
    ln -s ${gtest} $sourceRoot/src/third_party/gtest
    rmdir $sourceRoot/src/third_party/gyp/
    ln -s ${gyp} $sourceRoot/src/third_party/gyp
    rmdir $sourceRoot/src/third_party/jsoncpp/
    rmdir $sourceRoot/src/third_party/japanese_usage_dictionary/
    ln -s ${japanese_usage_dictionary} $sourceRoot/src/third_party/japanese_usage_dictionary
  '';

  # Copied from https://github.com/archlinux/svntogit-community/blob/packages/fcitx5-mozc/trunk/PKGBUILD
  configurePhase = ''
    cd src
    export GYP_DEFINES="document_dir=$out/share/doc/mozc use_libzinnia=1 use_libprotobuf=1 use_libabseil=1"
    # disable fcitx4
    rm unix/fcitx/fcitx.gyp
    # gen zip code seed
    PYTHONPATH="$PWD:$PYTHONPATH" python dictionary/gen_zip_code_seed.py --zip_code="x-ken-all.csv" --jigyosyo="JIGYOSYO.CSV" >> data/dictionary_oss/dictionary09.txt
    # Include Neologd
    mkdir -p /build/$sourceRoot/mozcdict-ext/neologd/src/seed
    cp -r ${mozcdict-ext}/neologd/* /build/$sourceRoot/mozcdict-ext/neologd
    cd /build/$sourceRoot/mozcdict-ext/neologd
    xz -k -d -c $(ls ${neologd}/seed/mecab-* | head -n1) > ./src/seed/user-dict-seed.csv
    RUBYOPT=-EUTF-8 MOZC_ID_FILE="/build/$sourceRoot/src/data/dictionary_oss/id.def" ruby ./neologd.rb >> /build/$sourceRoot/src/data/dictionary_oss/dictionary09.txt
    cd /build/$sourceRoot/src
    # use libstdc++ instead of libc++
    sed "/stdlib=libc++/d;/-lc++/d" -i gyp/common.gypi
    # run gyp
    python build_mozc.py gyp --gypdir=${gyp}/bin --server_dir=$out/lib/mozc
  '';

  buildPhase = ''
    python build_mozc.py build -c Release \
      server/server.gyp:mozc_server \
      gui/gui.gyp:mozc_tool \
      unix/fcitx5/fcitx5.gyp:fcitx5-mozc
  '';

  installPhase = ''
    export PREFIX=$out
    export _bldtype=Release
    ../scripts/install_server
    install -d $out/share/licenses/fcitx5-mozc
    head -n 29 server/mozc_server.cc > $out/share/licenses/fcitx5-mozc/LICENSE
    install -m644 data/installer/*.html $out/share/licenses/fcitx5-mozc/
    install -d $out/share/fcitx5/addon
    install -d $out/share/fcitx5/inputmethod
    install -d $out/lib/fcitx5
    ../scripts/install_fcitx5
  '';

  meta = with lib; {
    description = "Fcitx5 Module of A Japanese Input Method for Chromium OS, Windows, Mac and Linux (the Open Source Edition of Google Japanese Input)";
    homepage = "https://github.com/fcitx/mozc";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
