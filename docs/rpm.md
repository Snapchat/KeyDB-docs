---
id: rpm
title: Using & Installing RPM Packages
sidebar_label: RPM Packages
---



## About the KeyDB RPM Packages

You can find all KeyDB RPM packages here: https://download.keydb.dev/pkg/open_source/rpm/. In our RPM directory listing you can find all previous rpm package versions as well as the latest. We have linked to the latest rpm package in the higher level directories for easy access and for those running scripts. 

KeyDB RPM packages when installed download dependencies, install binaries and set up systemd services for keydb and sentinel. You can obtain packages as shown below for your setup:

## RPM Signing Key

RPM packages are signed. You can get the public key [here](https://download.keydb.dev/pkg/open_source/rpm/) or simply import it with the following command:
```
$ rpm --import https://download.keydb.dev/pkg/open_source/rpm/RPM-GPG-KEY-keydb
```
You can validate signature of the package with:
```
$ rpm -Kv keydb-rpm-package-you-downloaded.rpm
```

## KeyDB Community Download

You can get a full list of rpm packages available for install here: https://download.keydb.dev/pkg/open_source/rpm/
For the latest versions, you can use the commands below:

### Centos 7 amd64 (x86_64):
```
$ wget https://download.keydb.dev/pkg/open_source/rpm/centos7/x86_64/keydb-latest-1.el7.x86_64.rpm
$ sudo yum install ./keydb-latest-1.el7.x86_64.rpm
```
### Centos 7 arm64 (aarch64)
```
$ wget https://download.keydb.dev/pkg/open_source/rpm/centos7/aarch64/keydb-latest-1.el7.aarch64.rpm
$ sudo yum install ./keydb-latest-1.el7.aarch64.rpm
```

### Centos 8 amd64 (x86_64):
```
$ wget https://download.keydb.dev/pkg/open_source/rpm/centos8/x86_64/keydb-latest-1.el8.x86_64.rpm
$ sudo yum install ./keydb-latest-1.el8.x86_64.rpm
```
### Centos 8 arm64 (aarch64)
```
$ wget https://download.keydb.dev/pkg/open_source/rpm/centos8/aarch64/keydb-latest-1.el8.aarch64.rpm
$ sudo yum install ./keydb-latest-1.el8.aarch64.rpm
```

## Versions
By default when you download the packages above with the version “latest” the latest rpm package will be downloaded. Once you download the package you can verify the version number with 
```
$ rpm -qip <package.rpm>` 
```
If already installed `$ sudo yum info keydb` 
The latest release will be kept up to date with the latest stable release on github which you can find here https://github.com/EQ-Alpha/KeyDB/releases. The tag will be referenced as latest.

## Compatibility
Please note these rpm packages are built and available on Centos 7 & Centos 8. As such they should be compatible on redhat equivalent versions.

## Setting up KeyDB RPM Packages
Install as shown above. You can then either call binaries directly and pass in configuration parameters. Or start and stop the service.

### Using Services

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

Binaries installed are placed in /usr/bin/

### Enabling Automatic Start on Boot
By default the service is disabled and will be disabled if your machine is rebooted. If you would like to have KeyDB start on system boot:
```
$ sudo systemctl enable keydb
```


## Uninstall
```
$ sudo yum remove keydb
```



