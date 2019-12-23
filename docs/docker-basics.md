---
id: docker-basics
title: Getting Started with Docker
sidebar_label: Getting Started
---

## Whats New?

KeyDB now has support for Active Replicas.  This feature greatly simplifies hot-spare failover and allows you to distribute writes over replicas instead of just a single master.  For more information [see the wiki page](https://github.com/JohnSully/KeyDB/wiki/KeyDB-(Redis-Fork):-Active-Replica-Support).
The latest pull (v0.9.3) will contain the option for Active Replica Support which is by default disabled in redis.conf. If you want to try please enable this option per [wiki](https://github.com/JohnSully/KeyDB/wiki/KeyDB-(Redis-Fork):-Active-Replica-Support) and run docker container per below with your own config file.

KeyDB now supports ARM, ARM 64 , x86-64. `docker pull eqalpha/keydb` will pull correct image from manifest.

If you are interested in generating the latest binaries from our github unstable, check out our [image to build binaries (x86_64) "eqalpha/keydb-build-bin"](https://hub.docker.com/r/eqalpha/keydb-build-bin)

Multi-Master support and Active-Replica support is included in the latest release 0.9.4. This feature is still considered experimental, but give it a try and let us know your thoughts. We have some other very cool features on their way soon. If you want to join the mailing list to keep up to date on our releases and features, please [visit our website to send us a message to get added!](https://www.eqalpha.com/)

## start a keydb instance

```
docker run --name some-keydb -d eqalpha/keydb
```

## start with persistent storage

```
$ docker run --name some-keydb -d eqalpha/keydb keydb-server --appendonly yes
```

If persistence is enabled, data is stored in the `VOLUME /data`, which can be used with `--volumes-from some-volume-container` or `-v /docker/host/dir:/data` (see[docs.docker volumes](https://docs.docker.com/storage/volumes/)).

## connect to it from an application

```
$ docker run --name some-app --link some-keydb:eqalpha/keydb -d application-that-uses-keydb
```

## or connect via keydb-cli *(also compantible with redis-cli)*

```
$ docker run -it --link some-keydb:eqalpha/keydb --rm eqalpha/keydb keydb-cli -h keydb -p 6379
```
you can also grab the ip of the container with `docker inspect --format '{{ .NetworkSettings.IPAddress }}' mycontainername` then run the following:
```
docker run -it --rm eqalpha/keydb keydb-cli -h <ipaddress-from-above> -p 6379
```
## updating config file used within Docker image
If you want to specify the binary to run (for CMD) and update its config file, make sure you specify the config file location within the image followed by your updates (ie. enable active-replica on current setup) :
```
$ docker run --name mykeydb -d eqalpha/keydb keydb-server /etc/keydb/redis.conf --active-replica yes
```
## if you would like to use your own config file

```
$ docker run -v /path-to-config-file/redis.conf:/etc/keydb/redis.conf --name mykeydb -d eqalpha/keydb
```
If you are using your own config file remember to comment out "bind 127.0.0.1", change "protected-mode" from yes to no. If you want to enable Active Replica Support then uncomment "active-replica yes". 

you can grab a copy of the default config file off our [github page](https://github.com/johnsully/keydb)

## New Configuration Options

With new features comes new options:

```
server-threads N
server-thread-affinity [true/false]
scratch-file-path /tmp/
active-replica yes
```

The number of threads used to serve requests. This should be related to the number of queues available in your network hardware, not the number of cores on your machine. Because KeyDB uses spinlocks to reduce latency; making this too high will reduce performance. We recommend using 4 here. By default this is set to 3 for this image.

All other configuration options behave as you'd expect. Your existing configuration files should continue to work unchanged.

For more options on things like flash backed storge or dumping directly to AWS S3, take a look at our [github page](https://github.com/johnsully/keydb) 

## KeyDB with Flash Support
See [wiki](https://github.com/JohnSully/KeyDB/wiki/FLASH-Storage) for detailed explanation

You will need to make a directory mounted to your SSD/NVMe volume with BTRFS filesystem. You can then run via:
```
$ docker run -it --name mykeydb --mount type=bind,target=/tmp/keydbflash,source=/path-to-btrfs-ssd-mount-location-you-made/ eqalpha/keydb:flash
```

## Try The Latest:
If you keep up to date with KeyDB and want to check out features in the making prior to an official release, you can pull with the unstable tags. This will grab the latest version (automatically updated daily at 4am Eastern). These tags are for x86-64 (amd-64) only.

Pull the latest image with `docker pull eqalpha/keydb:unstable`  or to get the flash build  `docker pull eqalpha/keydb:unstable-flash`

For regular updates of changes and issue resolutions pushed to the github unstable branch, <a href=https://github.com/JohnSully/KeyDB/>please watch/follow us on github</a>.  For more general updates or to keep in touch please <a href=https://eqalpha.us20.list-manage.com/subscribe/post?u=978f486c2f95589b24591a9cc&id=4ab9220500 />subscribe to KeyDB</a>


