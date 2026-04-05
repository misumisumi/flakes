{ final, prev }:
with prev;
commitlint.overrideAttrs {
  passthru.withPlugins =
    plugins:
    buildEnv {
      nativeBuildInputs = [ makeWrapper ];
      name = "commitlint-with-plugins";
      paths = [ commitlint ] ++ plugins;
      pathsToLink = [
        "/bin"
        "/lib/node_modules"
      ];
      postBuild = ''
        #HACK: NODE_PATH is not working since node v22 so I use NPM_CONFIG_PREFIX from https://github.com/nodejs/node/blob/4451309e99e37da7d4b44b5fb136db1c6a1dea90/doc/api/modules.md
        wrapProgram "$out/bin/commitlint" \
          --set NPM_CONFIG_PREFIX "$out"
      '';
    };
}
