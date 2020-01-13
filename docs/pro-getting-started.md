---
id: pro-getting-started
title: Getting Started with KeyDB Professional
sidebar_label: Getting Started
---

<div id="blog_body">

## Downloading KeyDB-Pro

It is currently recommended to use docker images with KeyDB Pro. We do have binaries available to download for Ubuntu 18.04. In the near future we plan to have the binaries available in DEB packages and RPM packages for common builds. 

KeyDB-Pro binaries can be downloaded through our <a href=”https://keydb.dev/downloads.html”><span style=:color:red”>website here</span></a>. Please note these are Ubuntu 18.04 binaries and should not be used on other platforms. We plan to offer downloads for many other builds in the near future.

### Download & Install Binaries
You can download these via our website [here](https://keydb.dev/downloads.html)
```
$ wget https://download.keydb.dev/keydb-bin.tar.gz
$ tar -xvf keydb-bin.tar.gz
$ cd keydb-bin
$ cp keydb-* /usr/bin/
$ cp *.conf /path/to/directory/for/config
```
Here we grabbed the binaries off the keydb website, extracted the tar.gz file and then moved the binaries to /usr/bin so they can be called from anywhere. If you dont want to move them to bin, make sure to call the program directly

Keep the configuration files where you would like (ie. /etc/keydb/) so you can customize the configuration file and specify it when you launch.

### Download Docker Image

If you use docker, simply run our official image you are used to which now contains the KeyDB Pro binaries as well. You can check out docker <a href=”https://hub.docker.com/r/eqalpha/keydb”><span style=:color:red”>here</span></a> or pull the image directly via 
```
$ sudo docker pull eqalpha/keydb`. 
```

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

### Launching Enhanced FLASH
```
keydb-server --enable-pro [license-key] --storage-provider  flash  [path-to-flash-storage] --maxmemory [max-memory-for-DRAM… ie. 500mb or 1G] --eviction-policy allkeys-lru
```
In your config file you will find descriptions of each parameter used above. You can also find out more about using Enhanced FLASH [here]( https://docs.keydb.dev/docs/pro-flash/)

## Run on Docker

### Install Docker

If you havent installed docker you can install with `$ sudo apt-get install docker docker.io`

### Run KeyDB

Pull the latest KeyDB docker image with `$sudo docker pull eqalpha/keydb`. Alternatively, if you start by using the run command, docker will pull the latest image prior to running. The basic run command will be `$ sudo docker run eqalpha/keydb`

You will likely want to customize your configuration on startup. You can find out more on our [docker page](https://hub.docker.com/r/eqalpha/keydb). We will go over a few examples here on launching docker containers:

### Launching an Instance
```
$ docker run -name mycontainername -d eqalpha/keydb keydb-server --requirepass mypassword 
```
Here we launched a container with name 'mycontainername', it was launched in 'detached' mode to run in the background, we specified the repository 'eqalpha/keydb', followed by calling the program 'keydb-server' with an update to the 'requirepass' parameter. keydb-server will launch by default if a program is not otherwise specified. You have to specify the program if you plan to pass in additional parameters.

### Launching Pro
```
$ docker run --name mycontainername -d eqalpha/keydb keydb-server --enable-pro [license-key]
```
KeyDB pro is part of the binary package. If you do not have a license key you can use it in trial mode for 20 minutes after which time you will have to restart it. If you have a license key you can enter it here or speicfy it in your configuration file (see more [here](https://hub.docker.com/r/eqalpha/keydb).

### Launching Enhanced FLASH
```
sudo docker run -d -it --name mycontainername --mount type=bind,dst=/flash,src=/path/to/flash/ eqalpha/keydb keydb-server --enable-pro --storage-provider flash /flash --maxmemory [maxmemory-amount-ie. 500M] --eviction-policy [eviction-policy ie. allkeys-lfu]
```
This launches Pro with FLASH storage. Specify your flash location, mount it, and specify the appropriate configuration parameters. You can see more [here](https://hub.docker.com/r/eqalpha/keydb).

### Connect with keydb-cli
you can grab the ip of the container with docker inspect --format '{{ .NetworkSettings.IPAddress }}' mycontainername then run the following:
```
docker run -it --rm eqalpha/keydb keydb-cli -h <ipaddress-from-above> -p 6379
```
The 'rm' parameter removes the container when you are done with it


## Enabling Pro on a Live Server

If you are using KeyDB Community and want to convert it to KeyDB Pro without taking down any servers, this is possible by introducing Pro nodes into your cluster or replica setup. You can connect a Pro node to a non-Pro cluster but not the other way around. You can also introduce your Pro node as a replica to a non-Pro node. After which you would promote the Pro version to master then convert the replica to Pro.

For more information see [migration](https://docs.keydb.dev/migration/)

</div>
