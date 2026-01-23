---
id: about
title: About KeyDB
sidebar_label: About KeyDB
---

We believe performance ultimately provides freedom to users  – KeyDB is fast, provides high throughput out of the box and you don't need to be a database expert to use it. KeyDB does a lot more under the hood enabling you to focus on what counts.

> *If you had to move to a new house would you rather use a car or a 40ft truck? One method involves careful thought on what you bring and how to pack it in, the other you throw everything in without a second thought and go*

This is analogous to the database world when it comes to development. While some databases require sharding and several processes running for a basic setup, KeyDB focuses on extracting maximum performance out of each node. This means less moving parts, and for most workloads removes the need to shard or have sentinel nodes for monitoring. For really large workloads requiring sharding, KeyDB can scale horizontally and with less nodes to provide sub-millisecond latencies.

## Our Story

The KeyDB project began in 2019 after creating a multithreaded fork of Redis. We were baffled by the fact it was not fully optimized to take advantage of multiple server cores. We had to run a cluster of nodes on a single machine in order to achieve peak server throughput. The maintainers of Redis had strong convictions to maintain a simple codebase including a single threaded engine, and had turned down some great community requests as a result. While we loved Redis, we had a very different philosophy on how the codebase should evolve. We felt that ease of use, high performance, and a “batteries included” approach is the best way to create a good user experience, even if it adds complexity to the codebase. Because of this difference of opinion, features which are right for KeyDB may not be appropriate for Redis. We work hard to ensure compatibility with upstream Redis, while building out functionality in KeyDB that we think is necessary for users to succeed given the challenges of today.

When we introduced KeyDB’s multithreading and MVCC architecture, we had orders of magnitude increase in single node throughput. We have since continued to squeeze out every ounce of performance in the design of KeyDB to become a leader in performance. Our architecture has enabled us to design features, commands and configurations that provide powerful tools to users without performance penalties. Since KeyDB began we have added support for non-blocking queries, FLASH storage, subkey expires, and others. We will be supporting additional data structures, and configuration options as we continue to grow.

As KeyDB grew and we started to monetize we were always torn between what features to open source and which ones were needed to monetize and support the company's growth. In 2021 we were approached by Snap Inc. with the opportunity to bring KeyDB to a company that operates at a magnificent scale. At this time we discovered Snap wanted to open source everything to share and collaborate with the community while KeyDB continued to develop as a major part of the backend caching layer at Snap! At the end of 2021, KeyDB found its permanent home at Snap Inc.

## A Home at Snap

We were so excited to join the Snap team at the end of 2021. Not only would we get to work under the hood and power some of the largest workloads, but we would get to share **all** our advancements with the community (including what used to be our monetized offering)! Snap wanted to open source our entire codebase to collaborate and develop with the open source community. They understood that many hands are better than fewer, and a diversity of workloads and super talented community developers will help drive KeyDB to be the best product it can be. Maintaining only one community offering also meant that our team could focus on what we do best, writing high performance database code! 

Since our time here at Snap we were so happy to find that they really live by their [values](https://eng.snap.com/values) and we are excited to be working at such a great company. For anyone who is interested in joining the Snap team, they are hiring and we encourage you to [apply](https://careers.snap.com/?lang=en-US&utm_source=post&utm_medium=cta&utm_campaign=snap+eng).


## Our Team

KeyDB maintains a team of C++ developers (including all original developers) to continue building the open source project, and has also expanded to bring in Snap engineers who are highly experienced developing applications at scale. 


