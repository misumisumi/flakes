{
  lib,
  stdenvNoCC,
  fetchurl,
  stdenv,
  patchelf,
  writeScript,
}:
stdenvNoCC.mkDerivation rec {
  pname = "oh-my-openagent";
  version = "5.1.51";

  src = fetchurl {
    url = "https://github.com/code-yeongyu/oh-my-openagent/releases/download/v${version}/omo-linux-x64";
    hash = "sha256-6ngz6kfREQjOg3eMppfBOvs9037xZeFgwJ3dTTGE1QY=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ patchelf ];

  buildInputs = [ stdenv.cc.cc.lib ];

  dontAutoPatchelf = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/omo
    runHook postInstall
  '';

  # autoPatchelfHook rewrites sections and breaks the payload embedded in the
  # bun-compiled executable, so only patch the ELF interpreter.
  postFixup = ''
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} $out/bin/omo
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$(mktemp -d)
    $out/bin/omo --version
    runHook postInstallCheck
  '';

  # Upstream publishes release tags that ship no binaries at all
  # (e.g. v5.1.52 and v5.1.53 have no assets), which makes plain
  # nix-update pick a version whose URL 404s. Select the newest
  # release that actually contains the omo-linux-x64 asset.
  passthru.updateScript = writeScript "oh-my-openagent-update" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq nix-update

    set -euo pipefail

    version=$(curl -fsSL "https://api.github.com/repos/code-yeongyu/oh-my-openagent/releases?per_page=100" | jq -er '
      map(select(.draft == false and .prerelease == false
        and any(.assets[]; .name == "omo-linux-x64")))
      | first | .tag_name | ltrimstr("v")
    ')

    nix-update --version "$version" --flake ${pname}
  '';

  meta = with lib; {
    description = "OmO Native - standalone AI coding assistant with the OMO extension built in";
    homepage = "https://github.com/code-yeongyu/oh-my-openagent";
    changelog = "https://github.com/code-yeongyu/oh-my-openagent/releases/tag/v${version}";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "omo";
    platforms = [ "x86_64-linux" ];
  };
}
