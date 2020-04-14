---
id: rpm
title: Using & Installing RPM Packages
sidebar_label: RPM Packages
---

<div id="blog_body">


## About the KeyDB RPM Packages

You can find all KeyDB RPM packages here: https://download.keydb.dev/packages/rpm/. In our RPM directory listing you can find all previous rpm package versions as well as the latest. We have linked to the latest rpm package in the higher level directories for easy access and for those running scripts. 

KeyDB RPM packages when installed download dependencies, install binaries and set up systemd services for keydb and sentinel. You can obtain packages as shown below for your setup:

## KeyDB Community Download

### amd64 (x86_64):
```
$ wget https://download.keydb.dev/packages/rpm/centos7/x86_64/keydb-latest-2.el7.x86_64.rpm
$ sudo yum install ./keydb-latest-2.el7.x86_64.rpm
```
### arm64 (aarch64)
```
$ wget https://download.keydb.dev/packages/rpm/centos7/aarch64/keydb-latest-2.el7.aarch64.rpm
$ sudo yum install ./keydb-latest-2.el7.aarch64.rpm
```
## KeyDB Professional Download

### amd4 (x86_64):
```
$ wget https://download.keydb.dev/packages/rpm/centos7/x86_64/keydb-pro-latest-2.el7.x86_64.rpm
$ sudo yum install ./keydb-pro-latest-2.el7.x86_64.rpm
```
### arm64 (aarch64)
```
$ wget https://download.keydb.dev/packages/rpm/centos7/aarch64/keydb-pro-latest-2.el7.aarch64.rpm
$ sudo yum install ./keydb-pro-latest-2.el7.aarch64.rpm
```
## Versions
By default when you download the packages above with the version “latest” the latest rpm package will be downloaded. Once you download the package you can verify the version number with 
```
$ rpm -qip <package.rpm>` 
```
If already installed `$ sudo yum info keydb` or `$ sudo yum info keydb-pro`
The latest release will be kept up to date with the latest stable release on github which you can find here https://github.com/JohnSully/KeyDB/releases. The tag will be referenced as latest.

## Compatibility
Please note these rpm packages are built on centos7. As such they will be compatible on higher versions of centos as well as redhat equivalent versions.

## Setting up KeyDB RPM Packages
Install as shown above. You can then either call binaries directly and pass in configuration parameters. Or start and stop the service.

### Using Services
Commands are the same whether using KeyDB Community or Professional
```
$ sudo service keydb start
$ sudo service keydb stop
$ sudo service keydb status
```
This can be done similarly with keydb-sentinel

The main configuration file is located at /etc/keydb/keydb.conf

Other relevant files updated with keydb are:
* /etc/logrotate.d/keydb
* /lib/systemd/system/keydb.service
* /lib/systemd/system/keydb-sentinel.service
* /etc/keydb/sentinel.conf

Binaries installed with keydb-tools are placed in /usr/bin/

### Enabling Automatic Start on Boot
By default the service is disabled and will be disabled if your machine is rebooted. If you would like to have KeyDB start on system boot:
```
$ sudo systemctl enable keydb
```

## Using FLASH with systemd
KeyDB is run as a service as user:group keydb:keydb. Upon installation the associated directories are give permissions, however if you set up a FLASH storage medium to use with KeyDB you will need to modify the ownership of that directory.
```
$ sudo chown -R keydb:keydb /path/to/flash/storage/directory
```
You will also have to tell systemd to allow read/write access to this directory by appending the following line to /lib/systemd/system/keydb.service below where the other similar to it are located:
```
ReadWriteDirectories=-/path/to/flash/storage/directory
```

Please reference the other documents in “Getting Started” section of docs regarding using KeyDB and its features

## Uninstall
```
$ sudo yum remove keydb
```
If KeyDB Professional is installed:
```
$ sudo yum remove keydb-pro
```

</div>
