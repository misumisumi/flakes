{
  lib,
  fetchFromGitHub,
  nix-update-script,
  jre,
  makeWrapper,
  maven,
}:

maven.buildMavenPackage {
  pname = "discord-mcp";
  version = "1.0.0-unstable-2026-04-25";
  src = fetchFromGitHub {
    owner = "SaseQ";
    repo = "discord-mcp";
    rev = "0b35793bf9f86cc65849ae42ebae940718fbf812";
    fetchSubmodules = false;
    sha256 = "sha256-cse7EqqdIBY6QiSmIYjdqRN9jCSQsaTOaI2EzPJKS8s=";
  };
  mvnHash = "sha256-ou9rfs19udyKP3NGaPRYqRREJQy5AtwWrYcUf42fXHQ=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/discord-mcp
    cp target/*.jar $out/share/discord-mcp/

    makeWrapper ${jre}/bin/java $out/bin/discord-mcp \
      --add-flags "-jar $out/share/discord-mcp/discord-mcp-*.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--flake"
      "--version"
      "branch"
    ];
  };

  meta = with lib; {
    description = "A MCP server for the Discord integration. Enable your AI assistants to seamlessly interact with Discord. Enhance your Discord experience with powerful automation capabilities.";
    homepage = "https://github.com/SaseQ/discord-mcp";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
