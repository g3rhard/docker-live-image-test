FROM amd64/debian:bullseye

RUN apt-get -y update && apt-get install -yqq extlinux fdisk qemu-utils
