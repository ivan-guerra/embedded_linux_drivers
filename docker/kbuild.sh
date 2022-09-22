#!/bin/bash

# kbuild.sh runs the series of command needed to configure and build the kernel
# and any custom drivers in MODULE_SRC_DIR.

ConfigKernel()
{
    pushd $KERNEL_SRC_DIR
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- \
             O=$KERNEL_OBJ_DIR bb.org_defconfig
    popd
}

BuildKernel()
{
    pushd $KERNEL_SRC_DIR
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- \
             KERNEL_IMAGETYPE=bzImage O=$KERNEL_OBJ_DIR -j$(nproc)
    popd
}

BuildModules()
{
    pushd $MODULE_SRC_DIR
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- O=$KERNEL_OBJ_DIR all
    popd
}

Main()
{
    read -p "Build kernel? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        if [ ! -f "${KERNEL_OBJ_DIR}/.config" ]
        then
            # Missing kernel config, create one.
            ConfigKernel
        fi
        BuildKernel
    fi

    read -p "Build modules (assumes existing kernel build)? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        BuildModules
    fi
}

Main
