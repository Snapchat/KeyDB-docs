---
id: build
title: Building KeyDB
sidebar_label:  Building KeyDB
---
<div id="blog_body">
## Standard Build

Use this to build from the unstable (latest) branch of Github. This will contain the latest changes. If you want to generate the latest official release please change branch to RELEASE_5

```
sudo apt-get update
sudo apt-get install build-essential nasm autotools-dev autoconf libjemalloc-dev tcl tcl-dev uuid-dev libcurl4-openssl-dev
git clone https://github.com/JohnSully/KeyDB.git
cd KeyDB
make
sudo make install
```

## Switch to Official Release

In order to build from the latest official release please change branches prior to `make`:

```
git fetch --all
git checkout RELEASE_5
git pull
```

## Legacy Flash Build

If you are using Enhanced FLASH with KeyDB Pro, you must download a pro binary package. No build is required. 

If you are building the legacy flash support version you need additional dependencies, libtool and libnuma, and will have to build with MALLOC=memkind:

```
sudo apt-get update
sudo apt-get install build-essential nasm autotools-dev autoconf libjemalloc-dev tcl tcl-dev uuid-dev libtool libnuma-dev libcurl4-openssl-dev
git clone https://github.com/JohnSully/KeyDB.git
cd KeyDB
make MALLOC=memkind
sudo make install
```

## Possible Issues

If you need to update your build, ensure you `make distclean` prior to building again. 

There have been a few instances where `make distclean` did not get everything and the repo had to be recloned.
</div>
