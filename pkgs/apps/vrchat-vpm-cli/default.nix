{ stdenvNoCC, lib, fetchpatch, name, pkgSources, writeShellApplication, makeWrapper, dotnet-sdk_6, unzip }:

stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;
  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src -d /build/
  '';

  installPhase = ''
    mkdir -p $out/bin
    cat <<EOF > $out/bin/vpm
      DOTNET_ROOT=${dotnet-sdk_6} ${dotnet-sdk_6}/dotnet $out/tools/net6.0/any/vpm.dll \$@
    EOF
    chmod +x $out/bin/vpm
    cp -r ./tools $out/
    cp ./{README.md,LICENSE.md} $out/
  '';

  meta = with lib; {
    inherit version;
    description = "The VRChat Package Manager from Command Line";
    homepage = "https://vcc.docs.vrchat.com/vpm/cli/";
  };
}
