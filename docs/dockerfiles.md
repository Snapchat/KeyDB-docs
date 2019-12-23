---
id: dockerfiles
title: KeyDB Official Dockerfiles
sidebar_label: Dockerfiles
---

This page contains the dockerfiles used to generate different images and tags used for our images. They are listed here for transparency so you can see what you are getting. It also allows you to customize to a custom image that might meet your needs better.

If you find some major improvements you think are beneficial we are open to feedback. 

The images are all built from the offical release branch. The tag will be versioned at the end, ie. `v0.9.5`. You will also see the version number when you launch the server.

There is an image generated every morning at 4am Eastern time for the unstable branch for those who like to kep up with the development of this project.

## Manifest

The main docker image, "latest", when pulling eqalpha/keydb is a manifest. This means there are 3 images associated, x86_64_vxxx, arm_vxxx, arm64_vxxx. Depending on your system the manifest file will pull the appropriate image. This main pull is based on the latest official release branch on github.

## Building Images

You will note from the Dockerfiles that you should have an "app" directory located where your Dockerfile is. Dockerfile should be named "Dockerfile". In the "app" folder you should place the binaries you want copied over (keydb-server at a minimum). The redis.conf file should also be located here. You can customize to your liking which can be beneficial. Our Dockerfile modifies our base config file within the Dockerfile instead of using a custom Dockerfile. So you might consider removing the part of the script that modifies it.

See the Dockerfiles for the 5 main images/tags we generate below as well as for the builder:


## Standard Build

```
#
# KeyDB Dockerfile for x86_64
#
#
# Pull base image.
FROM ubuntu:18.04

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r keydb && useradd -r -g keydb keydb

# grab gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
ENV GOSU_VERSION 1.10
RUN set -ex; \
	\
	fetchDeps=" \
		ca-certificates \
		dirmngr \
		gnupg \
		wget \
	"; \
	apt-get update; \
	apt-get install -y --no-install-recommends libcurl4-openssl-dev $fetchDeps; \
	rm -rf /var/lib/apt/lists/*; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	gpgconf --kill all; \
	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	chmod +x /usr/local/bin/gosu; \
	gosu nobody true; \
	\
	apt-get purge -y --auto-remove $fetchDeps


# Load binaries to image. Much smaller size than building.
ADD ./app/* /usr/local/bin/

RUN \
  cd /usr/local/bin && \
  mkdir -p /etc/keydb && \
  mv -f *.conf /etc/keydb && \
# update config file for use in container
  sed -i 's/^\(bind .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/keydb/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/protected-mode yes/protected-mode no/g' /etc/keydb/redis.conf

# Define default command.
#CMD ["keydb-server", "/etc/keydb/redis.conf"]

RUN mkdir /data && chown keydb:keydb /data
VOLUME /data
WORKDIR /data

#COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD ["keydb-server", "/etc/keydb/redis.conf"]
```

## ARM Build

```
#
# KeyDB Dockerfile for ARM
#
#
FROM jsurf/rpi-raspbian:latest

RUN [ "cross-build-start" ]

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r keydb && useradd -r -g keydb keydb

# add gosu for easy step-down from root
ENV GOSU_VERSION 1.10
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y --auto-remove ca-certificates wget

# Load binaries to image. Much smaller size than building.
ADD ./app/* /usr/local/bin/

RUN \
  cd /usr/local/bin && \
  mkdir -p /etc/keydb && \
  mv -f *.conf /etc/keydb && \
# update config file for use in container
  sed -i 's/^\(bind .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/keydb/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/protected-mode yes/protected-mode no/g' /etc/keydb/redis.conf

# Define default command.
#CMD ["keydb-server", "/etc/keydb/redis.conf"]

RUN mkdir /data && chown keydb:keydb /data
VOLUME /data
WORKDIR /data

#COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD ["keydb-server", "/etc/keydb/redis.conf"]

RUN [ "cross-build-end" ]
```

## Flash Build

