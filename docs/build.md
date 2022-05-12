---
id: build
title: Building KeyDB
sidebar_label:  Building KeyDB
---



This document reviews how to build open source KeyDB yourself.

If you are looking for a prebuilt DEB or RPM package, take a look through our DOCS or check out https://keydb.dev/downloads

## Build Example

The following builds from the unstable (latest) branch of Github. This will contain the latest pushed changes. If you want to generate the latest official release please change branch to RELEASE_6

```
sudo apt-get update
sudo apt-get install build-essential nasm autotools-dev autoconf libjemalloc-dev tcl tcl-dev uuid-dev libcurl4-openssl-dev git
git clone https://github.com/EQ-Alpha/KeyDB.git
cd KeyDB
make
sudo make install
```

### Build Issues & Rebuilding

If you need to update your build, ensure you `make distclean` prior to building again.

### Switch to a Release Branch or Dev Branch

In order to build from the latest official release please change branches prior to `make`:

```
git fetch --all
git checkout RELEASE_6
git pull
```

## Build Flags

### Building with TLS support:

Note that if you are building with TLS support, pass the `BUILD_TLS=yes` flag when calling make.

### Build with systemd support

To enable using systemd, use the `USE_SYSTEMD=yes` flag when calling make. You can now update your service file to use `Type=notify` and your keydb.conf file to use `supervised systemd` to take advantage of this support.

## Building Other Linux Distributions

The following dependencies are recommended for building and testing KeyDB

### Ubuntu/Debian

```
sudo apt update
sudo apt install build-essential nasm autotools-dev autoconf libjemalloc-dev tcl tcl-dev uuid-dev libcurl4-openssl-dev git
```

### Archlinux

```
pacman -Syu --noconfirm
pacman -S --noconfirm base-devel git tcl
```

### Alpine

```
apk add --no-cache coreutils gcc linux-headers make musl-dev util-linux-dev openssl-dev curl-dev g++ bash git perl libunwind-dev
```

### CentOS 7
```
sudo yum install -y scl-utils centos-release-scl
sudo yum install -y devtoolset-7 libuuid-devel
sudo source scl_source enable devtoolset-7
sudo yum install -y openssl openssl-devel curl-devel devtoolset-7-libatomic-devel tcl tcl-devel git wget epel-release
sudo yum install -y tcltls libzstd
```

### Centos 8
```
yum install -y scl-utils epel-release
dnf group install -y "Development Tools"
yum install -y 'dnf-command(config-manager)'
yum install -y dnf-plugins-core
dnf config-manager --set-enabled powertools
yum install -y libuuid-devel which libatomic
yum install -y openssl openssl-devel curl-devel git
yum install -y tcl-devel tcltls
```

### Fedora 35
```
dnf install -y jemalloc-devel g++ libuuid-devel libatomic openssl-devel curl-devel
```

## Additional dependencies for packaging:

Source code for creating deb/rpm packages can be found in https://github.com/EQ-Alpha/KeyDB/tree/unstable/pkg

### For Deb Packages:
```
sudo apt install pbuilder lintian devscripts dh-make	# for all deb packaging
sudo apt install apt-utils				# for xenial/stretch/buster
sudo apt install systemd procps				# for stretch/buster
```

### For RPM Packages
```
sudo yum install rpm-build
```


## Generate Latest Binaries (Ubuntu 18.04) with Docker

If you want the latest open source binaries but do not want to run the build yourself, you can generate within a docker container. Please note this is building in Ubuntu 18.04 and is pulling from the unstable branch of KeyBD. Dockerfiles are posted in the Docker section if you want to build on a different image.

make a folder you would like to have the latest binaries dumped in, then run the following command with your updated path:
```
$ docker run -it --rm -v /path-to-dump-binaries:/keydb_bin eqalpha/keydb-build-bin
```
You should receive the following files: keydb-benchmark,  keydb-check-aof,  keydb-check-rdb,  keydb-cli,  keydb-sentinel,  keydb-server


