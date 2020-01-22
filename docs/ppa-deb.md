---
id: ppa-deb
title: Using DEB Packages and KeyDB's PPA Repository
sidebar_label: PPA & DEB Install
---

<div id="blog_body">

Debian installation packages make installation of KeyDB easy. No need to worry about building the binaries, or directory setup. Just simply install and go!

Please note this will be the official PPA for KeyDB with the Launchpad PPA distribution becoming deprecated in the near future. Hosting the PPA ourselves enables more flexibility for binary distribution and allows us to serve you better. 

## KeyDB's PPA

A PPA (Personal Package Archive) allows you to easily install, update and remove packages with commands such as `apt` or `dpkg`. When you follow the commands below to install KeyDB, the proper package will be selected for your installation. Current packages are available for arm64 and amd64 (x86_64) machines. These are built on Ubuntu 18.04 (bionic build).

In order to get your keydb-ppa, simply follow these commands below:
```
$ curl -s --compressed "https://benschermel.github.io/keydb-ppa/KEY.gpg" | sudo apt-key add -
$ sudo curl -s --compressed -o /etc/apt/sources.list.d/keydb.list "https://benschermel.github.io/keydb-ppa/keydb.list"
$ sudo apt update
$ sudo apt install keydb
```

During the `apt install` phase you can choose from several installation methods:

### keydb-tools
Use `apt install keydb-tools` to install binaries only. This method is for someone who wants the program installed but not configured to run automatically (as a service). The installation moves these binaries to `/usr/bin/`: keydb-cli, keydb-server, keydb-pro-server, keydb-benchmark, keydb-check-aof, keydb-check-rdb.

### keydb-server
Use `apt install keydb-server` to run keydb-server as a service. Systemd files will be set up as well as directory structures for pid files, conf files, etc. keydb-tools is a dependancy for this package and will be installed if not already.

### keydb
Use `apt install keydb`. This installs both keydb-server and keydb-tools. This is a common installation for most.

### keydb-sentinel
For those using keydb-sentinel and want to run it as a service you will need to run `apt install keydb-sentinel`

## Using KeyDB

When keydb-server is set up as a service you can start, stop and check status via:
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


## DEB Packages

If you do not wish to use the PPA, you can download the deb packages individually and install them. This method is more manual than using the PPA and any updates will be a manual process.

### Installation
To install the deb packages first unzip the contents of the package you have downloaded, then install the package(s) you would like. You will have to specify the package and install keydb-tools before keydb-server or keydb-sentinel.

### AMD64 Bionic
```
$ wget https://keydb.dev/downloads/keydb-deb_bionic_amd64.tar.gz
$ tar -xvf keydb-deb_bionic_amd64.tar.gz
$ cd keydb-deb_bionic_amd64
$ apt install keydb-tools_x.x.x-1chl1~bionic1_amd64.deb
$ apt install keydb-server_x.x.x-1chl1~bionic1_amd64.deb
```
### ARM64 Bionic
```
$ wget https://keydb.dev/downloads/keydb-deb_bionic_arm64.tar.gz
$ tar -xvf keydb-deb_bionic_arm64.tar.gz
$ cd keydb-deb_bionic_arm64
$ apt install keydb-tools_x.x.x-1chl1~bionic1_arm64.deb
$ apt install keydb-server_x.x.x-1chl1~bionic1_amd64.deb
```

## Uninstall
```
$ sudo apt autoremove --purge keydb keydb-server keydb-sentinel keydb-tools
```
Choose which package to uninstall based on which packages were installed in the first place. All packages are listed in above command

If you want to remove the ppa from your list of programs to update on `apt update`, then remove the .list file in sources:
```
$ sudo rm /etc/apt/sources.list.d/keydb.list
```

## Issues and Requests

If you have a build request, issue, or would like to make updates to the packages please visit our github page for the ppa where you can create an issue or PR. 

https://github.com/benschermel/keydb-ppa


</div>
