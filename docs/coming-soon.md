---
id: coming-soon
title: What is on the Roadmap for the KeyDB Project?
sidebar_label: Project Roadmap
---

## A Single Open Source Codebase

KeyDB is going all open source! This means integrating previously Enterprise features into KeyDB Open Source!! Without the need to monitize KeyDB will open source the entire codebase and work with the community to maintain a powerhouse of a database for all!

## Introduced in April 2022 Release
As part of the initial Enterprise-to-OpenSource merge:
* MVCC architecture introduced to codebase for increased read performance
* Partial Synchroization for multi-master mode is available
* Add 'comments' to config, callable from INFO

## Coming Soon!

### KeyDB FLASH Support
Support for KeyDB FLASH using the RocksDB engine will become available September 2022

### Namespaces
Multi-Tenant support through dedicated namespaces will be available in an upcoming release as tracked through PR#404. This is a community PR by @ederuiter. It will be released first without active-rep support which will be added in a future release.

### JSON
Native support for nested hashes will be coming to KeyDB. This will support nesting data structures such as hashes, values, and lists within hashes and will enable support for most JSON objects.

### RAFT
This is a strongly consistent mode using the RAFT algorithm. This enable strong data consistency accross nodes. Check out this blogpost for more details

### More Performance Improvements
We are always improving the performance of KeyDB. With the introduction of MVCC into the open source codebase, we can now avoid locks and extract more parallelism for different queries.


