#compile (this can take up a lot of time)
#    Build -a X64 -p MdeModulePkg/MdeModulePkg.dsc

#create vdi
. CreateFormatedVirtDrive.sh

#startvm
qemu-system-x86_64.exe -bios edk2/Build/OvmfX64/DEBUG_GCC5/FV/OVMF.fd formatedVirtDrive.vdi&

#vboxmanage unregistervm UEFI-OS-VM --delete
#vboxmanage createvm --name "UEFI-OS-VM" --basefolder ./ --register
#vboxmanage modifyvm UEFI-OS-VM --chipset piix3 --memory 1024
#vboxmanage storagectl UEFI-OS-VM --name 'my Storageconstroller' --add ide --controller PIIX4
#vboxmanage storageattach UEFI-OS-VM --storagectl 'my Storageconstroller' --port 0 --device 0 --type hdd --medium "$VDpath"
#vboxmanage startvm UEFI-OS-VM