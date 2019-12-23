---
id: build
title: Building KeyDB
sidebar_label:  Building KeyDB
---

## Standard Build

Use this to build from the unstable (latest) branch of Github. This will contain the latest changes. If you want to generate the latest official release please change branches to RELEASE_0_9

```
sudo apt-get update
sudo apt-get install build-essential nasm autotools-dev autoconf libjemalloc-dev tcl tcl-dev uuid-dev
git clone https://github.com/JohnSully/KeyDB.git
cd KeyDB
make
sudo make install
```

## Switch to Official Release

In order to build from the latest official release please change branches prior to `make`:

```
git fetch --all
git checkout RELEASE_0_9
git pull
```

## Flash Build

If you are building the flash support version you need additional dependencies, libtool and libnuma, and will have to build with MALLOC=memkind:

```
sudo apt-get update
sudo apt-get install build-essential nasm autotools-dev autoconf libjemalloc-dev tcl tcl-dev uuid-dev libtool libnuma-dev
git clone https://github.com/JohnSully/KeyDB.git
cd KeyDB
make MALLOC=memkind
sudo make install
```

## Possible Issues

If you need to update your build, ensure you `make distclean` prior to building again. 

There have been a few instances where `make distclean` did not get everything and the repo had to be recloned.

