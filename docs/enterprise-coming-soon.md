---
id: enterprise-coming-soon
title: Coming Soon to KeyDB Enterprise
sidebar_label: Coming Soon
---

In addition to the current KeyDB Enterprise feature suite, we have some exciting new features on the way.

## KeyDB Persistence Offerings

Intel Optane DC Persistent Memory is starting to become more readily available to the public. Preliminary testing of KeyDB on PMEM enables persistence at near DRAM speeds. This means that once a value is written to the database it is persisted in the optane memory at that point (no waiting to persist to RDB or AOF). When the client receives the ‘OK’ the data is persisted and not waiting for the fsync interval to elapse. 

KeyDB Enterprise on FLASH is retained in FLASH where it is stored which offers a new level of persistence without the need for RDB/AOF. See [ FLASH](https://docs.keydb.dev/docs/enterprise-flash/) in docs for more info. This feature is currently available. We have been making big gains in performance with FLASH at peak loads and continue to do so. 

## Transaction Rollbacks

Transaction Rollbacks are being introduced allowing isolation guarantees. In addition to ensuring atomicity where rollbacks are possible without a high level of pre-screening on the client side. Also enabling the user to rollback when they decide to cancel, etc. 

## Data Compression Options

Enable compression of objects to reduce database size and cut costs way down. For those limited by memory or paying a lot for the memory, this option has immediate payback. 

## RAFT Consensus Support

We are working on a RAFT implementation in KeyDB Enterprise which will offer very strong data guarantees

## Subscribe

If you want to keep up to date with KeyDB-Enterprise and what we are doing, please be sure to connect and follow us on one of our channels:

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"></link>
<a style={{'font-size': '40px'}} href="https://twitter.com/realkeydb" class="fa fa-twitter"></a><a style={{'font-size': '40px'}} href="https://eqalpha.us20.list-manage.com/subscribe/post?u=978f486c2f95589b24591a9cc&id=4ab9220500" class="fa fa-envelope"></a><a style={{'font-size': '40px'}} href="https://www.linkedin.com/company/eqalphatechnology/" class="fa fa-linkedin"></a><a style={{'font-size': '40px'}} href="https://github.com/EQ-Alpha/KeyDB" class="fa fa-github"></a><a style={{'font-size': '40px'}} href="https://www.facebook.com/realkeydb/" class="fa fa-facebook"></a><a style={{'font-size': '40px'}} href="https://www.instagram.com/_keydb_/" class="fa fa-instagram"></a>
