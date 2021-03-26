---
id: open-source-getting-started
title: Getting Started with KeyDB Open Source
sidebar_label: Getting Started
---

## Run on Docker

### Install Docker

If you haven't installed docker you can install with `$ sudo apt-get install docker docker.io`

### Pull and Run

Pull the latest KeyDB docker image with `$sudo docker pull eqalpha/keydb`. Alternatively, if you start by using the run command, docker will pull the latest image prior to running. The basic run command will be `$ sudo docker run eqalpha/keydb`

You will likely want to customize your configuration on startup. You can find out more on our [docker page](https://hub.docker.com/r/eqalpha/keydb). We will go over a few examples here on launching docker containers:

### Launching an Instance
```
$ docker run -p 6379:6379 --name mycontainername -d eqalpha/keydb keydb-server /etc/keydb/keydb.conf --requirepass mypassword 
```
Here we launched a container with name 'mycontainername', it was launched in 'detached' mode to run in the background, we specified the repository 'eqalpha/keydb', followed by calling the program 'keydb-server' and referencing the config file with an update to the 'requirepass' parameter. keydb-server will launch by default if a program is not otherwise specified. You have to specify the program if you plan to pass in additional parameters.

### Connect with keydb-cli

you can grab the ip of the container with docker inspect --format '{{ .NetworkSettings.IPAddress }}' mycontainername then run the following:
```
docker run -it --rm eqalpha/keydb keydb-cli -h <ipaddress-from-above> -p 6379
```
The 'rm' parameter removes the container when you are done with it

## Using the KeyDB PPA

Please see [this article](https://docs.keydb.dev/docs/ppa-deb/) for more details on our PPA and using deb packages. However in order to use the PPA its as simple as:
```
$ echo "deb https://download.keydb.dev/open-source-dist $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/keydb.list
$ sudo wget -O /etc/apt/trusted.gpg.d/keydb.gpg https://download.keydb.dev/open-source-dist/keyring.gpg
$ sudo apt update
$ sudo apt install keydb
```

### Using KeyDB as a Service

Once the debian package is installed you can start or stop the service with:
```
$ sudo service keydb-server start
$ sudo service keydb-server stop
```
You can customize your KeyDB configuration in `/etc/keydb/keydb.conf`

### Installed Binaries

The binary packages are installed, so you can run an instance by calling the binary directly and passing parameters. For example:
```
$ keydb-server --port 6379 --requirepass mypassword --server-threads 7
```
Here we launched keydb-server and passed in parameters to the default config file. You can also specify the configuration file which you may have already customized
```
$ keydb-server ./path/to/config/keydb.conf
```


### Connect with keydb-cli
```
$ keydb-cli -h 127.0.0.1 -p 6379
```

For more information please see [PPA & DEB Install](https://docs.keydb.dev/docs/ppa-deb)

## Build Community KeyDB

Take a look at our docs on [building KeyDB (Open Source)](https://docs.keydb.dev/docs/build/). Once you have installed the binaries (`make install`) you can simply call the program at the command line `keydb-server`. You will want to specify you directory location, logfile location, and .conf location. 

Once installed you can remove the project folder you cloned but make sure to copy 'keydb.conf' from the top level directory into a location of your choice.
