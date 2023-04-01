FROM debian:bullseye

RUN apt-get -y update \
    && apt-get install -yqq --no-install-recommends \
          fakeroot extlinux syslinux fdisk qemu-utils squashfs-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
