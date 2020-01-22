---
id: build
title: Building KeyDB
sidebar_label:  Building KeyDB
---

<div id="blog_body">

This document reviews different ways to build open source KeyDB yourself.

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


## Possible Issues

If you need to update your build, ensure you `make distclean` prior to building again. 

There have been a few instances where `make distclean` did not get everything and the repo had to be recloned.



## Generate Latest Binaries (Ubuntu 18.04) with Docker

If you want the latest open source binaries but do not want to run the build yourself, you can generate within a docker container. Please note this is building in Ubuntu 18.04 and is pulling from the unstable branch of KeyBD. Dockerfiles are posted in the Docker section if you want to build on a different image.

make a folder you would like to have the latest binaries dumped in, then run the following commmand with your updated path:
```
$ docker run -it --rm -v /path-to-dump-binaries:/keydb_bin eqalpha/keydb-build-bin
```
You should receive the following files: keydb-benchmark,  keydb-check-aof,  keydb-check-rdb,  keydb-cli,  keydb-sentinel,  keydb-server


</div>
