# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  asusctl-latest = {
    pname = "asusctl-latest";
    version = "4.5.8";
    src = fetchgit {
      url = "https://gitlab.com/asus-linux/asusctl";
      rev = "4.5.8";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-6AitRpyLIq5by9/rXdIC8AChMVKZmR1Eo5GTo+DtGhc=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./asusctl-latest-4.5.8/Cargo.lock;
      outputHashes = {
        "supergfxctl-5.0.2" = "sha256-zp92mWyWUEWUP4kEyHbiUyYTtp2kLv+gxkPzOu77fi8=";
        "ecolor-0.20.0" = "sha256-tnjFkaCWmCPGw3huQN9VOAeiH+zk3Zk9xYoRKmg2WQg=";
        "notify-rust-4.6.0" = "sha256-jhCgisA9f6AI9e9JQUYRtEt47gQnDv5WsdRKFoKvHJs=";
      };
    };
  };
  bt-dualboot = {
    pname = "bt-dualboot";
    version = "1.0.1";
    src = fetchurl {
      url = "https://pypi.io/packages/source/b/bt-dualboot/bt-dualboot-1.0.1.tar.gz";
      sha256 = "sha256-pjzGvLkotQllzyrnxqDIjGlpBOvUPkWpv0eooCUrgv8=";
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
    version = "0.9.1";
    src = fetchurl {
      url = "https://pypi.io/packages/source/d/doq/doq-0.9.1.tar.gz";
      sha256 = "sha256-uszDSN35Z8i/Mr/fVNqDJuHcdPN4ZeLBdgEq0Lx+6h4=";
    };
  };
  droidcam-obs-plugin = {
    pname = "droidcam-obs-plugin";
    version = "2.0.1";
    src = fetchurl {
      url = "https://github.com/dev47apps/droidcam-obs-plugin/releases/download/2.0.1/droidcam_obs_2.0.1_linux.zip";
      sha256 = "sha256-WFDTNoZ51O31NCxr6UknzfCBbkOcqjuo9wHejxJEV30=";
    };
  };
  fcitx5-mozc-ext-neologd = {
    pname = "fcitx5-mozc-ext-neologd";
    version = "1882e33b61673b66d63277f82b4c80ae4e506c10";
    src = fetchFromGitHub ({
      owner = "fcitx";
      repo = "mozc";
      rev = "1882e33b61673b66d63277f82b4c80ae4e506c10";
      fetchSubmodules = false;
      sha256 = "sha256-R+w0slVFpqtt7PIr1pyupJjRoQsABVZiMdZ9fKGKAqw=";
    });
  };
  fcitx5-nord = {
    pname = "fcitx5-nord";
    version = "bdaa8fb723b8d0b22f237c9a60195c5f9c9d74d1";
    src = fetchFromGitHub ({
      owner = "tonyfettes";
      repo = "fcitx5-nord";
      rev = "bdaa8fb723b8d0b22f237c9a60195c5f9c9d74d1";
      fetchSubmodules = false;
      sha256 = "sha256-qVo/0ivZ5gfUP17G29CAW0MrRFUO0KN1ADl1I/rvchE=";
    });
    date = "2021-07-27";
  };
  fcitx5-skk = {
    pname = "fcitx5-skk";
    version = "5.0.14";
    src = fetchFromGitHub ({
      owner = "fcitx";
      repo = "fcitx5-skk";
      rev = "5.0.14";
      fetchSubmodules = false;
      sha256 = "sha256-12N7ctBj3yQKOc4wbov2ea7DQ5OGLVZEE++lSF3Ib1Q=";
    });
  };
  japanese-usege-dictionary = {
    pname = "japanese-usege-dictionary";
    version = "a4a66772e33746b91e99caceecced9a28507e925";
    src = fetchgit {
      url = "https://github.com/hiroyuki-komatsu/japanese-usage-dictionary";
      rev = "a4a66772e33746b91e99caceecced9a28507e925";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-qnWA+lesLo3Odk8gY9UTKQr/YmIn+nCcbtKDjUDobII=";
    };
    date = "2018-07-01";
  };
  jawiki-kana-kanji-dict = {
    pname = "jawiki-kana-kanji-dict";
    version = "e31d3242e97260997497b9fef8c87f128168ea4a";
    src = fetchurl {
      url = "https://raw.githubusercontent.com/tokuhirom/jawiki-kana-kanji-dict/e31d3242e97260997497b9fef8c87f128168ea4a/SKK-JISYO.jawiki";
      sha256 = "sha256-AsmiZCMe3eTAC6u1WXrJpwiVhci3XmKbCyYpuMOZw3s=";
    };
    date = "2023-02-02";
  };
  juce = {
    pname = "juce";
    version = "7.0.5";
    src = fetchFromGitHub ({
      owner = "juce-framework";
      repo = "JUCE";
      rev = "7.0.5";
      fetchSubmodules = false;
      sha256 = "sha256-NRF9oSE04hk6KVSxuUBpP+z+DKRyb6pzBXtz/pLz0/0=";
    });
  };
  knp = {
    pname = "knp";
    version = "25425d33907ce69c5fa5b584ba58183020a07bba";
    src = fetchFromGitHub ({
      owner = "ku-nlp";
      repo = "knp";
      rev = "25425d33907ce69c5fa5b584ba58183020a07bba";
      fetchSubmodules = false;
      sha256 = "sha256-P33+6Iwh7fYugZrFRylrtzz24EjwUToXJ/nbDw06Pbg=";
    });
    date = "2022-06-14";
  };
  mecab-ipadic-neologd = {
    pname = "mecab-ipadic-neologd";
    version = "v0.0.7";
    src = fetchFromGitHub ({
      owner = "neologd";
      repo = "mecab-ipadic-neologd";
      rev = "v0.0.7";
      fetchSubmodules = false;
      sha256 = "sha256-6mZ+Wcre0ZTUitso9kQn11um29cdOUaOAbhPgSq7OxU=";
    });
  };
  mozc-dict-jigyosyo = {
    pname = "mozc-dict-jigyosyo";
    version = "202110";
    src = fetchurl {
      url = "https://osdn.net/projects/ponsfoot-aur/storage/mozc/jigyosyo-202110.zip";
      sha256 = "sha256-bI1F/UyrBAnMwcrZff4GDc87jAfnPm2UJqh+itzsOkM=";
    };
  };
  mozc-dict-x-ken-all = {
    pname = "mozc-dict-x-ken-all";
    version = "202110";
    src = fetchurl {
      url = "https://osdn.net/projects/ponsfoot-aur/storage/mozc/x-ken-all-202110.zip";
      sha256 = "sha256-85iKUrxpGdcoSg7wzbmrAn+HZ8ud58uEabEuH7PLavk=";
    };
  };
  mozcdict-ext = {
    pname = "mozcdict-ext";
    version = "21294dd9671a0c03f24fed2b528befb1e516c843";
    src = fetchgit {
      url = "https://github.com/reasonset/mozcdict-ext";
      rev = "21294dd9671a0c03f24fed2b528befb1e516c843";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-d1Z/xHwa1e4zy4UtHtIgZV5ZFSvz/nFNY0LhOOmLuRY=";
    };
    date = "2023-01-15";
  };
  notify-rust = {
    pname = "notify-rust";
    version = "c83082a2549932bde52a4ec449b9981fc39e9a0d";
    src = fetchFromGitHub ({
      owner = "flukejones";
      repo = "notify-rust";
      rev = "c83082a2549932bde52a4ec449b9981fc39e9a0d";
      fetchSubmodules = false;
      sha256 = "sha256-jhCgisA9f6AI9e9JQUYRtEt47gQnDv5WsdRKFoKvHJs=";
    });
    date = "2022-11-30";
  };
  pyknp = {
    pname = "pyknp";
    version = "0.6.1";
    src = fetchurl {
      url = "https://pypi.io/packages/source/p/pyknp/pyknp-0.6.1.tar.gz";
      sha256 = "sha256-X8ooinAwTHRdINpWV8YXW16t96elce1PV7sVfrbn300=";
    };
  };
  skk-emoji-jisyo = {
    pname = "skk-emoji-jisyo";
    version = "v0.0.7";
    src = fetchFromGitHub ({
      owner = "uasi";
      repo = "skk-emoji-jisyo";
      rev = "v0.0.7";
      fetchSubmodules = false;
      sha256 = "sha256-cxaRVV5d7zZdhWxq6m+NjA9P9PKZfwiimCToo81yxkY=";
    });
  };
  snack = {
    pname = "snack";
    version = "2.2.10";
    src = fetchurl {
      url = "http://www.speech.kth.se/snack/dist/snack2.2.10.tar.gz";
      sha256 = "sha256-S/52RUerkrpY9Dt3Nm27fHs1EtZaJ82/nlhanLZM6B4=";
    };
  };
  supergfxctl-latest = {
    pname = "supergfxctl-latest";
    version = "5.0.1";
    src = fetchgit {
      url = "https://gitlab.com/asus-linux/supergfxctl";
      rev = "5.0.1";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-4q+7F8s6y+oDkBUKIBBsXZ2EtADcChdnjmABjBUnH9k=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./supergfxctl-latest-5.0.1/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  unityhub-latest = {
    pname = "unityhub-latest";
    version = "3.4.1";
    src = fetchurl {
      url = "https://hub.unity3d.com/linux/repos/deb/pool/main/u/unity/unityhub_amd64/unityhub-amd64-3.4.1.deb";
      sha256 = "sha256-/P6gPLSRGfwEN801cyNrZTpHyZKO+4tU6cFvLz8ERuo=";
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
  xp-pen-tablet = {
    pname = "xp-pen-tablet";
    version = "3.2.3.220323";
    src = fetchurl {
      url = "https://www.xp-pen.com/download/file/id/1936/pid/690/ext/gz.html";
      sha256 = "sha256-cLbcE0WVjBhY0JGj1IvddckfzIeboXVznvkVJ5C9yys=";
    };
  };
  yaskkserv2 = {
    pname = "yaskkserv2";
    version = "0.1.5";
    src = fetchFromGitHub ({
      owner = "wachikun";
      repo = "yaskkserv2";
      rev = "0.1.5";
      fetchSubmodules = false;
      sha256 = "sha256-S1xuraK85gBI9DV8bojjNBgRD9R98pWR2eaeji5rC6M=";
    });
    cargoLock."Cargo.lock" = {
      lockFile = ./yaskkserv2-0.1.5/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
}
