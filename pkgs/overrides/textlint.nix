{ final, prev }:
with prev;
textlint.overrideAttrs {
  passthru.withPlugins =
    plugins:
    buildEnv {
      nativeBuildInputs = [ makeWrapper ];
      name = "textlint-with-plugins";
      paths = [ nodePackages.textlint ] ++ (plugins final);
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
