# Need to add `ln -sf /lib/node_modules ./node_modules` to devshell Hook
# Because prettier v3 doesn't recognize global plugins.
# https://github.com/prettier/prettier/issues/15141
{ final, prev }:
with prev; nodePackages.prettier.overrideAttrs {
  passthru.withPlugins = p:
    let
      _plugins = p final.nodePackages;
      plugins = map (p: if lib.isDerivation p then p else final.nodePackages.${p}) _plugins;
    in
    buildEnv {
      nativeBuildInputs = [ makeWrapper ];
      name = "prettier-with-plugins";
      paths = [ nodePackages.prettier ] ++ plugins;
      pathsToLink = [
        "/bin"
        "/lib/node_modules"
      ];
      postBuild = ''
        wrapProgram "$out/bin/prettier" \
          --set NODE_PATH "$out/lib/node_modules"
      '';
    };
}
