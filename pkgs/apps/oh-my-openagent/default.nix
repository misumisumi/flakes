{
  lib,
  stdenvNoCC,
  fetchurl,
  stdenv,
  patchelf,
  darwin,
}:
let
  system = stdenv.hostPlatform.system;
  version = "5.1.64";

  # Upstream publishes one standalone binary per OS/CPU. Keep the
  # asset name and hash next to each other so the update script can
  # refresh every platform in one go.
  assets = {
    "x86_64-linux" = {
      name = "omo-linux-x64";
      hash = "sha256-CflgMNBL40zW/JfFvmalnva7LGWJB1rMiW93wVUvELg=";
    };
    "aarch64-linux" = {
      name = "omo-linux-arm64";
      hash = "sha256-/Fw6LeSj/qO0f71ue2F+Nor+0w9waJAj5GwovBLoEMQ=";
    };
    "aarch64-darwin" = {
      name = "omo-darwin-arm64";
      hash = "sha256-WK+wYuqW6IrWxqtJglNveBD6vYobWyafW0hNjktgzUA=";
    };
  };

  source = assets.${system} or (throw "oh-my-openagent: unsupported system ${system}");
in
stdenvNoCC.mkDerivation {
  pname = "oh-my-openagent";
  inherit version;

  src = fetchurl {
    url = "https://github.com/code-yeongyu/oh-my-openagent/releases/download/v${version}/${source.name}";
    inherit (source) hash;
  };

  dontUnpack = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ patchelf ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.autoSignDarwinBinariesHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontAutoPatchelf = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/omo
    runHook postInstall
  '';

  # autoPatchelfHook rewrites sections and breaks the payload embedded in the
  # bun-compiled executable, so only patch the ELF interpreter.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} $out/bin/omo
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$(mktemp -d)
    $out/bin/omo --version
    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "OmO Native - standalone AI coding assistant with the OMO extension built in";
    homepage = "https://github.com/code-yeongyu/oh-my-openagent";
    changelog = "https://github.com/code-yeongyu/oh-my-openagent/releases/tag/v${version}";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "omo";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
