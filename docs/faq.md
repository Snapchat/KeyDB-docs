---
id: faq          
title: FAQ's 
sidebar_label: FAQ 
---

## How is KeyDB different than Redis?

KeyDB started as a fork of Redis where our fundamental beliefs differed. 
We thought Redis should be multithreaded and the core development team of 
Redis did not plan to support it. The fork started as a way to accelerate 
development in the areas of interest to us and other users. After multithreading 
Redis and seeing the benefits and performance gains, we felt there was value 
in having open source implementations of features currently only supported in some proprietary modules.
Some aspects of using Redis introduce a lot of uneccessary complexity such as sharding and high availability setup. 
As a result KeyDB introduced features such as active-replication and multi-master configuration options. 
Other features such as flash support, aws s3 backup, were also important features we believe should be part of the base code 
and standard to each instance.

KeyDB is also written largely in c++ allowing this project to accelerate to a different level. Plans to add other highly
sought afer features continue and KeyDB will announce these features as they are released. KeyDB is a leader when it comes
to performance and you can expect that the KeyDB product will adapt and take advantage of the latest hardware and software as it becomes available. 

## Why is KeyDB different compared to most other key-value stores?

There are two main reasons.

* KeyDB is a different evolution path in the key-value DBs where values can contain more complex data types, with atomic operations defined on those data types. KeyDB data types are closely related to fundamental data structures and are exposed to the programmer as such, without additional abstraction layers.
* KeyDB is an in-memory but persistent on disk database, so it represents a different trade off where very high write and read speed is achieved with the limitation of data sets that can't be larger than memory. Another advantage of
in memory databases is that the memory representation of complex data structures
is much simpler to manipulate compared to the same data structures on disk, so
KeyDB can do a lot, with little internal complexity. At the same time the
two on-disk storage formats (RDB and AOF) don't need to be suitable for random
access, so they are compact and always generated in an append-only fashion
(Even the AOF log rotation is an append-only operation, since the new version
is generated from the copy of data in memory). However this design also involves
different challenges compared to traditional on-disk stores. Being the main data
representation on memory, KeyDB operations must be carefully handled to make sure
there is always an updated version of the data set on disk.

## What's the KeyDB memory footprint?

To give you a few examples (all obtained using 64-bit instances):

* An empty instance uses ~ 3MB of memory.
* 1 Million small Keys -> String Value pairs use ~ 85MB of memory.
* 1 Million Keys -> Hash value, representing an object with 5 fields, use ~ 160 MB of memory.

To test your use case is trivial using the `KeyDB-benchmark` utility to generate random data sets and check with the `INFO memory` command the space used.

64-bit systems will use considerably more memory than 32-bit systems to store the same keys, especially if the keys and values are small. This is because pointers take 8 bytes in 64-bit systems. But of course the advantage is that you can
have a lot of memory in 64-bit systems, so in order to run large KeyDB servers a 64-bit system is more or less required. The alternative is sharding.

## I like KeyDB's high level operations and features, but I don't like that it takes everything in memory and I can't have a dataset larger the memory. Plans to change this?

"KeyDB on flash" is a solution that is able to use a mixed RAM/flash approach for
larger data sets. DRAM is significantly more expensive per GB than non volatile memory such as FLASH. When enabled KeyDB can store less frequently accessed data in non volatile storage instead of RAM. KeyDB will actively page data in and out of non volatile storage as necessary. Of course you can also use plain spinning disks, but it is not recommended as performance will be poor. KeyDB expects the underlying device to have good random I/O performance.

FLASH storage is only used for temporary data and behaves similar to RAM. Persistence is still accomplished through the normal mechanisms. Memory used by KeyDB will show up as "buff/cache" when looking at memory with the 'free' command. KeyDB relies on the kernel's paging policy for decisions on what to put on disk.



## Is using KeyDB together with an on-disk database a good idea?

Yes, a common design pattern involves taking very write-heavy small data
in KeyDB (and data you need the KeyDB data structures to model your problem
in an efficient way), and big *blobs* of data into an SQL or eventually
consistent on-disk database. Similarly sometimes KeyDB is used in order to
take in memory another copy of a subset of the same data stored in the on-disk
database. This may look similar to caching, but actually is a more advanced model
since normally the KeyDB dataset is updated together with the on-disk DB dataset,
and not refreshed on cache misses.

