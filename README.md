# docker-live-image-test

> Repo for creating squashfs filesystem from docker images

## Build docker image

```sh
docker build . -t live-test
```

## Export docker container via mksquashfs file

### mksquashfs 4.6

```sh
CID=$(docker run -d live-test /bin/true)
docker export ${CID} | mksquashfs - image.squashfs -tar -noappend -comp xz -no-progress
```

## Check mksquashfs file

```sh
unsquashfs -ls image.squashfs
```

## Links

* [iximiuz - From Docker Container to Bootable Linux Disk Image](https://iximiuz.com/en/posts/from-docker-container-to-bootable-linux-disk-image/)
* [defunctzombie/jetson-nano-image-maker](https://github.com/defunctzombie/jetson-nano-image-maker)
* [hashbrowncipher/docker2squash.sh](https://gist.github.com/hashbrowncipher/9b811bad8353a7246695a1e2bfea0e84)
