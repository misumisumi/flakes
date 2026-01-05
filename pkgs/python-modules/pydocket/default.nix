{
  lib,
  name,
  pkgSources,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  cloudpickle,
  fakeredis,
  opentelemetry-api,
  opentelemetry-exporter-prometheus,
  opentelemetry-instrumentation,
  prometheus-client,
  py-key-value-aio,
  python-json-logger,
  redis,
  rich,
  typer,
}:
buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;
  pyproject = true;
  # for runtime depend
  dependencies = [
    cloudpickle
    fakeredis
    opentelemetry-api
    opentelemetry-exporter-prometheus
    opentelemetry-instrumentation
    prometheus-client
    py-key-value-aio
    python-json-logger
    redis
    rich
    typer
  ]
  ++ py-key-value-aio.optional-dependencies.dev;
  pythonRelaxDeps = [
    "fakeredis"
    "opentelemetry-exporter-prometheus"
    "opentelemetry-instrumentation"
  ];
  build-system = [
    hatchling
    hatch-vcs
  ];

  meta = with lib; {
    homepage = "https://github.com/chrisguidry/docket";
    description = "docket is a distributed background task system for Python";
    license = licenses.mit;
    platforms = lib.platforms.all;
  };
}
