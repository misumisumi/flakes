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

  - @commitlint/config-angular-19.3.0
  - @commitlint/config-conventional-19.2.2
  - @commitlint/config-lerna-scopes-19.0.0
  - @commitlint/config-patternplate-19.3.0
  - @commitlint/load-19.2.0
  - @commitlint/read-19.2.1
  - @pkgdeps/update-github-actions-permissions-2.6.0
  - @pkgdeps/update-github-actions-permissions-2.6.0
  - @prettier/plugin-php-0.22.2
  - @prettier/plugin-pug-3.0.0
  - @prettier/plugin-ruby-4.0.4
  - @prettier/plugin-xml-3.4.1
  - @proofdict/textlint-rule-proofdict-3.1.2
  - bt-dualboot-1.0.1
  - commitlint-format-json-1.1.0
  - commitlint-with-plugins
  - csharp-ls-0.14.0
  - cups-brother-hll5100dn-3.5.1-1
  - droidcam-obs-plugin-2.3.3
  - julius-speech-v4.6
  - knp-bc4cef188669f88cdeb590fe7afb1021ce2ae481
  - moralerspace-fonts-v1.0.2
  - moralerspace-nerd-fonts-v1.0.2
  - nixos-diff
  - plemoljp-fonts-v1.7.1
  - prettier-plugin-go-template-0.0.15
  - prettier-plugin-kotlin-2.1.0
  - prettier-plugin-nginx-1.0.3
  - prettier-plugin-rust-0.1.9
  - prettier-plugin-sh-0.14.0
  - prettier-plugin-sql-0.18.1
  - prime-run
  - python3.12-jupynium-0.2.4
  - python3.12-pyknp-0.6.1
  - python3.12-suds-1.1.2
  - ricoh-sp-c260series-ppd-1.00
  - skk-emoji-jisyo-v0.0.9
  - snack-2.2.10
  - textlint-filter-rule-allowlist-4.0.0
  - textlint-filter-rule-comments-1.2.2
  - textlint-rule-preset-ja-engineering-paper-1.0.4
  - textlint-rule-preset-ja-spacing-2.4.3
  - textlint-rule-preset-ja-technical-writing-10.0.1
  - tkdnd-2.9.4
  - unityhub-latest-3.8.0
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-d62e22ece14866e4cb935c8077d7b49aa1897bd8
  - zenn-cli-0.1.154
  - zotero-better-bibtex-6.7.212
  - zotero-night-0.4.23
  - zotero-pdf-translate-1.0.27
  - zotero-zotfile-5.1.2

