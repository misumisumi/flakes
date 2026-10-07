{
  lib,
  edk2,
  fetchFromForgejo,
  fetchFromGitHub,
  fetchurl,
  qemu,
  stdenvNoCC,
}:
let
  inherit (lib) optionalString versionOlder versionAtLeast;
  inherit (lib.versions) majorMinor;

  fixed-qemu = qemu.overrideAttrs (old: rec {
    version = "11.0.3";
    src = fetchurl {
      url = "https://download.qemu.org/qemu-${version}.tar.xz";
      hash = "sha256-2l/P/DJ2KCBWi4KO1DCnKIZNNNULbS8wNYWXdgy7BSM=";
    };
    enableParallelBuilding = true;
  });
  fixed-edk2 = edk2.overrideAttrs (old: rec {
    version = "202605";
    srcWithVendoring = fetchFromGitHub {
      owner = "tianocore";
      repo = "edk2";
      tag = "edk2-stable${version}";
      fetchSubmodules = true;
      hash = "sha256-sUqLocdX7lxN2pEdn84Cjh8pOzYqIeKqO144XhwKA30=";
    };
    __intentionallyOverridingVersion = true;
  });
  qemuVersion = fixed-qemu.version;
  edk2Version = fixed-edk2.version;

  qemuMajorMinor = majorMinor qemuVersion;
  edk2MajorMinor = majorMinor edk2Version;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "anti-anti-cheat-patch";
  version = "0-unstable-2026-08-08";
  src = fetchFromForgejo {
    domain = "git.keyemail.dev";
    owner = "Scrut1ny";
    repo = "AutoVirt";
    rev = "190569cc940fb5366b095d5ca70b478769e65216";
    sha256 = "sha256-NiFiy0L+lz9PRACrccSnrRO7Vmpwby1cnv4COM3E1Co=";
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
      echo "Get patch for $pattern"
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
    # Also restore smbios_defaults: with it disabled QEMU omits the required
    # SMBIOS type 127 (End-of-Table) record, and OVMF's SmbiosPlatformDxe then
    # loops forever in InstallAllStructures() looking for the terminator.
    substituteInPlace "$out/QEMU/intel.patch" \
        --replace-fail "+    dc->hotpluggable = false;" "+    dc->hotpluggable = true;" \
        --replace-fail "pcmc->smbios_defaults = false" "pcmc->smbios_defaults = true"
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
    ${optionalString (versionOlder qemuVersion "11.0.2") ''
      substituteInPlace "$out/QEMU/amd.patch" \
        --replace-fail "+#define ICH9_SATA1_DEV                          20" "+#define ICH9_SATA1_DEV                          31" \
        --replace-fail "+#define ICH9_SMB_DEV                            20" "+#define ICH9_SMB_DEV                            31" \
        --replace-fail "+        case 20:" "+        case 31:" \
        --replace-fail "Slot 20 (0x14): LPC" "Slot 31 (0x1F): LPC" \
        --replace-fail "S20%X" "S31%X"
    ''}
    ${optionalString (versionAtLeast qemuVersion "11.0.1") ''
      substituteInPlace "$out/QEMU/amd.patch" \
        --replace-fail "+#define ICH9_A2_LPC_REVISION                    0x51" "+#define ICH9_A2_LPC_REVISION                    0x2" \
        --replace-fail "+#define ICH9_LPC_DEV                            20" "+#define ICH9_LPC_DEV                            31"

      substituteInPlace "$out/EDK2/amd.patch" \
        --replace-fail "+  PCI_LIB_ADDRESS (0, 0x14, 0, (Offset))"  "+  PCI_LIB_ADDRESS (0, 0x1f, 0, (Offset))" \
        --replace-fail "+  EFI_PCI_ADDRESS (0, 0x14, 0, (Offset))"  "+  EFI_PCI_ADDRESS (0, 0x1f, 0, (Offset))"

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
    updateScript = {
      command = [ ./update.sh ];
    };
    qemu = fixed-qemu;
    edk2 = fixed-edk2;
  };

  meta = with lib; {
    homepage = "https://git.keyemail.dev/Scrut1ny/AutoVirt";
    description = "Automated Linux virtualization scripts for advanced malware analysis.";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
})
