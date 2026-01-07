{
  lib,
  name,
  pkgSources,
  stdenv,
  buildPythonPackage,
  beartype,
  py-key-value-shared,
  uv-build,
  dependency-groups,
  cachetools,
  diskcache,
  pathvalidate,
  aiofile,
  anyio,
  redis,
  pymongo,
  valkey-glide,
  hvac,
  aiomcache,
  elasticsearch,
  aiohttp,
  keyring,
  dbus-python,
  pydantic,
  rocksdict,
  duckdb,
  pytz,
  cryptography,
}:
buildPythonPackage {
  inherit (pkgSources."${name}") pname version src;

  doCheck = false;
  pyproject = true;
  # for runtime depend
  propagatedBuildInputs = [
    beartype
    py-key-value-shared
  ];
  build-system = [ uv-build ];
  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace-fail "uv_build>=0.8.2,<0.9.0" "uv_build"
  '';
  dependencies = [
    dependency-groups
  ];
  optional-dependencies = {
    dev = [
      # memory
      cachetools
      # disk
      diskcache
      pathvalidate
      # filetree
      aiofile
      anyio
      # redis
      redis
      # mongodb
      pymongo
      # valkey
      valkey-glide
      # valut
      hvac
      # memcasched
      aiomcache
      # elasticsearch
      elasticsearch
      aiohttp
      # pydntic
      pydantic
      # rocksdb
      rocksdict
      # duckdb
      duckdb
      pytz
      # wrappers-encryption
      cryptography
      # keyring
      keyring
    ]
    ++ lib.optional stdenv.isLinux dbus-python; # keyring-linux
  };

  meta = with lib; {
    homepage = "http://strawgate.com/py-key-value/";
    description = "A pluggable interface for KV Stores";
    license = licenses.asl20;
    platforms = lib.platforms.all;
  };
}
