# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  zotero-better-bibtex = {
    pname = "zotero-better-bibtex";
    version = "7.0.35";
    src = fetchurl {
      url = "https://github.com/retorquere/zotero-better-bibtex/releases/download/v7.0.35/zotero-better-bibtex-7.0.35.xpi";
      sha256 = "sha256-wL2fyUnOQ3p9RiZFc/ZtMMN+xrgre6hl7/ntVChMlzo=";
    };
    addonId = "better-bibtex@iris-advies.com";
    license = "mit";
    homepage = "https://github.com/retorquere/zotero-better-bibtex";
    description = "Make Zotero effective for us LaTeX holdouts";
  };
  zotero-night = {
    pname = "zotero-night";
    version = "0.4.23";
    src = fetchurl {
      url = "https://github.com/tefkah/zotero-night/releases/download/v0.4.23/night.xpi";
      sha256 = "sha256-szoKwmYMm9fZrWxqN2ZJptahCgGkIUNwR0n3m5zhiJw=";
    };
    addonId = "night@tefkah.com";
    license = "gpl3";
    homepage = "https://github.com/tefkah/zotero";
    description = "Night theme for Zotero UI and PDF";
  };
  zotero-pdf-translate = {
    pname = "zotero-pdf-translate";
    version = "2.2.14";
    src = fetchurl {
      url = "https://github.com/windingwind/zotero-pdf-translate/releases/download/v2.2.14/translate-for-zotero.xpi";
      sha256 = "sha256-PYRP6X45QvknmVA2DKSK6Gq57zDETIRy4njeNmt4AWE=";
    };
    addonId = "zoteropdftranslate@euclpts.com";
    license = "agpl3Only";
    homepage = "https://github.com/winidngwind/zotero-pdf-translate";
    description = "Translate PDF, EPub, webpage, metadata, annotations, notes to the target language. Support 20+ translate services.";
  };
  zotero-scipdf = {
    pname = "zotero-scipdf";
    version = "1.3.0";
    src = fetchurl {
      url = "https://github.com/syt2/zotero-scipdf/releases/download/V1.3.0/sci-pdf.xpi";
      sha256 = "sha256-Z0OVtN7JHmvfE0hZ6rQ6VUgLFJPF3hnewJn/iQ+Ma8c=";
    };
    addonId = "scipdf@ytshen.com";
    license = "agpl3Plus";
    homepage = "https://github.com/syt2/zotero-scipdf";
    description = "Download PDF from Sci-Hub automatically (For Zotero7)";
  };
  zotero-zotfile = {
    pname = "zotero-zotfile";
    version = "5.1.2";
    src = fetchurl {
      url = "https://github.com/jlegewie/zotfile/releases/download/v5.1.2/zotfile-5.1.2-fx.xpi";
      sha256 = "sha256-vmJVLqNgxbI6eE3TqDKJs/u/Bdemag2aADfy8L89YKc=";
    };
    addonId = "zotfile@columbia.edu";
    license = "gpl3";
    homepage = "https://github.com/jlegewie/zotfile";
    description = "Zotero plugin to manage your attachments: automatically rename, move, and attach PDFs (or other files) to Zotero items, sync PDFs from your Zotero library to your (mobile) PDF reader (e.g. an iPad, Android tablet, etc.), and extract PDF annotations.";
  };
  zotero-zotmoov = {
    pname = "zotero-zotmoov";
    version = "1.2.21";
    src = fetchurl {
      url = "https://github.com/wileyyugioh/zotmoov/releases/download/1.2.21/zotmoov-1.2.21-fx.xpi";
      sha256 = "sha256-gN5INdWAM8LSJKGzinklT05x4oU28muJUYLtmmh9Pn4=";
    };
    addonId = "zotmoov@wileyy.com";
    license = "gpl3Only";
    homepage = "https://github.com/wileyyugioh/zotmoov";
    description = "Mooves attachments and links them";
  };
}
