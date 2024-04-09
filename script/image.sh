#! /bin/bash
set -ex

rm -rf /output/*

cp /root/linux-source-$KERNEL_SOURCE_VERSION/vmlinux /output/vmlinux
cp /root/linux-source-$KERNEL_SOURCE_VERSION/.config /output/config

truncate -s 1G /output/image.ext4
mkfs.ext4 /output/image.ext4

mount /output/image.ext4 /rootfs
debootstrap --include openssh-server,unzip,rsync,apt,netplan.io,nano jammy /rootfs http://archive.ubuntu.com/ubuntu/

mount --bind / /rootfs/mnt
chroot /rootfs /bin/bash /mnt/script/provision.sh

umount /rootfs/mnt
umount /rootfs

cd /output
tar czvf ubuntu-jammy.tar.gz image.ext4 vmlinux config
cd /
