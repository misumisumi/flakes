{
  pkgSource,
  proton-ge-bin,
}:
proton-ge-bin.overrideAttrs (oldAttrs: {
  inherit (pkgSource) pname version src;
})
