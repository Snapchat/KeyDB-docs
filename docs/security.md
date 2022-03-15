---
id: security
title: Security
sidebar_label: Security
---

This document provides an introduction to the topic of security from the point of
view of KeyDB: the access control provided by KeyDB, code security concerns,
attacks that can be triggered from the outside by selecting malicious inputs and
other similar topics are covered.

For security related contacts please open an issue on GitHub.

KeyDB general security model
----

KeyDB is designed to be accessed by trusted clients inside trusted environments.
This means that usually it is not a good idea to expose the KeyDB instance
directly to the internet or, in general, to an environment where untrusted
clients can directly access the KeyDB TCP port or UNIX socket.

For instance, in the common context of a web application implemented using KeyDB
as a database, cache, or messaging system, the clients inside the front-end
(web side) of the application will query KeyDB to generate pages or
to perform operations requested or triggered by the web application user.

In this case, the web application mediates access between KeyDB and
untrusted clients (the user browsers accessing the web application).

This is a specific example, but, in general, untrusted access to KeyDB should
always be mediated by a layer implementing ACLs, validating user input,
and deciding what operations to perform against the KeyDB instance.

Network security
---

Access to the KeyDB port should be denied to everybody but trusted clients
in the network, so the servers running KeyDB should be directly accessible
only by the computers implementing the application using KeyDB.

In the common case of a single computer directly exposed to the internet, such
as a virtualized Linux instance (Linode, EC2, ...), the KeyDB port should be
firewalled to prevent access from the outside. Clients will still be able to
access KeyDB using the loopback interface.

Note that it is possible to bind KeyDB to a single interface by adding a line
like the following to the **keydb.conf** file:

    bind 127.0.0.1

Failing to protect the KeyDB port from the outside can have a big security
impact because of the nature of KeyDB. For instance, a single `FLUSHALL` command can be used by an external attacker to delete the whole data set.

Protected mode
---

Unfortunately many users fail to protect KeyDB instances from being accessed
from external networks. Many instances are simply left exposed on the
internet with public IPs. When KeyDB is
executed with the default configuration (binding all the interfaces) and
without any password in order to access it, it enters a special mode called
**protected mode**. In this mode KeyDB only replies to queries from the
loopback interfaces, and reply to other clients connecting from other
addresses with an error, explaining what is happening and how to configure
KeyDB properly.

We expect protected mode to seriously decrease the security issues caused
by unprotected KeyDB instances executed without proper administration, however
the system administrator can still ignore the error given by KeyDB and
just disable protected mode or manually bind all the interfaces.

Authentication feature
---

While KeyDB does not try to implement Access Control, it provides
a tiny layer of authentication that is optionally turned on editing the
**keydb.conf** file.

When the authorization layer is enabled, KeyDB will refuse any query by
unauthenticated clients. A client can authenticate itself by sending the
**AUTH** command followed by the password.

The password is set by the system administrator in clear text inside the
keydb.conf file. It should be long enough to prevent brute force attacks
for two reasons:

* KeyDB is very fast at serving queries. Many passwords per second can be tested by an external client.
* The KeyDB password is stored inside the **keydb.conf** file and inside the client configuration, so it does not need to be remembered by the system administrator, and thus it can be very long.

The goal of the authentication layer is to optionally provide a layer of
redundancy. If firewalling or any other system implemented to protect KeyDB
from external attackers fail, an external client will still not be able to
access the KeyDB instance without knowledge of the authentication password.

The AUTH command, like every other KeyDB command, is sent unencrypted, so it
does not protect against an attacker that has enough access to the network to
perform eavesdropping.

TLS support
---

KeyDB has optional support for TLS on all communication channels, including
client connections, replication links and the KeyDB Cluster bus protocol.

Disabling of specific commands
---

It is possible to disable commands in KeyDB or to rename them into an unguessable
name, so that normal clients are limited to a specified set of commands.

For instance, a virtualized server provider may offer a managed KeyDB instance
service. In this context, normal users should probably not be able to
call the KeyDB **CONFIG** command to alter the configuration of the instance,
but the systems that provide and remove instances should be able to do so.

In this case, it is possible to either rename or completely shadow commands from
the command table. This feature is available as a statement that can be used
inside the keydb.conf configuration file. For example:

    rename-command CONFIG b840fc02d524045429941cc15f59e41cb7be6c52

In the above example, the **CONFIG** command was renamed into an unguessable name.  It is also possible to completely disable it (or any other command) by renaming it to the empty string, like in the following example:

    rename-command CONFIG ""

Attacks triggered by carefully selected inputs from external clients
---

There is a class of attacks that an attacker can trigger from the outside even
without external access to the instance. An example of such attacks are
the ability to insert data into KeyDB that triggers pathological (worst case)
algorithm complexity on data structures implemented inside KeyDB internals.

For instance an attacker could supply, via a web form, a set of strings that
are known to hash to the same bucket into a hash table in order to turn the
O(1) expected time (the average time) to the O(N) worst case, consuming more
CPU than expected, and ultimately causing a Denial of Service.

To prevent this specific attack, KeyDB uses a per-execution pseudo-random
seed to the hash function.

KeyDB implements the SORT command using the qsort algorithm. Currently,
the algorithm is not randomized, so it is possible to trigger a quadratic
worst-case behavior by carefully selecting the right set of inputs.

String escaping and NoSQL injection
---

The KeyDB protocol has no concept of string escaping, so injection
is impossible under normal circumstances using a normal client library.
The protocol uses prefixed-length strings and is completely binary safe.

Lua scripts executed by the `EVAL` and `EVALSHA` commands follow the
same rules, and thus those commands are also safe.

While it would be a very strange use case, the application should avoid composing the body of the Lua script using strings obtained from untrusted sources.

Code security
---

In a classical KeyDB setup, clients are allowed full access to the command set,
but accessing the instance should never result in the ability to control the
system where KeyDB is running.

Internally, KeyDB uses all the well known practices for writing secure code, to
prevent buffer overflows, format bugs and other memory corruption issues.
However, the ability to control the server configuration using the **CONFIG**
command makes the client able to change the working dir of the program and
the name of the dump file. This allows clients to write RDB KeyDB files
at random paths, that is a security issue that may easily lead to the ability to compromise the system and/or run untrusted code as the same user as KeyDB is running.

KeyDB does not requires root privileges to run. It is recommended to
run it as an unprivileged *KeyDB* user that is only used for this purpose.
The KeyDB authors are currently investigating the possibility of adding a new
configuration parameter to prevent **CONFIG SET/GET dir** and other similar run-time configuration directives. This would prevent clients from forcing the server to write KeyDB dump files at arbitrary locations.
