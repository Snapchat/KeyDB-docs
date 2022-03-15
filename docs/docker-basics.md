---
id: docker-basics
title: Getting Started with Docker
sidebar_label: Using Docker
---

## KeyDB Open Source docker images

You can find the docker repository here: https://hub.docker.com/r/eqalpha/keydb

If you need a brushup on any of the docker commands you can check out dockers documentation [here ](https://docs.docker.com/engine/reference/run/)


## Start a KeyDB instance

```
docker run --name some-keydb -d eqalpha/keydb
```
You can also run simply with `docker run eqalpha/keydb`. The above command simply specifies a name to the container and that it is 'detached' or runs in the background.

## Pass configuration parameters to KeyDB on boot:
```
docker run -name some-keydb -d eqalpha/keydb keydb-server /etc/keydb/keydb.conf --server-threads 4 --requirepass password 
```
Make sure you specify the program you are running (keydb-server) for which to modify the parameters for. Next specify the config parameter you would like to modify when starting the container with `--parameter-name value`.
You can see the full set of configuration options [here](https://docs.keydb.dev/docs/config-file/)

## Bind port

If you want to bind the container to the node/machine so it is accessible externally pass the parameter `-p 6379:6379`

## If you would like to use your own config file

```
$ docker run -v /path-to-config-file/keydb.conf:/etc/keydb/keydb.conf --name mykeydb -d eqalpha/keydb
```
If you are using your own config file remember to comment out "bind 127.0.0.1", change "protected-mode" from yes to no. 

you can grab a copy of the default config file off our [github page](https://github.com/EQ-Alpha/KeyDB) and modify as you see fit.

## Symlinks

As requested by users for Redis compatibility, we have included symbolic links for both redis-cli and redis.conf so they are linked to keydb-cli and keydb.conf respectively. 


## Start with persistent storage

```
$ docker run --name some-keydb -d eqalpha/keydb keydb-server /etc/keydb/keydb.conf --appendonly yes
```
This enables data to be saved every second. Read up more about AOF [configuration options here](https://docs.keydb.dev/docs/config-file/) to modify persistence options further.
If persistence is enabled, data is stored in the `VOLUME /data`, which can be used with `--volumes-from some-volume-container` or `-v /docker/host/dir:/data` (see [docs.docker volumes](https://docs.docker.com/storage/volumes/)).

## Connect to it from an application

```
$ docker run --name some-app --link some-keydb:eqalpha/keydb -d application-that-uses-keydb
```

## Or connect via keydb-cli *(also compatible with redis-cli)*

you can grab the ip of the container with `docker inspect --format '{{ .NetworkSettings.IPAddress }}' mycontainername` then run the following:
```
docker run -it --rm eqalpha/keydb keydb-cli -h <ipaddress-from-above> -p 6379
```
alternatively you can link to it
```
$ docker run -it --link some-keydb:eqalpha/keydb --rm eqalpha/keydb keydb-cli -h keydb -p 6379
```


## Nightly build:

If you keep up to date with KeyDB and want to check out features in the making prior to an official release, you can pull with the unstable tags. This will grab the latest version (automatically updated daily at 4am Eastern). These tags are for x86-64 (amd-64) only.

Pull the latest image with `docker pull eqalpha/keydb:unstable` 
