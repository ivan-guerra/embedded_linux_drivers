#!/bin/bash

# This script will copy the $ELD_MODULE_SRC_PATH modules directory to the BBB
# using scp. Note the usage of this script:
#   run.sh TARGET_USER TARGET_IP TARGET_DIR
# Once the modules are copied to the BBB, you can ssh to the BBB and work
# with the *.ko files directly using insmod, rmmod, etc.

# Source global project configurations.
source config.sh

Help()
{
    echo "usage: run.sh TARGET_USER TARGET_IP TARGET_DIR"
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

# scp the ELD_MODULE_SRC_PATH directory to the Beaglebone Black.
scp -r $ELD_MODULE_SRC_PATH $1@$2:$3
