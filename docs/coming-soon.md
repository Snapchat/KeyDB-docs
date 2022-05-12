---
id: coming-soon
title: What is on the Roadmap for the KeyDB Project?
sidebar_label: Project Roadmap
---

## A Single Open Source Codebase

KeyDB is going all open source! This means integrating previously Enterprise features into KeyDB Open Source!! As part of Snap, KeyDB will open source the entire codebase and work with the community to maintain and grow the project!

## Introduced in Version 6.3.0
* The main branch has moved to what was previously the KeyDB Enterprise branch
* MVCC architecture is introduced to the codebase for increased read performance. This brings async commands (GET, MGET), non-blocking queries such as SCAN/KEYS, and in-process background saving.
* Partial Synchronization is also available for multi-master configurations
* [v6.3.0 Complete Feature Summary](/news/2022/05/11/feature-summary-6_3_0)

## Coming Soon!

### KeyDB FLASH Support
Support for KeyDB FLASH using the RocksDB engine will become available **September 2022**. This was offered as part of the previously Enterprise codebase, however for contractual reasons will not be released until September at which point it will remain open source.

### Namespaces
Multi-Tenant support through dedicated namespaces will be available in an upcoming release as tracked through PR#404. This is a community PR by @ederuiter. It will be released first without active-rep support which will be added in a future release.

### JSON
Native support for nested hashes will be coming to KeyDB. This will support nesting data structures such as hashes, values, and lists within hashes and will enable support for most JSON objects.

### RAFT
This is a strongly consistent mode using the RAFT algorithm. This enables strong data consistency across nodes. Check out [this blogpost](/blog/2021/07/06/blog-post) for more details

### More Performance Improvements
We are always improving the performance of KeyDB. With the introduction of MVCC into the open source codebase, we can now avoid locks and extract more parallelism for different commands. We plan to have additional async support for the following commands in July, 2022: HGET, HMGET, HKEYS, HVALS, HGETALL, HSCAN.


