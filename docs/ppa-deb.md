---
id: ppa-deb
title: Using DEB Packages and KeyDB's PPA Repository
sidebar_label: PPA & DEB Install
---

<div id="blog_body">

Debian installation packages make installation of KeyDB easy. No need to worry about building the binaries, or directory setup. Just simply install and go!

Please note this will be the official PPA for KeyDB with the Launchpad PPA distribution becoming deprecated in the near future. Hosting the PPA ourselves enables more flexibility for binary distribution and allows us to serve you better. 

## KeyDB PPA

A PPA (Personal Package Archive) allows you to easily install, update and remove packages with commands such as `apt` or `dpkg`. When you follow the commands below to install KeyDB, the proper package will be selected for your installation. Current packages are available for arm64 and amd64 (x86_64) machines. These are built on Ubuntu 18.04 (bionic build).

In order to get your keydb-ppa, simply follow these commands below:
```
$ curl -s --compressed "https://download.keydb.dev/keydb-ppa/KEY.gpg" | sudo apt-key add -
$ sudo curl -s --compressed -o /etc/apt/sources.list.d/keydb.list https://download.keydb.dev/keydb-ppa/keydb.list
$ sudo apt update
$ sudo apt install keydb
```
In order to install keydb professional `$ sudo apt install keydb-pro`

Note that in addition to our Ubuntu18.04 Bionic PPA above we also have an Ubuntu16.04 Xenial PPA for amd64. You can install it by replacing the  first two lines above with the following:
```
$ curl -s --compressed "https://download.keydb.dev/keydb-ppa-xenial/KEY.gpg" | sudo apt-key add -
$ sudo curl -s --compressed -o /etc/apt/sources.list.d/keydb.list https://download.keydb.dev/keydb-ppa-xenial/keydb.list
```

## Installation

During the `apt install` phase you can choose from several installation methods:

### keydb-tools
Use `apt install keydb-tools` to install binaries only. This method is for someone who wants the program installed but not configured to run automatically (as a service). The installation moves these binaries to `/usr/bin/`: keydb-cli, keydb-server, keydb-pro-server, keydb-benchmark, keydb-check-aof, keydb-check-rdb.

### keydb-server
Use `apt install keydb-server` to run keydb-server as a service. Systemd files will be set up as well as directory structures for pid files, conf files, etc. keydb-tools is a dependancy for this package and will be installed if not already.

### keydb
Use `apt install keydb`. This installs both keydb-server and keydb-tools. This is a common installation for most.

### keydb-sentinel
For those using keydb-sentinel and want to run it as a service you will need to run `apt install keydb-sentinel`

### keydb-pro-tools
Use `apt install keydb-pro-tools` to install pro binaries only. This method is for someone who wants the program installed but not configured to run automatically (as a service). This package contains keydb pro binaries exclusively.

### keydb-pro-server
Use `apt install keydb-pro-server` to run keydb-pro-server as a service. Systemd files will be set up as well as directory structures for pid files, conf files, etc. keydb-pro-tools is a dependancy for this package and will be installed if not already

### keydb-pro
Use `apt install keydb-pro`. This installs both keydb-pro-server and keydb-pro-tools. This is a common installation for most and enables keydb-pro features to run with the services configured exclusively for pro

### keydb-pro-sentinel
For those using keydb-pro-sentinel and want to run it as a service you will need to run `apt install keydb-pro-sentinel`

## KeyDB DEB Packages
For those not getting KeyDB DEB packages via the PPA repository, they can be accessed at https://download.keydb.dev/packages/deb/. In this directory listing you can access deb packages for all previous versions as well as the latest versions. For each release there are 4 deb packages available as described above and they are consoldated to their own versioned directory for each release. 

In the higher level directories there is a "keydb-latest" or "keydb-pro-latest" directory linked to the latest version for ease of access and those running scripts. See above for more information on each deb package.

Unlike with the PPA, you will need to manually install the 'tools' package prior to the others, and you will have to install both 'tools' and 'server' prior to just the 'keydb' or 'keydb-pro' deb packages. 

The directory listing structure narrows down by distribution --> architecture --> keydb --> package


## Using KeyDB as a Service

When keydb-server or keydb-pro-server is set up as a service you can start, stop and check status via:
```
$ sudo service keydb-server status
$ sudo service keydb-server start
$ sudo service keydb-server stop
```
This can be done similarly with keydb-sentinel if installed

The main configuration file is located at /etc/keydb/keydb.conf

Other relevant files updated with keydb-server are:
* /etc/logrotate.d/keydb-server
* /etc/init.d/keydb-server
* /lib/systemd/system/keydb-server.service

Binaries installed with keydb-tools are placed in /usr/bin/

## Run on Boot

By default the service is disabled and will be disabled if your machine is rebooted. If you would like to have KeyDB start on system boot:
```
$ sudo systemctl enable keydb-server
```

## Setting up FLASH with systemd

If you are running KeyDB as a service with FLASH options enabled, you need to let systemd know you will be accessing the flash volume and make sure the keydb user/group have access. You will need to update the systemd file  `/lib/systemd/system/keydb-server.service` and append the following line below where the others are located:
```
ReadWriteDirectories=-/path/to/your/flash/volume/db/folder
```
This followed by `sudo systemctl daemon-reload`

You will then need to change the ownership on the directory of the specified flash volume
```
sudo chown -R keydb:keydb /path/to/your/flash/volume/db/folder

```
Now you should be able to run keydb pro with flash as a service and start/stop with `sudo service keydb-server start/stop/status`



## Uninstall
```
$ sudo apt autoremove --purge keydb keydb-server keydb-sentinel keydb-tools
```
or for pro
```
$ sudo apt autoremove --purge keydb-pro keydb-pro-server keydb-pro-sentinel keydb-pro-tools
```
Choose which package to uninstall based on which packages were installed in the first place. All packages are listed in above command, however some of the packages will remove the packages dependent on them as well.

If you want to remove the ppa from your list of programs to update on `sudo apt update`, then remove the .list file in sources:
```
$ sudo rm /etc/apt/sources.list.d/keydb.list
```

## Issues and Requests

If you have a build request, issue, or would like to make updates to the packages please email support@keydb.dev or create an issue on [github](https://github.com/JohnSully/KeyDB/issues)


</div>
