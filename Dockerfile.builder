FROM amd64/debian:bullseye

RUN apt-get -y update
RUN apt-get -y install extlinux fdisk qemu-utils
