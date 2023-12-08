# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  SpeechRecognition = {
    pname = "SpeechRecognition";
    version = "3.10.1";
    src = fetchurl {
      url = "https://pypi.org/packages/source/S/SpeechRecognition/SpeechRecognition-3.10.1.tar.gz";
      sha256 = "sha256-cYcxiGt4NuIKBrmixsrOEqnhMJcbtq8bHdEwsiutn4I=";
    };
  };
  bt-dualboot = {
    pname = "bt-dualboot";
    version = "1.0.1";
    src = fetchurl {
      url = "https://pypi.org/packages/source/b/bt-dualboot/bt-dualboot-1.0.1.tar.gz";
      sha256 = "sha256-pjzGvLkotQllzyrnxqDIjGlpBOvUPkWpv0eooCUrgv8=";
    };
  };
  csharp-ls = {
    pname = "csharp-ls";
    version = "0.10.0";
    src = fetchurl {
      url = "https://www.nuget.org/api/v2/package/csharp-ls/0.10.0";
      sha256 = "sha256-1t8U2Q4lIlj2QwbnevAMMGcqtpPh5zk0Bd7EHa7qvCI=";
    };
  };
  cups-brother-hll5100dn-cupswrapper = {
    pname = "cups-brother-hll5100dn-cupswrapper";
    version = "3.5.1-1";
    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf102554/hll5100dncupswrapper-3.5.1-1.i386.deb";
      sha256 = "sha256-i309lhjE6FTNd8f0d4vv7/oaNUt165scU9Gzlff8gcE=";
    };
  };
  cups-brother-hll5100dn-lpr = {
    pname = "cups-brother-hll5100dn-lpr";
    version = "3.5.1-1";
    src = fetchurl {
      url = "https://download.brother.com/welcome/dlf102553/hll5100dnlpr-3.5.1-1.i386.deb";
      sha256 = "sha256-JnPiBVJ+ZJKivjq+Kizcf5U8vilOFdLVWBuRUiWJ5zE=";
    };
  };
  doq = {
    pname = "doq";
    version = "0.10.0";
    src = fetchurl {
      url = "https://pypi.org/packages/source/d/doq/doq-0.10.0.tar.gz";
      sha256 = "sha256-ZyuAwa658CzaO8vpWzBG6WMZOFggusxwZizEhvTDSoY=";
    };
  };
  drbd9-dkms = {
    pname = "drbd9-dkms";
    version = "9.1.17";
    src = fetchurl {
      url = "https://pkg.linbit.com//downloads/drbd/9/drbd-9.1.17.tar.gz";
      sha256 = "sha256-Xvl5Cw7cp7xHtUGbo1fNvYdHtLosU6lsHQLkozdvveI=";
    };
  };
  droidcam-obs-plugin = {
    pname = "droidcam-obs-plugin";
    version = "2.1.0";
    src = fetchurl {
      url = "https://github.com/dev47apps/droidcam-obs-plugin/releases/download/2.1.0/droidcam_obs_2.1.0_linux_ffmpeg5.zip";
      sha256 = "sha256-Qrb23aNddJhMvLgRyW7UamDVAjrhZhw4Kbr0FP/5mXs=";
    };
  };
  fcitx5-nord = {
    pname = "fcitx5-nord";
    version = "bdaa8fb723b8d0b22f237c9a60195c5f9c9d74d1";
    src = fetchFromGitHub {
      owner = "tonyfettes";
      repo = "fcitx5-nord";
      rev = "bdaa8fb723b8d0b22f237c9a60195c5f9c9d74d1";
      fetchSubmodules = false;
      sha256 = "sha256-qVo/0ivZ5gfUP17G29CAW0MrRFUO0KN1ADl1I/rvchE=";
    };
    date = "2021-07-27";
  };
  fcitx5-skk = {
    pname = "fcitx5-skk";
    version = "5.1.0";
    src = fetchFromGitHub {
      owner = "fcitx";
      repo = "fcitx5-skk";
      rev = "5.1.0";
      fetchSubmodules = false;
      sha256 = "sha256-N69OyGzJGO27tsR1g06d0EILsX2mpbW/tIgeSLc06OU=";
    };
  };
  fence-agents = {
    pname = "fence-agents";
    version = "v4.13.1";
    src = fetchFromGitHub {
      owner = "ClusterLabs";
      repo = "fence-agents";
      rev = "v4.13.1";
      fetchSubmodules = false;
      sha256 = "sha256-vqD3z/w0pGPKAynEAr1+G6FcanldhfuMb4Cvs4mqkhE=";
    };
  };
  jawiki-kana-kanji-dict = {
    pname = "jawiki-kana-kanji-dict";
    version = "8688cc9ef1daa3e8d6a64bbeb2d834d09105b3d6";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/tokuhirom/jawiki-kana-kanji-dict/8688cc9ef1daa3e8d6a64bbeb2d834d09105b3d6/SKK-JISYO.jawiki";
      sha256 = "sha256-7Kie4eDtbH+pXBf0iSpzWDfIh9h0R4AVnYZofOLdkfQ=";
    };
    date = "2023-11-21";
  };
  knp = {
    pname = "knp";
    version = "bc4cef188669f88cdeb590fe7afb1021ce2ae481";
    src = fetchFromGitHub {
      owner = "ku-nlp";
      repo = "knp";
      rev = "bc4cef188669f88cdeb590fe7afb1021ce2ae481";
      fetchSubmodules = false;
      sha256 = "sha256-QdBeT/tJVleX0HgV30JqiOWXXzemWfS6VEhvN76fObE=";
    };
    date = "2023-11-01";
  };
  plemoljp = {
    pname = "plemoljp";
    version = "v1.6.0";
    src = fetchurl {
      url = "https://github.com/yuru7/PlemolJP/releases/download/v1.6.0/PlemolJP_v1.6.0.zip";
      sha256 = "sha256-iQB11qItBWhaoL0+hTkPugFRwiIKHiZJl2xa9BaSw8w=";
    };
  };
  plemoljp-hs = {
    pname = "plemoljp-hs";
    version = "v1.6.0";
    src = fetchurl {
      url = "https://github.com/yuru7/PlemolJP/releases/download/v1.6.0/PlemolJP_HS_v1.6.0.zip";
      sha256 = "sha256-2t6IKpFA2qy0L7HHNneQQUh76DAkkiiujYyFR06tpO4=";
    };
  };
  plemoljp-nf = {
    pname = "plemoljp-nf";
    version = "v1.6.0";
    src = fetchurl {
      url = "https://github.com/yuru7/PlemolJP/releases/download/v1.6.0/PlemolJP_NF_v1.6.0.zip";
      sha256 = "sha256-6mPtfrb6JV970rsQZhWAd9QbhmjjKob/qTIlAdb8GNw=";
    };
  };
  pyknp = {
    pname = "pyknp";
    version = "0.6.1";
    src = fetchurl {
      url = "https://pypi.org/packages/source/p/pyknp/pyknp-0.6.1.tar.gz";
      sha256 = "sha256-X8ooinAwTHRdINpWV8YXW16t96elce1PV7sVfrbn300=";
    };
  };
  ricoh-sp-c260series-ppd = {
    pname = "ricoh-sp-c260series-ppd";
    version = "1.00";
    src = fetchurl {
      url = "http://support.ricoh.com/w/bb/pub_j/dr_ut_d/4101035/4101035832/V100/5205252/sp-c260series-printer-1.00-amd64.deb";
      sha256 = "sha256-aRqpBpYpQnOdAoGe21cBYrkhtRaiBZJTYgVsdN2irEU=";
    };
  };
  skk-emoji-jisyo = {
    pname = "skk-emoji-jisyo";
    version = "v0.0.9";
    src = fetchFromGitHub {
      owner = "uasi";
      repo = "skk-emoji-jisyo";
      rev = "v0.0.9";
      fetchSubmodules = false;
      sha256 = "sha256-H73wfvFhff55vFvNOunkma3C28BnXGuLzMrSvTLTgXU=";
    };
  };
  snack = {
    pname = "snack";
    version = "2.2.10";
    src = fetchurl {
      url = "http://www.speech.kth.se/snack/dist/snack2.2.10.tar.gz";
      sha256 = "sha256-S/52RUerkrpY9Dt3Nm27fHs1EtZaJ82/nlhanLZM6B4=";
    };
  };
  suds = {
    pname = "suds";
    version = "1.1.2";
    src = fetchurl {
      url = "https://pypi.org/packages/source/s/suds/suds-1.1.2.tar.gz";
      sha256 = "sha256-HVz6dBFxk7JEpCM/JGxIPZ9BGYtEjF8UqLrRHE9knys=";
    };
  };
  unityhub-latest = {
    pname = "unityhub-latest";
    version = "3.6.1";
    src = fetchurl {
      url = "https://hub.unity3d.com/linux/repos/deb/pool/main/u/unity/unityhub_amd64/unityhub-amd64-3.6.1.deb";
      sha256 = "sha256-rpH87aFvbYanthwPw/SlluOH/rtj6owcVetBD4+TJeU=";
    };
  };
  vrc-get-latest = {
    pname = "vrc-get-latest";
    version = "v1.3.2";
    src = fetchFromGitHub {
      owner = "anatawa12";
      repo = "vrc-get";
      rev = "v1.3.2";
      fetchSubmodules = false;
      sha256 = "sha256-5610o5Wl2xKTeJwQRsFiTG9IZhdreyTUiWry4d8FkGo=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./vrc-get-latest-v1.3.2/Cargo.lock;
      outputHashes = {
        "async_zip-0.0.15" = "sha256-UXBVZy3nf20MUh9jQdYeS5ygrZfeRWtiNRtiyMvkdSs=";
      };
    };
  };
  vrchat-vpm-cli = {
    pname = "vrchat-vpm-cli";
    version = "0.1.20";
    src = fetchurl {
      url = "https://www.nuget.org/api/v2/package/vrchat.vpm.cli/0.1.20";
      sha256 = "sha256-KZrHwrrc9NojcfYGqm9avGDqxQEj/sBV9dWWIneMjss=";
    };
  };
  wavesurfer = {
    pname = "wavesurfer";
    version = "1.8.8p5";
    src = fetchurl {
      url = "http://downloads.sourceforge.net/wavesurfer/wavesurfer-1.8.8p5-src.tgz";
      sha256 = "sha256-rlYGEUfdEXD3SF3JwZ23pF3RVwUKw5RmYsf8ec/7YRo=";
    };
  };
  yaskkserv2 = {
    pname = "yaskkserv2";
    version = "0.1.7";
    src = fetchFromGitHub {
      owner = "wachikun";
      repo = "yaskkserv2";
      rev = "0.1.7";
      fetchSubmodules = false;
      sha256 = "sha256-bF8OHP6nvGhxXNvvnVCuOVFarK/n7WhGRktRN4X5ZjE=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./yaskkserv2-0.1.7/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
