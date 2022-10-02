#!/bin/bash

# This script launches a docker container that will build the Linux kernel,
# any custom modules under embedded_linux_drivers/modules, and any test apps
# under embedded_linux_drivers/apps. See deploy.sh for more info on how to
# transfer the *.ko files and app binaries to the BBB.

# Source global project configurations.
source config.sh

Build()
{
    pushd $ELD_DOCKER_PATH
        docker build \
            --build-arg USER=$USER \
            --build-arg HOME=$HOME \
            --build-arg USER_ID=$(id -u) \
            --build-arg GROUP_ID=$(id -g) \
            -t kbuild:latest .

        BUILDER_NAME="kernel-builder"
        docker run -it --name $BUILDER_NAME \
            -e CCACHE_DIR=/ccache \
            -e KERNEL_SRC_DIR=$ELD_KERNEL_SRC_PATH \
            -e KERNEL_OBJ_DIR=$ELD_KERNEL_OBJ_PATH \
            -e MODULE_SRC_DIR=$ELD_MODULE_SRC_PATH \
            -e APP_SRC_DIR=$ELD_APP_SRC_PATH \
            -v $ELD_KERNEL_SRC_PATH:$ELD_KERNEL_SRC_PATH:rw \
            -v $ELD_KERNEL_OBJ_PATH:$ELD_KERNEL_OBJ_PATH:rw \
            -v $ELD_MODULE_SRC_PATH:$ELD_MODULE_SRC_PATH:rw \
            -v $ELD_APP_SRC_PATH:$ELD_APP_SRC_PATH:rw \
            -v $ELD_CCACHE_PATH:/ccache:rw \
            kbuild:latest

        docker rm -f $BUILDER_NAME
    popd
}

Main()
{
    # Create the kernel binary output directory if it does not already exist.
    # Caching the build objects on the host allows us to pass the obj dir
    # as a volume to the docker containers. This is handy for speeding up
    # builds.
    mkdir -pv $ELD_KERNEL_OBJ_PATH
    mkdir -pv $ELD_CCACHE_PATH

    Build
}

Main
