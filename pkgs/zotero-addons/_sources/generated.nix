# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  zotero-better-bibtex = {
    pname = "zotero-better-bibtex";
    version = "7.0.5";
    src = fetchurl {
      url = "https://github.com/retorquere/zotero-better-bibtex/releases/download/v7.0.5/zotero-better-bibtex-7.0.5.xpi";
      sha256 = "sha256-MXRcvd6QDYwKKPtLq01KlUijrHbMhUhu95qXcv3f6Pc=";
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
    addonId = "night@tefkah.com";
  };
  zotero-pdf-translate = {
    pname = "zotero-pdf-translate";
    version = "2.1.6";
    src = fetchurl {
      url = "https://github.com/windingwind/zotero-pdf-translate/releases/download/v2.1.6/translate-for-zotero.xpi";
      sha256 = "sha256-LoHlwrzwWzZeALeBW/JDGpkPZ/eZMl2cA4bJwI6StkM=";
    };
    license = "agpl3Only";
    description = "Translate PDF, EPub, webpage, metadata, annotations, notes to the target language. Support 20+ translate services.";
    homepage = "https://github.com/winidngwind/zotero-pdf-translate";
    addonId = "zoteropdftranslate@euclpts.com";
  };
  zotero-scipdf = {
    pname = "zotero-scipdf";
    version = "1.3.0";
    src = fetchurl {
      url = "https://github.com/syt2/zotero-scipdf/releases/download/V1.3.0/sci-pdf.xpi";
      sha256 = "sha256-Z0OVtN7JHmvfE0hZ6rQ6VUgLFJPF3hnewJn/iQ+Ma8c=";
    };
    license = "agpl3Plus";
    description = "Download PDF from Sci-Hub automatically (For Zotero7)";
    homepage = "https://github.com/syt2/zotero-scipdf";
    addonId = "scipdf@ytshen.com";
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
  zotero-zotmoov = {
    pname = "zotero-zotmoov";
    version = "1.2.18";
    src = fetchurl {
      url = "https://github.com/wileyyugioh/zotmoov/releases/download/1.2.18/zotmoov-1.2.18-fx.xpi";
      sha256 = "sha256-THHoymaINraEcEokZqPCod96FCx8CwHTqPYslv+iK9w=";
    };
    license = "gpl3Only";
    description = "Mooves attachments and links them";
    homepage = "https://github.com/wileyyugioh/zotmoov";
    addonId = "zotmoov@wileyy.com";
  };
}
