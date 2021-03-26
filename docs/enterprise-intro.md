---
id: enterprise-intro
title: Welcome to KeyDB Enterprise
sidebar_label: About KeyDB Enterprise
---

## KeyDB Enterprise Docs

This section of docs houses all documentation relating specifically to KeyDB Enterprise. KeyDB Enterprise can be thought of as a superset to Open Source functionality, so documents related to Open Source also pertain to Enterprise unless otherwise specified/categorized.

## KeyDB Enterprise provides solutions to the tough problems:

### The fastest database for the most demanding workloads

KeyDB Enterprise keeps a leading edge in performance over the open source product. With options for more concurrency and less blocking calls, KeyDB Enterprise optimizes performance regardless of workload, maximizing throughput with ultra low latencies.

### Stable & consistent performance under heavy workloads

With asynchronous rehashing, and forkless background saving, KeyDB Enterprise maintains performance at peak loads, even during complex background operations that would otherwise impact performance.

### Additional security without a tradeoff in performance

KeyDB enables the use of TLS encryption. The additional overhead is handled with our multithreaded architecture spreading the workload over many cores. This allows us to allocate more threads and avoid the penalty otherwise seen from databases such as Redis.

### Insight into your data without a performance penalty

KeyDB Enterprise offers Non-blocking queries. With an MVCC implementation at the underlying architecture, KeyDB Enterprise can query individual snapshots of the database, avoiding otherwise blocking calls such as SCAN and KEYS. Such queries can now be called concurrently at scale without reducing overall performance of existing workloads.

### Disk-based support options for large datasets

KeyDB on FLASH is for large datasets requiring low latencies. Using FLASH storage mediums can help dramatically reduce hardware spend. KeyDB on FLASH keeps hot data in memory for sub millisecond latencies, while all data resides in FLASH memory. Data is written to FLASH immediately where it persists, eliminating the need for RDB or AOF files.

## A better Redis? Yes.

KeyDB Enterprise is significantly faster than Redis and able to handle much higher throughput per node. KeyDB keeps up to date with the latest versions of open source Redis to support any new features and maintain its compatibility. KeyDB Enterprise as such is a drop in replacement product for Redis and the best alternative on the market.

KeyDB Enterprise is architected in a way that allows us to take on the complexities and challenges associated with operating at scale so you don't have to. Using MVCC and building out our multithreading framework has opened the door to allow us to provEnterprise ide more complex and compute heavy features, opening up an exciting roadmap for our product without having tradeoffs in performance. 

## No Commitment or Vendor Lock-in 

KeyDB remains fully compatible with Redis API, Modules, Protocol. We work with Redis clients and are a drop in replacement for your current Redis deployment. If you develop with KeyDB, your efforts still enable you to change to Redis (minus KeyDB specific features). 


## Support

As an Enterprise customer, your issues will be prioritized first. Bugs are escalated and in critical situations, patched versions (pre-release) can be deployed quickly to get you back and running.

Take comfort knowing you have the experts on your side. With the developers of KeyDB within reach, your engineering team will be able to maximize its effectiveness in design and implementation.
