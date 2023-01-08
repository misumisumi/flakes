# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub }:
{
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
  };
  flake-asusctl = {
    pname = "flake-asusctl";
    version = "4.5.1";
    src = fetchgit {
      url = "https://gitlab.com/asus-linux/asusctl";
      rev = "4.5.1";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-5LlPDti7LRa1QiwNyln2GwX6JBN0XH4EZ9OpczLSU0g=";
    };
    cargoLock."Cargo.lock" = {
      lockFile = ./flake-asusctl-4.5.1/Cargo.lock;
      outputHashes = {
        "eframe-0.19.0" = "sha256-HW7gfs8vXXhQbNTBPdl3KurqcjvZHANoF2t0DAB+QDI=";
        "supergfxctl-5.0.2" = "sha256-N2k/vkv+bct+Lo3y5jzpwdEGBcoOAtX9SBI8inNQqGQ=";
        "notify-rust-4.5.11" = "sha256-ybjbKl/5326L4RKene8WrBd3k6KCbanx/UrFbUzoxpo=";
      };
    };
  };
  flake-supergfxctl = {
    pname = "flake-supergfxctl";
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
      lockFile = ./flake-supergfxctl-5.0.1/Cargo.lock;
      outputHashes = {
        
      };
    };
  };
  juce = {
    pname = "juce";
    version = "7.0.2";
    src = fetchFromGitHub ({
      owner = "juce-framework";
      repo = "JUCE";
      rev = "7.0.2";
      fetchSubmodules = false;
      sha256 = "sha256-G531oy31eAXdBOnB6HWKP697BBpRqMUd+xbVlZiwXGs=";
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
  };
  pyknp = {
    pname = "pyknp";
    version = "0.6.1";
    src = fetchurl {
      url = "https://pypi.io/packages/source/p/pyknp/pyknp-0.6.1.tar.gz";
      sha256 = "sha256-X8ooinAwTHRdINpWV8YXW16t96elce1PV7sVfrbn300=";
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
}
