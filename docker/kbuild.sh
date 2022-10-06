#!/bin/bash

# kbuild.sh runs the series of commands needed to configure and build the
# kernel, custom kernel modules, and custom C apps.

ConfigKernel()
{
    pushd $KERNEL_SRC_DIR
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- \
             O=$KERNEL_OBJ_DIR bb.org_defconfig
    popd
}

BuildKernel()
{
    pushd $KERNEL_SRC_DIR
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- \
             LOADADDR=0x80008000 O=$KERNEL_OBJ_DIR uImage dtbs -j$(nproc)
    popd
}

BuildModules()
{
    pushd $MODULE_SRC_DIR
        make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=$KERNEL_OBJ_DIR all
    popd
}

BuildApps()
{
    pushd $APP_SRC_DIR
        make CC=arm-linux-gnueabihf-gcc -j$(nproc) all
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

    read -p "Build apps? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        BuildApps
    fi
}

Main
