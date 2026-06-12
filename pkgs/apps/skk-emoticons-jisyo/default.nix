{
  lib,
  fetchFromGitHub,
  nix-update-script,
  stdenvNoCC,
  yaskkserv2,
  jq,
}:

stdenvNoCC.mkDerivation {
  pname = "skk-emoticons-jisyo";
  version = "0.2.1-unstable-2021-04-02";
  src = fetchFromGitHub {
    owner = "w33ble";
    repo = "emoticon-data";
    rev = "92b6211ec2a93e14052e0e572d697d4d06c71868";
    sha256 = "sha256-AlzFMsXmkSz4zphpYPTSXJsQ303lI9I02pjVxA1YcIs=";
  };

  nativeBuildInputs = [
    jq
    yaskkserv2
  ];

  installPhase = ''
    mkdir -p $out/share/skk
    cat <<EOF > emoticons.jisyo
    ;; emoticons dictionary for SKK system
    ;;
    ;; okuri-nasi entries.
    EOF
    jq -r '.emoticons[] | "\(.tags[0] | sub(" "; "_") | sub("laugh"; "smile")) /\(.string)/"' emoticons.json >> emoticons.jisyo
    yaskkserv2_make_dictionary --utf8 --dictionary-filename ./dictionary.yaskkserv2 emoticons.jisyo
    yaskkserv2_make_dictionary --utf8 --dictionary-filename ./dictionary.yaskkserv2 --output-jisyo-filename SKK-JISYO.emoticons.utf8
    sed -i -e "2s/yaskkserv2/Emoticons/g" SKK-JISYO.emoticons.utf8
    cp SKK-JISYO.emoticons.utf8 $out/share/skk/SKK-JISYO.emoticons.utf8
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version"
      "branch"
    ];
  };

  meta = with lib; {
    description = "emoticons dictionary for SKK";
    homepage = "https://github.com/w33ble/emoticon-data";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
