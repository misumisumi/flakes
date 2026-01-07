{
  lib,
  name,
  pkgSources,
  buildPythonPackage,
  beartype,
  typing-extensions,
  uv-build,
}:
buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;
  pyproject = true;
  # for runtime depend
  propagatedBuildInputs = [
    beartype
    typing-extensions
  ];
  build-system = [ uv-build ];
  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace-fail "uv_build>=0.8.2,<0.9.0" "uv_build"
  '';

  meta = with lib; {
    homepage = "http://strawgate.com/py-key-value/";
    description = "A pluggable interface for KV Stores";
    license = licenses.asl20;
    platforms = lib.platforms.all;
  };
}
