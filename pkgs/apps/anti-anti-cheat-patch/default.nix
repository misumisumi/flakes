{
  lib,
  fetchFromGitHub,
  nix-update-script,
  stdenvNoCC,
  qemu,
  edk2,
  qemuVersion ? qemu.version,
  edk2Version ? edk2.version,
}:
let
  inherit (lib) optionalString versionOlder;
  inherit (lib.versions) majorMinor;
  qemuMajorMinor = majorMinor qemuVersion;
  edk2MajorMinor = majorMinor edk2Version;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "anti-anti-cheat-patch";
  version = "0-unstable-2026-06-14";
  src = fetchFromGitHub {
    owner = "Scrut1ny";
    repo = "AutoVirt";
    rev = "267ec3effbaf49ca43ad27c9c01dcc9859cebc2c";
    sha256 = "sha256-oejSjvSlIpQL6JE8mR8B9KCy90V8kDPeO8UFrn0McVg=";
  };

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

      mkdir -p "$outDir"
      while read -r patchFile; do
          base=$(basename "$patchFile")
          lower="''${base,,}"
          cp_tgt="''${lower%%-*}.patch"
          cp "$patchFile" "$outDir/''${cp_tgt}"
      done < <(find "$dir" -maxdepth 1 -type f -name "$pattern")
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
    # for using looking-glass without patch to that
    substituteInPlace "$out/QEMU/intel.patch" \
        --replace-fail "+    dc->hotpluggable = false;" "+    dc->hotpluggable = true;"
    ${optionalString (versionOlder qemuVersion "11.0.0") ''
      substituteInPlace "$out/QEMU/intel.patch" \
        --replace-fail "+#define PCI_VENDOR_ID_REDHAT_QUMRANET    0x8086" "+#define PCI_VENDOR_ID_REDHAT_QUMRANET    0x1af4 " \
        --replace-fail "+#define PCI_SUBVENDOR_ID_REDHAT_QUMRANET 0x8086" "+#define PCI_SUBVENDOR_ID_REDHAT_QUMRANET 0x1af4 " \
        --replace-fail "+#define PCI_SUBDEVICE_ID_QEMU            0x8086" "+#define PCI_SUBDEVICE_ID_QEMU            0x1100 "
    ''}
    substituteInPlace "$out/QEMU/amd.patch" \
      --replace-fail "+    dc->hotpluggable = false;" "+    dc->hotpluggable = true;" \
      --replace-fail "pcmc->smbios_defaults = false" "pcmc->smbios_defaults = true"
    ${optionalString (versionOlder qemuVersion "11.0.0") ''
      substituteInPlace "$out/QEMU/amd.patch" \
        --replace-fail "+#define PCI_VENDOR_ID_REDHAT_QUMRANET    0x1022" "+#define PCI_VENDOR_ID_REDHAT_QUMRANET    0x1af4" \
        --replace-fail "+#define PCI_SUBVENDOR_ID_REDHAT_QUMRANET 0x1022" "+#define PCI_SUBVENDOR_ID_REDHAT_QUMRANET 0x1af4" \
        --replace-fail "+#define PCI_SUBDEVICE_ID_QEMU            0x1022" "+#define PCI_SUBDEVICE_ID_QEMU            0x1100"
    ''}

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
    updateScript = nix-update-script {
      extraArgs = [
        "--flake"
        "--version"
        "branch"
      ];
    };
  };

  meta = with lib; {
    homepage = "https://github.com/Scrut1ny/AutoVirt/tree/main";
    description = "Automated Linux virtualization scripts for advanced malware analysis.";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
})
