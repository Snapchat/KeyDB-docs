---
id: enterprise-flash-sizing
title: "KeyDB on FLASH: Sizing and Hardware Configuration"
sidebar_label: FLASH Sizing & Config
---


## When to use KeyDB on FLASH

KeyDB on FLASH offers major cost savings, and can do so while maintaining very high performance. However it is important to find the right balance between RAM and FLASH, and also to understand the application of KeyDB on FLASH and how it relates to your use case.

NVMe SSDs are very fast, however they are still orders of magnitude slower than RAM and do have their limitations. By combining FLASH with RAM we are able to get the best of both worlds, serving hot data from RAM and storing cold data on FLASH.

For most use cases a LRU or LFU eviction strategy enables you to serve the majority of reads from RAM. This allows speeds to remain very high while enabling a large storage volume.

## Performance Expectations

The higher the RAM to flash ratio, the higher your ability to serve at faster speeds and volume. SSDs are limited by writes and have tiers of speed in which they will perform. Sustained heavy write operations will result in lower performance. It is also important not to exceed the amount of writes the disk can handle. If you size your machines correctly for your use case along with a good RAM to FLASH ratio, you will be able to take full advantage to maximize throughput while drastically lowering your memory consumption.

You can find more information on AWS NVMe SSD performance below. The AWS documentation does a good job explaining iops and performance of the hardware. Keep in mind the actual IOPS specific to your use case can be determined through testing.

R5: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/memory-optimized-instances.html

M5 and general: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/general-purpose-instances.html

If you have a lot of data and lower IOPS, FLASH is an easy choice and the ratio of FLASH to RAM can often be much higher. However if you have very high traffic & IOPS requiring very fast speeds, the sizing and horizontal scaling of your setup needs to be carefully selected.

## Selecting RAM, FLASH & Machine Size

Consider the following when selecting the amount of RAM for your machine:
* How much data is considered 'hot' at any given time. You definitely want to ensure you have enough memory available to minimize the ratio of disk reads required.
* We recommend allocating 50% of memory (maxmemory setting) towards data and up to 70% if you allocate a swap space similar in size. This allows space for system operations as well as up to 30% that may be allocated during BGSAVE during heavy write loads.
* We recommend not setting the maxmemory policy too low. Ideally this is at least a few GB. With cluster mode enabled this should be set at least 2G. In scenarios where you are running a smaller instance size it is not recommended to go less than 1G. There is overhead required for rocksdb as well as background saving and replica output buffers which makes it necessary to have a reasonable amount of flash.

Consider the following when selecting FLASH:
* IOPS. This is likely the most important factor as it relates to performance. Looking at the disk manufacturers settings. can give you a relative expectation of performance which can be validated under load tests. Often these numbers look at initial and disk cache performance. As the disk fills and under heavy sustained use, the values will often be much less than what is published.
* It is important to have an idea of your write loads and ensure you will not be exceeding the SSD IOPS available per machine. If the disk writes become overloaded this will drastically increase latency. Hence the time to horizontally scale your cluster will be more dependent on writes than anything else.
* Different machines provision different IOPS, and different disks do as well. It is important to take a look at what to expect.
* The total volume you expect to store. If your writes are acceptable for the machine you select, the total SSD volume will be whatever you expect your total volume requirement to be (up to Terabytes).

Consider your Backup Volumes:
* With AWS NMVe SSDs they can be detached if the machine is stopped thus are not considered a reliable persistent storage medium even though the data is persisted there upon a KeyDB failure. As such if you are using RDB saves you should ensure the root SSD volume or S3 bucket is at least 2.5x the size of your FLASH volume. This is because the old RDB is kept until the new one has finished which can use up to 2x the rdb size.

Consider the following when selecting machine size/type:
* Having more cores with KeyDB-Enterprise FLASH  helps to assist with handling concurrent reads/writes.
* Different machines have different provisioned IOPS. Check details and test to validate

## Determining Number of Cluster Nodes

If you have a lot of data and lower IOPS that do not exceed SSD limits, an active-replica or large single instance may work well.

However if you have heavier traffic or require considerable IOPS you will likely be running a cluster for the ability to scale IOPS horizontally.

The number of nodes you select will likely be reflected by the write operations you expect. Based on the machine type and SSD type, you can determine what is an ideal setup and scale horizontally from there.

It is best to predict the machine size/type you would like to use and then test it to ensure it meets your needs. It is then easy to scale out/shard from there.

## FLASH Configuration

### KeyDB Settings

