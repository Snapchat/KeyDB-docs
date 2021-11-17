---
id: enterprise-docker-basics
title: Getting Started with Docker
sidebar_label: Using Docker
---

## KeyDB Enterprise docker images

You can find the docker repository here: https://hub.docker.com/r/eqalpha/keydb-server

If you need a brushup on any of the docker commands you can check out dockers documentation [here ](https://docs.docker.com/engine/reference/run/)

## Start a KeyDB Enterprise instance without a license key

Please note that KeyDB Enterprise will not work without a license key. For POC testing or trial licenses, please contact sales@eqalpha.com to get set up.
```
docker run --name some-keydb -d eqalpha/keydb-enterprise
```
From above, --name specifies a name for the container, its not needed but makes it easier to identify. The -d option is 'detached' or runs in the background.

## Pass configuration parameters to KeyDB Enterprise on boot:
```
docker run -name some-keydb -d eqalpha/keydb-enterprise keydb-server /etc/keydb/keydb.conf --server-threads 8 --requirepass password --enable-enterprise LKXX-XXXX-XXXX-XXXX-XXXX
```
Make sure you specify the program you are running (keydb-server) for which to modify the parameters for. Next specify the config parameter you would like to modify when starting the container with `--parameter-name value`.
You can see the full set of configuration options [here](https://docs.keydb.dev/docs/config-file/)

## Bind port

If you want to bind the container to the node/machine so it is accessible externally pass the parameter `-p 6379:6379`

## If you would like to use your own config file

```
$ docker run -v /path-to-config-file/keydb.conf:/etc/keydb/keydb.conf --name mykeydb -d eqalpha/keydb-enterprise
```
If you are using your own config file remember to comment out "bind 127.0.0.1", change "protected-mode" from yes to no. 

you can grab a copy of the default config file off our [github page](https://github.com/EQ-Alpha/KeyDB) and modify as you see fit.

## Symlinks

As requested by users for Redis compatibility, we have included symbolic links for both redis-cli and redis.conf so they are linked to keydb-cli and keydb.conf respectively. 


## Using Enhanced FLASH Storage

```
sudo docker run -d -it --name mycontainername --mount type=bind,dst=/flash,src=/path/to/flash/ eqalpha/keydb-enterprise keydb-server /etc/keydb/keydb.conf --enable-enterprise LKXX-XXXX-XXXX-XXXX-XXXX --storage-provider flash /flash --maxmemory [maxmemory-amount-ie. 2G] --eviction-policy [eviction-policy ie. allkeys-lru]
```
You need to mount your flash storage volume (ssd/flash) to the docker container so it has a place to write its data. `src=/path/to/flash` references the location you have set up. Specify `-it' to enable the container to communicate with it. The docker container already has a directory inside it named `/flash` which we will use internally as a reference. `--storage-provider [storage-type] [storage-location] is used to specify the storage type and location. For this docker container it will always be `--storage-provider flash /flash`. 

To see more about FLASH sizing check out [docs](https://docs.keydb.dev/docs/enterprise-flash-sizing/)

The FLASH storage provider is always persistent. There is no requirement to save or load RDB files if FLASH is used. You may disable periodic RDB saving by adding: save "" to your configuration file. On boot KeyDB will load any existing data in your FLASH database. 


## Connect to it from an application

```
$ docker run --name some-app --link some-keydb:eqalpha/keydb-enterprise -d application-that-uses-keydb
```

## Or connect via keydb-cli *(also compatible with redis-cli)*

you can grab the ip of the container with `docker inspect --format '{{ .NetworkSettings.IPAddress }}' mycontainername` then run the following:
```
docker run -it --rm eqalpha/keydb-enterprise keydb-cli -h [ipaddress-from-above] -p 6379
```
alternatively you can link to it
```
$ docker run -it --link some-keydb:eqalpha/keydb-enterprise --rm eqalpha/keydb-enterprise keydb-cli -h keydb -p 6379
```
