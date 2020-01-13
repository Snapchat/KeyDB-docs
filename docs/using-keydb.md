---
id: using-keydb
title: Start Using KeyDB in Minutes
sidebar_label: Get Started in Minutes
---

<div id="blog_body">

## Compatability

KeyDB remains up to date with the current version of Redis and as such maintains compatibility with standard Redis API's and protocols. Front-end tools, redis clients, API's and modules will work with KeyDB. KeyDB is a drop in alternative to Redis. You can see more in [migration](https://docs.keydb.dev/docs/migration)

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

## Binaries for Ubuntu 18.04

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

### Launching an Instance

```
$ keydb-server --port 6379 --requirepass mypassword --server-threads 7
```
Here we launched keydb-server and passed in parameters to the default config file. You can also specify the configuration file which you may have already customized
```
$ keydb-server ./path/to/config/keydb.conf
```
### Launching Pro
You can either specify keydb-server to run the pro binary: `keydb-server --enable-pro [license-key]` or you can just call the pro binary directly `keydb-pro-server`

If you do not have a license key you can use it in trial mode for 20 minutes after which time you will have to restart it. If you have a license key you can enter it here or speicfy it in your configuration file

### Launching Enhanced FLASH
```
keydb-server --enable-pro [license-key] --storage-provider  flash  [path-to-flash-storage] --maxmemory [max-memory-for-DRAM… ie. 500mb or 1G] --eviction-policy allkeys-lru
```
In your config file you will find descriptions of each parameter used above. You can also find out more about using Enhanced FLASH [here]( https://docs.keydb.dev/docs/pro-flash/)

### Connect with keydb-cli
```
$ keydb-cli -h 127.0.0.1 -p 6379
```

## Build Community KeyDB

Take a look at our docs on [building KeyDB (Open Source)](https://docs.keydb.dev/docs/build/). Once you have installed the binaries (`make install`) you can simply call the program at the command line `keydb-server`. You will want to specify you directory location, logfile location, and .conf location. 

Once installed you can remove the project folder you cloned but make sure to copy 'keydb.conf' from the top level directory into a location of your choice.

## Coming soon

In the near future KeyDB will be hosting deb and rmp packages for several different builds as well as more binary downloads for different builds. Each method will support KeyDB Pro
</div>
