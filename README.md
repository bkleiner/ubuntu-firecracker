# ubuntu-firecracker
Docker container to build a linux kernel and ext4 rootfs compatible with [firecracker](https://github.com/firecracker-microvm/firecracker).

## Usage
Build the container:
```shell
docker build -t ubuntu-firecracker .
```

Build the image:
```shell
docker run --privileged -it --rm -v $(pwd)/output:/output ubuntu-firecracker
```

Start the image with firectl
```shell
# copy image and kernel
cp output/vmlinux ubuntu-vmlinux
cp output/image.ext4 ubuntu.ext4
# resize image
truncate -s 5G ubuntu.ext4
resize2fs ubuntu.ext4
#launch firecracker
firectl --kernel=ubuntu-vmlinux --root-drive=ubuntu.ext4 --kernel-opts="init=/bin/systemd noapic reboot=k panic=1 pci=off nomodules console=ttyS0"
```

## Contributions
This project is actively looking for contributions/maintainers.
I (bkleiner) have stopped using firecracker a while ago.
