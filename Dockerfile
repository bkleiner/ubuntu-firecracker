FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV KERNEL_SOURCE_VERSION 5.4.0

WORKDIR /root

RUN apt-get update && apt-get install -y debootstrap build-essential kernel-package \
    bison rsync rsyslog \
    fakeroot linux-source-$KERNEL_SOURCE_VERSION bc kmod cpio flex cpio \
    libncurses5-dev libelf-dev libssl-dev \
    && tar xvf /usr/src/linux-source-$KERNEL_SOURCE_VERSION.tar.*

ADD config/kernel-config /root/linux-source-$KERNEL_SOURCE_VERSION/.config

WORKDIR /root/linux-source-$KERNEL_SOURCE_VERSION
RUN yes '' | make oldconfig \
    && make -j $(nproc) deb-pkg
WORKDIR /root

VOLUME [ "/output", "/rootfs", "/script", "/config" ]

ADD script /script
ADD config /config

CMD [ "/bin/bash", "/script/image.sh" ]
