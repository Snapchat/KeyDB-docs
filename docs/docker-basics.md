---
id: docker-basics
title: Getting Started with Docker
sidebar_label: Using Docker
---

<div id="blog_body">


## Whats New?

[KeyDB Professional](https://keydb.dev/keydb-pro.html) is now avaiable! If you are using KeyDB on Docker our images now include KeyDB Pro binaries in addition to open source KeyDB. KeyDB Pro costs less than your cell phone bill and does not require a license key to try it (20min recurring demo time)!

KeyDB Pro has a new [Enhanced FLASH Storage](https://docs.keydb.dev/docs/pro-flash/) which is built on RocksDB. This new FLASH feature offers substantially higher performance than was possible with our previous FLASH implementation and does not require special filesystems. In addition FLASH offers persistent storage without requiring periodic RDB backups.

KeyDB Pro also supports [MultiVersion Concurrency Control (MVCC)](https://docs.keydb.dev/docs/pro-mvcc/) and enables great options such as [forkless background saving](https://docs.keydb.dev/docs/pro-mvcc/#forkless-background-saving) and [non-blocking queries](https://docs.keydb.dev/docs/pro-non-blocking-queries/). 

# How to use this image

If you need a brushup on any of the docker commands you can check out dockers documentation [here ](https://docs.docker.com/engine/reference/run/)

## start a KeyDB instance

```
docker run --name some-keydb -d eqalpha/keydb
```
You can also run simply with `docker run eqalpha/keydb`. The above command simply specifies a name to the container and that it is 'detached' or runs in the background.

## pass configuration parameters to KeyDB on boot:
```
docker run -name some-keydb -d eqalpha/keydb keydb-server --server-threads 4 --requirepass password 
```
make sure you specify the program you are running (keydb-server) for which to modify the parameters for. Next specify the config parameter you would like to modify when starting the container with `--parameter-name value`.
You can see the full set of configuration options [here](https://docs.keydb.dev/docs/config-file/)

## if you would like to use your own config file

```
$ docker run -v /path-to-config-file/keydb.conf:/etc/keydb/keydb.conf --name mykeydb -d eqalpha/keydb
```
If you are using your own config file remember to comment out "bind 127.0.0.1", change "protected-mode" from yes to no. 

you can grab a copy of the default config file off our [github page](https://github.com/johnsully/keydb) and modify as you see fit.

## symlinks

As requested by users for Redis compatability, we have included symbolic links for both redis-cli and redis.conf so they are linked to keydb-cli and keydb.conf respectively. 

## using KeyDB Pro with docker 
(not yet available for arm)

```
docker run --name some-keydb -d eqalpha/keydb keydb-server --enable-pro [license-key]
```
simply specify you would like to run pro with `--enable-pro`. If you have a license key specify it as a value to this paramter. If no value is specified you will be operating in demo mode. This enables you to try KeyDB Pro, however without a license key the process will be killed after 20 minutes. Once you have purchased a license key, put it in place of [license-key] and pro is now enabled.

Alternatively include this in your own config file as `enable-pro [license-key]`

## using Enhanced FLASH Storage

```
sudo docker run -d -it --name mycontainername --mount type=bind,dst=/flash,src=/path/to/flash/ eqalpha/keydb keydb-server --enable-pro --storage-provider flash /flash --maxmemory [maxmemory-amount-ie. 500M] --eviction-policy [eviction-policy ie. allkeys-lfu]
```
You need to mount your flash storage volume (ssd/flash) to the docker container so it has a place to write its data. `src=/path/to/flash` references the location you have set up. Specify `-it' to enable the container to communicate with it. The docker container already has a directory inside it named `/flash` which we will use internally as a reference. `--storage-provider <storage-type> <storage-location> is used to specify the storage type and location. For this docker container it will always be `--storage-provider flash /flash`. 

To see more about using FLASH check out [docs](https://docs.keydb.dev/docs/pro-flash/)

The FLASH storage provider is always persistent. There is no requirement to save or load RDB files if FLASH is used. You may disable periodic RDB saving by adding: save "" to your configuration file. On boot KeyDB will load any existing data in your FLASH database.


## start with persistent storage

```
$ docker run --name some-keydb -d eqalpha/keydb keydb-server --appendonly yes
```
This enables data to be saved every second. Read up more about AOF [configuration optionshere](https://docs.keydb.dev/docs/config-file/) to modify persistence options further.
If persistence is enabled, data is stored in the `VOLUME /data`, which can be used with `--volumes-from some-volume-container` or `-v /docker/host/dir:/data` (see[docs.docker volumes](https://docs.docker.com/storage/volumes/)).

## connect to it from an application

```
$ docker run --name some-app --link some-keydb:eqalpha/keydb -d application-that-uses-keydb
```

## or connect via keydb-cli *(also compantible with redis-cli)*

you can grab the ip of the container with `docker inspect --format '{{ .NetworkSettings.IPAddress }}' mycontainername` then run the following:
```
docker run -it --rm eqalpha/keydb keydb-cli -h <ipaddress-from-above> -p 6379
```
alternatively you can link to it
```
$ docker run -it --link some-keydb:eqalpha/keydb --rm eqalpha/keydb keydb-cli -h keydb -p 6379
```

## keydb specific options

With new features comes new options:

```
server-threads N
server-thread-affinity [true/false]
scratch-file-path /tmp/
active-replica yes
enable-pro [license-key]
storage-provider flash /path/to/storage/volumes/
```

## nightly build:

If you keep up to date with KeyDB and want to check out features in the making prior to an official release, you can pull with the unstable tags. This will grab the latest version (automatically updated daily at 4am Eastern). These tags are for x86-64 (amd-64) only.

Pull the latest image with `docker pull eqalpha/keydb:unstable` 

</div>