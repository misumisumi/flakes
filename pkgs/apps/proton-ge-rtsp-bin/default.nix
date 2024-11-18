{
  name,
  pkgSources,
  proton-ge-bin,
}:
proton-ge-bin.overrideAttrs (oldAttrs: {
  inherit (pkgSources."${name}") pname version src;
})
