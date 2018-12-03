FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y debootstrap build-essential \
  fakeroot kernel-package linux-source libncurses5-dev libelf-dev libssl-dev

ENV KERNEL_SOURCE_VERSION 4.15.0
RUN tar xvf /usr/src/linux-source-$KERNEL_SOURCE_VERSION.tar.bz2

ADD config/kernel-pkg.conf /etc/kernel-pkg.conf
ADD config/kernel-config /linux-source-$KERNEL_SOURCE_VERSION/.config

WORKDIR /linux-source-$KERNEL_SOURCE_VERSION
RUN make-kpkg clean
RUN yes '' | fakeroot make-kpkg -j $(nproc) --revision=1.firecracker kernel_image
WORKDIR /

VOLUME [ "/output", "/rootfs", "/script", "/config" ]

ADD script /script
ADD config /config

CMD [ "/bin/bash", "/script/image.sh" ]