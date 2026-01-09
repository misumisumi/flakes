# My nix packages and nixosModules

This repository use [nvfetcher](https://github.com/berberman/nvfetcher.git) for auto update packages.

## Usage

### Use binary cache from cachix:

```sh
$ cachix use misumisumi
```

### Run a package immediately

```sh
$ nix run github:misumisumi/flakes#<package-name>
```

### Add the overlay to your system

In your `flake.nix`

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    misumisumi = {
      url = "github:misumisumi/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, misumisumi }: {
    nixosConfigurations.my-machine = nixpkgs.lib.nixosSystem {
      # ...
      modules = [
        # ...
        {
          nixpkgs.overlays = [
            # ...
            misumisumi.overlays
          ];
        }
      ];
    };
  };
}

```

## Available packages

  - @commitlint/config-angular-20.3.1
  - @commitlint/config-conventional-20.3.1
  - @commitlint/config-patternplate-20.3.1
  - @commitlint/config-workspace-scopes-20.2.0
  - @commitlint/load-20.3.1
  - @commitlint/read-20.3.1
  - @modelcontextprotocol/server-everything-2025.12.18
  - @modelcontextprotocol/server-filesystem-2025.12.18
  - @modelcontextprotocol/server-filesystem-2025.12.18
  - @modelcontextprotocol/server-memory-2025.11.25
  - @modelcontextprotocol/server-memory-2025.11.25
  - @modelcontextprotocol/server-sequential-thinking-2025.12.18
  - @modelcontextprotocol/server-sequential-thinking-2025.12.18
  - @pkgdeps/update-github-actions-permissions-2.9.1
  - @pkgdeps/update-github-actions-permissions-2.9.1
  - @prettier/plugin-php-0.24.0
  - @prettier/plugin-pug-3.4.2
  - @prettier/plugin-ruby-4.0.4
  - @prettier/plugin-xml-3.4.2
  - @proofdict/textlint-rule-proofdict-3.1.2
  - bt-dualboot-1.0.1
  - commitlint-format-json-1.1.0
  - commitlint-with-plugins
  - cups-brother-hll5100dn-3.5.1-1
  - discord-mcp-ac33c4f492fcd99b08aa9dfbd95f8ec4279c1e72
  - jawiki-kana-kanji-dict-2025-08-11
  - julius-speech-v4.6
  - knp-bc4cef188669f88cdeb590fe7afb1021ce2ae481
  - mcp-hub-4.2.1
  - mcp-hub-4.2.1
  - mstflint-cx3-support-4.25.0-1
  - napi-postinstall-0.3.4
  - nixos-diff
  - openpace-1.1.3
  - paper-search-mcp-0.1.3
  - ppp-scripts-2.5.2
  - prettier-plugin-go-template-0.0.15
  - prettier-plugin-kotlin-2.1.0
  - prettier-plugin-nginx-1.0.3
  - prettier-plugin-rust-0.1.9
  - prettier-plugin-sh-0.18.0
  - prettier-plugin-sql-0.19.2
  - proton-ge-rtsp-bin-GE-Proton10-26-rtsp20
  - python3.13-fastmcp--2.14.2
  - python3.13-jupynium-0.2.7
  - python3.13-py-key-value-aio-0.3.0
  - python3.13-py-key-value-shared-0.3.0
  - python3.13-pydocket-0.16.4
  - python3.13-pyknp-0.6.1
  - python3.13-rocksdict-v0.3.29
  - python3.13-valkey-glide-2.2.3
  - python3.13-version-pioneer-0.0.14
  - ricoh-sp-c260series-ppd-1.00
  - skk-emoji-jisyo-v0.0.9
  - skk-emotikons-jisyo-2021-04-01
  - skk-kaomoji-jisyo-2.30.5544.102
  - snack-2.2.10
  - textlint-filter-rule-allowlist-4.0.0
  - textlint-filter-rule-comments-1.3.0
  - textlint-rule-preset-ja-engineering-paper-1.0.4
  - textlint-rule-preset-ja-spacing-2.4.3
  - textlint-rule-preset-ja-technical-writing-12.0.2
  - tkdnd-2.9.5
  - virtualsmartcard-virtualsmartcard-0.10
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-2025-08-11
  - zotero-better-bibtex-7.0.75
  - zotero-night-0.4.23
  - zotero-pdf-translate-2.3.16
  - zotero-reading-list-1.5.15
  - zotero-scipdf-8.0.1
  - zotero-zotfile-5.1.2
  - zotero-zotmoov-1.2.25

