#! /bin/bash
set -ex

rm -rf /output/*

truncate -s 512M /output/image.ext4
mkfs.ext4 /output/image.ext4

mount /output/image.ext4 /rootfs
mount --bind / /rootfs/mnt

debootstrap --include openssh-server,netplan.io,nano bionic /rootfs http://archive.ubuntu.com/ubuntu/

chroot /rootfs /bin/bash /mnt/script/provision.sh

cp /rootfs/boot/vmlinux-* /output/vmlinux
cp /rootfs/boot/config-* /output/config

umount /rootfs/mnt
umount /rootfs

cd /output
tar czvf ubuntu-bionic.tar.gz image.ext4 vmlinux config
cd /