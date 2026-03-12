{
  lib,
  pkgSource,
  stdenvNoCC,
  dotnet-sdk,
  unzip,
}:

stdenvNoCC.mkDerivation {
  inherit (pkgSource) pname version src;
  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./tools $out/
    cp ./{README.md,LICENSE.md} $out/
    DLLPATH=$(find $out/tools -type f -name "vpm.dll")
    cat <<EOF > $out/bin/vpm
      DOTNET_ROOT=${dotnet-sdk} ${dotnet-sdk}/bin/dotnet ''${DLLPATH} \$@
    EOF
    chmod +x $out/bin/vpm
  '';

  meta = {
    description = "The VRChat Package Manager from Command Line";
    homepage = "https://vcc.docs.vrchat.com/vpm/cli/";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
