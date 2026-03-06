{
  pkgSource,
  lib,
  jre,
  makeWrapper,
  maven,
}:

maven.buildMavenPackage {
  inherit (pkgSource)
    pname
    src
    ;
  version = pkgSource.date;
  mvnHash = "sha256-fGOFUz/3E9J6uBvpFqNCiKnX4PWZ2pxyvoTMztICwpU=";

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
