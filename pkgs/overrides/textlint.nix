{ final, prev }:
with prev; nodePackages.textlint.overrideAttrs {
  passthru.withPlugins = p:
    let
      _plugins = p final.nodePackages;
      plugins = map (p: if lib.isDerivation p then p else final.nodePackages.${p}) _plugins;
    in
    buildEnv {
      nativeBuildInputs = [ makeWrapper ];
      name = "textlint-with-plugins";
      paths = [ nodePackages.textlint ] ++ plugins;
      pathsToLink = [
        "/bin"
        "/lib/node_modules"
      ];
      postBuild = ''
        wrapProgram "$out/bin/textlint" \
          --set NODE_PATH "$out/lib/node_modules"
      '';
    };
}
