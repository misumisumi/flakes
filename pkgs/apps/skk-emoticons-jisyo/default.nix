{
  stdenvNoCC,
  lib,
  pkgSources,
  yaskkserv2,
  jq,
}:

stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."emoticon-data") src;
  pname = "skk-emotikons-jisyo";
  version = pkgSources."emoticon-data".date;
  nativeBuildInputs = [
    jq
    yaskkserv2
  ];

  installPhase = ''
    mkdir -p $out/share
    cat <<EOF > emoticons.jisyo
    ;; emoticons dictionary for SKK system
    ;;
    ;; okuri-nasi entries.
    EOF
    jq -r '.emoticons[] | "\(.tags[0] | sub(" "; "_") | sub("laugh"; "smile")) /\(.string)/"' emoticons.json >> emoticons.jisyo
    yaskkserv2_make_dictionary --utf8 --dictionary-filename ./dictionary.yaskkserv2 emoticons.jisyo
    yaskkserv2_make_dictionary --utf8 --dictionary-filename ./dictionary.yaskkserv2 --output-jisyo-filename SKK-JISYO.emoticons.utf8
    sed -i -e "2s/yaskkserv2/Emoticons/g" SKK-JISYO.emoticons.utf8
    cp SKK-JISYO.emoticons.utf8 $out/share/SKK-JISYO.emoticons.utf8
  '';

  meta = with lib; {
    inherit version;
    description = "emoticons dictionary for SKK";
    homepage = "https://github.com/w33ble/emoticon-data";
    license = licenses.mit;
  };
}
