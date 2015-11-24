echo BUILD SCRIPT .1

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
cp arch/arm/boot/zImage ../Downloads/temp
cd ../Downloads/temp
abootimg -u boot.img -f bootimg.cfg -k zImage -r ramdisk.img
cp boot.img ../../android_kernel_asus_grouper
fi
echo ___________________
exit
}

##### Declare env vars and set bash color codes
green='\033[01;32m'
red='\033[01;31m'
blink_red='\033[05;31m'
restore='\033[0m'

if grep -q eabi <<< "$PATH" ; then
echo Variables are good to go.
else
export SUBARCH=arm
export ARCH=arm
export CROSS_COMPILE=arm-eabi-
export PATH=$PATH:/home/jacob/arm-eabi-4.9/bin/
export CCACHE=ccache
fi

##### Compilation pivot point
if [ $1 = "cfg" ]; then
make -j2 menuconfig && exit
fi
if [ -e .config ]
then
# Kernel builds here with bldk
echo .config exists && bldk
echo ___________________________
else
echo ___________________________
make grouper_defconfig
echo ___________________________
fi

