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

  meta = {
    description = "Simple command line wrapper around JD Core Java Decompiler project";
    homepage = "https://github.com/intoolswetrust/jd-cli";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ majiir ];
  };
}
