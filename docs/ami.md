---
id: ami
title: Using the KeyDB Pro AMI
sidebar_label: Using AWS AMI
---

<div id="blog_body">

## About the KeyDB Pro AMI

The KeyDB Pro AWS AMI is an Amazon Machine Image that is fully set up and configured for use. The AMI can be set up in seconds and launched through the Amazon interface, through the client, or API. You can also SSH into it and run the keydb-setup tool.

This document provides information and instructions on using the AMI and getting started. Both a quick reference guide and a step by step detailed walkthrough are covered

Benefits of the AMI:
* No need to purchase a license key. Pro is already enabled exclusive to this image. Just pay your hourly AWS costs.
* Automatically set up FLASH and KeyDB configuration through user data, avoiding the need to SSH into the machine. Linux experience is not required
* KeyDB is set up to automatically launch and reboot (set up as a service). 
* Basic configuration for your selection is already done and optimized
* Scripts available to set up FLASH and update binaries

## Get going quickly

This is a quick reference to get going. For more information see the detailed walkthrough section further down
1.	Select the KeyDB AMI to use, you can find our AMI [here](https://aws.amazon.com/marketplace/pp/B086WNHBGJ). Click “Continue to Subscribe” and accept terms
2.	Choose your instance type. 
3.	Copy the sample script below into the “user data” section to automatically configure the instance. 
	* Start by entering your keydb.conf parameter changes under ‘config_parameters’. Make sure you set your password by updating the “requirepass” parameter. Any other instance specific parameters can be enabled here as well, ie `replicaof [ip] [port]` or `active-replica yes`, etc. ‘bind 0.0.0.0’ enables KeyDB to be accessed from outside this machine.
	* If you are using the KeyDB FLASH feature uncomment (remove ‘#’) for the `keydb-flash-setup.sh [option1] [option2]` and select the configuration you want. Keep in mind settings for flash will be automatically configured based on your selection. This includes setting up a raid array of available, unused volumes and mounting. 
	  * ‘nvme’ configures ephemeral direct attached NVMe SSDs
	  * ‘ebs’ configures unused EBS volumes for flash
	  * ‘nordb’ option passed as the second argument will disable rdb saving. 
  For more detail on these options please refer to the detailed setup instructions further down. If you are not adding any volumes other than your main root volume and want FLASH configured there, simply specify `storage-provider flash /mnt/keydb_flash` under ‘configurtion_parameters’ and keep the keydb-flash-setup.sh script disabled (commented out)
```
#! /bin/bash

## uncomment flash setup option below, usage 'keydb-flash-setup.sh [nvme or ebs] [nordb]' ##
# keydb-flash-setup.sh nvme

## enter non-default parameters below ##
config_parameters="
bind 0.0.0.0
requirepass yourpasswordhere
"

IFS=$'\n'
for line in $config_parameters
do
   param=$(echo $line | awk '{print $1}')
   sed -i "/^${param}.*/{h;s||${line}|};\${x;/^$/{s||${line}|;H};x}" /etc/keydb/keydb.conf
done
service keydb-server restart
exit
```
4.	Choose your volumes to add. Based on your selection above please ensure your volumes satisfy the following:
	* For all options below please note the flash script looks for any unused (non-root) volumes to configure for the flash database. The `nvme` option will look for all direct attached NVMe SSDs attached and set them up in a RAID array. Similarly if `ebs` argument is given the script will look for all unused EBS SSD volumes and set them up in a RAID array.
	* For `keydb-flash-setup.sh nvme` rdb backups can require up to 2x the NVMe database size + swap (equivalent to RAM), hence we typically recommend sizing the root EBS volume 2.5x the size of NVMe volumes. Because these volumes can be removed if you stop the instance, by default RDB save is enabled. You do have the option to add the `nordb` argument but keep in mind the possibility of aws detaching these under certain scenarios. A typical reboot will not disconnect the volumes.
	* For `keydb-flash-setup.sh ebs` it is assumed you are using a separate volume for the flash database. It also assumes you will be saving an RDB file redundantly on the root volume. As such your root volume should be over 2x the size of your EBS volumes.
	* For `keydb-flash-setup.sh ebs nordb` rdb saving is disabled. Add an EBS volume of any size for and do not worry about root volume size.
	* If you do not run the `keydb-flash-setup.sh` script with user data or pass arguments to it, the SSD drives will not be configured and FLASH will not be enabled. This can be done later by SSH’ing to the instance later and calling the `keydb-flash-setup.sh scripts or launching the keydb-setup.sh tool. 
5.	Set your security group:
	* Ideally create inbound rules to allow access to the KeyDB port 6379
6.	Launch instance. You are now ready to go!

## Set up KeyDB after launching

If you did not set up KeyDB through the user data section, it is recommended to launch the keydb-setup script which will walk you through setting up your instance:
```
$ sudo keydb-setup.sh
```

## Some FAQ’s

<b>What happens if I don’t specify a user data script when I launch?</b>
The instance will launch with protected mode enabled, so will not be accessible outside of the loopback adaptor. This assumes you will SSH into the machine to test or set up further. Running `$sudo keydb-setup.sh` will walk you through setup.

<b>Can I set up FLASH after I launch?</b>
Yes. You can run `$ sudo keydb-flash-setup.sh [option1] [option2]` script as root once you are SSH’d to the instance. You can also run the keydb-setup.sh script which will walk through the steps

<b>What if I want to update to a newer release of KeyDB?</b>
Simple, just run `$ sudo keydb-update-bin.sh`. This script will stop keydb, grab latest binaries, install them and restart keydb. The database will be stopped for a brief time during the update. 
You can also spin up a new AMI with the newer KeyDB Pro AMI as we update the AMIs with new point releases.

<b>What is the underlying distribution this image is build on?</b>
This is built on an Ubuntu18.04 64-bit x86 image. It uses a KeyDB Pro DEB package similar to our PPA repository Pro downloads. The services can be used the same.

<b>What if my NVMe SSD volume is unmounted?</b>
This will only happen if your aws machine is stopped. If this happens, SSH in and run the `keydb-flash-setup.sh nvme` script again to set up the new volumes.

## A Detailed Step by Step Walkthrough

### Select the KeyDB Pro AMI

You can select the AMI [here](https://aws.amazon.com/marketplace/pp/B086WNHBGJ). 

Click “Continue to Subscribe” and “Accept Terms”

### Select EC2 Instance

![image](/img/doc/ami/select_instance.png)

Under Instance Storage you will see two types of SSD storage. EBS volumes and NVMe direct attached SSDs. If you are using KeyDB on FLASH best performance can be seen with direct attached NVMe SSDs on m5d/r5d/i3/c5d/etc. 

KeyDB is multithreaded and will automatically allocate up to 7 cores for use with KeyDB. The more cores available typically the higher the performance and throughput. You can reference this [blog]( https://docs.keydb.dev/blog/2019/12/16/blog-post/) for more information on selecting ec2 instance types.

KeyDB is an in memory database, and for KeyDB on FLASH will use memory as a hot tier for data. Select an instance with memory appropriate for your loading.

### Configure Instance

Under the “Advanced Details” section you will see a field to enter “user data”. This is where you can place a startup script to configure your instance on boot. KeyDBs user data script enables you to fully configure your instance including FLASH setup and KeyDB additional configuration parameters. 

![image](/img/doc/ami/configure_instance.png)

It is recommended to configure via the user data script, unless you are familiar with linux and wish to set up KeyDB Pro manually. You will see a detailed breakdown for the script below

If you wish to configure manually, you can SSH into the instance and update keydb.conf in /etc/keydb/keydb.conf. You can start/stop keydb-server service and set up FLASH volume manually or via the keydb-flash-setup.sh tool. For an easy setup you can run `$ sudo keydb-setup.sh` to walk you through setup.

### User Data Script

In the “user data” field you can use the sample script below. Start by entering your keydb.conf parameter changes under ‘config_parameters’. Make sure you set your password by updating the “requirepass” parameter. Any other instance specific parameters can be enabled here as well, ie `replicaof [ip] [port]` or `active-replica yes`, etc. ‘bind 0.0.0.0’ enables KeyDB to be accessed from outside this machine.

If you wish to set up flash use one of the following options:
1.	'keydb-flash-setup.sh nvme' will set up ephemeral attached volumes in a raid array. RDB saving will save to your root drive which should be sized accordingly
2.	'keydb-flash-setup.sh ebs' will set up any unused EBS volumes in a raid array. RDB saving will be saved (redundant) to root drive which should be sized accordinlgy
3.	'keydb-flash-setup.sh nvme nordb' will set ephemeral attached volumes in a raid array with no rdb saving. Keep in mind if the instance is stopped, the volume will be diconnected and your data will be lost.
4.	'keydb-flash-setup.sh ebs nordb' will set up unused EBS volumes in a raid array. RDB save is disabled but data remains persisted on EBS flash volumes.

#### User Data Script Example:

```
#! /bin/bash

## uncomment flash setup option below, usage 'keydb-flash-setup.sh [nvme or ebs] [nordb]' ##
# keydb-flash-setup.sh nvme

## enter non-default parameters below ##
config_parameters="
bind 0.0.0.0
requirepass yourpasswordhere
"

IFS=$'\n'
for line in $config_parameters
do
   param=$(echo $line | awk '{print $1}')
   sed -i "/^${param}.*/{h;s||${line}|};\${x;/^$/{s||${line}|;H};x}" /etc/keydb/keydb.conf
done
service keydb-server restart
exit
```

### Add Storage

![image](/img/doc/ami/add_storage.png)

Choose your volumes to add. 
* If you have already chosen an instance with direct attached NVMe storage its recommended to select the root volume to be large enough to store RDB backups in addition to swap space and system requirements. Swap space is the same size as RAM, and RDB backups may take up to twice their volume during the backup process (old rdb not removed until new one written). Hence it is often recommended to size at 2.5x the NVMe requirement.
* If you plan on using EBS volumes for KeyDB on FLASH you can add additional EBS volumes. Ideally add one, however several can be selected and will be configured for FLASH in a raid array.

If you chose to run the user data script, keep in mind the following actions taken by the `keydb-flash-setup.sh` script.
* For all options below please note the flash script looks for any unused (non-root) volumes to configure for the flash database. The `nvme` option will look for all direct attached NVMe SSDs attached and set them up in a RAID array. Similarly if `ebs` argument is given the script will look for all unused EBS SSD volumes and set them up in a RAID array.
* For `keydb-flash-setup.sh nvme` the flash database can grow as large as your nvme volumes attached. Because these volumes can be removed if you stop the instance, by default RDB save is enabled and you should select your root volume to be ~2.5x the size of your NVMe FLASH volume
* For `keydb-flash-setup.sh ebs` it is assumed you are using a separate volume for the flash database. It also assumes you will be saving an RDB file redundantly on the root volume. As such your root volume should be 2.5x the size of your EBS volume.
* For `keydb-flash-setup.sh ebs nordb` rdb saving is disabled. Add an EBS volume of any size for use and do not worry about root volume size.
* If you do not run the `keydb-flash-setup.sh` script with user data or pass arguments to it, the SSD drives will not be configured and FLASH will not be enabled. This can be done later by SSH’ing to the instance later and calling the script. 

### Configure Security Group

![image](/img/doc/ami/configure_sg.png)

If you want to access the database outside of this instance you will need to specify access to port 6379 (or custom if you set it). Allow access from your client IP (s) or load balancer. If allowing access to the outside network you must at a minimum set a password. You should allow SSH access if you need to access for maintenance. Security groups can be modified after setup if needed.

Ideally you allow access to your client IP only, possibly through a load balancer or reverse proxy. If you have the option to go over the private aws network it is also a preferred option for security. It is always a good idea to expose access only as much as needed. 

If this instance is configured as part of a cluster it needs the cluster bus port enabled as well which is the port + 10,000. In the case above would be 16379. 

### Launch Instance

You can now launch your instance. Create a key or use existing one. This is needed if you want to SSH into the machine for maintenance, setup or troubleshooting. Keep the key in a secure place should you need it.

![image](/img/doc/ami/connect.png)

## Verifying your setup

SSH into the instance. You can see your drives using the `lsblk` command. They are labeled as ‘md0’ and created in a raid array. If there are more than 1 ssd drives available they will both be ‘md0’

```
ubuntu@ip-172-31-1-63:~$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0         7:0    0   18M  1 loop  /snap/amazon-ssm-agent/1566
loop1         7:1    0 89.1M  1 loop  /snap/core/8268
loop2         7:2    0 91.4M  1 loop  /snap/core/8689
loop3         7:3    0   18M  1 loop  /snap/amazon-ssm-agent/1480
nvme0n1     259:0    0 46.6G  0 disk
└md0         9:0    0 46.5G  0 raid0 /mnt/keydb_flash
nvme1n1     259:2    0    8G  0 disk
└nvme2n1p1 259:3    0    8G  0 part  /
```

Using the `df` command you can see your mount point. Your FLASH working directory is /mnt/keydb_flash. You will see the volume of the drive available to this directory

```
ubuntu@ip-172-31-1-63:~$ df
Filesystem     1K-blocks    Used Available Use% Mounted on
udev             1884872       0   1884872   0% /dev
tmpfs             379404     756    378648   1% /run
/dev/nvme2n1p1   8065444 1673408   6375652  21% /
tmpfs            1897000       0   1897000   0% /dev/shm
tmpfs               5120       0      5120   0% /run/lock
tmpfs            1897000       0   1897000   0% /sys/fs/cgroup
/dev/loop0         18432   18432         0 100% /snap/amazon-ssm-agent/1566
/dev/loop1         91264   91264         0 100% /snap/core/8268
/dev/loop3         18432   18432         0 100% /snap/amazon-ssm-agent/1480
/dev/loop2         93568   93568         0 100% /snap/core/8689
/dev/md0        47766208  130140  47619684   1% /mnt/keydb_flash
tmpfs             379400       0    379400   0% /run/user/1000
```

We use fstab to ensure drives are remounted on boot. Under /etc/fstab you will find the mount call which references the drive md0 by UUID. 

If you reboot your machine your volumes will appear as set up above. No data loss will occur. 

The only time you can lose data is if you stop a machine with direct attached NVMe storage because AWS disconnects the drives if you stop the machine. They will remain connected on a standard reboot. Should your drives be disconnected from stopping the machine or other, you will need to rerun `keydb-flash-setup.sh nvme` to reassociate the drives and setup fstab as the uuid will have changed. The nofail option when mounting ensures your machine boots even if the drive is not available.

## Updating KeyDB

As new versions of KeyDB Pro are released they will be updated with new AMIs. However if you do not wish to update your AMI but just want to update the KeyDB binaries, you can run the following script:
```
$ sudo keydb-update.sh
```

This will pull the latest binaries, stop the keydb service, swap out binaries, then start the service again. You will experience some downtime for the update.


If you need to revert to a previous AMI version you can run the update script and pass an argument for the specific version. For example:

```
$ sudo keydb-update.sh 6.0.3
```

</div>
