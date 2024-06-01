{ pkgs }:
{
  commitlintMyEnv = pkgs.commitlint.withPlugins (ps: with ps; [
    "@commitlint/config-conventional"
    commitlint-format-json
  ]);
}
