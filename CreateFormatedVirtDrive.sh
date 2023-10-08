#/bin/bash

#expected: to boot in to Shell.efi
#Poblems: qemu an vbox dont boot
#Shell_###.efi meight not be the right efi File
#qemu meight have problems with UEFI in general, since kvm uses BIOS out of the box

#variables
mntVirtDrive="./mntVirtDrive"
loop="$(cat loop.txt)"

#cleanup
sudo rm -rfv "$mntVirtDrive"  #delete everything inside $mntVirtDrive
sudo umount "$mntVirtDrive"
if [ -f formatedVirtDrive.vdi ]; then
    rm -v formatedVirtDrive.vdi
fi
if [ -f loop.txt ]; then
  rm -v loop.txt
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

#inform the os-Kernel of partition table changes
sudo partprobe $(cat loop.txt)  # THATS THE TRICK :) now I have to loopNp1

#write gpt, esp, fat32fs
sudo parted -s $(cat loop.txt) mklabel gpt;
sudo parted $(cat loop.txt) -- mkpart SystemPartition 1049KB -1MiB;
sudo parted -s $(cat loop.txt) set 1 boot on;
sudo parted -s $(cat loop.txt) set 1 esp on;
sudo parted $(cat loop.txt) print
sudo losetup -j formatedVirtDrive


#writeFileSystem
sudo mkfs.vfat -F32 $(cat loop.txt)p1
sudo parted $(cat loop.txt) print



#create mnt point and mount
mkdir "$mntVirtDrive"
sudo mount -t vfat $(cat loop.txt)p1 "$mntVirtDrive"

#create appropriate Folders
sudo mkdir "$mntVirtDrive"/EFI
sudo mkdir "$mntVirtDrive"/EFI/boot
sudo touch "$mntVirtDrive"/EFI/boot/bootX64.efi

#copy (timeintensive)
#find ./edk2/Build/Shell/DEBUG_GCC5/X64/ -name 'Shell.efi'
sudo dd if=edk2/Build/Shell/DEBUG_GCC5/X64/ShellPkg/Application/Shell/Shell/OUTPUT/Shell.efi of="$mntVirtDrive"/EFI/boot/bootX64.efi
#sudo cp -r -v edk2/Build/Shell/DEBUG_GCC5/X64/*.efi "$mntVirtDrive"/EFI/boot/
sudo cp -r -v edk2/Build/MdeModule/DEBUG_GCC5/X64/* "$mntVirtDrive"/EFI/boot/

vboxmanage convertfromraw --format vdi formatedVirtDrive ./formatedVirtDrive.vdi
