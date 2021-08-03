---
id: active-rep
title: Active Replica Setup
sidebar_label: Active Replication
---

## Set up Your Replica Node to Easily Accept Reads & Writes

KeyDB now has support for active replicas (Also known as "Active Active").  This greatly simplifies fail-over scenarios as replicas no longer need to be promoted to active masters.  In addition, “Active Replica” support can be used to distribute load in high write scenarios.

## How it Works ##

By default, KeyDB acts as Redis does and only allows one-way communication from the master to the replica.  A new configuration option “active-replica” has been added and when set to true also implies “replica-read-only no”.  Under this mode KeyDB will accept replicas even if its connection to the master is severed.  It will also allow circular connections where two nodes are the master of each other.

## Split Brain ##

KeyDB can handle split brain scenarios where the connection between masters is severed, but writes continue to be made.  Each write is timestamped and when the connection is restored each master will share their new data.  The newest write will win.  This prevents stale data from overwriting new data written after the connection was severed.

## Steps to Enable ##

The following steps assume two servers, A and B.

1. Both servers must have "active-replica yes" in their respective configuration files
2. On server B execute the command "replicaof [A address] [A port]"
    Server B will drop its database and load server A's dataset
3. On server A execute the command "replicaof [B address] [B port]"
    Server A will drop its database and load server B's dataset (including the data it just transferred in the prior step)
4. Both servers will now propagate writes to each other.  You can test this by writing to a key on Server A and ensuring it is visible on B and vice versa.

See our demo on YouTube:

<iframe width="560" height="315" src="https://www.youtube.com/embed/2QOICUsBEls?start=12" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Technical Implementation ##

On boot each KeyDB instance will compute a dynamic UUID.  This UUID is not saved and exists only for the life of the process.  When a replica connects to its master it will inform the master of its UUID and the master will reply with its own.  The UUIDs are compared to inform the server if two clients are from the same KeyDB instance (IPs and ports are insufficient as there may be different processes on the same machine).  The UUIDs are used to prevent rebroadcasting changes to the master that sent them if it is also our replica.

A new configuration option is added to enable this mode, and when enabled also makes KeyDB writable even if it is a replica (by default this is disabled).  Except for extra logic to prevent infinitely bouncing queries between clients in a loop the replication code executes as it normally would.

The majority of Active Replica was implemented in [this change](https://github.com/EQ-Alpha/KeyDB/commit/a7aa2b074049a130761bc0a98d47130b6a0ff817)

## Setting up Active-Replication

Active Replica nodes allow you to read and write to both instances which can increase reads under high load, and have your backup/replica node ready to go in a failure scenario. Setup is as simple as setting up your proxy server to point to the healthy instance. Take a look at the HAProxy section for example configurations that can enable health checks, and different routing configurations (round-robin, first, etc)
Setting up you proxy server is simple, and the keydb configuration is even simpler as described earlier. An example config file:

## Config File

Instance-A config file:

```
# assuming below parameters were set and IP address of this instance is 10.0.0.2
port 6379
requirepass mypassword123
masterauth mypassword123
# you will need to configure the following
active-replica yes
replicaof 10.0.0.3 6379
```

Instance-B config file:

```
# assuming below parameters were set and IP address of this instance is 10.0.0.3
port 6379
requirepass mypassword123
masterauth mypassword123
# you will need to configure the following
active-replica yes
replicaof 10.0.0.2 6379
```

You can also append to config file `keydb-server --active-replica yes --replicaof <ipaddress> <port>`

## Testing Active-Replica

Any commands you write to one node will be seen on the other node. If a server goes down, the timestamping will ensure your replica will not overwrite newer writes when it is brought back online. This enables you to set up scripts, cron, etc to automatically reboot failed instances if desired without the risk of overwriting new data. Under extremely high loading there may be mild latency but still very low in data syncing (almost negligible). 
