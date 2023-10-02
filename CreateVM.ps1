. 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' unregistervm UEFI-OS-VM --delete
ubuntu run /mnt/d/hobby/UEFI-OS/CreateFormatedVirtDrive.sh
. 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' createvm --name "UEFI-OS-VM" --basefolder "$(pwd)\VM" --register
. 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' modifyvm UEFI-OS-VM --chipset piix3 --firmware efi
. 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' storagectl UEFI-OS-VM --name 'my Storageconstroller' --add ide --controller PIIX4
. 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' storageattach UEFI-OS-VM --storagectl 'my Storageconstroller' --port 0 --device 0 --type hdd --medium formatedVirtDrive.vdi
. 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' startvm UEFI-OS-VM