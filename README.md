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

  - blender-bin_4_4-4.4.3
  - blender-bin_4_5-4.5.7
  - blender-bin_5_0-5.0.1
  - blender-bin_latest-5.0.1
  - bt-dualboot-1.0.1
  - commitlint-format-json-1.1.4
  - cups-brother-hll5100dn-3.5.1-1
  - discord-mcp-2026-02-14
  - drbd9-dkms-9.1.23
  - fence-agents-4.17.0
  - julius-speech-4.6
  - knp-2023-11-01
  - mcp-hub-4.2.1
  - mstflint-cx3-support-4.25.0-1
  - nixos-diff
  - openpace-1.1.4
  - paper-search-mcp-0.1.3
  - ppp-scripts-2.5.2
  - prettier-plugin-go-template-2023-07-26
  - prettier-plugin-kotlin-2.1.0
  - prettier-plugin-nginx-2023-03-17
  - prettier-plugin-php-v0.24.0
  - prettier-plugin-pug-3.4.2
  - prettier-plugin-ruby-v4.0.4
  - prettier-plugin-xml-v3.4.1
  - proton-ge-rtsp-bin-GE-Proton10-26-rtsp20
  - python3.13-jupynium-0.2.7
  - python3.13-pyknp-0.6.1
  - python3.13-valkey-glide-2.2.7
  - python3.13-version-pioneer-0.0.15
  - ricoh-sp-c260series-ppd-1.00
  - skk-emoji-jisyo-0.0.9
  - skk-emotikons-jisyo-2021-04-01
  - skk-jawiki-jisyo-2026.03.05.001107
  - skk-kaomoji-jisyo-2.30.5544.102
  - snack-2.2.10
  - tkdnd-2.9.5
  - update-github-actions-permissions-2.9.1
  - virtualsmartcard-virtualsmartcard-0.10
  - vrchat-vpm-cli-0.1.28
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-2026.03.05.001107
  - zotero-better-bibtex-9.0.2
  - zotero-night-0.4.23
  - zotero-pdf-translate-2.4.3
  - zotero-reading-list-1.5.17
  - zotero-scipdf-8.0.4
  - zotero-zotfile-5.1.2
  - zotero-zotmoov-1.2.26

