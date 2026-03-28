{
  anti-anti-cheat-patch,
  OVMF,
  qemu,
  buildPackages,
}:
let
  qemuOverrideAttrs =
    cpu:
    (old: {
      pname = "aac-QEMU-${cpu}";
      patches = old.patches or [ ] ++ [
        anti-anti-cheat-patch.qemuPatch.${cpu}
      ];
      postPatch = old.postPatch or "" + ''
        substituteInPlace \
          "hw/nvme/ctrl.c" \
          --replace-fail "NVMe Ctrl" "SanDisk SSD PLUS 1TB"
      '';
      meta.platforms = [ "x86_64-linux" ];
    });
  ovmfOverrideAttrs =
    cpu:
    (old: {
      pname = "aac-OVMF";
      patches = old.patches or [ ] ++ [
        anti-anti-cheat-patch.edk2Patch.${cpu}
      ];
      prePatch = ''
        rm -rf BaseTools
        cp -r ${buildPackages.edk2}/BaseTools BaseTools
        chmod u+w -R BaseTools
      '';
      postPatch =
        let
          biosVendor = "American Megatrends International, LLC.";
          biosVersion = "1.0";
          biosDate = "01/01/2024";
          biosRevision = "0x00010000";
          acpiOemId = "ALASKA";
          acpiOemTableId = "0x20202020324B4445";
          acpiOemRevision = "0x00000002";
          acpiCreatorId = "0x20202020";
          acpiCreatorRevision = "0x01000013";
        in
        ''
          # SMBIOS Type 0 strings
          sed -i \
            -e 's@VendStr = L"unknown";@VendStr = L"${biosVendor}";@' \
            -e 's@VersStr = L"unknown";@VersStr = L"${biosVersion}";@' \
            -e 's@DateStr = L"02/02/2022";@DateStr = L"${biosDate}";@' \
            OvmfPkg/SmbiosPlatformDxe/SmbiosPlatformDxe.c

          # MdeModulePkg PCDs
          sed -E -i \
            -e 's@(PcdFirmwareVendor)\|L"EDK II"\|@\1|L"${biosVendor}"|@' \
            -e 's@(PcdFirmwareRevision)\|0x00010000\|@\1|${biosRevision}|@' \
            -e 's@(PcdFirmwareVersionString)\|L""\|@\1|L"${biosVersion}"|@' \
            -e 's@(PcdFirmwareReleaseDateString)\|L""\|@\1|L"${biosDate}"|@' \
            -e 's@(PcdAcpiDefaultOemId)\|"[^"]*"\|@\1|"${acpiOemId}"|@' \
            -e 's@(PcdAcpiDefaultOemTableId)\|0x[0-9a-fA-F]+\|@\1|${acpiOemTableId}|@' \
            -e 's@(PcdAcpiDefaultOemRevision)\|0x[0-9a-fA-F]+\|@\1|${acpiOemRevision}|@' \
            -e 's@(PcdAcpiDefaultCreatorId)\|0x[0-9a-fA-F]+\|@\1|${acpiCreatorId}|@' \
            -e 's@(PcdAcpiDefaultCreatorRevision)\|0x[0-9a-fA-F]+\|@\1|${acpiCreatorRevision}|@' \
            MdeModulePkg/MdeModulePkg.dec

          # Scrub "Bochs" strings from QemuVideoDxe (compiled into firmware binary,
          # detectable by scanners that read raw FIRM/UEFI tables on Windows)
          for f in OvmfPkg/QemuVideoDxe/Driver.c OvmfPkg/QemuVideoDxe/Qemu.h OvmfPkg/QemuVideoDxe/Initialize.c OvmfPkg/QemuVideoDxe/Gop.c; do
            if [ -f "$f" ]; then
              sed -i \
                -e 's/BochsRead/VgaRegRead/g' \
                -e 's/BochsWrite/VgaRegWrite/g' \
                -e 's/InitializeBochsGraphicsMode/InitializeStdGraphicsMode/g' \
                -e 's/QemuVideoBochsModeSetup/QemuVideoStdModeSetup/g' \
                -e 's/QemuVideoBochsModes/QemuVideoStdModes/g' \
                -e 's/QemuVideoBochsAddMode/QemuVideoStdAddMode/g' \
                -e 's/QemuVideoBochsEdid/QemuVideoStdEdid/g' \
                -e 's/QEMU_VIDEO_BOCHS_MODE_COUNT/QEMU_VIDEO_STD_MODE_COUNT/g' \
                -e 's/QEMU_VIDEO_BOCHS_MMIO/QEMU_VIDEO_STD_MMIO/g' \
                -e 's/QEMU_VIDEO_BOCHS/QEMU_VIDEO_STD/g' \
                -e 's/QEMU_VIDEO_BOCHS_MODES/QEMU_VIDEO_STD_MODES/g' \
                -e 's/BochsId/VgaRegId/g' \
                -e 's/"Bochs/"Std/g' \
                -e 's/"Skipping Bochs/"Skipping Std/g' \
                -e 's/"Adding Bochs/"Adding Std/g' \
                -e 's/"QemuVideo: BochsID/"QemuVideo: VgaRegID/g' \
                "$f"
            fi
          done

          # Also scrub the Bochs debug port magic reference
          sed -i 's/BOCHS_DEBUG_PORT_MAGIC/STD_DEBUG_PORT_MAGIC/g' \
            OvmfPkg/Library/PlatformDebugLibIoPort/DebugIoPortQemu.c 2>/dev/null || true
        '';
      meta.platforms = [ "x86_64-linux" ];
    });
in
rec {
  aac-OVMF-amd =
    (OVMF.override {
      qemu = aac-qemu-amd;
      secureBoot = true;
      tpmSupport = true;
      msVarsTemplate = true;
    }).overrideAttrs
      (ovmfOverrideAttrs "amd"); # aac = anti-anti-cheat

  aac-qemu-amd = qemu.overrideAttrs (qemuOverrideAttrs "amd");

  aac-OVMF-intel =
    (OVMF.override {
      qemu = aac-qemu-intel;
      secureBoot = true;
      tpmSupport = true;
      msVarsTemplate = true;
    }).overrideAttrs
      (ovmfOverrideAttrs "intel"); # aac = anti-anti-cheat

  aac-qemu-intel = qemu.overrideAttrs (qemuOverrideAttrs "intel");
}
