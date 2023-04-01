COL_RED="\033[0;31m"
COL_GRN="\033[0;32m"
COL_END="\033[0m"

UID=$(shell id -u)
GID=$(shell id -g)
VM_DISK_SIZE_MB?=1024

REPO=docker-to-linux

.PHONY:
debian: debian.img

.PHONY:
ubuntu: ubuntu.img

.PHONY:
alpine: alpine.img

%.tar:
	@echo ${COL_GRN}"[Dump $* directory structure to tar archive]"${COL_END}
	docker build -f $*/Dockerfile -t ${REPO}/$* .
	docker export -o $*.tar `docker run -d ${REPO}/$* /bin/true`

%.dir: %.tar
	@echo ${COL_GRN}"[Extract $* tar archive]"${COL_END}
	docker run -it \
		-v `pwd`:/os:rw \
		${REPO}/builder bash -c 'mkdir -p /os/$*.dir && tar -C /os/$*.dir --numeric-owner -xf /os/$*.tar'

%.img: builder %.dir
	@echo ${COL_GRN}"[Create $* disk image]"${COL_END}
	docker run -it \
		-v `pwd`:/os:rw \
		-e DISTR=$* \
		--privileged \
		--cap-add SYS_ADMIN \
		${REPO}/builder bash /os/create_image.sh ${UID} ${GID} ${VM_DISK_SIZE_MB}

.PHONY:
builder:
	@echo ${COL_GRN}"[Ensure builder is ready]"${COL_END}
	@if [ "`docker images -q ${REPO}/builder`" = '' ]; then\
		docker build -f Dockerfile.builder -t ${REPO}/builder .;\
	fi

.PHONY:
builder-interactive:
	docker run -it \
		-v `pwd`:/os:rw \
		--cap-add SYS_ADMIN \
		${REPO}/builder bash

.PHONY:
clean: clean-docker-procs clean-docker-images
	@echo ${COL_GRN}"[Remove leftovers]"${COL_END}
	rm -rf mnt debian.* alpine.* ubuntu.*

.PHONY:
clean-docker-procs:
	@echo ${COL_GRN}"[Remove Docker Processes]"${COL_END}
	@if [ "`docker ps -qa -f=label=com.iximiuz-project=${REPO}`" != '' ]; then\
		docker rm `docker ps -qa -f=label=com.iximiuz-project=${REPO}`;\
	else\
		echo "<noop>";\
	fi

.PHONY:
clean-docker-images:
	@echo ${COL_GRN}"[Remove Docker Images]"${COL_END}
	@if [ "`docker images -q ${REPO}/*`" != '' ]; then\
		docker rmi `docker images -q ${REPO}/*`;\
	else\
		echo "<noop>";\
	fi
