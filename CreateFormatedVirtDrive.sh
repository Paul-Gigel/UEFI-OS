#/bin/bash

#expected: to boot in to Shell.efi
#Poblems: qemu an vbox dont boot
#Shell_###.efi meight not be the right efi File
#qemu meight have problems with UEFI in general, since kvm uses BIOS out of the box

#variables
mntVirtDrive="./mntVirtDrive"
loop="$(cat loop.txt)"

#cleanup
sudo umount "$mntVirtDrive"
sudo rm -rf "$mntVirtDrive"
if [ -f formatedVirtDrive.vdi ]; then
    rm formatedVirtDrive.vdi
fi
if [ -f loop.txt ]; then
  rm loop.txt
  sudo losetup -d "$loop" #detach created loop
fi
if [ -f formatedVirtDrive ]; then
    rm formatedVirtDrive
fi


#createFile
touch formatedVirtDrive
dd if=/dev/zero of=formatedVirtDrive bs=1M count=1024

#create LoopDevice and write Name to File
(sudo losetup -fP formatedVirtDrive --show)>loop.txt
sudo partprobe $(cat loop.txt)  # THATS THE TRICK :) now I have to loopNp1
#sudo losetup -j formatedVirtDrive #list associated loops(should be max 1)

#write gpt, esp, fat32fs
sudo parted -s $(cat loop.txt) mklabel gpt;
sudo parted $(cat loop.txt) -- mkpart SystemPartition 1049KB -1MiB;
sudo parted -s $(cat loop.txt) set 1 boot on;
sudo parted -s $(cat loop.txt) set 1 esp on;
sudo parted $(cat loop.txt) print
sudo losetup -j formatedVirtDrive


#writeFileSystem
sudo mkfs.vfat -F32 $(cat loop.txt)p1
#sudo parted -s formatedVirtDrive set 1 boot on;
#sudo parted -s formatedVirtDrive set 1 esp on;
sudo parted $(cat loop.txt) print



#create mnt point and mount
mkdir "$mntVirtDrive"
sudo mount -t vfat $(cat loop.txt)p1 "$mntVirtDrive"

sudo mkdir "$mntVirtDrive"/EFI
sudo mkdir "$mntVirtDrive"/EFI/BOOT
sudo touch "$mntVirtDrive"/EFI/BOOT/BOOTX64.efi

sudo dd if=edk2/Build/Shell/DEBUG_GCC5/X64/Shell_7C04A583-9E3E-4f1c-AD65-E05268D0B4D1.efi of="$mntVirtDrive"/EFI/BOOT/BOOTX64.efi
sudo cp edk2/Build/MdeModule/DEBUG_GCC5/X64/HelloWorld.efi "$mntVirtDrive"/EFI/BOOT/

vboxmanage convertfromraw --format vdi formatedVirtDrive ./formatedVirtDrive.vdi
