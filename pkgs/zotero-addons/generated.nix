# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  zotero-better-bibtex = {
    pname = "zotero-better-bibtex";
    version = "6.7.212";
    src = fetchurl {
      url = "https://github.com/retorquere/zotero-better-bibtex/releases/download/v6.7.212/zotero-better-bibtex-6.7.212.xpi";
      sha256 = "sha256-WyOpyPhrwkO8vD/UG2KGq91clo2ov4p1zBAQGQ1X7G8=";
    };
    license = "mit";
    description = "Make Zotero effective for us LaTeX holdouts";
    homepage = "https://github.com/retorquere/zotero-better-bibtex";
    addonId = "better-bibtex@iris-advies.com";
  };
  zotero-night = {
    pname = "zotero-night";
    version = "0.4.23";
    src = fetchurl {
      url = "https://github.com/tefkah/zotero-night/releases/download/v0.4.23/night.xpi";
      sha256 = "sha256-szoKwmYMm9fZrWxqN2ZJptahCgGkIUNwR0n3m5zhiJw=";
    };
    license = "gpl3";
    description = "Night theme for Zotero UI and PDF";
    homepage = "https://github.com/tefkah/zotero";
    addonId = "night@tefkah.com.";
  };
  zotero-pdf-translate = {
    pname = "zotero-pdf-translate";
    version = "1.0.27";
    src = fetchurl {
      url = "https://github.com/windingwind/zotero-pdf-translate/releases/download/v1.0.27/zotero-pdf-translate.xpi";
      sha256 = "sha256-R7Mdej8HMzuWETvY90KGZ8Hmx1qYs77kO4bsD8MRvA8=";
    };
    license = "agpl3Only";
    description = "Translate PDF, EPub, webpage, metadata, annotations, notes to the target language. Support 20+ translate services.";
    homepage = "https://github.com/winidngwind/zotero-pdf-translate";
    addonId = "zoteropdftranslate@euclpts.com";
  };
  zotero-zotfile = {
    pname = "zotero-zotfile";
    version = "5.1.2";
    src = fetchurl {
      url = "https://github.com/jlegewie/zotfile/releases/download/v5.1.2/zotfile-5.1.2-fx.xpi";
      sha256 = "sha256-vmJVLqNgxbI6eE3TqDKJs/u/Bdemag2aADfy8L89YKc=";
    };
    license = "gpl3";
    description = "Zotero plugin to manage your attachments: automatically rename, move, and attach PDFs (or other files) to Zotero items, sync PDFs from your Zotero library to your (mobile) PDF reader (e.g. an iPad, Android tablet, etc.), and extract PDF annotations.";
    homepage = "https://github.com/jlegewie/zotfile";
    addonId = "zotfile@columbia.edu";
  };
}
