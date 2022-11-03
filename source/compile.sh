# Create necessary directories and clone repositories
cd ${DATA_DIR}
CPU_COUNT=$(nproc --all)
mkdir -p ${DATA_DIR}/${LAT_V##*-}/install
mkdir -p ${DATA_DIR}/${LAT_V##*-}/usr/share/qemu/ovmf-x64
mkdir -p ${DATA_DIR}/${LAT_V}
git clone https://github.com/tianocore/edk2.git
cd ./edk2
git checkout ${LAT_V}
git submodule update --init

# Compile edk2 BaseTools
make -C BaseTools -j${CPU_COUNT}

# Compile OVMF firmware with TPM enabled
OvmfPkg/build.sh -b RELEASE -a X64 -t GCC5 -n ${CPU_COUNT} -D TPM1_ENABLE -D TPM2_ENABLE -D TPM_CONFIG_ENABLE -D SECURE_BOOT_ENABLE -D NETWORK_TLS_ENABLE || exit 1

# Move build directory
mv Build/OvmfX64 Build/OvmfX64_TPM

# Compile OVMF firmware
OvmfPkg/build.sh -b RELEASE -a X64 -t GCC5 -n ${CPU_COUNT} -D FD_SIZE_2MB || exit 1

# Copy over OVMF with TPM enabled firmware files to temporary directory
cp Build/OvmfX64_TPM/RELEASE_GCC5/FV/OVMF_CODE.fd ${DATA_DIR}/${LAT_V##*-}/usr/share/qemu/ovmf-x64/OVMF_CODE-pure-efi-tpm.fd
cp Build/OvmfX64_TPM/RELEASE_GCC5/FV/OVMF_VARS.fd ${DATA_DIR}/${LAT_V##*-}/usr/share/qemu/ovmf-x64/OVMF_VARS-pure-efi-tpm.fd

# Copy over OVMF firmware files to temporary directory
cp Build/OvmfX64/RELEASE_GCC5/FV/OVMF_CODE.fd ${DATA_DIR}/${LAT_V##*-}/usr/share/qemu/ovmf-x64/OVMF_CODE-pure-efi.fd
cp Build/OvmfX64/RELEASE_GCC5/FV/OVMF_VARS.fd ${DATA_DIR}/${LAT_V##*-}/usr/share/qemu/ovmf-x64/OVMF_VARS-pure-efi.fd

# Copy slack-desc to temporary directory, create Slackware package and md5 file
cd ${DATA_DIR}/${LAT_V##*-}
cp ${DATA_DIR}/slack-desc ${DATA_DIR}/${LAT_V##*-}/install/slack-desc 
makepkg -l y -c y ${DATA_DIR}/${LAT_V}/ovmf-${LAT_V##*-}-x86_64-1.txz
md5sum ${DATA_DIR}/${LAT_V}/ovmf-${LAT_V##*-}-x86_64-1.txz | awk '{print $1}' > ${DATA_DIR}/${LAT_V}/ovmf-${LAT_V##*-}-x86_64-1.txz.md5

## Cleanup
rm -rf ${DATA_DIR}/edk2 ${DATA_DIR}/${LAT_V##*-}
chown $UID:$GID ${DATA_DIR}/$LAT_V/*
