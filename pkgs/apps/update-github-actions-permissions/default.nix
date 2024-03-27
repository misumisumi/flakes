{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, prefetch-yarn-deps
, yarn
, name
, pkgSources
}:
stdenv.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = pkgSources."${name}".yarn-hash;
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    prefetch-yarn-deps
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p $out/lib/node_modules/@pkgdeps/update-github-actions-permissions
    cp -r actions.yml package.json node_modules third-party module bin $out/lib/node_modules/@pkgdeps/update-github-actions-permissions

    makeWrapper "${nodejs}/bin/node" "$out/bin/update-github-actions-permissions" \
      --add-flags "$out/lib/node_modules/@pkgdeps/update-github-actions-permissions/bin/cmd.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Update GitHub Actions's permissions automatically.";
    homepage = "https://github.com/pkgdeps/update-github-actions-permissions?tab=readme-ov-file";
    license = with licenses; [ mit agpl3Only ];
    inherit (nodejs.meta) platforms;
  };
}