## Is there something I can do to lower the KeyDB memory usage?

If you can, use KeyDB 32 bit instances. Also make good use of small hashes,
lists, sorted sets, and sets of integers, since KeyDB is able to represent
those data types in the special case of a few elements in a much more compact
way. There is more info in the [Memory Optimization page](/topics/memory-optimization).

## What happens if KeyDB runs out of memory?

KeyDB will either be killed by the Linux kernel OOM killer,
crash with an error, or will start to slow down.
With modern operating systems malloc() returning NULL is not common, usually
the server will start swapping (if some swap space is configured), and KeyDB
performance will start to degrade, so you'll probably notice there is something
wrong.

KeyDB has built-in protections allowing the user to set a max limit to memory
usage, using the `maxmemory` option in the configuration file to put a limit
to the memory KeyDB can use. If this limit is reached KeyDB will start to reply
with an error to write commands (but will continue to accept read-only
commands), or you can configure it to evict keys when the max memory limit
is reached in the case you are using KeyDB for caching.

We have detailed documentation in case you plan to use [KeyDB as an LRU cache](/topics/lru-cache).

The INFO command will report the amount of memory KeyDB is using so you can
write scripts that monitor your KeyDB servers checking for critical conditions
before they are reached.

## Background saving fails with a fork() error under Linux even if I have a lot of free RAM!

Short answer: `echo 1 > /proc/sys/vm/overcommit_memory` :)

And now the long one:

KeyDB background saving schema relies on the copy-on-write semantic of fork in
modern operating systems: KeyDB forks (creates a child process) that is an
exact copy of the parent. The child process dumps the DB on disk and finally
exits. In theory the child should use as much memory as the parent being a
copy, but actually thanks to the copy-on-write semantic implemented by most
modern operating systems the parent and child process will _share_ the common
memory pages. A page will be duplicated only when it changes in the child or in
the parent. Since in theory all the pages may change while the child process is
saving, Linux can't tell in advance how much memory the child will take, so if
the `overcommit_memory` setting is set to zero fork will fail unless there is
as much free RAM as required to really duplicate all the parent memory pages,
with the result that if you have a KeyDB dataset of 3 GB and just 2 GB of free
memory it will fail.

Setting `overcommit_memory` to 1 tells Linux to relax and perform the fork in a
more optimistic allocation fashion, and this is indeed what you want for KeyDB.

A good source to understand how Linux Virtual Memory works and other
alternatives for `overcommit_memory` and `overcommit_ratio` is this classic
from Red Hat Magazine, ["Understanding Virtual Memory"][redhatvm].
Beware, this article had `1` and `2` configuration values for `overcommit_memory`
reversed: refer to the [proc(5)][proc5] man page for the right meaning of the
available values.

[redhatvm]: http://www.redhat.com/magazine/001nov04/features/vm/
[proc5]: http://man7.org/linux/man-pages/man5/proc.5.html

## Are KeyDB on-disk-snapshots atomic?

Yes, KeyDB background saving process is always forked when the server is
outside of the execution of a command, so every command reported to be atomic
in RAM is also atomic from the point of view of the disk snapshot.

## What is the maximum number of keys a single KeyDB instance can hold? and what the max number of elements in a Hash, List, Set, Sorted Set?

KeyDB can handle up to 2^32 keys, and was tested in practice to
handle at least 250 million keys per instance.

Every hash, list, set, and sorted set, can hold 2^32 elements.

In other words your limit is likely the available memory in your system.

## My slave claims to have a different number of keys compared to its master, why?

If you use keys with limited time to live (KeyDB expires) this is normal behavior. This is what happens:

* The master generates an RDB file on the first synchronization with the slave.
* The RDB file will not include keys already expired in the master, but that are still in memory.
* However these keys are still in the memory of the KeyDB master, even if logically expired. They'll not be considered as existing, but the memory will be reclaimed later, both incrementally and explicitly on access. However while these keys are not logical part of the dataset, they are advertised in `INFO` output and by the `DBSIZE` command.
* When the slave reads the RDB file generated by the master, this set of keys will not be loaded.

As a result of this, it is common for users with many keys with an expire set to see less keys in the slaves, because of this artifact, but there is no actual logical difference in the instances content.
