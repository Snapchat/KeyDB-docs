---
id: pro-mvcc
title: MultiVersion Concurrency Control (MVCC)
sidebar_label: MVCC 
---

EQ Alpha Technology has decided to integrate MVCC into KeyDB-Pro. You may have heard the term MVCC tossed around by developers and may recognize terminology from databases such as PostgreSQL. The use of a powerful method such as MVCC brings tools to KeyDB that are not typical in a NoSQL database. It also works in tandem with KeyDB’s multithreaded architecture to provide advanced querying and transactions without the performance penalties expected with a database such as Redis. We believe that a database should allow as many requests to be processed simultaneously as possible.

## What is MVCC?

MultiVersion Concurrency Control as implied in the name enables us to allow concurrent access to a database. For example, when KeyDB needs to update certain data or perform transactions, it doesn’t overwrite the original data, but instead creates a newer version/snapshot of it. This way data being modified is only visible to the transaction that created it until it is committed. Until then other reads are looking at the snapshot prior to the uncommited changes. When the older snapshot is no longer being accessed it is automatically removed.

By maintaining several versions of the object, MVCC ensures a transaction never has to wait to read a database object making it non-blocking. This is hugely important for workloads that involve transactions, scripts, heavy queries, etc. which would typically be blocking operations with Redis. With MVCC the ability to have isolation with multiple snapshots enables great functionality such as rollbacks. This guarantees atomicity and helps ensure isolation.  

MVCC has much better concurrency than two-phase locking, which makes it much better to use in database systems.

## Why build MVCC into KeyDB? 

KeyDB has integral plans using MVCC with future features and uses that require such infrastructure.

KeyDB believes the user should only require one database where it is optimized right out of the box. You should not have to run external tools or other databases in tandem to compensate for existing database limitations. KeyDB looks to enable simplicity through its high performance. 

Transactions, lua scripts, data management are very important to many users to enable them to do whats needed with their database. There are a number of issues using these heavily including blocking operations that can slow down the entire database, backlog and potentially crash a server. To us, MVCC goes right along with the original intention of multithreading the application. We can now run more concurrent operations without slowing down. What this means is that the user can do a lot more, perform transactions, sscripts, advanced queries, without the fears associated performing such an action on Redis.

MVCC will allow us to perform transaction rollbacks. This is something providing a new level of freedom to the user where prescreening and perfection on the client end is not required. It also enables options to rollback when a user changes their mind (depending on setup). 

Redis cannot make these guarantees and relies on client side screening to prevent issues. If part of a transaction has made alterations, it cannot be undone if the transaction fails. “All or nothing… except if something happened in between”. 

KeyDB can offer rollbacks and atomicity guarantees you are used to seeing in a SQL database. 

## Wait Free and Lockless Algorithm

KeyDB uses a wait-free and lockless algorithm. What this means is that we can provide latency and system wide throughput guarantees with our concurrent operations. Lockless means that progress will be made regardless of if a thread is held up which can prevent slowdowns under different write scenarios. Wait-free with MVCC means that reads will not be held up and each thread will continue to make progress. Many blocking operations often feared and of grave concern running in production with Redis are no longer a concern with KeyDB. This infrastructure is setting up KeyDB to build powerful tools that can enable more complex operations offering better data management and analysis.

This adoptions is enabling the use of more threads ensuring KeyDB’s multithreading will continue to scale with complexity/heavy operations in addition to high IOPS.

## Forkless Background Saving

One feature made possible with MVCC is forkless background saving. This marginalizes the amount of free memory required when performing background saves.

Forkless background saving is really about Linux performance first and foremost. The issue with using fork() for snapshotting is write amplification, if you modify even one byte on a page all 4K needs to be duplicated. While the fork is occurring you must ensure there is sufficient memory available to accept all write operations (new and updated data). Inadequate memory can cause the process to fail. Time to write the rdb backup depends on the database size and can take a while as the size grows to many GB. Fork() time is related to the total dataset size. In contrast forkless background save has the same cost if your key is 1 byte or 500MB. This will become important as value sizes increase. Forkless background save will be both faster and use less memory. 

