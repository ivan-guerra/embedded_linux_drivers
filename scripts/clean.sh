#!/bin/bash

# This script cleans up the source tree leaving it as if a fresh clone of
# the repository was made.

# Source the project configuration.
source config.sh

# Remove the binary directory.
if [ -d $ELD_BIN_DIR ]
then
    echo -e "${LGREEN}Removing '$ELD_BIN_DIR'${NC}"
    rm -r $ELD_BIN_DIR
fi

# Remove module build artefacts.
pushd $ELD_MODULE_SRC_PATH
    make clean
popd
