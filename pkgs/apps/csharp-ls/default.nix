{ stdenvNoCC, lib, fetchpatch, name, pkgSources, writeShellApplication, makeWrapper, dotnet-sdk_7, unzip }:

stdenvNoCC.mkDerivation rec {
  inherit (pkgSources."${name}") pname version src;
  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src -d /build/
  '';

  installPhase = ''
    mkdir -p $out/bin
    cat <<EOF > $out/bin/csharp-ls
      DOTNET_ROOT=${dotnet-sdk_7} ${dotnet-sdk_7}/dotnet $out/tools/net7.0/any/CSharpLanguageServer.dll \$@
    EOF
    chmod +x $out/bin/csharp-ls
    cp -r ./tools $out/
  '';

  meta = with lib; {
    inherit version;
    homepage = "https://github.com/razzmatazz/csharp-language-server";
    description = "Roslyn-based LSP language server for C#";
    license = licenses.mit;
  };
}
