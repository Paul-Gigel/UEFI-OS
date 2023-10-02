#!/bin/bash
#rm -rf edk2/
#mkdir edk2
#sudo apt install build-essential git python2 uuid-dev nasm acpica-tools
#git clone https://github.com/tianocore/edk2.git
cd edk2
#git submodule update --init
export EDK_TOOLS_PATH=$PWD/BaseTools
source edksetup.sh
make -C BaseTools
. edksetup.sh
cd ..
