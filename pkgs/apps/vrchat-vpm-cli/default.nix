{
  fetchurl,
  writeScript,
  stdenvNoCC,
  dotnet-sdk,
  unzip,
}:
let
  version = "0.1.28";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vrchat-vpm-cli";
  inherit version;
  src = fetchurl {
    url = "https://www.nuget.org/api/v2/package/VRChat.VPM.CLI/${version}";
    sha256 = "sha256-Pz8KBpjmpzx+6gD4nqGVBEp5z4UX6hFqZHGy8hJCD4k=";
  };
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

  passthru.updateScript = writeScript "update" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq nix-update

    set -euo pipefail

    version=$(curl -fsSL "https://api.nuget.org/v3-flatcontainer/vrchat.vpm.cli/index.json" | jq -er '.versions | last(.[] | select(match("^[0-9]+\\.[0-9]+\\.[0-9]+$")))')
    nix-update --version "$version" --flake ${finalAttrs.pname}
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
})
