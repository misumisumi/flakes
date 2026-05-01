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

  - aac-OVMF-202602
  - aac-OVMF-202602
  - aac-QEMU-amd-10.2.1
  - aac-QEMU-intel-10.2.1
  - anti-anti-cheat-patch-0-unstable-2026-04-28
  - blender-bin_4_5-4.5.9
  - blender-bin-5.1.1
  - blender-bin_lts-4.5.9
  - bt-dualboot-1.0.1
  - commitlint-format-json-1.1.0
  - cups-brother-hll5100dn-3.5.1-1
  - discord-mcp-1.0.0-unstable-2026-04-25
  - julius-speech-4.6
  - knp-trank-20121203+1-unstable-2023-11-01
  - mcp-hub-4.2.1
  - mcpvault-0-unstable-2026-04-16
  - mstflint-cx3-support-4.25.0-1
  - nixos-diff
  - nix-update-1.14.0
  - openpace-1.1.4
  - paper-search-mcp-0.1.3-unstable-2026-04-27
  - ppp-scripts-2.5.2
  - prettier-plugin-nginx-0-unstable-2023-03-17
  - prettier-plugin-php-0.25.0
  - prettier-plugin-pug-3.4.2
  - prettier-plugin-ruby-3.4.1
  - prettier-plugin-ruby-4.0.4
  - prettier-plugin-sh-0.18.1
  - prettier-plugin-sql-0.20.0
  - prettier-plugin-toml-2.0.6
  - proton-ge-rtsp-bin-GE-Proton10-33-rtsp24-1
  - python3.13-jupynium-0.2.7
  - python3.13-valkey-glide-2.3.1
  - python3.13-version_pioneer-0.0.16
  - ricoh-sp-c260series-ppd-1.00
  - skk-emoji-jisyo-0.0.9
  - skk-emoticons-jisyo-0.2.1-unstable-2021-04-02
  - skk-jawiki-jisyo-2026.04.21.141141
  - skk-kaomoji-jisyo-2.30.5544.102
  - snack-2.2.10
  - tkdnd-2.9.5
  - update-github-actions-permissions-2.9.1
  - virtualsmartcard-0.10
  - vrchat-vpm-cli-0.1.28
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-2026.04.21.141141
  - zotero-better-bibtex-9.0.19
  - zotero-night-0.4.23
  - zotero-pdf-translate-2.4.3
  - zotero-reading-list-1.5.17
  - zotero-scipdf-8.0.4
  - zotero-zotfile-5.1.2
  - zotero-zotmoov-1.2.26

