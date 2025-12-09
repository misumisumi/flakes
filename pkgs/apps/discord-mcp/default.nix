{
  name,
  pkgSources,
  lib,
  jre,
  makeWrapper,
  maven,
}:

maven.buildMavenPackage {
  inherit (pkgSources."${name}") pname version src;

  mvnHash = "sha256-T0K/TEJh99WonBt6jWo7ud6RAXPNBQ6KIugrcQvlh2s";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/discord-mcp
    cp target/*.jar $out/share/discord-mcp/

    makeWrapper ${jre}/bin/java $out/bin/discord-mcp \
      --add-flags "-jar $out/share/discord-mcp/discord-mcp-*.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A MCP server for the Discord integration. Enable your AI assistants to seamlessly interact with Discord. Enhance your Discord experience with powerful automation capabilities.";
    homepage = "https://github.com/SaseQ/discord-mcp";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
