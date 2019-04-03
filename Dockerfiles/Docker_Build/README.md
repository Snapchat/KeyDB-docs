# Build a fresh set of binaries for x86_64 (amd64)

### This dockerfile is whats used to generate our image EQAlpha/keydb-build-binaries. It is run on Ubuntu 18.04

### In order to use, specify the location on your host you would like the docker image to dump binaries, then run the command below with your updated path:

```
$ docker run -it --rm -v /path-to-dump-binaries:/keydb_bin eqalpha/keydb-build-bin
```
You should now have the latest: keydb-benchmark, keydb-check-aof, keydb-check-rdb, keydb-cli, keydb-sentinel, keydb-server

This was generated with "Dockerfile"

### To enable FLASH support:

If you are looking to enable flash support with the build (make MALLOC=memkind) then use the following command:
```
$ docker run -it --rm -v /path-to-dump-binaries:/keydb_bin eqalpha/keydb-build-bin:flash
```
This was generated with Dockerfile_flash, which requires libtool and libnuma-dev as additional dependencies to the abover Docker file. We also use 'make Malloc=memkind'
