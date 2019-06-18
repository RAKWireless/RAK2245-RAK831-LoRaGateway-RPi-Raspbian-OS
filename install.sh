#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

pushd lora
./install.sh
popd

pushd loraserver
./install.sh
popd

pushd ap
./install.sh
popd

pushd sysconf
./install.sh
popd

echo "******************************"
echo "* Please reboot your system. *"
echo "******************************"
sleep 3
#shutdown -r now
