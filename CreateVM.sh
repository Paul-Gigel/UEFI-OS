vboxmanage unregistervm UEFI-OS-VM --delete
vboxmanage createvm --name "UEFI-OS-VM" --basefolder ./ --register
vboxmanage modifyvm UEFI-OS-VM --chipset piix3 --memory 1024
vboxmanage storagectl UEFI-OS-VM --name 'my Storageconstroller' --add ide --controller PIIX4
vboxmanage storageattach UEFI-OS-VM --storagectl 'my Storageconstroller' --port 0 --device 0 --type hdd --medium "$VDpath"
vboxmanage startvm UEFI-OS-VM