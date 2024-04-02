# Node Packageの作成について

## 基本

[languages-frameworks/javascript.section](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/doc/languages-frameworks/javascript.section.md)に従えば良い。  
パッケージ定義は`node2nix`で自動的に生成される。  
`@owner/repo`のようなパッケージは`nodePackages."@owner/repo"`で取得可能。  
`pkgs.<repo>`にしたい場合はこのリポジトリの`flake.nix`にある通り`main-programs.nix`のメインプログラムと同じ名前になるようにしている。(公式に実装は分からない。)  
`node2nix`でビルドできないパッケージは`overrides.nix`で修正する。  
逆に`stdenv.mkDerivation`などで作成したパッケージを`pkgs.nodePackages`に含める場合は`aliases.nix`に記載する。

## npmで配布されていないパッケージについて

GitHub等から自分でビルドする場合も基本的に従えば良い。  
`yarn.lock`しかないプロジェクトでは`yarn.lock`のハッシュの更新が必要がある。  
ハッシュはファイル自体のものではなく`nix`によって依存関係が全て解決されたものに対してのハッシュである。
2024/03/28現在[nvfetcher](https://github.com/berberman/nvfetcher)は`yarn.lock`の更新に対応していないため自分で更新する必要がある。  
よってこれを自動で更新するスクリプトを作成した。(`scripts/update-yarn-lock.sh`)  
`packages.toml`を以下のように作成する。

```toml
[update-github-actions-permissions]
src.github_tag = "pkgdeps/update-github-actions-permissions"
fetch.github = "pkgdeps/update-github-actions-permissions"
extract = ["yarn.lock"]
passthru = { yarn-hash = "update-github-actions-permissions-yarn-hash" }
```

`_sources/<pkgs>-<ver>/yarn.lock`が作成されるので`prefetch-yarn-deps`でハッシュを取得し、正規表現によって`<pkg-name>-yarn-hash`を更新する。
