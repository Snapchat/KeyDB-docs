---
id: enterprise-getting-started
title: Getting Started with KeyDB Enterprise
sidebar_label: Getting Started
---

This is just a quick introduction to get running KeyDB Enterprise quickly. For more detailed information, Check out the 'KeyDB Enterprise' section or 'Getting Started --> Enterprise' of docs listed in the sidebar to your left.

Going from using Open Source to Enterprise is simple. There is a lot of overlap between using KeyDB Open Source and KeyDB Enterprise regarding commands, functionality and configuration. With KeyDB Enterprise there are additional performance improvements, features, and configurations you can take advantage of. These are listed specifically under Enterprise categories in the documentation.  

## Downloading KeyDB-Enterprise

It is currently recommended to use docker, ppa deb packages, or rpm packages with KeyDB Enterprise. You can contact support@keydb.dev if you have more specific needs.

### KeyDB PPA

Please see [this article](https://docs.keydb.dev/docs/entperise-ppa-deb/) for more details on our PPA and using deb packages. However in order to use the PPA its as simple as:
```
$ echo "deb https://download.keydb.dev/enterprise-dist $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/keydb.list
$ sudo wget -O /etc/apt/trusted.gpg.d/keydb.gpg https://download.keydb.dev/enterprise-dist/keyring.gpg
$ sudo apt update
$ sudo apt install keydb-enterprise
```

### Download Docker Image

If you use docker, simply run our official Enterprise image eqalpha/keydb-enterprise. You can check out docker [here](https://hub.docker.com/r/eqalpha/keydb-enterprise)
 or pull the image directly via 
```
$ sudo docker pull eqalpha/keydb-enterprise 
```

## Obtain License Key

KeyDB-Enterprise requires a license key that you can obtain by contacting sales@keydb.dev.

Once you have your license key you can run Enterprise at the command line by specifying it with:
```
keydb-server --enable-enterprise [license-key]
```
Where “[license-key]” is the license key provided to you following purchase.

If you are using a DEB/RPM package and running KeyDB as a service, you can update your license key at the bottom of `/etc/keydb/keydb.conf` and restart the service.

## Launching Enhanced FLASH
```
keydb-server --enable-enterprise [license-key] --storage-provider  flash  [path-to-flash-storage] 
```
In your config file you will find descriptions of each parameter used above. You can also find out more about using Enhanced FLASH [here]( https://docs.keydb.dev/docs/enterprise-flash/)

## Run on Docker

### Install Docker

If you haven't installed docker you can install with `$ sudo apt-get install docker docker.io`

### Run KeyDB

Pull the latest KeyDB docker image with `$sudo docker pull eqalpha/keydb-enterprise`. Alternatively, if you start by using the run command, docker will pull the latest image prior to running. The basic run command will be `$ sudo docker run eqalpha/keydb-enterprise`

You will likely want to customize your configuration on startup. You can find out more on our [docker page](https://hub.docker.com/r/eqalpha/keydb-enterprise). We will go over a few examples here on launching docker containers:

### Launching an Instance
```
$ docker run -name mycontainername -d eqalpha/keydb-enterprise keydb-server /etc/keydb/keydb.conf --requirepass mypassword --enable-enterprise LKXX-XXXX-XXXX-XXXX-XXXX
```
Here we launched a container with name 'mycontainername', it was launched in 'detached' mode to run in the background, we specified the repository 'eqalpha/keydb-enterprise', followed by calling the program 'keydb-server' with the contained config file and an update to the 'requirepass' parameter and license key. keydb-server will launch by default if a program is not otherwise specified. KeyDB Enterprise will not work without a license key. Please contact sales@eqalpha.com to discuss options for obtaining a license key.

If you want to bind the container to the node/machine so it is accessible externally pass the parameter `-p 6379:6379`

### Launching Enhanced FLASH
```
sudo docker run -d -it --name mycontainername --mount type=bind,dst=/flash,src=/path/to/flash/ eqalpha/keydb-enterprise keydb-server /etc/keydb/keydb.conf --enable-enterprise --storage-provider flash /flash --maxmemory [maxmemory-amount-ie. 500M] --maxmemory-policy [eviction-policy ie. allkeys-lfu] --enable-enterprise LKXX-XXXX-XXXX-XXXX-XXXX
```
This launches KeyDB with FLASH storage. Specify your flash location, mount it, and specify the appropriate configuration parameters. You can see more [here](https://hub.docker.com/r/eqalpha/keydb-enterprise).

### Connect with keydb-cli
you can grab the ip of the container with docker inspect --format '{{ .NetworkSettings.IPAddress }}' mycontainername then run the following:
```
docker run -it --rm eqalpha/keydb-enterprise keydb-cli -h [ipaddress-from-above>] -p 6379
```
The 'rm' parameter removes the container when you are done with it


## Introducing Enterprise to Your Setup

If you are using KeyDB Community and want to upgrade to KeyDB Enterprise without taking down any servers, this is possible by introducing enterprise nodes into your cluster or replica setup. You can connect a Enterprise node to a non-Enterprise cluster but not the other way around (pending use of Enterprise specific features). You can also introduce your Enterprise node as a replica to a non-Enterprise node. After which you would promote the Enterprise version to master then convert the replica to Enterprise.

For more information see [migration](https://docs.keydb.dev/migration/)