```
#
# KeyDB Dockerfile for x86_64
#
# Useage: docker run -it --name mykeydb --mount type=bind,target=/tmp/keydbflash,source=/path-to-my-btrfs-volume/ eqalpha/keydb:flash
#
# Pull base image.
FROM ubuntu:18.04

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r keydb && useradd -r -g keydb keydb

# grab gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
ENV GOSU_VERSION 1.10
RUN set -ex; \
        \
        fetchDeps=" \
                ca-certificates \
                dirmngr \
                gnupg \
                wget \
        "; \
        apt-get update; \
        apt-get install -y --no-install-recommends $fetchDeps; \
        rm -rf /var/lib/apt/lists/*; \
        \
        dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
        wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
        wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
        export GNUPGHOME="$(mktemp -d)"; \
        gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
        gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
        gpgconf --kill all; \
        rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
        chmod +x /usr/local/bin/gosu; \
        gosu nobody true; \
        \
        apt-get purge -y --auto-remove $fetchDeps

# Load binaries to image. Much smaller size than building.
ADD ./app/* /usr/local/bin/

RUN \
  apt-get install -y libnuma-dev libtool libcurl4-openssl-dev && \
  cd /usr/local/bin && \
  mkdir -p /etc/keydb && \
  mkdir /tmp/keydbflash && \
  mv -f *.conf /etc/keydb && \
# update config file for use in container
  sed -i 's/^\(bind .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/keydb/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/protected-mode yes/protected-mode no/g' /etc/keydb/redis.conf && \
  sed -i '/scratch-file-path/a \scratch-file-path /tmp/keydbflash' /etc/keydb/redis.conf

RUN mkdir /data && chown keydb:keydb /data
VOLUME /data
WORKDIR /data

#COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD ["keydb-server", "/etc/keydb/redis.conf"]
```

## Unstable Builds

This is the same as standard builds, except binaries are generated from the unstable branch on github.

## Docker Builder - Standard

```
# KeyDB Fresh Build
# 
# This Docker image will be used to generate the latest binaries from github
#
# Useage: docker run -it --rm -v /path-to-dump-binaries:/keydb_bin eqalpha/keydb-build-bin
#
# pull the base image
FROM ubuntu:18.04
# setup up container with dependencies for build
RUN apt-get update -y && \
 DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
 build-essential apt-utils nasm autotools-dev autoconf libjemalloc-dev tcl tcl-dev uuid-dev git -y && \
 apt-get clean && \
 mkdir /keydb_bin
# upon launch we will build project and dump binaries into specified folder on host
CMD ["sh","-c", "cd /tmp && git clone https://github.com/JohnSully/KeyDB.git && \
 cd KeyDB  && \
 make && \
 cp ./src/keydb-* /keydb_bin"]
```

## Docker Builder - Flash

```
#
# KeyDB Dockerfile for x86_64
#
# Useage: docker run -it --name mykeydb --mount type=bind,target=/tmp/keydbflash,source=/path-to-my-btrfs-volume/ eqalpha/keydb:flash
#
# Pull base image.
FROM ubuntu:18.04

# Load binaries to image. Much smaller size than building.
ADD ./app/* /usr/local/bin/

RUN \
  apt-get update && \
  apt-get install -y libnuma-dev libtool && \
  cd /usr/local/bin && \
  mkdir -p /etc/keydb && \
  mkdir /tmp/keydbflash && \
  mv -f *.conf /etc/keydb && \
# update config file for use in container
  sed -i 's/^\(bind .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/keydb/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/protected-mode yes/protected-mode no/g' /etc/keydb/redis.conf && \
  sed -i '/scratch-file-path/a \scratch-file-path /tmp/keydbflash' /etc/keydb/redis.conf

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["keydb-server", "/etc/keydb/redis.conf"]

# Expose ports.
EXPOSE 6379

```

## docker-entrypoint.sh

```

#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- keydb-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'keydb-server' -a "$(id -u)" = '0' ]; then
	find . \! -user keydb -exec chown keydb '{}' +
	exec gosu keydb "$0" "$@"
fi

exec "$@"
```