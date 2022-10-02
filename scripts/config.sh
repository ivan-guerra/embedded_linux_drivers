#!/bin/bash

# This script configures the default search paths for many of the binaries
# and configuration files used by the project. Other scripts may source this
# file to find the resources that they need.

LGREEN='\033[1;32m'
LRED='\033[1;31m'
NC='\033[0m'

# Root directory.
ELD_PROJECT_PATH=$(dirname $(pwd))

# Binary directory.
ELD_BIN_DIR="${ELD_PROJECT_PATH}/bin"

# Kernel config docker context path.
ELD_DOCKER_PATH="${ELD_PROJECT_PATH}/docker"

# Linux kernel build files.
ELD_KERNEL_OBJ_PATH="${ELD_BIN_DIR}/obj"

# Linux kernel source tree directory.
ELD_KERNEL_SRC_PATH="${ELD_PROJECT_PATH}/linux"

# Driver module source path.
ELD_MODULE_SRC_PATH="${ELD_PROJECT_PATH}/modules"

# Driver test app(s) source path.
ELD_APP_SRC_PATH="${ELD_PROJECT_PATH}/apps"

# ccache path. Allows for re-use of the cache between container builds.
ELD_CCACHE_PATH="${ELD_BIN_DIR}/ccache"
