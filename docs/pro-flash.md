---
id: pro-flash          
title: KeyDB Pro on FLASH - Enhanced FLASH
sidebar_label: Enhanced FLASH
---

<div id="blog_body">

## Enhanced FLASH

Enhanced FLASH offered with KeyDB Pro is architected much differently than our open source legacy FLASH. It does not require any special file system and is built on RocksDB. Enhanced FLASH is much faster than legacy FLASH and is also persistent to the storage medium it is written to.

Enhanced FLASH enables you to expand memory capacity greatly without a huge compromise on performance. Best of all your data persists to the FLASH memory as it is written eliminating the need for AOF/RDB files. KeyDB on FLASH is great for applications where memory is limited or too costly for the application. It is also a great option for databases that often near or exceed their maxmemory limit. 

This document discusses how Enhanced FLASH works and how it can be used.

## How it works:

With the FLASH option enabled all data is written to FLASH where it persists, with hot data remaining in memory as well as FLASH. Typically when you run out of memory for your database you set up an eviction policy to start deleting keys. With KeyDB on FLASH this data is evicted from memory but not FLASH and is still accessible.

With KeyDB on FLASH everything sent to the database is persisted to FLASH similar to AOF fysync everysec option. If you require a fsync always option it is recommended setting up AOF options and setting to fsync always. RDB files are also not necessary, however are required for creating and syncing replica instances or when updating KeyDB or migrating data.

### Flash storage essentially works in two ways:

* Cache mode for smaller values: Smaller values that are accessed infrequently are kept in FLASH until needed.  KeyDB will maintain the most commonly used values in RAM for quicker access.  This caching happens transparently.
* BLOB mode for larger values and streams: Larger values are automatically detected and treated as Binary Large Object.  These objects are kept in flash and streamed directly to clients as necessary using fast sequential access.  This provides great performance while ensuring that these large objects do not adversely impact objects already in the cache. The BLOB threshold is fully configurable so you can make the right trade-off for your application.  

## When to use KeyDB on FLASH:

This really depends on your setup, traffic demands/patterns, and latency requirements. Obviously keeping all your data in memory at all times will be the fastest option. However most use cases have a subset of data accessed far more than the rest. Keeping this data as hot data in memory with the rest of the data remaining on FLASH enables a good balance of performance, while minimizing server requirements.

For those wanting additional capacity, cheaper capacity, or backup overflow from DRAM, FLASH is a great solution.

It is best using a FLASH storage medium when closest to the CPU. If you are using AWS instances I3 instances are great for FLASH options because it is attached storage vs something like an EBS volume. Instances with ‘d’ specifier typically include FLASH with the instance (ie. m5d.xlarge). If you are adding FLASH to your instance it is always good to benchmark ensuring an ideal setup. We will be publishing an article shortly comparing different FLASH setups and their relative perf stats.

## Using KeyDB on FLASH - Quick setup: 

Enable keydb professional, specify storage medium, and configure maxmemory and eviction policy. For example:
``` 
keydb-server --enable-pro [license-key] --storage-provider  flash  [path-to-flash-storage] --maxmemory [max-memory-for-DRAM… ie. 500mb or 1G] --maxmemory-policy allkeys-lru
```

## Docker Quick Setup

```
sudo docker run -d -it --name mycontainername --mount type=bind,dst=/flash,src=/path/to/flash/ eqalpha/keydb keydb-server --enable-pro --storage-provider flash /flash --maxmemory [maxmemory-amount-ie. 500M] --maxmemory-policy [eviction-policy ie. allkeys-lfu]
```

## Using KeyDB on FLASH - Detailed Setup:

### Mount FLASH Volume

If you are unsure of how to set up your volume, take a look at <a href="https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux"><span style="color:red"> this article </span></a>this article by digitalocean on how to do it. Once complete, you will point to the directory you want KeyDB Pro to write to for FLASH

### Specify in Configuration

Once your volume is set up, you can specify the location of the directory you would like KeyDB to write to with the parameter: `--storage-provider flash [location]`. 
•	‘flash’ specifies the storage medium to be used (there will be multiple types available in the future)
•	[location] is the directory mentioned above where KeyDB FLASH will write to

### Configure maxmemory

This determines the memory amount allocated to KeyDB for DRAM usage. This prevents using up all the memory and once exceeded will either return errors to the client or if an eviction policy is set will start removing data in a specified fashion. As such maxmemory is often set conservatively and depending on how you values your data.

With KeyDB on FLASH you can set maxmemory to the amount of DRAM you want allocated without the fear of losing data when exceeded. Instead the data is removed from DRAM but remains in FLASH where it is not lost and can still be served.

Set maxmemory to the maximum amount you are willing to allocate towards KeyDB on the server and let FLASH deal with the rest.

Set maxmemory with the directive `--maxmemory [max-memory-amount]`. The default is in bytes, however you can specify mb, M, G, etc to avoid typing out bytes. Ie. `--maxmemory 3G`

### Set Eviction Policy

For more on setting the maxmemory and eviction policies check out <a href="https://docs.keydb.dev/docs/lru-cache/"><span style="color:red"> this document </span></a>. However keep in mind, the data is not removed with KeyDB Pro on FLASH, it is just removed from DRAM but still available in FLASH.

To excerpt the document:

The exact behavior KeyDB follows when the maxmemory limit is reached is configured using the maxmemory-policy configuration directive.

The following policies are available:
* noeviction: return errors when the memory limit was reached and the client is trying to execute commands that could result in more memory to be used (most write commands, but DEL and a few more exceptions).
* allkeys-lru: evict keys by trying to remove the less recently used (LRU) keys first, in order to make space for the new data added.
* volatile-lru: evict keys by trying to remove the less recently used (LRU) keys first, but only among keys that have an expire set, in order to make space for the new data added.
* allkeys-random: evict keys randomly in order to make space for the new data added.
* volatile-random: evict keys randomly in order to make space for the new data added, but only evict keys with an expire set.
* volatile-ttl: evict keys with an expire set, and try to evict keys with a shorter time to live (TTL) first, in order to make space for the new data added.

The policies volatile-lru, volatile-random and volatile-ttl behave like noeviction if there are no keys to evict matching the prerequisites.

It is recommended to use a policy such as ‘allkeys-lru’ or ‘allkeys-lfu’ to ensure you never run out of memory and data can always be moved to FLASH storage. These directives work best for most scenarios using FLASH.

Specify with `--maxmemory-policy allkeys-lfu`

</div>
