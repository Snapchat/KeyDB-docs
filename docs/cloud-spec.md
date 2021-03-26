---
id: cloud-spec
title: KeyDB Cloud Specifications and Offering Details
sidebar_label: Cloud Spec Sheet
---


## Selecting Nodes and Sizes

When you create a KeyDB Cloud deployment, you will see several options and offerings. See the "getting-started" section for details on creating a deployment. This section defines the details of the machine offering selections. 

### Spec Chart

The chart below displays the different machine offerings:

You will see each offering type is in the format: (Offering Type) (GB Memory) x (Throughput). For more details on the spec see the section below.

| Offering                         | Size (GB Memory) | Ops/sec | Cores | KeyDB Type   |
|----------------------------------|------------------|---------|-------|--------------|
| HighOps 3GB x 175k Ops/sec       | 3                | 175000  | 1     | Enterprise   |
| HighOps 6GB x 275k Ops/sec       | 6                | 275000  | 2     | Enterprise   |
| HighOps 12GB x 425k Ops/sec      | 12               | 425000  | 4     | Enterprise   |
| HighOps 24GB x 600k Ops/sec      | 24               | 600000  | 8     | Enterprise   |
| HighOps 48GB x 1milllion Ops/sec | 48               | 1000000 | 16    | Enterprise   |

## Defining the Spec

### HighOps

The HighOps machine type/setup refers to an in-memory only database. KeyDB is set up to ensure you get the highest throughput and lowest latency. As KeyDB Cloud expands the offering to additional storage medium such as FLASH and PMEM, there will be additional types to select from. Offering machine sizes are selected to help maximize resource usage to ensure throughput. Increasing cluster size is recommended beyond the 48GB offering.

Right now the HighOps offering is available to provide maximum throughput and performance for the given resources. HighOps offerings are set up to launch in clusters. Any replica nodes can be used to direct read-only workloads to in addition to the master nodes.

### Dedicated Servers

Each KeyDB node is on a dedicated server. You are not sharing resources with other users and your node will have all the dedicated resources of the machine you are launched on. Machines do not share with replica nodes either, there is a dedicated server for each instance. This helps to ensure throughput and latency consistency. 

### Ops/Sec

The posted Ops/Sec is defined as the throughput seen when benchmarked with a Memtier standard workload. You can use this as a relative indicator. It is recommended that you test your own workload to determine the peak load you can achieve and understand when to increase cluster size. As you run a workload test you will be able to see the average ops/sec and latency of KeyDB. 

### GB

In the spec sheet the "GB" value refers to the maximum database size (dataset) you can have. This is not the memory of the machine itself, but the maxmemory policy setting after which you will no longer be able to write to (noeviction policy). We keep enough memory free on the machines for background saving, system operations, etc.

### Cores

This is the number of machine cores on your dedicated server. KeyDB is optimized to take advantage of the resources. With the HighOps offering types, the highest offering is the 16 core machine size as resources are more powerful sharding when the GB capacity is reached instead of allocating potentially unused resources. 

### KeyDB Type

Currently all our cloud offerings use the more powerful KeyDB Enterprise binaries. You will be able to take advantage of any enterprise features when you use KeyDB Cloud.
