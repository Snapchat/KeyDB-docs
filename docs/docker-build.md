---
id: docker-bin
title: Docker Builder for Ubuntu 18.04
sidebar_label: Docker Build (18.04)
---

<div id="blog_body">
If you are running on Docker, please see the Docker section.

## Generate Latest Binaries (Ubuntu 18.04)

If you want the latest binaries but do not want to run the build yourself, you can generate within a docker container. Please note this is building in Ubuntu 18.04 and is pulling from the unstable branch of KeyBD. Dockerfiles are posted in the Docker section if you want to build on a different image.

make a folder you would like to have the latest binaries dumped in, then run the following commmand with your updated path:
```
$ docker run -it --rm -v /path-to-dump-binaries:/keydb_bin eqalpha/keydb-build-bin
```
You should receive the following files: keydb-benchmark,  keydb-check-aof,  keydb-check-rdb,  keydb-cli,  keydb-sentinel,  keydb-server


## To enable Legacy FLASH support:
If you are looking to enable legacy flash support with the build (make MALLOC=memkind) then use the following command:
```
$ docker run -it --rm -v /path-to-dump-binaries:/keydb_bin eqalpha/keydb-build-bin:flash
```
</div>