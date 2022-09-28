#!/bin/bash

# This script will copy the *.ko files in the $ELD_MODULE_SRC_PATH dir to the
# BBB using rsync. Note the usage of this script:
#   deploy.sh TARGET_USER TARGET_IP TARGET_DIR
# Once the modules are copied to the BBB, you can ssh to the BBB and work
# with the *.ko files directly using insmod, rmmod, etc.

# Source global project configurations.
source config.sh

Help()
{
    echo "usage: deploy.sh TARGET_USER TARGET_IP TARGET_DIR"
    echo -e "\tTARGET_USER    target board username"
    echo -e "\tTARGET_IP      target board IPv4 address"
    echo -e "\tTARGET_DIR     target dir under which modules will be installed"
}

# Check for positional arguments.
if [ "$#" -ne 3 ]; then
    echo -e "${LRED}error: invalid arguments, see script usage below${NC}"
    Help
    exit 1
fi

# rsync *.ko files in the ELD_MODULE_SRC_PATH dir to the Beaglebone Black.
pushd $ELD_MODULE_SRC_PATH > /dev/null
    # See https://unix.stackexchange.com/questions/87018/find-and-rsync
    # for an explanation of this command.
    rsync -avR --files-from=<(find . -name "*.ko") ./ $1@$2:$3
popd > /dev/null