* **maxmemory:** this setting dictates the amount of RAM allocated to KeyDB. Once set, your RAM usage for KeyDB will not exceed this. However during a BGSAVE if there is incoming traffic, this amount will increase up to 30%. RAM can also be used for replica output buffers with the eviction strategies used here. We recommend setting maxmemory to 50% of available RAM (default). However if you increase swap space to the equivalent of RAM you can increase maxmemory up to 70%.  If increased higher you increase risk of slowdowns upon entering swap space. Also keep in mind system memory being used and memory that may be consumed by other applications, especially if you are running on a shared server.
* **maxmemory-policy:** typically an `allkeys-lru` (least recently used) or an `allkeys-lfu` (least frequently used) policy is set. It works well to ensure a working 'hot' set of data remains in memory. [Other policies](https://docs.keydb.dev/docs/lru-cache/#eviction-policies) can be used as well.
* **maxmemory-samples:** This is the number of samples to select from when evicting. Default is 16 which is a good number for most use cases with FLASH. If required this can be increased (log warnings)


### SSD Setup

We recommend an ext4 filesystem with the following mount settings: ``
```
defaults,noiversion,auto_da_alloc,noatime,errors=remount-ro,delalloc,barrier=0,nofail
```
If there are more than one SSD being used consider setting them up in a RAID array.

If you are using AWS you will have to remount to your NVME volume on boot via fstab typicaly using UUIDs. If you want an AWS image with FLASH automatically set up, use the [KeyDB AMI](https://aws.amazon.com/marketplace/pp/B086WNHBGJ). Follow the instructions [here](https://docs.keydb.dev/docs/ami/) to have flash automatically configured.

## Monitoring

You can use common linux tools such as top, htop, iotop, df, etc to monitor RAM and SSD usage for the overall system

You can also gain specific insight through the KeyDB INFO command. Here you can see the memory used as well as the FLASH volume used.
```
keydb-cli>  INFO memory
keydb-cli>  DBSIZE
```

## Benchmarking

For most use cases relying on the ability to store and serve hot data in addition to FLASH storage, it is recommended to use a Gaussian distribution pattern with memtier, or workload "d" if using YCSB benchmarking tool.

**A note about testing:** Keep in mind that memtier has the tendency to want to push the SSD writes past its limitations. This can result in excessive latency during testing. You may notice fluctuations with disk writes as data is compacted and moved around (while near limit). Hence if you encounter scenarios where this is occurring you may want to reduce the write ratio, or reduce the number of clients/threads being used. Once you have an idea of the write limit you can test with a smaller load to get a realistic idea of the latencies associated.
Tools such as YCSB are great for performing specified loads and then measuring the latency.

If you expect a majority of hits for your requests, consider preloading the database prior to testing. Also to ensure that not all data is kept in memory. You can predict the amount of data you are storing by multiplying the requests by the data-size. As you put in more data than your maxmemory setting allows for, the additional data will be held exclusively in FLASH storage. You can probe the info command to see how much data is stored in FLASH.

Memtier parameters of note for this test: (see `memtier_benchmark --help` for all parameters)
* -n, --requests=NUMBER : The number of requests per client
* --ratio=RATIO : the set to get ratio. If loading you can perform all writes ie. 1:0. During testing you will want a representative ratio such as 1:10 or 1:20
* -d  --data-size=SIZE : Specify the data size. This can help understanding specific benchmark tests and in predicting database size
* --data-size-range=RANGE : you can use this for a varying data size to help represent a more accurate workload
* --key-pattern=PATTERN : For loading you will want a P:P pattern, and for testing you will likely want a G:G pattern. P=parallel where each client has a set amount of key range so they are not duplicating writes. G=Gaussian distribution pattern representative of most workloads. If you use R=random pattern this will end up reading mostly from disk and will be slower, but may be applicable for the use cases that likely will not be reading much from the hot data set.
* --cluster-mode : this setting is required if you are running keydb in cluster mode enabled.

If you are sized correctly for write IOPS and not exceeding what KeyDB can do, when reading mostly from the hot tier, performance should remain quite fast while allowing for a large DB size as can be seen in [this blog post](https://docs.keydb.dev/blog/2020/01/05/blog-post/)

Currently KeyDB consolidates client connections at 50 for the first thread and so on to help reduce latency for most use cases. If you would like to ensure more threads are used with keydb during your workload with 50 or less client connections, you can specify the KeyDB config file option `--min-clients-per-thread 0`

An example Memtier command to fill your database with 20 million keys of size 1024 might be
```
memtier_benchmark -s 127.0.0.1 -p 6379 --requests=20000000 --data-size=1024 --key-pattern=P:P --ratio=1:0 --clients=4 --threads=4
```
To test a common workload using a Gaussian pattern:
```
memtier_benchmark  -s 127.0.0.1 -p 6379 --key-pattern=G:G --ratio=1:20 --data-size-range=32-1024
```

As you test you can tune parameters to reflect your anticipated loading.

### Testing specific commands

You can test specific commands with memtier using the --command flag. However memtier does not like this in cluster mode so will have to be done on a single instance. You can run several commands and specify the ratio, pattern, and with autogenerated keys and values. See memtier_benchmark --help for more information.

Example: Create and read from a hash. Set a limited range of key IDs and a much larger number of requests to ensure the number of key-value pairs in the hash grow.

```
memtier_benchmark -s 127.0.0.1 -p 6379 \
        --command="hset __key__ __key__ __data__" --command="hget __key__ __key__" \
        --command-ratio=1 --command-key-pattern=G \
        --key-prefix=key --key-minimum=1 --key-maximum=10000 \
        --data-size-range=32-1024  --requests=1000000
```
The __key__ and __data__ values are generated by memtier. Different combinations can be experimented with if needed to test your workload. Keep in mind this will likely need to be performed with specific key prefixes to ensure you are not using incorrect commands on existing data types.
