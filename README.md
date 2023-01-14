# My nix packages and nixos modules

This repository use [nvfetcher](https://github.com/berberman/nvfetcher.git) for auto update packages.

## Warning

1. When using `asusctl-latest` and `supergfxctl-latest`, the nixpkgs does not contain the latest rustc, so you need to adjust the version.default.(So I'm treating it as broken.)
2. `fcitx5-mozc-ext-neologd` conflicts with fcitx5-mozc included in nixpkgs
3. `modules/yaskkserv2.nix` is module for [home-manager](https://github.com/nix-community/home-manager).
   In addition, intended to be used with fcitx5

## Available packages

- Apps
  - [droidcam-obs-plugin](https://dev47apps.com/obs/)
  - [fcitx5-mozc-ext-neologd](https://aur.archlinux.org/packages/fcitx5-mozc-ext-neologd)
  - [fcitx5-nord](https://github.com/tonyfettes/fcitx5-nord.git)
  - [fcitx5-skk](https://github.com/fcitx/fcitx5-skk)
  - [juce](https://juce.com/)
  - [knp](https://nlp.ist.i.kyoto-u.ac.jp/?KNP)
  - [prime-run](https://wiki.archlinux.org/title/PRIME)
  - [skk-emoji-jisyo](https://github.com/uasi/skk-emoji-jisyo)
  - [snack](https://www.speech.kth.se/snack/)
  - [unityhub-latest](https://unity.com/ja/download)
  - [wavesurfer](https://gitlab.com/asus-linux/supergfxctl)
  - [xp-pen-tablet](https://www.xp-pen.com/download)
  - [yaskkserv2](https://github.com/wachikun/yaskkserv2)
  - [yaskkserv2-dict](https://github.com/wachikun/yaskkserv2)
  - They already exist in nixpkgs-unstable.
    - [asusctl-latest](https://gitlab.com/asus-linux/asusctl)
    - [supergfxctl-latest](https://gitlab.com/asus-linux/supergfxctl)
- PythonModules
  - [doc](https://github.com/heavenshell/py-doq)
  - [pyknp](https://github.com/heavenshell/py-doq)

## ToDO

- [ ] Add auto update package system using github action
- [x] Do I `pythonPackages` overlays?
