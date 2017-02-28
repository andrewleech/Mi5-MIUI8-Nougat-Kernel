#!/bin/bash
#export CROSS_COMPILE=/myth/android/xperia/kernel/android-ndk-r13b/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
export CROSS_COMPILE=/myth/android/xperia/kernel/android-ndk-r13b/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-
#export CROSS_COMPILE=/myth/android/mi5/kernel/aarch64-linux-android-7.0-kernel/bin/aarch64-linux-android-
#export CROSS_COMPILE=/myth/android/mi5/kernel/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-linaro-4.9/bin/aarch64-linux-android-
#export CROSS_COMPILE=/myth/android/mi5/kernel/Sabermod_aarch64-7.0/bin/aarch64-

export ARCH=arm64
export SUBARCH=arm64

export KBUILD_BUILD_USER='corona'

rm arch/arm64/boot/Image*
rm arch/arm/boot/dts/qcom/*.dtb

#make clean && make mrproper
make gemini-miui8-nougat_defconfig

export KCFLAGS="-I. -Wno-unused-const-variable -Wno-misleading-indentation -Wno-bool-compare -Wno-return-local-addr"
nice make -j3

echo "checking for compiled kernel..."
if [ -f arch/arm64/boot/Image ]
then

cat arch/arm/boot/dts/qcom/a1-msm8996-v2-pmi8994-mtp.dtb arch/arm/boot/dts/qcom/a1-msm8996-v3-pmi8994-mtp.dtb arch/arm/boot/dts/qcom/a1-msm8996-v3.0-pmi8994-mtp.dtb arch/arm/boot/dts/qcom/a2-msm8996-v3-pmi8994-mtp.dtb arch/arm/boot/dts/qcom/a2-msm8996-v3.0-pmi8994-mtp.dtb > arch/arm/boot/dts/qcom/Gemini.dtb
cat arch/arm64/boot/Image.gz-dtb arch/arm/boot/dts/qcom/Gemini.dtb  > arch/arm64/boot/zImage

find ./ -name '*.ko' -exec ./scripts/sign-file sha512 signing_key.priv signing_key.x509 {} \;

mkdir output

# abootimg -u anl_boot.img -k arch/arm64/boot/zImage
#cp anl_boot.img output/

rm MIUI-Kernel-V2.0-anl.zip
cd MIUI-Kernel-V2.0
cp ../arch/arm64/boot/zImage ./
rm -rf ./modules/*
find ../ -name '*.ko' -exec cp {} ./modules \;
7za a -r ../MIUI-Kernel-V2.0-anl.zip ./*
cd ..

cp MIUI-Kernel-V2.0-anl.zip output/

echo "DONE"

else

echo "Image not created"

fi

