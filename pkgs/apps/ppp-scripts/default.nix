{
  stdenvNoCC,
  ppp,
  systemd,
  glibc,
  busybox,
  gnugrep,
}:
stdenvNoCC.mkDerivation {
  pname = "ppp-scripts";
  inherit (ppp) version;
  src = ./etc/ppp;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/etc/ppp/{ip-pre-up.d,ipv6-down.d,ipv6-up.d,peers}
    cp -r $src/* $out/etc/ppp
  '';
  postFixup = ''
    substituteInPlace $out/etc/ppp/ip-down.d/0000usepeerdns \
      --replace /sbin/resolvconf ${systemd}/bin/resolvconf \
      --replace systemctl ${systemd}/bin/systemctl \
      --replace /etc/init.d/nscd ${glibc}/bin/nscd \
      --replace grep ${gnugrep}/bin/grep
    substituteInPlace $out/etc/ppp/ip-up.d/0000usepeerdns \
      --replace /sbin/resolvconf ${systemd}/bin/resolvconf \
      --replace systemctl ${systemd}/bin/systemctl \
      --replace /etc/init.d/nscd ${glibc}/bin/nscd \
      --replace grep ${gnugrep}/bin/grep

    substituteInPlace $out/etc/ppp/ip-down \
      --replace run-parts ${busybox}/bin/run-parts
    substituteInPlace $out/etc/ppp/ip-pre-up \
      --replace run-parts ${busybox}/bin/run-parts
    substituteInPlace $out/etc/ppp/ip-up \
      --replace run-parts ${busybox}/bin/run-parts
    substituteInPlace $out/etc/ppp/ipv6-down \
      --replace run-parts ${busybox}/bin/run-parts
    substituteInPlace $out/etc/ppp/ipv6-up \
      --replace run-parts ${busybox}/bin/run-parts
  '';
  meta = {
    description = "ppp scripts from ubuntu";
    platforms = [ "x86_64-linux" ];
  };
}
