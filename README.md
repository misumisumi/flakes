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

  - aac-OVMF-202605
  - aac-QEMU-amd-11.0.3
  - aac-QEMU-intel-11.0.3
  - anti-anti-cheat-patch-0-unstable-2026-08-08
  - blender-bin_4_5-4.5.16
  - blender-bin-5.2.3
  - blender-bin_lts-5.2.3
  - bt-dualboot-1.0.1
  - commitlint-format-json-1.1.0
  - cups-brother-hll5100dn-3.5.1-1
  - devshell
  - discord-mcp-1.0.0-unstable-2026-10-23
  - ibis-office-0.8.7
  - ibis-office-bin-0.8.7
  - julius-speech-4.6
  - mcp-hub-4.2.1
  - mcpvault-0.18.3
  - mstflint-cx3-support-4.25.0-1
  - ndi-6-6.3.2.0
  - nixos-diff
  - null
  - oh-my-openagent-5.1.70
  - openpace-1.1.4
  - paper-search-mcp-0.1.4-unstable-2026-10-02
  - ppp-scripts-2.5.2
  - prettier-plugin-nginx-0-unstable-2026-09-04
  - prettier-plugin-php-0.26.0
  - prettier-plugin-pug-3.6.0
  - prettier-plugin-ruby-4.0.4
  - prettier-plugin-sh-0.20.2
  - prettier-plugin-sql-0.20.0
  - prettier-plugin-toml-4.1.0
  - prettier-plugin-xml-3.4.1
  - proton-ge-rtsp-bin-GE-Proton10-33-rtsp24-1
  - python3.14-jupynium-0.2.8
  - python3.14-pdf-inspector-1.26.0
  - python3.14-valkey-glide-2.6.0
  - python3.14-version_pioneer-0.0.16
  - ricoh-sp-c260series-ppd-1.00
  - skk-emoji-jisyo-0.0.9
  - skk-emoticons-jisyo-0.2.1-unstable-2021-04-02
  - skk-jawiki-jisyo-2026.11.01.184542
  - skk-kaomoji-jisyo-3.35.6354
  - snack-2.2.10
  - tkdnd-2.9.5
  - tokyonight-gtk-theme-0-unstable-2025-10-23
  - update-github-actions-permissions-2.9.1
  - virtualsmartcard-0.11
  - vrchat-vpm-cli-0.1.28
  - wavesurfer-1.8.8p5
  - yaskkserv2-0.1.7
  - yaskkserv2-dict-2026.11.01.184542
  - zotero-better-bibtex-9.0.77
  - zotero-mcp-0.17.1
  - zotero-pdf-translate-2.4.8
  - zotero-reading-list-1.7.1
  - zotero-scipdf-8.1.1
  - zotero-zotmoov-1.2.34

