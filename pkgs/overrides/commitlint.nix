{ final, prev }:
with prev; commitlint.overrideAttrs {
  passthru.withPlugins = p:
    let
      _plugins = p final.nodePackages;
      plugins = map (p: if lib.isDerivation p then p else final.nodePackages.${p}) _plugins;
    in
    buildEnv {
      nativeBuildInputs = [ makeWrapper ];
      name = "commitlint-with-plugins";
      paths = [ nodePackages."@commitlint/cli" ] ++ plugins;
      pathsToLink = [
        "/bin"
        "/lib/node_modules"
      ];
      postBuild = ''
        wrapProgram "$out/bin/commitlint" \
          --set NODE_PATH "$out/lib/node_modules"
      '';
    };
}
