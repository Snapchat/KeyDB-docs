---
id: pro-getting-started
title: Getting Started with KeyDB Professional
sidebar_label: Getting Started
---

## Downloading KeyDB-Pro

It is currently recommended to use docker images with KeyDB Pro. We do have binaries available to download for Ubuntu 18.04. In the near future we plan to have the binaries available in DEB packages and RPM packages for common builds. 

KeyDB-Pro can be downloaded through our <a href=”https://keydb.dev/downloads.html”><span style=:color:red”>website here</span></a>. Please note these are Ubuntu 18.04 binaries and should not be used on other platforms. We plan to offer downloads for many other builds in the near future. 

If you use docker, simply run our official image you are used to which now contains the KeyDB Pro binaries as well. You can check out docker <a href=”https://hub.docker.com/r/eqalpha/keydb”><span style=:color:red”>here</span></a> or pull the image directly via `sudo docker pull eqalpha/keydb`. 

Please note that the Community and Professional versions are packaged together as of January 6, 2020. The open source version by default is used, however Pro features can be enabled easily via the config file or command line. If you have downloaded KeyDB on docker or via the website you likely have KeyDB-Pro features already available to you. 

## Obtain license Key

KeyDB-Pro requires a license key that you can obtain <a href=”https://checkout.keydb.dev/”><span style=:color:red”>here</span></a>. Current pricing is very affordable at $69.99/month with no limits to single node usage. A single KeyDB node will be able to maximize use of the server it is on with KeyDB’s multithreading. There is no limit to DRAM, FLASH, threads enabled, etc. All KeyDB-Pro features are available with the purchase of a license. Licenses cannot be shared between instances but are transferrable. KeyDB replica and cluster nodes with the same license key cannot connect to each other.

Once you have your license key you can run Pro at the command line by specifying it with:
```
keydb-server --enable-pro [license-key]
```
Where “[license-key]” is the license key provided to you following purchase.

## Or Start Using Immediately without a Key

If you want to play around with KeyDB-Pro before purchasing a license Key, you can use it for 20 minutes before the process is killed and you have to restart it. Hence you can use it to develop on and test, but not in production. Simply specify the option to run Pro without adding in a license key 
```
keydb-server --enable-pro
```
## Updating the Config File

Open up your configuration file you are using for KeyDB, typically found in /etc/keydb/keydb.conf, or wherever you have specified the directory for it. Scroll to the bottom where the pro features are located and update the file to enable pro and provide the license key with it. 
```
server-threads 7
server-thread-affinity true
...
enable-pro [license-key]
```

## Using Pro with Docker

To load your custom config file to docker:
```
$ docker run -v /path-to-config-file/keydb.conf:/etc/keydb/keydb.conf --name mykeydb -d eqalpha/keydb

```
To pass configuration options to keydb at startup:
```
$ docker run --name mykeydb -d eqalpha/keydb keydb-server --enable-pro [license-key]
```

## Enabling Pro on a Live Server

If you are using KeyDB Community and want to convert it to KeyDB Pro without taking down any servers, this is possible by introducing Pro nodes into your cluster or replica setup. You can connect a Pro node to a non-Pro cluster but not the other way around. You can also introduce your Pro node as a replica to a non-Pro node. After which you would promote the Pro version to master then convert the replica to Pro.

