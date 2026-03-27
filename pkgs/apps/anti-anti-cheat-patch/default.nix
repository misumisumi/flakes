{
  pkgSource,
  lib,
  stdenvNoCC,
  qemu,
  edk2,
  qemuVersion ? qemu.version,
  edk2Version ? edk2.version,
}:
let
  inherit (lib.versions) majorMinor;
  qemuMajorMinor = majorMinor qemuVersion;
  edk2MajorMinor = majorMinor edk2Version;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (pkgSource) pname src;
  version = pkgSource.date;

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontSetup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{QEMU,EDK2}

    function cp_patches () {
      dir="$1"
      pattern="$2"
      outDir="$3"

      patchExist=$(find "$dir" -maxdepth 1 -type f -name "$pattern" | wc -l)
      if [ "$patchExist" -eq 0 ]; then
        return 1
      fi

      version=$(find "$dir" -maxdepth 1 -type f -name "$pattern" | sort -r | head -n1 | grep -oE '[0-9]+(\.[0-9]+)+')

      mkdir -p "$outDir"
      while read -r patchFile; do
          base=$(basename "$patchFile")
          lower="''${base,,}"
          cp_tgt="''${lower%%-*}.patch"
          cp "$patchFile" "$outDir/''${cp_tgt}"
      done < <(find $dir -maxdepth 1 -type f -name "*$version.patch")
    }

    search_patterns=(
      "QEMU,*${qemuVersion}.patch"
      "QEMU/Archive,*${qemuVersion}.patch"
      "QEMU,*${qemuMajorMinor}*.patch"
      "QEMU/Archive,*${qemuMajorMinor}*.patch"
    )

    for pattern in "''${search_patterns[@]}"; do
      dir="''${pattern%%,*}"
      version="''${pattern##*,}"
      cp_patches "patches/$dir" "$version" "$out/QEMU" && break
    done

    search_patterns=(
      "EDK2,*${edk2Version}.patch"
      "EDK2/Archive,*${edk2Version}.patch"
      "EDK2,*${edk2MajorMinor}*.patch"
      "EDK2/Archive,*${edk2MajorMinor}*.patch"
    )

    for pattern in "''${search_patterns[@]}"; do
      dir="''${pattern%%,*}"
      version="''${pattern##*,}"
      cp_patches "patches/$dir" "$version" "$out/EDK2" && break
    done
    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace "$out/QEMU/intel.patch" \
      --replace-fail "+#define PCI_VENDOR_ID_REDHAT_QUMRANET    0x8086" "+#define PCI_VENDOR_ID_REDHAT_QUMRANET    0x1af4 " \
      --replace-fail "+#define PCI_SUBVENDOR_ID_REDHAT_QUMRANET 0x8086" "+#define PCI_SUBVENDOR_ID_REDHAT_QUMRANET 0x1af4 " \
      --replace-fail "+#define PCI_SUBDEVICE_ID_QEMU            0x8086" "+#define PCI_SUBDEVICE_ID_QEMU            0x1100 " \
      --replace-fail "+    dc->hotpluggable = false;" "+    dc->hotpluggable = true;"

    substituteInPlace "$out/QEMU/amd.patch" \
      --replace-fail "+#define PCI_VENDOR_ID_REDHAT_QUMRANET    0x1022" "+#define PCI_VENDOR_ID_REDHAT_QUMRANET    0x1af4" \
      --replace-fail "+#define PCI_SUBVENDOR_ID_REDHAT_QUMRANET 0x1022" "+#define PCI_SUBVENDOR_ID_REDHAT_QUMRANET 0x1af4" \
      --replace-fail "+#define PCI_SUBDEVICE_ID_QEMU            0x1022" "+#define PCI_SUBDEVICE_ID_QEMU            0x1100" \
      --replace-fail "+    dc->hotpluggable = false;" "+    dc->hotpluggable = true;" \
      --replace-fail "pcmc->smbios_defaults = false" "pcmc->smbios_defaults = true"

    sed -i 's/\r//' "$out/QEMU/intel.patch"
    sed -i 's/\r//' "$out/QEMU/amd.patch"
  '';

  passthru = {
    qemuPatch = {
      amd = "${finalAttrs.finalPackage.out}/QEMU/amd.patch";
      intel = "${finalAttrs.finalPackage.out}/QEMU/intel.patch";
    };
    edk2Patch = {
      amd = "${finalAttrs.finalPackage.out}/EDK2/amd.patch";
      intel = "${finalAttrs.finalPackage.out}/EDK2/intel.patch";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/Scrut1ny/AutoVirt/tree/main";
    description = "Automated Linux virtualization scripts for advanced malware analysis.";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
})
