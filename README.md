# docker-live-image-test

> Repo for creating squashfs filesystem from docker images

## Build docker image

```sh
docker build . -t live-test
```

## Export docker container via mksquashfs file

```sh
CID=$(docker run -d live-test /bin/true)
docker export ${CID} | mksquashfs - image.squashfs -tar -noappend
```

## Check mksquashfs file

```sh
unsquashfs -ls image.squashfs
```

## Links

* [iximiuz - From Docker Container to Bootable Linux Disk Image](https://iximiuz.com/en/posts/from-docker-container-to-bootable-linux-disk-image/)
