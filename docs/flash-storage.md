---
id: flash-storage
title: Using Non-Volatile Memory in Addition to RAM
sidebar_label: Legacy FLASH
---
<div id="blog_body">
## KeyDB on FLASH

KeyDB FLASH documentation is separated into two sections.

For our new KeyDB Pro FLASH feature see [Enhanced FLASH](https://docs.keydb.dev/docs/pro-flash)

For our legacy FLASH feature you can follow this document.

For new deployments we recommend the use of KeyDB Pro FLASH. Our Enhanced FLASH option built into pro is built on RocksDB and is much faster than the legacy flash product because of how its architected. It also does not require a special file system as does legacy. 


## Legacy FLASH System Requirements
-------------------

KeyDB relies on file system snapshots to keep data backups quick and efficient.  As such you must use a filesystem with snapshot support such as BTRFS or ZFS.  Additionally because this feature has a slight overhead you must enable it at compile time.  Docker images with this feature compiled in are available.  See the compiling section for more information on how to build from source with this feature enabled.

## Legacy FLASH Configuration File
------------------

A new configuration option is added which will enable this feature and determine where the scratch file goes.  This must be a path to a directory on a filesystem with snapshotting enabled.  KeyDB will make a temporary file in this directory which will automatically be deleted when the program is closed.

    scratch-file-path /path

Note: As a consequence of how the automatic deletion works you may not see the file in this directory with 'ls'.  The 'df' command and 'lsof' command can instead be used to get better information on the disk usage of this file.

## Legacy FLASH Compiling
---------

When compiling the malloc must be set to 'memkind' using the following command:

    make MALLOC=memkind
</div>