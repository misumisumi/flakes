{ pkgs }:
{
  commitlintMyEnv = pkgs.commitlint.withPlugins (ps: with ps; [
    "@commitlint/config-conventional"
    commitlint-format-json
  ]);
  textlintMyEnv = pkgs.textlint.withPlugins (ps: with ps; [
    textlint-filter-rule-allowlist
    textlint-filter-rule-comments
    textlint-rule-preset-ja-spacing
    textlint-rule-preset-ja-technical-writing
    "@proofdict/textlint-rule-proofdict"
  ]);
}
