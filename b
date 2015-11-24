echo BUILD SCRIPT .2

##### Define functions
bldk () {
echo __________________________
echo Kernel build
make -j2 || finish "failed"
finish "success"
}

finish () {
echo ___________________
if [ $1 = "failed" ]
then
echo Build Fail.
else
echo Build Success.

echo Building Standard boot image for Android 6.0
cp arch/arm/boot/zImage scripts/temp
cd scripts/temp
abootimg -u ../../boot.img -f bootimg.cfg -k zImage -r ramdisk.img
rm zImage
cd ../../
echo Creating AnyKernel2 zip
cp arch/arm/boot/zImage scripts/temp/AnyKernel2
cd scripts/temp/AnyKernel2
zip -r9 UPDATE-AnyKernel2.zip * -x README UPDATE-AnyKernel2.zip
mv UPDATE-AnyKernel2.zip ../../../
rm zImage
cd ../../../

fi
echo ___________________
echo Install UPDATE-AnyKernel2.zip for support of any rom or use boot.img for 6.0 rom.
echo Zip Recommended
return
}

##### Declare env vars and set bash color codes
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

varsnotset=false
grep -q "eabi" <<< "$PATH" || varsnotset=true
if [ "true" = "$varsnotset" ]
then
echo Setting vars.
export SUBARCH=arm ARCH=arm CROSS_COMPILE=arm-eabi-  PATH=$PATH:/home/jacob/arm-eabi-4.9/bin/ CCACHE=ccache USE_CCACHE=1 CCACHE_DIR=$(pwd)/../.ccache
else
echo Env vars already set.
fi

##### Compilation pivot point
if [ $1 = "cfg" ]; then
make -j2 menuconfig && return
fi
if [ -e .config ]
then
# Kernel builds here with bldk
echo .config exists && bldk
return
else
echo ___________________________
make grouper_defconfig
echo ___________________________
return
fi
