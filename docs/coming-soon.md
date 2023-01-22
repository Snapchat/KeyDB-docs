---
id: coming-soon
title: What is on the Roadmap for the KeyDB Project?
sidebar_label: Project Roadmap
---

## Version 6.3.2 (Now Available)

We are excited to announce some major updates that shipped with version 6.3.2 including Beta level support for KeyDB FLASH, new ASYNC commands, latency improvements and a number of bug fixes. 

#### KeyDB FLASH Availability
KeyDB FLASH is included as a Beta feature with this release. Enabling this feature avoids the need to store all data in memory, allowing you to store more data at a lower cost. KeyDB will persist data to the storage medium it is written to avoiding the need for AOF/RDB files. KeyDB uses RocksDB as the persistent storage provider and can be enabled with config `storage-provider flash /path/to/rocksdb/output`. Read more at https://docs.keydb.dev/docs/flash/

#### New ASYNC Commands
Async commands are commands which can execute without the global lock. In addition to GET/MGET support released with v6.3.0, ASYNC support has been added for the following commands: HGET, HMGET, HKEYS, HVALS, HGETALL, HSCAN and can be enabled with config `enable-async-commands yes`

#### Jammy & Bookworm Support
Packaging support for Ubuntu 22.04 (Jammy) and Debian 12 (Bookworm) has been included with this release and will be maintained moving forwards. For details on installation please refer to https://docs.keydb.dev/docs/ppa-deb

#### Release Notes
Please refer to the [v6.3.2 Release Notes](https://github.com/Snapchat/KeyDB/releases/tag/v6.3.2) for a full list of improvements & bug fixes!

## Coming Soon!

### Namespaces
Multi-Tenant support through dedicated namespaces will be available in an upcoming release as tracked through PR#404. This is a community PR by @ederuiter. It will be released first without active-rep support which will be added in a future release.

### JSON
Native support for nested hashes will be coming to KeyDB. This will support nesting data structures such as hashes, values, and lists within hashes and will enable support for most JSON objects.

### RAFT
This is a strongly consistent mode using the RAFT algorithm. This enables strong data consistency across nodes. Check out [this blogpost](/blog/2021/07/06/blog-post) for more details


