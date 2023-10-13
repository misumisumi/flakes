{ name
, pkgSources
, lib
, stdenv
, amtterm
, automake
, autoreconfHook
, bison
, byacc
, corosync
, docbook-xsl-ns
, flex
, glib
, gnutls
, inetutils
, libqb
, libtool
, libvirt
, libxml2
, libxslt
, nspr
, nss
, openssh
, openssl
, openstackclient
, openwsman
, patchelf
, pkg-config
, pythonPackages
, sg3_utils
, sudo
, systemd
, time
, util-linux
, agents ? "all"
}:
let
  pythonEnv = pythonPackages.python.withPackages (p: with p; [
    boto3
    pexpect
    pycurl
    requests
    kubernetes
    aliyun-python-sdk-core
  ]);
in
stdenv.mkDerivation rec {
  inherit (pkgSources."${name}") pname src;
  version = lib.removePrefix "v" pkgSources."${name}".version;
  nativeBuildInputs = [
    automake
    autoreconfHook
    bison
    byacc
    docbook-xsl-ns
    flex
    libtool
    libxml2
    libxslt
    openssl
    patchelf
    pkg-config
    pythonEnv
    util-linux
  ];
  buildInputs = [
    amtterm
    corosync
    glib
    gnutls
    inetutils
    libqb
    libvirt
    libxml2
    libxslt
    nspr
    nss
    openssh
    openstackclient
    openwsman
    sg3_utils
    sudo
    time
  ];
  runtimeDependencies = [ (lib.getLib systemd) ];
  propagatedBuildInputs = with pythonPackages; [
    boto3
    pexpect
    pycurl
    requests
    kubernetes
    aliyun-python-sdk-core
  ];
  pythonPath = with pythonPackages; [
    boto3
    pexpect
    pycurl
    requests
    kubernetes
    aliyun-python-sdk-core
  ];
  dontUseSetuptoolsBuild = true;
  autoreconfFlags = [
    "-i"
    "-I make"
    "-v"
  ];
  preAutoreconf = ''
    echo ${lib.removePrefix "v" version} > .tarball-version
    mkdir -p ./etc/default
    export initconfdir=$out/etc/default
  '';
  configureFlags = [
    "--prefix=$(out)"
    "--bindir=$(out)/bin"
    "--sbindir=$(out)/bin"
    "--libdir=$(out)/lib"
    "--libexecdir=$(out)/lib"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-fencetmpdir=$(out)/var/run/fence-agents"
    "--with-agents=${agents}"
  ];
  preInstall = ''
    mkdir -p $out/etc
    substituteInPlace Makefile \
      --replace "\$(INSTALL) -d \$(DESTDIR)/\$(LOGDIR)" "" \
      --replace "\$(INSTALL) -d \$(DESTDIR)/\$(CLUSTERVARRUN)" "" \
      --replace "\$(INSTALL) -d -m 1755 \$(DESTDIR)\$(FENCETMPDIR)" ""  \

    substituteInPlace agents/virt/config/Makefile \
      --replace "sysconfdir = /etc" "sysconfdir = $out/etc"
  '';

  postInstall = ''
    rm -rf "$out/var"
    rm -rf "$out/etc/init.d"
  '';

  meta = with lib; {
    homepage = "https://github.com/heavenshell/py-doq";
    description = "Docstring generator";
    license = licenses.bsd3;
  };
}
