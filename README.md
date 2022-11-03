# edk2 - OVMF Firmware Repository for Unraid

This repository contains custom made OVMF Firmware files for Unraid.  
The firmware is compiled from: https://github.com/tianocore/edk2

## Package contents:
**OVMF_CODE-pure-efi-tpm.fd** - OVMF firmware with TPM and secure boot enabled  
**OVMF_VARS-pure-efi-tpm.fd** - Configuration file for OVMF firmware with TPM and secure boot enabled  

**OVMF_CODE-pure-efi.fd** - Default OVMF firmware  
**OVMF_VARS-pure-efi.fd** - Configuration file for default OVMF firmware

If a new tag is released in the [tianocore/edk2](https://github.com/tianocore/edk2) repository, a new firmware package will be built and pushed to the [Releases](https://github.com/ich777/edk2-unraid/releases).
