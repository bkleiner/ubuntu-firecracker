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

