---
id: intro
title: Welcome to KeyDB's Documentation
sidebar_label: About Docs
---
<div id="blog_body">

## What is KeyDB

KeyDB is a high performance fork of Redis with a focus on multithreading, memory efficiency, and high throughput. Another driver of this project is to focus on simplicity for the user. Redis often focussed on the simplicty of the code base at the expense of the user experience. KeyDB is architected differently and as such can offer features such as active replication, MVCC, FLASH, and non-blocking queries without performance penalties associated with the Redis architecture.

## KeyDB Licensing

KeyDB is an open source project, [BSD licensed](https://github.com/JohnSully/KeyDB/blob/unstable/COPYING) containing multithreading, active replication, aws s3 backup, multi-master control (experimental, all without restriction.

[KeyDB Pro](https://keydb.dev/keydb-pro.html) is available as part of our binary distribution packages (currently [docker](https://hub.docker.com/r/eqalpha/keydb) or [binary downloads](https://keydb.dev/downloads.html)). This is included with the open source binaries and enabled easily via command line config, update to the config file, or running as standalone binary. KeyDB Pro offers powerful features at a cost far lower than any other database. Major architectural changes have enabled features such as MVCC, persistent FLASH, non-blocking queries, forkless background saving, and others. Features comming soon include transaction rollbacks, Intel Optane Persistent Memory Support at DRAM speeds, compression, encryption and others.

[KeyDB Pro](https://keydb.dev/keydb-pro.html) is intended to finance and support the development of KeyDB which will always remain open source under the BSD license. All pro features will always be kept in a separate binary to differentiate it from our open source distribution.

## About KeyDB Docs

KeyBD Docs is an [open source repository](https://github.com/benschermel/KeyDB-docs) for documentation, examples, tutorials, etc related to using KeyDB. There is a section of KeyDB Pro docs containing everything related to KeyDB Pro explicitely. All other sections of Docs are relevant to both KeyDB Open Source and KeyDB Pro.

## Requests

If you have a request for spcecific documentation it is likely youre not the only one. Please create and issue in the [KeyDB-docs repository](https://github.com/benschermel/KeyDB-docs) and we will put it in the queue.

## Contributions

We want to hear from you! As our users you likely have insights to the application of the product we do not. If you have a markdown tutorial/demonstration/instruction you would like us to post please create a pull request on the [KeyDB-docs Github repository](https://github.com/benschermel/KeyDB-docs). We will merge after reviewing the content. 

## Community

Please [join our gitter chat](https://gitter.im/KeyDB/community) where you can reach out directly with other KeyDB users.
</div>
