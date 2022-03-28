---
id: compatibility
title: Compatibility
sidebar_label: Compatibility
---

The topic of compatibility is important to understand the larger ecosystem that KeyDB is applicable to. Here we will discuss a few topics briefly, however this is covered in more detail throughout our docs. 

## Compatibility with Redis

KeyDB remains fully compatible with the Redis API, modules and protocol. This means if you are using Redis, you can drop KeyDB in place without any modifications required. This works the same way going back to Redis if you are using a common config, however if you are using features specific to KeyDB such as active-rep, subkey expires, or FLASH, these will not be supported if you migrate back to Redis.

## Parity with Redis

KeyDB works to maintain parity with features and updates in the upstream Redis codebase. In general we attempt to perform these upstream merges quarterly. Where possible KeyDB will push PRs back to Redis.

## Client Libraries

Because KeyDB maintains full compatibility with Redis, all clients that support Redis will also work with KeyDB. You can see a full list of [Redis Clients here.](https://redis.io/clients) For commands specific to KeyDB, these are often supported in custom call options of libraries.

For any KeyDB features that may not be supported by the library you are using we encourage you to request support, create a PR, or maintain your own fork (if permitted) to support KeyDB. For support that is added for KeyDB please let us know and we will explicitly reference it on our site pending review.
