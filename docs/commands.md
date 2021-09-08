---
id: commands
title: KeyDB Commands
sidebar_label: Commands
---

## APPEND

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```APPEND <key> <value>```

#### Description: 

If `key` already exists and is a string, this command appends the `value` at the end of the string. If `key` 
does not exist it is created and set as an empty string, so `APPEND` will be similar to `SET` in this special 
case.

#### Return:

Integer Reply: the length of the string after the append operation.

#### Examples:

```
keydb-cli> EXISTS mykey
(integer) 0
keydb-cli> APPEND mykey "Hello"
(integer) 5
keydb-cli> APPEND mykey "World"
(integer) 10
keydb-cli> GET mykey
"helloworld"
```

#### Pattern: Time series

The `APPEND` command can be used to create a very compact representation of a
list of fixed-size samples, usually referred as _time series_.
Every time a new sample arrives we can store it using the command

```
APPEND timeseries "fixed-size sample"
```

Accessing individual elements in the time series is not hard:

* `STRLEN` can be used in order to obtain the number of samples.
* `GETRANGE` allows for random access of elements.
  If our time series have associated time information we can easily implement
  a binary search to get range combining `GETRANGE` with the Lua scripting
  engine
* `SETRANGE` can be used to overwrite an existing time series.

The limitation of this pattern is that we are forced into an append-only mode
of operation, there is no way to cut the time series to a given size easily
because KeyDB currently lacks a command able to trim string objects.
However the space efficiency of time series stored in this way is remarkable.

Hint: it is possible to switch to a different key based on the current Unix
time, in this way it is possible to have just a relatively small amount of
samples per key, to avoid dealing with very big keys, and to make this pattern
more friendly to be distributed across many KeyDB instances.

An example sampling the temperature of a sensor using fixed-size strings (using
a binary format is better in real implementations).

```
keydb-cli> APPEND ts "0043"
(integer) 4
keydb-cli> APPEND ts "0035"
(integer) 8
keydb-cli> GETRANGE ts 0 3
"0043"
keydb-cli> GETRANGE ts 4 7
"0035"
```
---

## AUTH

**Related Commands:** [AUTH](/docs/commands/#append), [ECHO](/docs/commands/#echo), [PING](/docs/commands/#ping), [QUIT](/docs/commands/#quit), [SELECT](/docs/commands/#select), [SWAPDB](/docs/commands/#swapdb)

#### Syntax:

```AUTH <password>```

```AUTH <username> <password>```

#### Description:

Request for authentication in a password-protected KeyDB server.
KeyDB can be instructed to require a password before allowing clients to execute
commands.
This is done using the `requirepass` directive in the configuration file.

If `password` matches the password in the configuration file, the server replies
with the `OK` status code and starts accepting commands.
Otherwise, an error is returned and the clients needs to try a new password.

**TIP**: because of the high performance nature of KeyDB, it is possible to try
a lot of passwords in parallel in very short time, so make sure to generate a
strong and very long password so that this attack is infeasible.

#### Return:

Simple String Reply

---

## BGSAVE

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

#### Syntax:

```BGSAVE```

```BGSAVE SCHEDULE```

#### Description: 

Save the DB in background.
The OK code is immediately returned.
KeyDB forks, the parent continues to serve the clients, the child saves the DB
on disk then exits.
A client may be able to check if the operation succeeded using the `LASTSAVE`
command.

Please refer to the [persistence documentation](https://docs.keydb.dev/docs/persistence/) for detailed information.

---

## BGREWRITEAOF

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

#### Syntax: 

```BGREWRITEAOF```

#### Description:

Instruct KeyB to start an [Append Only File](https://docs.keydb.dev/docs/persistence/) rewrite process.
The rewrite will create a small optimized version of the current Append Only
File.

If `BGREWRITEAOF` fails, no data gets lost as the old AOF will be untouched.

The rewrite will be only triggered by KeyDB if there is not already a background
process doing persistence.
Specifically:

* If a KeyDB child is creating a snapshot on disk, the AOF rewrite is
  _scheduled_ but not started until the saving child producing the RDB file
  terminates.
  In this case the `BGREWRITEAOF` will still return an OK code, but with an
  appropriate message.
  You can check if an AOF rewrite is scheduled looking at the `INFO` command.
* If an AOF rewrite is already in progress the command returns an error and no
  AOF rewrite will be scheduled for a later time.

Since KeyDB 2.4 the AOF rewrite is automatically triggered by KeyDB, however the
`BGREWRITEAOF` command can be used to trigger a rewrite at any time.

Please refer to the [persistence documentation](https://docs.keydb.dev/docs/persistence/) for detailed information.

#### Return:

Simple String Reply: always `OK`.

---



## BITCOUNT

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```BITCOUNT <key> ```

```BITCOUNT <key> <start> <end>```

#### Description:

Count the number of set bits (population counting) in a string.

By default all the bytes contained in the string are examined.
It is possible to specify the counting operation only in an interval passing the
additional arguments _start_ and _end_.

Like for the `GETRANGE` command start and end can contain negative values in
order to index bytes starting from the end of the string, where -1 is the last
byte, -2 is the penultimate, and so forth.

Non-existent keys are treated as empty strings, so the command will return zero.

#### Return:

Integer Reply

The number of bits set to 1.

#### Examples:

```
keydb-cli> SET mykey "foobar"
OK
keydb-cli> BITCOUNT mykey
(integer) 26
keydb-cli> BITCOUNT mykey 0 0
(integer) 4
keydb-cli> BITCOUNT mykey 1 1
(integer) 6
```

#### Pattern: real-time metrics using bitmaps

Bitmaps are a very space-efficient representation of certain kinds of
information.
One example is a Web application that needs the history of user visits, so that
for instance it is possible to determine what users are good targets of beta
features.

Using the `SETBIT` command this is trivial to accomplish, identifying every day
with a small progressive integer.
For instance day 0 is the first day the application was put online, day 1 the
next day, and so forth.

Every time a user performs a page view, the application can register that in
the current day the user visited the web site using the `SETBIT` command setting
the bit corresponding to the current day.

Later it will be trivial to know the number of single days the user visited the
web site simply calling the `BITCOUNT` command against the bitmap.


#### Performance considerations

In the above example of counting days, even after 10 years the application is
online we still have just `365*10` bits of data per user, that is just 456 bytes
per user.
With this amount of data `BITCOUNT` is still as fast as any other O(1) KeyDB
command like `GET` or `INCR`.

When the bitmap is big, there are two alternatives:

* Taking a separated key that is incremented every time the bitmap is modified.
  This can be very efficient and atomic using a small KeyDB Lua script.
* Running the bitmap incrementally using the `BITCOUNT` _start_ and _end_
  optional parameters, accumulating the results client-side, and optionally
  caching the result into a key.

---


## BITFIELD

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

The command treats a KeyDB string as a array of bits, and is capable of addressing specific integer fields of varying bit widths and arbitrary non (necessary) aligned offset. In practical terms using this command you can set, for example, a signed 5 bits integer at bit offset 1234 to a specific value, retrieve a 31 bit unsigned integer from offset 4567. Similarly the command handles increments and decrements of the specified integers, providing guaranteed and well specified overflow and underflow behavior that the user can configure.

`BITFIELD` is able to operate with multiple bit fields in the same command call. It takes a list of operations to perform, and returns an array of replies, where each array matches the corresponding operation in the list of arguments.

For example the following command increments an 8 bit signed integer at bit offset 100, and gets the value of the 4 bit unsigned integer at bit offset 0:

    > BITFIELD mykey INCRBY i5 100 1 GET u4 0
    1) (integer) 1
    2) (integer) 0

Note that:

1. Addressing with `GET` bits outside the current string length (including the case the key does not exist at all), results in the operation to be performed like the missing part all consists of bits set to 0.
2. Addressing with `SET` or `INCRBY` bits outside the current string length will enlarge the string, zero-padding it, as needed, for the minimal length needed, according to the most far bit touched.

#### Supported subcommands and integer types

The following is the list of supported commands.

* **GET** `<type>` `<offset>` -- Returns the specified bit field.
* **SET** `<type>` `<offset>` `<value>` -- Set the specified bit field and returns its old value.
* **INCRBY** `<type>` `<offset>` `<increment>` -- Increments or decrements (if a negative increment is given) the specified bit field and returns the new value.

There is another subcommand that only changes the behavior of successive
`INCRBY` subcommand calls by setting the overflow behavior:

* **OVERFLOW** `[WRAP|SAT|FAIL]`

Where an integer type is expected, it can be composed by prefixing with `i` for signed integers and `u` for unsigned integers with the number of bits of our integer type. So for example `u8` is an unsigned integer of 8 bits and `i16` is a
signed integer of 16 bits.

The supported types are up to 64 bits for signed integers, and up to 63 bits for
unsigned integers. This limitation with unsigned integers is due to the fact
that currently the KeyDB protocol is unable to return 64 bit unsigned integers
as replies.

#### Bits and positional offsets

There are two ways in order to specify offsets in the bitfield command.
If a number without any prefix is specified, it is used just as a zero based
bit offset inside the string.

However if the offset is prefixed with a `#` character, the specified offset
is multiplied by the integer type width, so for example:

    BITFIELD mystring SET i8 #0 100 i8 #1 200

Will set the first i8 integer at offset 0 and the second at offset 8.
This way you don't have to do the math yourself inside your client if what
you want is a plain array of integers of a given size.

#### Overflow control

Using the `OVERFLOW` command the user is able to fine-tune the behavior of
the increment or decrement overflow (or underflow) by specifying one of
the following behaviors:

* **WRAP**: wrap around, both with signed and unsigned integers. In the case of unsigned integers, wrapping is like performing the operation modulo the maximum value the integer can contain (the C standard behavior). With signed integers instead wrapping means that overflows restart towards the most negative value and underflows towards the most positive ones, so for example if an `i8` integer is set to the value 127, incrementing it by 1 will yield `-128`.
* **SAT**: uses saturation arithmetic, that is, on underflows the value is set to the minimum integer value, and on overflows to the maximum integer value. For example incrementing an `i8` integer starting from value 120 with an increment of 10, will result into the value 127, and further increments will always keep the value at 127. The same happens on underflows, but towards the value is blocked at the most negative value.
* **FAIL**: in this mode no operation is performed on overflows or underflows detected. The corresponding return value is set to NULL to signal the condition to the caller.

Note that each `OVERFLOW` statement only affects the `INCRBY` commands
that follow it in the list of subcommands, up to the next `OVERFLOW`
statement.

By default, **WRAP** is used if not otherwise specified.

    > BITFIELD mykey incrby u2 100 1 OVERFLOW SAT incrby u2 102 1
    1) (integer) 1
    2) (integer) 1
    > BITFIELD mykey incrby u2 100 1 OVERFLOW SAT incrby u2 102 1
    1) (integer) 2
    2) (integer) 2
    > BITFIELD mykey incrby u2 100 1 OVERFLOW SAT incrby u2 102 1
    1) (integer) 3
    2) (integer) 3
    > BITFIELD mykey incrby u2 100 1 OVERFLOW SAT incrby u2 102 1
    1) (integer) 0
    2) (integer) 3

#### Return value

The command returns an array with each entry being the corresponding result of
the sub command given at the same position. `OVERFLOW` subcommands don't count
as generating a reply.

The following is an example of `OVERFLOW FAIL` returning NULL.

    > BITFIELD mykey OVERFLOW FAIL incrby u2 102 1
    1) (nil)

#### Motivations

The motivation for this command is that the ability to store many small integers
as a single large bitmap (or segmented over a few keys to avoid having huge keys) is extremely memory efficient, and opens new use cases for KeyDB to be applied, especially in the field of real time analytics. This use cases are supported by the ability to specify the overflow in a controlled way.

#### Performance considerations

Usually `BITFIELD` is a fast command, however note that addressing far bits of currently short strings will trigger an allocation that may be more costly than executing the command on bits already existing.

#### Orders of bits

The representation used by `BITFIELD` considers the bitmap as having the
bit number 0 to be the most significant bit of the first byte, and so forth, so
for example setting a 5 bits unsigned integer to value 23 at offset 7 into a
bitmap previously set to all zeroes, will produce the following representation:

    +--------+--------+
    |00000001|01110000|
    +--------+--------+

When offsets and integer sizes are aligned to bytes boundaries, this is the
same as big endian, however when such alignment does not exist, its important
to also understand how the bits inside a byte are ordered.

---


## BITOP

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

Perform a bitwise operation between multiple keys (containing string values) and
store the result in the destination key.

The `BITOP` command supports six bitwise operations: **AND**, **OR**, **XOR**, **NOT**, **LSHIFT** and **RSHIFT** 
thus the valid forms to call the command are:


* `BITOP AND destkey srckey1 srckey2 srckey3 ... srckeyN`
* `BITOP OR  destkey srckey1 srckey2 srckey3 ... srckeyN`
* `BITOP XOR destkey srckey1 srckey2 srckey3 ... srckeyN`
* `BITOP NOT destkey srckey`
* `BITOP LSHIFT destkey srckey integer`
* `BITOP RSHIFT destkey srckey integer`

As you can see **NOT** only takes an input key, because it
performs inversion of bits so it only makes sense as an unary operator.

**LSHIFT** and **RSHIFT** are also performed on only one key and will perform a bitwise shift left or right by the specified interger value. 
It is important to note that these functions assume little endian format. 

The result of the operation is always stored at `destkey`.

#### Handling of strings with different lengths

When an operation is performed between strings having different lengths, all the
strings shorter than the longest string in the set are treated as if they were
zero-padded up to the length of the longest string.

The same holds true for non-existent keys, that are considered as a stream of
zero bytes up to the length of the longest string.

#### Return:

Integer Reply

The size of the string stored in the destination key, that is equal to the
size of the longest input string.

#### Examples:

```
keydb-cli> SET key1 foobar
OK
keydb-cli> SET key2 abcdef
OK
keydb-cli> BITOP AND dest key1 key2
(integer) 6
keydb-cli> GET dest
"`bc`ab"
keydb-cli> BITOP LSHIFT newdest dest 1
(integer) 7
keydb-cli> GET newdest
"\xc0\xc4\xc6\xc0\xc2\xc4\x00"
keydb-cli> BITOP XOR dest key1 key2
(integer) 6
keydb-cli> GET dest
"\a\r\x0c\x06\x04\x14"
```

#### Pattern: real time metrics using bitmaps

`BITOP` is a good complement to the pattern documented in the `BITCOUNT` command
documentation.
Different bitmaps can be combined in order to obtain a target bitmap where
the population counting operation is performed.


#### Performance considerations

`BITOP` is a potentially slow command as it runs in O(N) time.
Care should be taken when running it against long input strings.

For real-time metrics and statistics involving large inputs a good approach is to use a replica (with read-only option disabled) where the bit-wise operations are performed to avoid blocking the master instance.

---



## BITPOS

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen)

#### Syntax:

```BITPOS <key>```

```BITPOS <key> <start>```

```BITPOS <key> <start> <end>```

#### Description:

Return the position of the first bit set to 1 or 0 in a string.

The position is returned, thinking of the string as an array of bits from left to
right, where the first byte's most significant bit is at position 0, the second
byte's most significant bit is at position 8, and so forth.

The same bit position convention is followed by `GETBIT` and `SETBIT`.

By default, all the bytes contained in the string are examined.
It is possible to look for bits only in a specified interval passing the additional arguments _start_ and _end_ (it is possible to just pass _start_, the operation will assume that the end is the last byte of the string. However there are semantic differences as explained later). The range is interpreted as a range of bytes and not a range of bits, so `start=0` and `end=2` means to look at the first three bytes.

Note that bit positions are returned always as absolute values starting from bit zero even when _start_ and _end_ are used to specify a range.

Like for the `GETRANGE` command start and end can contain negative values in
order to index bytes starting from the end of the string, where -1 is the last
byte, -2 is the penultimate, and so forth.

Non-existent keys are treated as empty strings.

#### Return:

Integer Reply

The command returns the position of the first bit set to 1 or 0 according to the request.

If we look for set bits (the bit argument is 1) and the string is empty or composed of just zero bytes, -1 is returned.

If we look for clear bits (the bit argument is 0) and the string only contains bit set to 1, the function returns the first bit not part of the string on the right. So if the string is three bytes set to the value `0xff` the command `BITPOS key 0` will return 24, since up to bit 23 all the bits are 1.

Basically, the function considers the right of the string as padded with zeros if you look for clear bits and specify no range or the _start_ argument **only**.

However, this behavior changes if you are looking for clear bits and specify a range with both __start__ and __end__. If no clear bit is found in the specified range, the function returns -1 as the user specified a clear range and there are no 0 bits in that range.

#### Examples:

```
keydb-cli> SET mykey "\xff\xf0\x00"
OK
keydb-cli> BITPOS mykey 0
(integer) 12
keydb-cli> SET mykey "\x00\xff\xf0"
OK
keydb-cli> BITPOS mykey 1 0
(integer) 8
keydb-cli> BITPOS mykey 1 2
(integer) 16
keydb-cli> SET mykey "\x00\x00\x00"
OK
keydb-cli> BITPOS mykey 1
(integer) -1
```
---



## BLPOP

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax: 

```BLPOP <key> <timeout>```

```BLPOP <key> <key-2> ... <key-n> <timeout>```

#### Description:


`BLPOP` is a blocking list pop primitive.
It is the blocking version of `LPOP` because it blocks the connection when there
are no elements to pop from any of the given lists.
An element is popped from the head of the first list that is non-empty, with the
given keys being checked in the order that they are given.

#### Non-blocking behavior

When `BLPOP` is called, if at least one of the specified keys contains a
non-empty list, an element is popped from the head of the list and returned to
the caller together with the `key` it was popped from.

Keys are checked in the order that they are given.
Let's say that the key `list1` doesn't exist and `list2` and `list3` hold
non-empty lists.
Consider the following command:

```
BLPOP list1 list2 list3 0
```

`BLPOP` guarantees to return an element from the list stored at `list2` (since
it is the first non empty list when checking `list1`, `list2` and `list3` in
that order).

#### Blocking behavior

If none of the specified keys exist, `BLPOP` blocks the connection until another
client performs an `LPUSH` or `RPUSH` operation against one of the keys.

Once new data is present on one of the lists, the client returns with the name
of the key unblocking it and the popped value.

When `BLPOP` causes a client to block and a non-zero timeout is specified,
the client will unblock returning a `nil` multi-bulk value when the specified
timeout has expired without a push operation against at least one of the
specified keys.

**The timeout argument is interpreted as an integer value specifying the maximum number of seconds to block**. A timeout of zero can be used to block indefinitely.

#### What key is served first? What client? What element? Priority ordering details.

* If the client tries to blocks for multiple keys, but at least one key contains elements, the returned key / element pair is the first key from left to right that has one or more elements. In this case the client is not blocked. So for instance `BLPOP key1 key2 key3 key4 0`, assuming that both `key2` and `key4` are non-empty, will always return an element from `key2`.
* If multiple clients are blocked for the same key, the first client to be served is the one that was waiting for more time (the first that blocked for the key). Once a client is unblocked it does not retain any priority, when it blocks again with the next call to `BLPOP` it will be served accordingly to the number of clients already blocked for the same key, that will all be served before it (from the first to the last that blocked).
* When a client is blocking for multiple keys at the same time, and elements are available at the same time in multiple keys (because of a transaction or a Lua script added elements to multiple lists), the client will be unblocked using the first key that received a push operation (assuming it has enough elements to serve our client, as there may be other clients as well waiting for this key). Basically after the execution of every command KeyDB will run a list of all the keys that received data AND that have at least a client blocked. The list is ordered by new element arrival time, from the first key that received data to the last. For every key processed, KeyDB will serve all the clients waiting for that key in a FIFO fashion, as long as there are elements in this key. When the key is empty or there are no longer clients waiting for this key, the next key that received new data in the previous command / transaction / script is processed, and so forth.

#### Behavior of `!BLPOP` when multiple elements are pushed inside a list.

There are times when a list can receive multiple elements in the context of the same conceptual command:

* Variadic push operations such as `LPUSH mylist a b c`.
* After an `EXEC` of a `MULTI` block with multiple push operations against the same list.
* Executing a Lua Script with KeyDB.


#### `!BLPOP` inside a `!MULTI` / `!EXEC` transaction

`BLPOP` can be used with pipelining (sending multiple commands and
reading the replies in batch), however this setup makes sense almost solely
when it is the last command of the pipeline.

Using `BLPOP` inside a `MULTI` / `EXEC` block does not make a lot of sense
as it would require blocking the entire server in order to execute the block
atomically, which in turn does not allow other clients to perform a push
operation. For this reason the behavior of `BLPOP` inside `MULTI` / `EXEC` when the list is empty is to return a `nil` multi-bulk reply, which is the same
thing that happens when the timeout is reached.

If you like science fiction, think of time flowing at infinite speed inside a
`MULTI` / `EXEC` block...

#### Return:

Array Reply: specifically:

* A `nil` multi-bulk when no element could be popped and the timeout expired.
* A two-element multi-bulk with the first element being the name of the key
  where an element was popped and the second element being the value of the
  popped element.

#### Examples:

```
keydb-cli> DEL list1 list2
(integer) 0
keydb-cli> RPUSH list1 a b c
(integer) 3
keydb-cli> BLPOP list1 list2 0
1) "list1"
2) "a"
```

#### Reliable queues

When `BLPOP` returns an element to the client, it also removes the element from the list. This means that the element only exists in the context of the client: if the client crashes while processing the returned element, it is lost forever.

This can be a problem with some application where we want a more reliable messaging system. When this is the case, please check the `BRPOPLPUSH` command, that is a variant of `BLPOP` that adds the returned element to a target list before returning it to the client.

#### Pattern: Event notification

Using blocking list operations it is possible to mount different blocking
primitives.
For instance for some application you may need to block waiting for elements
into a KeyDB Set, so that as far as a new element is added to the Set, it is
possible to retrieve it without resort to polling.
This would require a blocking version of `SPOP` that is not available, but using
blocking list operations we can easily accomplish this task.

The consumer will do:

```
LOOP forever
    WHILE SPOP(key) returns elements
        ... process elements ...
    END
    BRPOP helper_key
END
```

While in the producer side we'll use simply:

```
keydb-cli> MULTI
OK
keydb-cli> SADD key element
QUEUED
keydb-cli> LPUSH helper_key x
QUEUED
keydb-cli> EXEC
1) (integer) 1
2) (integer) 1
```
---




## BRPOP

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```BRPOP <key> <timeout>```

```BRPOP <key> <key-2> ... <key-n> <timeout>```

#### Description:

`BRPOP` is a blocking list pop primitive.
It is the blocking version of `RPOP` because it blocks the connection when there
are no elements to pop from any of the given lists.
An element is popped from the tail of the first list that is non-empty, with the
given keys being checked in the order that they are given.

See the [BLPOP documentation](/docs/commands/#BLPOP) for the exact semantics, since `BRPOP` is
identical to `BLPOP` with the only difference being that it pops elements from
the tail of a list instead of popping from the head.

#### Return:

Array Reply: specifically:

* A `nil` multi-bulk when no element could be popped and the timeout expired.
* A two-element multi-bulk with the first element being the name of the key
  where an element was popped and the second element being the value of the
  popped element.

#### Examples:

```
keydb-cli> DEL list1 list2
(integer) 0
keydb-cli> RPUSH list1 a b c
(integer) 3
keydb-cli> BRPOP list1 list2 0
1) "list1"
2) "c"
```
---



## BRPOPLPUSH

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```BRPOPLPUSH <source> <destination> <timeout>```

#### Description: 

`BRPOPLPUSH` is the blocking variant of `RPOPLPUSH`.
When `source` contains elements, this command behaves exactly like `RPOPLPUSH`.
When used inside a `MULTI`/`EXEC` block, this command behaves exactly like `RPOPLPUSH`.
When `source` is empty, KeyDB will block the connection until another client
pushes to it or until `timeout` is reached.
A `timeout` of zero can be used to block indefinitely.

See `RPOPLPUSH` for more information.

#### Return:

Bulk String Reply: the element being popped from `source` and pushed to `destination`.
If `timeout` is reached, a nil-reply is returned.

#### Pattern: Reliable queue

Please see the pattern description in the `RPOPLPUSH` documentation.

#### Pattern: Circular list

Please see the pattern description in the `RPOPLPUSH` documentation.

---



## BZPOPMAX

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax:

```BZPOPMAX <key> <timeout>```

```BZPOPMAX <key> <key-2> ... <key-n> <timeout>```

#### Description: 

`BZPOPMAX` is the blocking variant of the sorted set `ZPOPMAX` primitive.

It is the blocking version because it blocks the connection when there are no
members to pop from any of the given sorted sets.
A member with the highest score is popped from first sorted set that is
non-empty, with the given keys being checked in the order that they are given.

The `timeout` argument is interpreted as an integer value specifying the maximum
number of seconds to block. A timeout of zero can be used to block indefinitely.

See the [BZPOPMIN documentation](/docs/commands/#bzpopmin) for the exact semantics, since `BZPOPMAX`
is identical to `BZPOPMIN` with the only difference being that it pops members
with the highest scores instead of popping the ones with the lowest scores.


#### Return:

Array Reply: specifically:

* A `nil` multi-bulk when no element could be popped and the timeout expired.
* A three-element multi-bulk with the first element being the name of the key
  where a member was popped, the second element being the score of the popped
  member, and the third element being the popped member itself.

#### Examples:

```
keydb-cli> DEL zset1 zset2
(integer) 0
keydb-cli> ZADD zset1 0 a 1 b 2 c
(integer) 3
keydb-cli> BZPOPMAX zset1 zset2 0
1) "zet1"
2) "2"
2) "c"
```
---



## BZPOPMIN

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax:

```BZPOPMIN <key> <timeout>```

```BZPOPMIN <key> <key-2> ... <key-n> <timeout>```

#### Description:

`BZPOPMIN` is the blocking variant of the sorted set `ZPOPMIN` primitive.

It is the blocking version because it blocks the connection when there are no
members to pop from any of the given sorted sets.
A member with the lowest score is popped from first sorted set that is
non-empty, with the given keys being checked in the order that they are given.

The `timeout` argument is interpreted as an integer value specifying the maximum
number of seconds to block. A timeout of zero can be used to block indefinitely.

See the [BLPOP documentation](/docs/commands/#blpop) for the exact semantics, since `BZPOPMIN` is
identical to `BLPOP` with the only difference being the data structure being
popped from.


#### Return:

Array Reply: specifically:

* A `nil` multi-bulk when no element could be popped and the timeout expired.
* A three-element multi-bulk with the first element being the name of the key
  where a member was popped, the second element being the score of the popped
  member, and the third element being the popped member itself.

#### Examples:

```
keydb-cli> DEL zset1 zset2
(integer) 0
keydb-cli> ZADD zset1 0 a 1 b 2 c
(integer) 3
keydb-cli> BZPOPMIN zset1 zset2 0
1) "zet1"
2) "0"
2) "a"
```

---


## CLIENT-GETNAME

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `CLIENT GETNAME` returns the name of the current connection as set by `CLIENT SETNAME`. Since every new connection starts without an associated name, if no name was assigned a null bulk reply is returned.

#### Return:

Bulk String Reply: The connection name, or a null bulk reply if no name is set.

#### Examples:
127.0.0.1:6379> CLIENT LIST
id=7 addr=127.0.0.1:39518 fd=10 name= age=0 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=26 qbuf-free=32742 argv-mem=10 obl=0 oll=0 omem=0 tot-mem=61466 events=r cmd=client user=default

```
keydb-cli> CLIENT GETNAME
(nil)
keydb-cli> CLIENT SETNAME foo
OK
keydb-cli> CLIENT GETNAME
"foo"
```

---


## CLIENT-ID

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The command just returns the ID of the current connection. Every connection
ID has certain guarantees:

1. It is never repeated, so if `CLIENT ID` returns the same number, the caller can be sure that the underlying client did not disconnect and reconnect the connection, but it is still the same connection.
2. The ID is monotonically incremental. If the ID of a connection is greater than the ID of another connection, it is guaranteed that the second connection was established with the server at a later time.

This command is especially useful together with `CLIENT UNBLOCK` which was
introduced also in KeyDB 5 together with `CLIENT ID`. Check the `CLIENT UNBLOCK` command page for a pattern involving the two commands.

#### Examples:

```
keydb-cli> CLIENT ID
(integer) 5
```

---



## CLIENT-KILL

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `CLIENT KILL` command closes a given client connection. Up to KeyDB 2.8.11 it was possible to close a connection only by client address, using the following form:

    CLIENT KILL addr:port

The `ip:port` should match a line returned by the `CLIENT LIST` command (`addr` field).

However starting with KeyDB 2.8.12 or greater, the command accepts the following
form:

    CLIENT KILL <filter> <value> ... ... <filter> <value>

With the new form it is possible to kill clients by different attributes
instead of killing just by address. The following filters are available:

* `CLIENT KILL ADDR ip:port`. This is exactly the same as the old three-arguments behavior.
* `CLIENT KILL ID client-id`. Allows to kill a client by its unique `ID` field, which was introduced in the `CLIENT LIST` command starting from KeyDB 2.8.12.
* `CLIENT KILL TYPE type`, where *type* is one of `normal`, `master`, `slave` and `pubsub` (the `master` type is available from v3.2). This closes the connections of **all the clients** in the specified class. Note that clients blocked into the `MONITOR` command are considered to belong to the `normal` class.
* `CLIENT KILL SKIPME yes/no`. By default this option is set to `yes`, that is, the client calling the command will not get killed, however setting this option to `no` will have the effect of also killing the client calling the command.

**Note: starting with KeyDB 5 the project is no longer using the slave word. You can use `TYPE replica` instead, however the old form is still supported for backward compatibility.**

It is possible to provide multiple filters at the same time. The command will handle multiple filters via logical AND. For example:

    CLIENT KILL addr 127.0.0.1:12345 type pubsub

is valid and will kill only a pubsub client with the specified address. This format containing multiple filters is rarely useful currently.

When the new form is used the command no longer returns `OK` or an error, but instead the number of killed clients, that may be zero.

#### CLIENT KILL and KeyDB Sentinel

Recent versions of KeyDB Sentinel (KeyDB 2.8.12 or greater) use CLIENT KILL
in order to kill clients when an instance is reconfigured, in order to
force clients to perform the handshake with one Sentinel again and update
its configuration.

#### Notes

Due to the single-threaded nature of KeyDB, it is not possible to
kill a client connection while it is executing a command. From
the client point of view, the connection can never be closed
in the middle of the execution of a command. However, the client
will notice the connection has been closed only when the
next command is sent (and results in network error).

#### Return:

When called with the three arguments format:

Simple String Reply: `OK` if the connection exists and has been closed

When called with the filter / value format:

Integer Reply: the number of clients killed.

---



## CLIENT-LIST

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `CLIENT LIST` command returns information and statistics about the client
connections server in a mostly human readable format.

As of v5.0, the optional `TYPE type` subcommand can be used to filter the list by clients' type, where *type* is one of `normal`, `master`, `replica` and `pubsub`. Note that clients blocked into the `MONITOR` command are considered to belong to the `normal` class.

#### Return:

Bulk String Reply: a unique string, formatted as follows:

* One client connection per line (separated by LF)
* Each line is composed of a succession of `property=value` fields separated
  by a space character.

Here is the meaning of the fields:

* `id`: an unique 64-bit client ID (introduced in KeyDB 2.8.12).
* `name`: the name set by the client with `CLIENT SETNAME`
* `addr`: address/port of the client
* `fd`: file descriptor corresponding to the socket
* `age`: total duration of the connection in seconds
* `idle`: idle time of the connection in seconds
* `flags`: client flags (see below)
* `db`: current database ID
* `sub`: number of channel subscriptions
* `psub`: number of pattern matching subscriptions
* `multi`: number of commands in a MULTI/EXEC context
* `qbuf`: query buffer length (0 means no query pending)
* `qbuf-free`: free space of the query buffer (0 means the buffer is full)
* `obl`: output buffer length
* `oll`: output list length (replies are queued in this list when the buffer is full)
* `omem`: output buffer memory usage
* `events`: file descriptor events (see below)
* `cmd`: last command played

The client flags can be a combination of:

```
A: connection to be closed ASAP
b: the client is waiting in a blocking operation
c: connection to be closed after writing entire reply
d: a watched keys has been modified - EXEC will fail
i: the client is waiting for a VM I/O (deprecated)
M: the client is a master
N: no specific flag set
O: the client is a client in MONITOR mode
P: the client is a Pub/Sub subscriber
r: the client is in readonly mode against a cluster node
S: the client is a replica node connection to this instance
u: the client is unblocked
U: the client is connected via a Unix domain socket
x: the client is in a MULTI/EXEC context
```

The file descriptor events can be:

```
r: the client socket is readable (event loop)
w: the client socket is writable (event loop)
```

#### Notes

New fields are regularly added for debugging purpose. Some could be removed in the future. A version safe KeyDB client using this command should parse the output accordingly (i.e. handling gracefully missing fields, skipping unknown fields).

#### Examples:

```
127.0.0.1:6379> CLIENT LIST
id=7 addr=127.0.0.1:39518 fd=10 name= age=0 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=26 qbuf-free=32742 argv-mem=10 obl=0 oll=0 omem=0 tot-mem=61466 events=r cmd=client user=default
```

---




## CLIENT-PAUSE

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

`CLIENT PAUSE` is a connections control command able to suspend all the KeyDB clients for the specified amount of time (in milliseconds).

The command performs the following actions:

* It stops processing all the pending commands from normal and pub/sub clients. However interactions with replicas will continue normally.
* However it returns OK to the caller ASAP, so the `CLIENT PAUSE` command execution is not paused by itself.
* When the specified amount of time has elapsed, all the clients are unblocked: this will trigger the processing of all the commands accumulated in the query buffer of every client during the pause.

This command is useful as it makes able to switch clients from a KeyDB instance to another one in a controlled way. For example during an instance upgrade the system administrator could do the following:

* Pause the clients using `CLIENT PAUSE`
* Wait a few seconds to make sure the replicas processed the latest replication stream from the master.
* Turn one of the replicas into a master.
* Reconfigure clients to connect with the new master.

It is possible to send `CLIENT PAUSE` in a MULTI/EXEC block together with the `INFO replication` command in order to get the current master offset at the time the clients are blocked. This way it is possible to wait for a specific offset in the replica side in order to make sure all the replication stream was processed.

Since KeyDB 3.2.10 / 4.0.0, this command also prevents keys to be evicted or
expired during the time clients are paused. This way the dataset is guaranteed
to be static not just from the point of view of clients not being able to write, but also from the point of view of internal operations.

#### Return:

Simple String Reply: The command returns OK or an error if the timeout is invalid.

#### Examples:

```
keydb-cli> CLIENT PAUSE -1
(error) ERR timeout is negative
keydb-cli> CLIENT PAUSE 10000000000000000000
(error) ERR timeout is not an integer or out of range
keydb-cli> CLIENT PAUSE 1000000000000000000
OK
keydb-cli> GET key 
{client is waiting for timeout to expire}
```

The `GET` will not be executed until the timeout expires.

---




## CLIENT-REPLY

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

Sometimes it can be useful for clients to completely disable replies from the KeyDB server. For example when the client sends fire and forget commands or performs a mass loading of data, or in caching contexts where new data is streamed constantly. In such contexts to use server time and bandwidth in order to send back replies to clients, which are going to be ignored, is considered wasteful.

The `CLIENT REPLY` command controls whether the server will reply the client's commands. The following modes are available:

* `ON`. This is the default mode in which the server returns a reply to every command.
* `OFF`. In this mode the server will not reply to client commands.
* `SKIP`. This mode skips the reply of command immediately after it.

#### Return:

When called with either `OFF` or `SKIP` subcommands, no reply is made. When called with `ON`:

Simple String Reply: `OK`.

---



## CLIENT-SETNAME

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `CLIENT SETNAME` command assigns a name to the current connection.

The assigned name is displayed in the output of `CLIENT LIST` so that it is possible to identify the client that performed a given connection.

For instance when KeyDB is used in order to implement a queue, producers and consumers of messages may want to set the name of the connection according to their role.

There is no limit to the length of the name that can be assigned if not the usual limits of the KeyDB string type (512 MB). However it is not possible to use spaces in the connection name as this would violate the format of the `CLIENT LIST` reply.

It is possible to entirely remove the connection name setting it to the empty string, that is not a valid connection name since it serves to this specific purpose.

The connection name can be inspected using `CLIENT GETNAME`.

Every new connection starts without an assigned name.

**Tip**: setting names to connections is a good way to debug connection leaks due to bugs in the application using KeyDB.

#### Return:

Simple String Reply: `OK` if the connection name was successfully set.

#### Examples:

```
keydb-cli> CLIENT SETNAME foo
OK
keydb-cli> CLIENT GETNAME
"foo"
```

---




## CLIENT-UNBLOCK

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

This command can unblock, from a different connection, a client blocked in a blocking operation, such as for instance `BRPOP` or `XREAD` or `WAIT`.

By default the client is unblocked as if the timeout of the command was
reached, however if an additional (and optional) argument is passed, it is possible to specify the unblocking behavior, that can be **TIMEOUT** (the default) or **ERROR**. If **ERROR** is specified, the behavior is to unblock the client returning as error the fact that the client was force-unblocked. Specifically the client will receive the following error:

    -UNBLOCKED client unblocked via CLIENT UNBLOCK

Note: of course as usually it is not guaranteed that the error text remains
the same, however the error code will remain `-UNBLOCKED`.

This command is useful especially when we are monitoring many keys with
a limited number of connections. For instance we may want to monitor multiple
streams with `XREAD` without using more than N connections. However at some
point the consumer process is informed that there is one more stream key
to monitor. In order to avoid using more connections, the best behavior would
be to stop the blocking command from one of the connections in the pool, add
the new key, and issue the blocking command again.

To obtain this behavior the following pattern is used. The process uses
an additional *control connection* in order to send the `CLIENT UNBLOCK` command
if needed. In the meantime, before running the blocking operation on the other
connections, the process runs `CLIENT ID` in order to get the ID associated
with that connection. When a new key should be added, or when a key should
no longer be monitored, the relevant connection blocking command is aborted
by sending `CLIENT UNBLOCK` in the control connection. The blocking command
will return and can be finally reissued.

This example shows the application in the context of KeyDB streams, however
the pattern is a general one and can be applied to other cases.

#### Example:

```
Connection A (blocking connection):

keydb-cli> CLIENT ID
(integer) 2934
keydb-cli> BRPOP key1 key2 key3 0
{client is blocked}

... Now we want to add a new key ...

Connection B {control connection}:
keydb-cli> CLIENT UNBLOCK 2934
(integer) 1

Connection A {blocking connection}:
... BRPOP reply with timeout ...
(nil)
(##.##s)
keydb-cli> BRPOP key1 key2 key3 key4 0
{client is blocked again}
```
---




## CLUSTER-ADDSLOTS

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

This command is useful in order to modify a node's view of the cluster
configuration. Specifically it assigns a set of hash slots to the node
receiving the command. If the command is successful, the node will map
the specified hash slots to itself, and will start broadcasting the new
configuration.

However note that:

1. The command only works if all the specified slots are, from the point of view of the node receiving the command, currently not assigned. A node will refuse to take ownership for slots that already belong to some other node (including itself).
2. The command fails if the same slot is specified multiple times.
3. As a side effect of the command execution, if a slot among the ones specified as argument is set as `importing`, this state gets cleared once the node assigns the (previously unbound) slot to itself.

#### Example

For example the following command assigns slots 1 2 3 to the node receiving
the command:

    > CLUSTER ADDSLOTS 1 2 3
    OK

However trying to execute it again results into an error since the slots
are already assigned:

    > CLUSTER ADDSLOTS 1 2 3
    ERR Slot 1 is already busy

#### Usage in KeyDB Cluster

This command only works in cluster mode and is useful in the following
KeyDB Cluster operations:

1. To create a new cluster ADDSLOTS is used in order to initially setup master nodes splitting the available hash slots among them.
2. In order to fix a broken cluster where certain slots are unassigned.

#### Information about slots propagation and warnings

Note that once a node assigns a set of slots to itself, it will start
propagating this information in heartbeat packet headers. However the
other nodes will accept the information only if they have the slot as
not already bound with another node, or if the configuration epoch of the
node advertising the new hash slot, is greater than the node currently listed
in the table.

This means that this command should be used with care only by applications
orchestrating KeyDB Cluster, like `keydb-trib`, and the command if used
out of the right context can leave the cluster in a wrong state or cause
data loss.

#### Return:

Simple String Reply: `OK` if the command was successful. Otherwise an error is returned.

---



## CLUSTER-COUNT-FAILURE-REPORTS

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

The command returns the number of *failure reports* for the specified node.
Failure reports are the way KeyDB Cluster uses in order to promote a
`PFAIL` state, that means a node is not reachable, to a `FAIL` state,
that means that the majority of masters in the cluster agreed within
a window of time that the node is not reachable.

A few more details:

* A node flags another node with `PFAIL` when the node is not reachable for a time greater than the configured *node timeout*, which is a fundamental configuration parameter of a KeyDB Cluster.
* Nodes in `PFAIL` state are provided in gossip sections of heartbeat packets.
* Every time a node processes gossip packets from other nodes, it creates (and refreshes the TTL if needed) **failure reports**, remembering that a given node said another given node is in `PFAIL` condition.
* Each failure report has a time to live of two times the *node timeout* time.
* If at a given time a node has another node flagged with `PFAIL`, and at the same time collected the majority of other master nodes *failure reports* about this node (including itself if it is a master), then it elevates the failure state of the node from `PFAIL` to `FAIL`, and broadcasts a message forcing all the nodes that can be reached to flag the node as `FAIL`.

This command returns the number of failure reports for the current node which are currently not expired (so received within two times the *node timeout* time). The count does not include what the node we are asking this count believes about the node ID we pass as argument, the count *only* includes the failure reports the node received from other nodes.

This command is mainly useful for debugging, when the failure detector of
KeyDB Cluster is not operating as we believe it should.

#### Return:

Integer Reply: the number of active failure reports for the node.

---




## CLUSTER-COUNTKEYSINSLOT

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

Returns the number of keys in the specified KeyDB Cluster hash slot. The
command only queries the local data set, so contacting a node
that is not serving the specified hash slot will always result in a count of
zero being returned.

```
> CLUSTER COUNTKEYSINSLOT 7000
(integer) 50341
```

#### Return:

Integer Reply: The number of keys in the specified hash slot, or an error if the hash slot is invalid.

---




## CLUSTER-DELSLOTS

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

In KeyDB Cluster, each node keeps track of which master is serving
a particular hash slot.

The `DELSLOTS` command asks a particular KeyDB Cluster node to
forget which master is serving the hash slots specified as arguments.

In the context of a node that has received a `DELSLOTS` command and
has consequently removed the associations for the passed hash slots,
we say those hash slots are *unbound*. Note that the existence of
unbound hash slots occurs naturally when a node has not been
configured to handle them (something that can be done with the
`ADDSLOTS` command) and if it has not received any information about
who owns those hash slots (something that it can learn from heartbeat
or update messages).

If a node with unbound hash slots receives a heartbeat packet from
another node that claims to be the owner of some of those hash
slots, the association is established instantly. Moreover, if a
heartbeat or update message is received with a configuration epoch
greater than the node's own, the association is re-established.

However, note that:

1. The command only works if all the specified slots are already
associated with some node.
2. The command fails if the same slot is specified multiple times.
3. As a side effect of the command execution, the node may go into
*down* state because not all hash slots are covered.

#### Example

The following command removes the association for slots 5000 and
5001 from the node receiving the command:

    > CLUSTER DELSLOTS 5000 5001
    OK

#### Usage in KeyDB Cluster

This command only works in cluster mode and may be useful for
debugging and in order to manually orchestrate a cluster configuration
when a new cluster is created. It is currently not used by `keydb-trib`,
and mainly exists for API completeness.

#### Return:

Simple String Reply: `OK` if the command was successful. Otherwise
an error is returned.

---




## CLUSTER-FAILOVER

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

This command, that can only be sent to a KeyDB Cluster replica node, forces
the replica to start a manual failover of its master instance.

A manual failover is a special kind of failover that is usually executed when
there are no actual failures, but we wish to swap the current master with one
of its replicas (which is the node we send the command to), in a safe way,
without any window for data loss. It works in the following way:

1. The replica tells the master to stop processing queries from clients.
2. The master replies to the replica with the current *replication offset*.
3. The replica waits for the replication offset to match on its side, to make sure it processed all the data from the master before it continues.
4. The replica starts a failover, obtains a new configuration epoch from the majority of the masters, and broadcasts the new configuration.
5. The old master receives the configuration update: unblocks its clients and starts replying with redirection messages so that they'll continue the chat with the new master.

This way clients are moved away from the old master to the new master
atomically and only when the replica that is turning into the new master
has processed all of the replication stream from the old master.

#### FORCE option: manual failover when the master is down

The command behavior can be modified by two options: **FORCE** and **TAKEOVER**.

If the **FORCE** option is given, the replica does not perform any handshake
with the master, that may be not reachable, but instead just starts a
failover ASAP starting from point 4. This is useful when we want to start
a manual failover while the master is no longer reachable.

However using **FORCE** we still need the majority of masters to be available
in order to authorize the failover and generate a new configuration epoch
for the replica that is going to become master.

#### TAKEOVER option: manual failover without cluster consensus

There are situations where this is not enough, and we want a replica to failover
without any agreement with the rest of the cluster. A real world use case
for this is to mass promote replicas in a different data center to masters
in order to perform a data center switch, while all the masters are down
or partitioned away.

The **TAKEOVER** option implies everything **FORCE** implies, but also does
not uses any cluster authorization in order to failover. A replica receiving
`CLUSTER FAILOVER TAKEOVER` will instead:

1. Generate a new `configEpoch` unilaterally, just taking the current greatest epoch available and incrementing it if its local configuration epoch is not already the greatest.
2. Assign itself all the hash slots of its master, and propagate the new configuration to every node which is reachable ASAP, and eventually to every other node.

Note that **TAKEOVER violates the last-failover-wins principle** of KeyDB Cluster, since the configuration epoch generated by the replica violates the normal generation of configuration epochs in several ways:

1. There is no guarantee that it is actually the higher configuration epoch, since, for example, we can use the **TAKEOVER** option within a minority, nor any message exchange is performed to generate the new configuration epoch.
2. If we generate a configuration epoch which happens to collide with another instance, eventually our configuration epoch, or the one of another instance with our same epoch, will be moved away using the *configuration epoch collision resolution algorithm*.

Because of this the **TAKEOVER** option should be used with care.

#### Implementation details and notes

`CLUSTER FAILOVER`, unless the **TAKEOVER** option is specified,  does not
execute a failover synchronously, it only *schedules* a manual failover,
bypassing the failure detection stage, so to check if the failover actually
happened, `CLUSTER NODES` or other means should be used in order to verify
that the state of the cluster changes after some time the command was sent.

#### Return:

Simple String Reply: `OK` if the command was accepted and a manual failover is going to be attempted. An error if the operation cannot be executed, for example if we are talking with a node which is already a master.

---




## CLUSTER-FORGET

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

The command is used in order to remove a node, specified via its node ID,
from the set of *known nodes* of the KeyDB Cluster node receiving the command.
In other words the specified node is removed from the *nodes table* of the
node receiving the command.

Because when a given node is part of the cluster, all the other nodes
participating in the cluster knows about it, in order for a node to be
completely removed from a cluster, the `CLUSTER FORGET` command must be
sent to all the remaining nodes, regardless of the fact they are masters
or replicas.

However the command cannot simply drop the node from the internal node
table of the node receiving the command, it also implements a ban-list, not
allowing the same node to be added again as a side effect of processing the
*gossip section* of the heartbeat packets received from other nodes.

#### Details on why the ban-list is needed

In the following example we'll show why the command must not just remove
a given node from the nodes table, but also prevent it for being re-inserted
again for some time.

Let's assume we have four nodes, A, B, C and D. In order to
end with just a three nodes cluster A, B, C we may follow these steps:

1. Reshard all the hash slots from D to nodes A, B, C.
2. D is now empty, but still listed in the nodes table of A, B and C.
3. We contact A, and send `CLUSTER FORGET D`.
4. B sends node A a heartbeat packet, where node D is listed.
5. A does no longer known node D (see step 3), so it starts an handshake with D.
6. D ends re-added in the nodes table of A.

As you can see in this way removing a node is fragile, we need to send
`CLUSTER FORGET` commands to all the nodes ASAP hoping there are no
gossip sections processing in the meantime. Because of this problem the
command implements a ban-list with an expire time for each entry.

So what the command really does is:

1. The specified node gets removed from the nodes table.
2. The node ID of the removed node gets added to the ban-list, for 1 minute.
3. The node will skip all the node IDs listed in the ban-list when processing gossip sections received in heartbeat packets from other nodes.

This way we have a 60 second window to inform all the nodes in the cluster that
we want to remove a node.

#### Special conditions not allowing the command execution

The command does not succeed and returns an error in the following cases:

1. The specified node ID is not found in the nodes table.
2. The node receiving the command is a replica, and the specified node ID identifies its current master.
3. The node ID identifies the same node we are sending the command to.

#### Return:

Simple String Reply: `OK` if the command was executed successfully, otherwise an error is returned.

---




## CLUSTER-GETKEYSINSLOT

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

The command returns an array of keys names stored in the contacted node and
hashing to the specified hash slot. The maximum number of keys to return
is specified via the `count` argument, so that it is possible for the user
of this API to batch-processing keys.

The main usage of this command is during rehashing of cluster slots from one
node to another. The way the rehashing is performed is exposed in the KeyDB
Cluster specification, or in a more simple to digest form, as an appendix
of the `CLUSTER SETSLOT` command documentation.

```
> CLUSTER GETKEYSINSLOT 7000 3
"47344|273766|70329104160040|key_39015"
"47344|273766|70329104160040|key_89793"
"47344|273766|70329104160040|key_92937"
```

#### Return:

Array Reply: From 0 to *count* key names in a KeyDB array reply.

---




## CLUSTER-INFO

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

`CLUSTER INFO` provides `INFO` style information about KeyDB Cluster
vital parameters. The following is a sample output, followed by the
description of each field reported.

```
cluster_state:ok
cluster_slots_assigned:16384
cluster_slots_ok:16384
cluster_slots_pfail:0
cluster_slots_fail:0
cluster_known_nodes:6
cluster_size:3
cluster_current_epoch:6
cluster_my_epoch:2
cluster_stats_messages_sent:1483972
cluster_stats_messages_received:1483968
```

* `cluster_state`: State is `ok` if the node is able to receive queries. `fail` if there is at least one hash slot which is unbound (no node associated), in error state (node serving it is flagged with FAIL flag), or if the majority of masters can't be reached by this node.
* `cluster_slots_assigned`: Number of slots which are associated to some node (not unbound). This number should be 16384 for the node to work properly, which means that each hash slot should be mapped to a node.
* `cluster_slots_ok`: Number of hash slots mapping to a node not in `FAIL` or `PFAIL` state.
* `cluster_slots_pfail`: Number of hash slots mapping to a node in `PFAIL` state. Note that those hash slots still work correctly, as long as the `PFAIL` state is not promoted to `FAIL` by the failure detection algorithm. `PFAIL` only means that we are currently not able to talk with the node, but may be just a transient error.
* `cluster_slots_fail`: Number of hash slots mapping to a node in `FAIL` state. If this number is not zero the node is not able to serve queries unless `cluster-require-full-coverage` is set to `no` in the configuration.
* `cluster_known_nodes`: The total number of known nodes in the cluster, including nodes in `HANDSHAKE` state that may not currently be proper members of the cluster.
* `cluster_size`: The number of master nodes serving at least one hash slot in the cluster.
* `cluster_current_epoch`: The local `Current Epoch` variable. This is used in order to create unique increasing version numbers during fail overs.
* `cluster_my_epoch`: The `Config Epoch` of the node we are talking with. This is the current configuration version assigned to this node.
* `cluster_stats_messages_sent`: Number of messages sent via the cluster node-to-node binary bus.
* `cluster_stats_messages_received`: Number of messages received via the cluster node-to-node binary bus.

More information about the Current Epoch and Config Epoch variables are available in the KeyDB Cluster specification document.

#### Return:

Bulk String Reply: A map between named fields and values in the form of `<field>:<value>` lines separated by newlines composed by the two bytes `CRLF`.

---




## CLUSTER-KEYSLOT

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

Returns an integer identifying the hash slot the specified key hashes to.
This command is mainly useful for debugging and testing, since it exposes
via an API the underlying KeyDB implementation of the hashing algorithm.
Example use cases for this command:

1. Client libraries may use KeyDB in order to test their own hashing algorithm, generating random keys and hashing them with both their local implementation and using KeyDB `CLUSTER KEYSLOT` command, then checking if the result is the same.
2. Humans may use this command in order to check what is the hash slot, and then the associated KeyDB Cluster node, responsible for a given key.

#### Example

```
> CLUSTER KEYSLOT somekey
11058
> CLUSTER KEYSLOT foo{hash_tag}
(integer) 2515
> CLUSTER KEYSLOT bar{hash_tag}
(integer) 2515
```

Note that the command implements the full hashing algorithm, including support for **hash tags**, that is the special property of KeyDB Cluster key hashing algorithm, of hashing just what is between `{` and `}` if such a pattern is found inside the key name, in order to force multiple keys to be handled by the same node.

#### Return:

Integer Reply: The hash slot number.

---




## CLUSTER-MEET

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

`CLUSTER MEET` is used in order to connect different KeyDB nodes with cluster
support enabled, into a working cluster.

The basic idea is that nodes by default don't trust each other, and are
considered unknown, so that it is unlikely that different cluster nodes will
mix into a single one because of system administration errors or network
addresses modifications.

So in order for a given node to accept another one into the list of nodes
composing a KeyDB Cluster, there are only two ways:

1. The system administrator sends a `CLUSTER MEET` command to force a node to meet another one.
2. An already known node sends a list of nodes in the gossip section that we are not aware of. If the receiving node trusts the sending node as a known node, it will process the gossip section and send an handshake to the nodes that are still not known.

Note that KeyDB Cluster needs to form a full mesh (each node is connected with each other node), but in order to create a cluster, there is no need to send all the `CLUSTER MEET` commands needed to form the full mesh. What matter is to send enough `CLUSTER MEET` messages so that each node can reach each other node through a *chain of known nodes*. Thanks to the exchange of gossip information in heartbeat packets, the missing links will be created.

So, if we link node A with node B via `CLUSTER MEET`, and B with C, A and C will find their ways to handshake and create a link.

Another example: if we imagine a cluster formed of the following four nodes called A, B, C and D, we may send just the following set of commands to A:

1. `CLUSTER MEET B-ip B-port`
2. `CLUSTER MEET C-ip C-port`
3. `CLUSTER MEET D-ip D-port`

As a side effect of `A` knowing and being known by all the other nodes, it will send gossip sections in the heartbeat packets that will allow each other node to create a link with each other one, forming a full mesh in a matter of seconds, even if the cluster is large.

Moreover `CLUSTER MEET` does not need to be reciprocal. If I send the command to A in order to join B, I don't need to also send it to B in order to join A.

#### Implementation details: MEET and PING packets

When a given node receives a `CLUSTER MEET` message, the node specified in the
command still does not know the node we sent the command to. So in order for
the node to force the receiver to accept it as a trusted node, it sends a
`MEET` packet instead of a `PING` packet. The two packets have exactly the
same format, but the former forces the receiver to acknowledge the node as
trusted.

#### Return:

Simple String Reply: `OK` if the command was successful. If the address or port specified are invalid an error is returned.

---




## CLUSTER-NODES

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

Each node in a KeyDB Cluster has its view of the current cluster configuration,
given by the set of known nodes, the state of the connection we have with such
nodes, their flags, properties and assigned slots, and so forth.

`CLUSTER NODES` provides all this information, that is, the current cluster
configuration of the node we are contacting, in a serialization format which
happens to be exactly the same as the one used by KeyDB Cluster itself in
order to store on disk the cluster state (however the on disk cluster state
has a few additional info appended at the end).

Note that normally clients willing to fetch the map between Cluster
hash slots and node addresses should use `CLUSTER SLOTS` instead.
`CLUSTER NODES`, that provides more information, should be used for
administrative tasks, debugging, and configuration inspections.
It is also used by `keydb-trib` in order to manage a cluster.

#### Serialization format

The output of the command is just a space-separated CSV string, where
each line represents a node in the cluster. The following is an example
of output:

```
07c37dfeb235213a872192d90877d0cd55635b91 127.0.0.1:30004 slave e7d1eecce10fd6bb5eb35b9f99a514335d9ba9ca 0 1426238317239 4 connected
67ed2db8d677e59ec4a4cefb06858cf2a1a89fa1 127.0.0.1:30002 master - 0 1426238316232 2 connected 5461-10922
292f8b365bb7edb5e285caf0b7e6ddc7265d2f4f 127.0.0.1:30003 master - 0 1426238318243 3 connected 10923-16383
6ec23923021cf3ffec47632106199cb7f496ce01 127.0.0.1:30005 slave 67ed2db8d677e59ec4a4cefb06858cf2a1a89fa1 0 1426238316232 5 connected
824fe116063bc5fcf9f4ffd895bc17aee7731ac3 127.0.0.1:30006 slave 292f8b365bb7edb5e285caf0b7e6ddc7265d2f4f 0 1426238317741 6 connected
e7d1eecce10fd6bb5eb35b9f99a514335d9ba9ca 127.0.0.1:30001 myself,master - 0 0 1 connected 0-5460
```

Each line is composed of the following fields:

```
<id> <ip:port> <flags> <master> <ping-sent> <pong-recv> <config-epoch> <link-state> <slot> <slot> ... <slot>
```

The meaning of each filed is the following:

1. `id`: The node ID, a 40 characters random string generated when a node is created and never changed again (unless `CLUSTER RESET HARD` is used).
2. `ip:port`: The node address where clients should contact the node to run queries.
3. `flags`: A list of comma separated flags: `myself`, `master`, `slave`, `fail?`, `fail`, `handshake`, `noaddr`, `noflags`. Flags are explained in detail in the next section.
4. `master`: If the node is a replica, and the master is known, the master node ID, otherwise the "-" character.
5. `ping-sent`: Milliseconds unix time at which the currently active ping was sent, or zero if there are no pending pings.
6. `pong-recv`: Milliseconds unix time the last pong was received.
7. `config-epoch`: The configuration epoch (or version) of the current node (or of the current master if the node is a replica). Each time there is a failover, a new, unique, monotonically increasing configuration epoch is created. If multiple nodes claim to serve the same hash slots, the one with higher configuration epoch wins.
8. `link-state`: The state of the link used for the node-to-node cluster bus. We use this link to communicate with the node. Can be `connected` or `disconnected`.
9. `slot`: A hash slot number or range. Starting from argument number 9, but there may be up to 16384 entries in total (limit never reached). This is the list of hash slots served by this node. If the entry is just a number, is parsed as such. If it is a range, it is in the form `start-end`, and means that the node is responsible for all the hash slots from `start` to `end` including the start and end values.

Meaning of the flags (field number 3):

* `myself`: The node you are contacting.
* `master`: Node is a master.
* `slave`: Node is a replica.
* `fail?`: Node is in `PFAIL` state. Not reachable for the node you are contacting, but still logically reachable (not in `FAIL` state).
* `fail`: Node is in `FAIL` state. It was not reachable for multiple nodes that promoted the `PFAIL` state to `FAIL`.
* `handshake`: Untrusted node, we are handshaking.
* `noaddr`: No address known for this node.
* `noflags`: No flags at all.

#### Notes on published config epochs

Replicas broadcast their master's config epochs (in order to get an `UPDATE`
message if they are found to be stale), so the real config epoch of the
replica (which is meaningless more or less, since they don't serve hash slots)
can be only obtained checking the node flagged as `myself`, which is the entry
of the node we are asking to generate `CLUSTER NODES` output. The other
replicas epochs reflect what they publish in heartbeat packets, which is, the
configuration epoch of the masters they are currently replicating.

#### Special slot entries

Normally hash slots associated to a given node are in one of the following formats,
as already explained above:

1. Single number: 3894
2. Range: 3900-4000

However node hash slots can be in a special state, used in order to communicate errors after a node restart (mismatch between the keys in the AOF/RDB file, and the node hash slots configuration), or when there is a resharding operation in progress. This two states are **importing** and **migrating**.

The meaning of the two states is explained in the KeyDB Specification, however the gist of the two states is the following:

* **Importing** slots are yet not part of the nodes hash slot, there is a migration in progress. The node will accept queries about these slots only if the `ASK` command is used.
* **Migrating** slots are assigned to the node, but are being migrated to some other node. The node will accept queries if all the keys in the command exist already, otherwise it will emit what is called an **ASK redirection**, to force new keys creation directly in the importing node.

Importing and migrating slots are emitted in the `CLUSTER NODES` output as follows:

* **Importing slot:** `[slot_number-<-importing_from_node_id]`
* **Migrating slot:** `[slot_number->-migrating_to_node_id]`

The following are a few Examples: of importing and migrating slots:

* `[93-<-292f8b365bb7edb5e285caf0b7e6ddc7265d2f4f]`
* `[1002-<-67ed2db8d677e59ec4a4cefb06858cf2a1a89fa1]`
* `[77->-e7d1eecce10fd6bb5eb35b9f99a514335d9ba9ca]`
* `[16311->-292f8b365bb7edb5e285caf0b7e6ddc7265d2f4f]`

Note that the format does not have any space, so `CLUSTER NODES` output format is plain CSV with space as separator even when this special slots are emitted. However a complete parser for the format should be able to handle them.

Note that:

1. Migration and importing slots are only added to the node flagged as `myself`. This information is local to a node, for its own slots.
2. Importing and migrating slots are provided as **additional info**. If the node has a given hash slot assigned, it will be also a plain number in the list of hash slots, so clients that don't have a clue about hash slots migrations can just skip this special fields.

#### Return:

Bulk String Reply: The serialized cluster configuration.

**A note about the word slave used in this man page and command name**: Starting with KeyDB 5, if not for backward compatibility, the KeyDB project no longer uses the word slave. Unfortunately in this command the word slave is part of the protocol, so we'll be able to remove such occurrences only when this API will be naturally deprecated.

---




## CLUSTER-REPLICAS

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

The command provides a list of replica nodes replicating from the specified
master node. The list is provided in the same format used by `CLUSTER NODES` (please refer to its documentation for the specification of the format).

The command will fail if the specified node is not known or if it is not
a master according to the node table of the node receiving the command.

Note that if a replica is added, moved, or removed from a given master node,
and we ask `CLUSTER REPLICAS` to a node that has not yet received the
configuration update, it may show stale information. However eventually
(in a matter of seconds if there are no network partitions) all the nodes
will agree about the set of nodes associated with a given master.

#### Return:

The command returns data in the same format as `CLUSTER NODES`.

---




## CLUSTER-REPLICATE

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

The command reconfigures a node as a replica of the specified master.
If the node receiving the command is an *empty master*, as a side effect
of the command, the node role is changed from master to replica.

Once a node is turned into the replica of another master node, there is no need
to inform the other cluster nodes about the change: heartbeat packets exchanged
between nodes will propagate the new configuration automatically.

A replica will always accept the command, assuming that:

1. The specified node ID exists in its nodes table.
2. The specified node ID does not identify the instance we are sending the command to.
3. The specified node ID is a master.

If the node receiving the command is not already a replica, but is a master,
the command will only succeed, and the node will be converted into a replica,
only if the following additional conditions are met:

1. The node is not serving any hash slots.
2. The node is empty, no keys are stored at all in the key space.

If the command succeeds the new replica will immediately try to contact its master in order to replicate from it.

#### Return:

Simple String Reply: `OK` if the command was executed successfully, otherwise an error is returned.

---




## CLUSTER-RESET

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

Reset a KeyDB Cluster node, in a more or less drastic way depending on the
reset type, that can be **hard** or **soft**. Note that this command
**does not work for masters if they hold one or more keys**, in that case
to completely reset a master node keys must be removed first, e.g. by using `FLUSHALL` first,
and then `CLUSTER RESET`.

Effects on the node:

1. All the other nodes in the cluster are forgotten.
2. All the assigned / open slots are reset, so the slots-to-nodes mapping is totally cleared.
3. If the node is a replica it is turned into an (empty) master. Its dataset is flushed, so at the end the node will be an empty master.
4. **Hard reset only**: a new Node ID is generated.
5. **Hard reset only**: `currentEpoch` and `configEpoch` vars are set to 0.
6. The new configuration is persisted on disk in the node cluster configuration file.

This command is mainly useful to re-provision a KeyDB Cluster node
in order to be used in the context of a new, different cluster. The command
is also extensively used by the KeyDB Cluster testing framework in order to
reset the state of the cluster every time a new test unit is executed.

If no reset type is specified, the default is **soft**.

#### Return:

Simple String Reply: `OK` if the command was successful. Otherwise an error is returned.

---




## CLUSTER-SAVECONFIG

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

Forces a node to save the `nodes.conf` configuration on disk. Before to return
the command calls `fsync(2)` in order to make sure the configuration is
flushed on the computer disk.

This command is mainly used in the event a `nodes.conf` node state file
gets lost / deleted for some reason, and we want to generate it again from
scratch. It can also be useful in case of mundane alterations of a node cluster
configuration via the `CLUSTER` command in order to ensure the new configuration
is persisted on disk, however all the commands should normally be able to
auto schedule to persist the configuration on disk when it is important
to do so for the correctness of the system in the event of a restart.

#### Return:

Simple String Reply: `OK` or an error if the operation fails.

---




## CLUSTER-SET-CONFIG-EPOCH

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

This command sets a specific *config epoch* in a fresh node. It only works when:

1. The nodes table of the node is empty.
2. The node current *config epoch* is zero.

These prerequisites are needed since usually, manually altering the
configuration epoch of a node is unsafe, we want to be sure that the node with
the higher configuration epoch value (that is the last that failed over) wins
over other nodes in claiming the hash slots ownership.

However there is an exception to this rule, and it is when a new
cluster is created from scratch. KeyDB Cluster *config epoch collision
resolution* algorithm can deal with new nodes all configured with the
same configuration at startup, but this process is slow and should be
the exception, only to make sure that whatever happens, two more
nodes eventually always move away from the state of having the same
configuration epoch.

So, using `CONFIG SET-CONFIG-EPOCH`, when a new cluster is created, we can
assign a different progressive configuration epoch to each node before
joining the cluster together.

#### Return:

Simple String Reply: `OK` if the command was executed successfully, otherwise an error is returned.

---




## CLUSTER-SETSLOT

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

`CLUSTER SETSLOT` is responsible of changing the state of a hash slot in the receiving node in different ways. It can, depending on the subcommand used:

1. `MIGRATING` subcommand: Set a hash slot in *migrating* state.
2. `IMPORTING` subcommand: Set a hash slot in *importing* state.
3. `STABLE` subcommand: Clear any importing / migrating state from hash slot.
4. `NODE` subcommand: Bind the hash slot to a different node.

The command with its set of subcommands is useful in order to start and end cluster live resharding operations, which are accomplished by setting a hash slot in migrating state in the source node, and importing state in the destination node.

Each subcommand is documented below. At the end you'll find a description of
how live resharding is performed using this command and other related commands.

#### CLUSTER SETSLOT `<slot>` MIGRATING `<destination-node-id>`

This subcommand sets a slot to *migrating* state. In order to set a slot
in this state, the node receiving the command must be the hash slot owner,
otherwise an error is returned.

When a slot is set in migrating state, the node changes behavior in the
following way:

1. If a command is received about an existing key, the command is processed as usually.
2. If a command is received about a key that does not exists, an `ASK` redirection is emitted by the node, asking the client to retry only that specific query into `destination-node`. In this case the client should not update its hash slot to node mapping.
3. If the command contains multiple keys, in case none exist, the behavior is the same as point 2, if all exist, it is the same as point 1, however if only a partial number of keys exist, the command emits a `TRYAGAIN` error in order for the keys interested to finish being migrated to the target node, so that the multi keys command can be executed.

#### CLUSTER SETSLOT `<slot>` IMPORTING `<source-node-id>`

This subcommand is the reverse of `MIGRATING`, and prepares the destination
node to import keys from the specified source node. The command only works if
the node is not already owner of the specified hash slot.

When a slot is set in importing state, the node changes behavior in the following way:

1. Commands about this hash slot are refused and a `MOVED` redirection is generated as usually, but in the case the command follows an `ASKING` command, in this case the command is executed.

In this way when a node in migrating state generates an `ASK` redirection, the client contacts the target node, sends `ASKING`, and immediately after sends the command. This way commands about non-existing keys in the old node or keys already migrated to the target node are executed in the target node, so that:

1. New keys are always created in the target node. During a hash slot migration we'll have to move only old keys, not new ones.
2. Commands about keys already migrated are correctly processed in the context of the node which is the target of the migration, the new hash slot owner, in order to guarantee consistency.
3. Without `ASKING` the behavior is the same as usually. This guarantees that clients with a broken hash slots mapping will not write for error in the target node, creating a new version of a key that has yet to be migrated.

#### CLUSTER SETSLOT `<slot>` STABLE

This subcommand just clears migrating / importing state from the slot. It is
mainly used to fix a cluster stuck in a wrong state by `keydb-trib fix`.
Normally the two states are cleared automatically at the end of the migration
using the `SETSLOT ... NODE ...` subcommand as explained in the next section.

#### CLUSTER SETSLOT `<slot>` NODE `<node-id>`

The `NODE` subcommand is the one with the most complex semantics. It
associates the hash slot with the specified node, however the command works
only in specific situations and has different side effects depending on the
slot state. The following is the set of pre-conditions and side effects of the
command:

1. If the current hash slot owner is the node receiving the command, but for effect of the command the slot would be assigned to a different node, the command will return an error if there are still keys for that hash slot in the node receiving the command.
2. If the slot is in *migrating* state, the state gets cleared when the slot is assigned to another node.
3. If the slot was in *importing* state in the node receiving the command, and the command assigns the slot to this node (which happens in the target node at the end of the resharding of a hash slot from one node to another), the command has the following side effects: A) the *importing* state is cleared. B) If the node config epoch is not already the greatest of the cluster, it generates a new one and assigns the new config epoch to itself. This way its new hash slot ownership will win over any past configuration created by previous failovers or slot migrations.

It is important to note that step 3 is the only time when a KeyDB Cluster node will create a new config epoch without agreement from other nodes. This only happens when a manual configuration is operated. However it is impossible that this creates a non-transient setup where two nodes have the same config epoch, since KeyDB Cluster uses a config epoch collision resolution algorithm.

#### Return:

Simple String Reply: All the subcommands return `OK` if the command was successful. Otherwise an error is returned.

#### KeyDB Cluster live resharding explained

The `CLUSTER SETSLOT` command is an important piece used by KeyDB Cluster in order to migrate all the keys contained in one hash slot from one node to another. This is how the migration is orchestrated, with the help of other commands as well. We'll call the node that has the current ownership of the hash slot the `source` node, and the node where we want to migrate the `destination` node.

1. Set the destination node slot to *importing* state using `CLUSTER SETSLOT <slot> IMPORTING <source-node-id>`.
2. Set the source node slot to *migrating* state using `CLUSTER SETSLOT <slot> MIGRATING <destination-node-id>`.
3. Get keys from the source node with `CLUSTER GETKEYSINSLOT` command and move them into the destination node using the `MIGRATE` command.
4. Use `CLUSTER SETSLOT <slot> NODE <destination-node-id>` in the source or destination.

Notes:

* The order of step 1 and 2 is important. We want the destination node to be ready to accept `ASK` redirections when the source node is configured to redirect.
* Step 4 does not technically need to use `SETSLOT` in the nodes not involved in the resharding, since the configuration will eventually propagate itself, however it is a good idea to do so in order to stop nodes from pointing to the wrong node for the hash slot moved as soon as possible, resulting in less redirections to find the right node.


---


## CLUSTER-SLAVES

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

**A note about the word slave used in this man page and command name**: Starting with KeyDB 5 this command: starting with KeyDB version 5, if not for backward compatibility, the KeyDB project no longer uses the word slave. Please use the new command `CLUSTER REPLICAS`. The command `SLAVEOF` will continue to work for backward compatibility.

The command provides a list of replica nodes replicating from the specified
master node. The list is provided in the same format used by `CLUSTER NODES` (please refer to its documentation for the specification of the format).

The command will fail if the specified node is not known or if it is not
a master according to the node table of the node receiving the command.

Note that if a replica is added, moved, or removed from a given master node,
and we ask `CLUSTER SLAVES` to a node that has not yet received the
configuration update, it may show stale information. However eventually
(in a matter of seconds if there are no network partitions) all the nodes
will agree about the set of nodes associated with a given master.

#### Return:

The command returns data in the same format as `CLUSTER NODES`.

---




## CLUSTER-SLOTS

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

`CLUSTER SLOTS` returns details about which cluster slots map to which
KeyDB instances. The command is suitable to be used by KeyDB Cluster client
libraries implementations in order to retrieve (or update when a redirection
is received) the map associating cluster *hash slots* with actual nodes
network coordinates (composed of an IP address and a TCP port), so that when
a command is received, it can be sent to what is likely the right instance
for the keys specified in the command.

#### Nested Result Array
Each nested result is:

  - Start slot range
  - End slot range
  - Master for slot range represented as nested IP/Port array 
  - First replica of master for slot range
  - Second replica
  - ...continues until all replicas for this master are returned.

Each result includes all active replicas of the master instance
for the listed slot range.  Failed replicas are not returned.

The third nested reply is guaranteed to be the IP/Port pair of
the master instance for the slot range.
All IP/Port pairs after the third nested reply are replicas
of the master.

If a cluster instance has non-contiguous slots (e.g. 1-400,900,1800-6000) then
master and replica IP/Port results will be duplicated for each top-level
slot range reply.

**Warning:** Newer versions of KeyDB Cluster will output, for each KeyDB instance, not just the IP and port, but also the node ID as third element of the array. In future versions there could be more elements describing the node better. In general a client implementation should just rely on the fact that certain parameters are at fixed positions as specified, but more parameters may follow and should be ignored. Similarly a client library should try if possible to cope with the fact that older versions may just have the IP and port parameter.

#### Return:

Array Reply: nested list of slot ranges with IP/Port mappings.

#### Sample Output (old version)
```
127.0.0.1:7001> cluster slots
1) 1) (integer) 0
   2) (integer) 4095
   3) 1) "127.0.0.1"
      2) (integer) 7000
   4) 1) "127.0.0.1"
      2) (integer) 7004
2) 1) (integer) 12288
   2) (integer) 16383
   3) 1) "127.0.0.1"
      2) (integer) 7003
   4) 1) "127.0.0.1"
      2) (integer) 7007
3) 1) (integer) 4096
   2) (integer) 8191
   3) 1) "127.0.0.1"
      2) (integer) 7001
   4) 1) "127.0.0.1"
      2) (integer) 7005
4) 1) (integer) 8192
   2) (integer) 12287
   3) 1) "127.0.0.1"
      2) (integer) 7002
   4) 1) "127.0.0.1"
      2) (integer) 7006
```


#### Sample Output (new version, includes IDs)
```
127.0.0.1:30001> cluster slots
1) 1) (integer) 0
   2) (integer) 5460
   3) 1) "127.0.0.1"
      2) (integer) 30001
      3) "09dbe9720cda62f7865eabc5fd8857c5d2678366"
   4) 1) "127.0.0.1"
      2) (integer) 30004
      3) "821d8ca00d7ccf931ed3ffc7e3db0599d2271abf"
2) 1) (integer) 5461
   2) (integer) 10922
   3) 1) "127.0.0.1"
      2) (integer) 30002
      3) "c9d93d9f2c0c524ff34cc11838c2003d8c29e013"
   4) 1) "127.0.0.1"
      2) (integer) 30005
      3) "faadb3eb99009de4ab72ad6b6ed87634c7ee410f"
3) 1) (integer) 10923
   2) (integer) 16383
   3) 1) "127.0.0.1"
      2) (integer) 30003
      3) "044ec91f325b7595e76dbcb18cc688b6a5b434a1"
   4) 1) "127.0.0.1"
      2) (integer) 30006
      3) "58e6e48d41228013e5d9c1c37c5060693925e97e"
```

---



## COMMAND

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

Returns Array Reply of details about all KeyDB commands.

Cluster clients must be aware of key positions in commands so commands can go to matching instances,
but KeyDB commands vary between accepting one key,
multiple keys, or even multiple keys separated by other data.

You can use `COMMAND` to cache a mapping between commands and key positions for
each command to enable exact routing of commands to cluster instances.

### Nested Result Array
Each top-level result contains six nested results.  Each nested result is:

  - command name
  - command arity specification
  - nested Array Reply of command flags
  - position of first key in argument list
  - position of last key in argument list
  - step count for locating repeating keys

### Command Name

Command name is the command returned as a lowercase string.

### Command Arity

| `GET` | `MGET` |
| ------------- | ------------- |
| ```1) 1) "get"```<br/>```2) (integer) 2```<br/>```3) 1) readonly```<br/>```4) (integer) 1```<br/>```5) (integer) 1```<br/>```6) (integer) 1``` | ```1) 1) "mget"```<br/>```2) (integer) -2```<br/>```3) 1) readonly```<br/>```4) (integer) 1```<br/>```5) (integer) -1```<br/>```6) (integer) 1```|

Command arity follows a simple pattern:

  - positive if command has fixed number of required arguments.
  - negative if command has minimum number of required arguments, but may have more.

Command arity _includes_ counting the command name itself.

Examples::

  - `GET` arity is 2 since the command only accepts one
argument and always has the format `GET _key_`.
  - `MGET` arity is -2 since the command accepts at a minimum
one argument, but up to an unlimited number: `MGET _key1_ [key2] [key3] ...`.

Also note with `MGET`, the -1 value for "last key position" means the list
of keys may have unlimited length.

### Flags
Command flags is Array Reply containing one or more status replies:

  - *write* - command may result in modifications
  - *readonly* - command will never modify keys
  - *denyoom* - reject command if currently OOM
  - *admin* - server admin command
  - *pubsub* - pubsub-related command
  - *noscript* - deny this command from scripts
  - *random* - command has random results, dangerous for scripts
  - *sort\_for\_script* - if called from script, sort output
  - *loading* - allow command while database is loading
  - *stale* - allow command while replica has stale data
  - *skip_monitor* - do not show this command in MONITOR
  - *asking* - cluster related - accept even if importing
  - *fast* - command operates in constant or log(N) time.  Used for latency monitoring.
  - *movablekeys* - keys have no pre-determined position.  You must discover keys yourself.


### Movable Keys

```
1) 1) "sort"
   2) (integer) -2
   3) 1) write
      2) denyoom
      3) movablekeys
   4) (integer) 1
   5) (integer) 1
   6) (integer) 1
```

Some KeyDB commands have no predetermined key locations.  For those commands,
flag `movablekeys` is added to the command flags Array Reply.  Your KeyDB
Cluster client needs to parse commands marked `movablekeys` to locate all relevant key positions.

Complete list of commands currently requiring key location parsing:

  - `SORT` - optional `STORE` key, optional `BY` weights, optional `GET` keys
  - `ZUNIONSTORE` - keys stop when `WEIGHT` or `AGGREGATE` starts
  - `ZINTERSTORE` - keys stop when `WEIGHT` or `AGGREGATE` starts
  - `EVAL` - keys stop after `numkeys` count arguments
  - `EVALSHA` - keys stop after `numkeys` count arguments

Also see `COMMAND GETKEYS` for getting your KeyDB server tell you where keys
are in any given command.

### First Key in Argument List

For most commands the first key is position 1.  Position 0 is
always the command name itself.


### Last Key in Argument List

KeyDB commands usually accept one key, two keys, or an unlimited number of keys.

If a command accepts one key, the first key and last key positions is 1.

If a command accepts two keys (e.g. `BRPOPLPUSH`, `SMOVE`, `RENAME`, ...) then the
last key position is the location of the last key in the argument list.

If a command accepts an unlimited number of keys, the last key position is -1.


### Step Count

| `MSET` | `MGET` |
| ------------- | ------------- |
| ```1) 1) "mset"```<br/>```2) (integer) -3```<br/>```3) 1) write```<br/>&nbsp&nbsp&nbsp&nbsp&nbsp```2) denyoom```<br/>```4) (integer) 1```<br/>```5) (integer) -1```<br/>```6) (integer) 2``` | ```1) 1) "mget"```<br/>```2) (integer) -2```<br/>```3) 1) readonly```<br/>```4) (integer) 1```<br/>```5) (integer) -1```<br/>```6) (integer) 1``` |

Key step count allows us to find key positions in commands
like `MSET` where the format is `MSET _key1_ _val1_ [key2] [val2] [key3] [val3]...`.

In the case of `MSET`, keys are every other position so the step value is 2.  Compare
with `MGET` above where the step value is just 1.


#### Return:

Array Reply: nested list of command details.  Commands are returned
in random order.

#### Examples:

```
keydb-cli> COMMAND

{output for all commands...}

215) 1) "bitcount"
     2) (integer) -2
     3) 1) readonly
     4) (integer) 1
     5) (integer) 1
     6) (integer) 1
     7) 1) @read
        2) @bitmap
        3) @slow

```
---



## COMMAND-COUNT

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

Returns Integer Reply of number of total commands in this KeyDB server.

#### Return:

Integer Reply: number of commands returned by `COMMAND`

#### Examples:

```
keydb-cli> COMMAND COUNT
(integer) 215
```
---



## COMMAND-GETKEYS

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

#### Syntax:

```COMMAND GETKEYS <commandX> <argument-1-of-commandX> ... <argument-n-of-commandX>```

#### Descripition: 

Returns Array Reply of keys from a full KeyDB command.

`COMMAND GETKEYS` is a helper command to let you find the keys
from a full KeyDB command.

`COMMAND` shows some commands as having movablekeys meaning
the entire command must be parsed to discover storage or retrieval
keys.  You can use `COMMAND GETKEYS` to discover key positions
directly from how KeyDB parses the commands.


#### Return:

Array Reply: list of keys from your command.

#### Examples:

```
keydb-cli> COMMAND GETKEYS MSET a b c d e f
1) "a"
2) "c"
3) "e"
keydb-cli> COMMAND GETKEYS EVAl "not consulted" 3 key1 key2 key3 arg1 arg2 arg3 argN
1) "key1"
2) "key2"
3) "key3"
keydb-cli> COMMAND GETKEYS SORT mylist ALPHA STORE outlist
1) "mylist"
2) "outlist"
```
---



## COMMAND-INFO

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

#### Syntax:

```COMMAND INFO <command-1> ... <command-n>```

#### Description: 

Returns Array Reply of details about multiple KeyDB commands.

Same result format as `COMMAND` except you can specify which commands
get returned.

If you request details about non-existing commands, their return
position will be nil.


#### Return:

Array Reply: nested list of command details.

#### Examples:

```
keydb-cli> COMMAND INFO get set eval
1) 1) "get"
   2) (integer) 2
   3) 1) readonly
      2) fast
   4) (integer) 1
   5) (integer) 1
   6) (integer) 1
   7) 1) @read
      2) @string
      3) @fast
2) 1) "set"
   2) (integer) -3
   3) 1) write
      2) denyoom
   4) (integer) 1
   5) (integer) 1
   6) (integer) 1
   7) 1) @write
      2) @string
      3) @slow
3) 1) "eval"
   2) (integer) -3
   3) 1) noscript
      2) movablekeys
   4) (integer) 0
   5) (integer) 0
   6) (integer) 0
   7) 1) @slow
      2) @scripting
keydb-cli> COMMAND INFO foo evalsha config bar
1) (nil)
2) 1) "evalsha"
   2) (integer) -3
   3) 1) noscript
      2) movablekeys
   4) (integer) 0
   5) (integer) 0
   6) (integer) 0
   7) 1) @slow
      2) @scripting
3) 1) "config"
   2) (integer) -2
   3) 1) admin
      2) noscript
      3) loading
      4) stale
   4) (integer) 0
   5) (integer) 0
   6) (integer) 0
   7) 1) @admin
      2) @slow
      3) @dangerous
```
---




## CONFIG-GET

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

#### Syntax :

```CONFIG GET <glob-pattern>```

#### Description:

The `CONFIG GET` command is used to read the configuration parameters of a
running KeyDB server.

The symmetric command used to alter the configuration at run time is `CONFIG
SET`.

`CONFIG GET` takes a single argument, which is a glob-style pattern.
All the configuration parameters matching this parameter are reported as a list
of key-value pairs.

#### Example:

```
keydb-cli> config get *max-*-entries*
1) "hash-max-zipmap-entries"
2) "512"
3) "list-max-ziplist-entries"
4) "512"
5) "set-max-intset-entries"
6) "512"
```

You can obtain a list of all the supported configuration parameters by typing
`CONFIG GET *` in an open `keydb-cli` prompt.

All the supported parameters have the same meaning of the equivalent
configuration parameter used in the keydb.conf file, with the
following important differences:

https://github.com/JohnSully/KeyDB/blob/unstable/keydb.conf

* Where bytes or other quantities are specified, it is not possible to use
  the `keydb.conf` abbreviated form (`10k`, `2gb` ... and so forth), everything
  should be specified as a well-formed 64-bit integer, in the base unit of the
  configuration directive.
* The save parameter is a single string of space-separated integers.
  Every pair of integers represent a seconds/modifications threshold.

For instance what in `keydb.conf` looks like:

```
save 900 1
save 300 10
```

that means, save after 900 seconds if there is at least 1 change to the dataset,
and after 300 seconds if there are at least 10 changes to the dataset, will be
reported by `CONFIG GET` as "900 1 300 10".

#### Return:

The return type of the command is a Array Reply.

---



## CONFIG-RESETSTAT

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

#### Descripition : 

Resets the statistics reported by KeyDB using the `INFO` command.

These are the counters that are reset:

* Keyspace hits
* Keyspace misses
* Number of commands processed
* Number of connections received
* Number of expired keys
* Number of rejected connections
* Latest fork(2) time
* The `aof_delayed_fsync` counter

#### Return:

Simple String Reply: always `OK`.

---




## CONFIG-REWRITE

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `CONFIG REWRITE` command rewrites the `keydb.conf` file the server was started with, applying the minimal changes needed to make it reflect the configuration currently used by the server, which may be different compared to the original one because of the use of the `CONFIG SET` command.

The rewrite is performed in a very conservative way:

* Comments and the overall structure of the original keydb.conf are preserved as much as possible.
* If an option already exists in the old keydb.conf file, it will be rewritten at the same position (line number).
* If an option was not already present, but it is set to its default value, it is not added by the rewrite process.
* If an option was not already present, but it is set to a non-default value, it is appended at the end of the file.
* Non used lines are blanked. For instance if you used to have multiple `save` directives, but the current configuration has fewer or none as you disabled RDB persistence, all the lines will be blanked.

CONFIG REWRITE is also able to rewrite the configuration file from scratch if the original one no longer exists for some reason. However if the server was started without a configuration file at all, the CONFIG REWRITE will just return an error.

#### Atomic rewrite process

In order to make sure the keydb.conf file is always consistent, that is, on errors or crashes you always end with the old file, or the new one, the rewrite is performed with a single `write(2)` call that has enough content to be at least as big as the old file. Sometimes additional padding in the form of comments is added in order to make sure the resulting file is big enough, and later the file gets truncated to remove the padding at the end.

#### Return:

Simple String Reply: `OK` when the configuration was rewritten properly.
Otherwise an error is returned.

#### Example:

```
keydb-cli> CONFIG REWRITE
(error) ERR The server is running without a config file
```

---




## CONFIG-SET

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

#### Syntax:

```CONFIG SET <server-configuration-parameter> <server-configruation-parameter-value-1> .. <server-configuration-parameter-value-n>```

#### Descripition:

The `CONFIG SET` command is used in order to reconfigure the server at run time
without the need to restart KeyDB.
You can change both trivial parameters or switch from one to another persistence
option using this command.

The list of configuration parameters supported by `CONFIG SET` can be obtained
issuing a `CONFIG GET *` command, that is the symmetrical command used to obtain
information about the configuration of a running KeyDB instance.

All the configuration parameters set using `CONFIG SET` are immediately loaded
by KeyDB and will take effect starting with the next command executed.

All the supported parameters have the same meaning of the equivalent
configuration parameter used in the keydb.conf file, with the
following important differences:

https://github.com/JohnSully/KeyDB/blob/unstable/keydb.conf

* In options where bytes or other quantities are specified, it is not
  possible to use the `keydb.conf` abbreviated form (`10k`, `2gb` ... and so forth),
  everything should be specified as a well-formed 64-bit integer, in the base
  unit of the configuration directive. However since KeyDB version 3.0 or
  greater, it is possible to use `CONFIG SET` with memory units for
  `maxmemory`, client output buffers, and replication backlog size.
* The save parameter is a single string of space-separated integers.
  Every pair of integers represent a seconds/modifications threshold.

For instance what in `keydb.conf` looks like:

```
save 900 1
save 300 10
```

that means, save after 900 seconds if there is at least 1 change to the dataset,
and after 300 seconds if there are at least 10 changes to the dataset, should
be set using  : 

```
CONFIG SET SAVE "900 1 300 10"
```

It is possible to switch persistence from RDB snapshotting to append-only file
(and the other way around) using the `CONFIG SET` command.
For more information about how to do that please check the [persistence
page](https://docs.keydb.dev/docs/persistence/)

In general what you should know is that setting the `appendonly` parameter to
`yes` will start a background process to save the initial append-only file
(obtained from the in memory data set), and will append all the subsequent
commands on the append-only file, thus obtaining exactly the same effect of a
KeyDB server that started with AOF turned on since the start.

You can have both the AOF enabled with RDB snapshotting if you want, the two
options are not mutually exclusive.

#### Return:

Simple String Reply: `OK` when the configuration was set properly.
Otherwise an error is returned.

---




## DBSIZE

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

Return the number of keys in the currently-selected database.

#### Return:

Integer Reply

#### Example:

```
keydb-cli> DBSIZE
(integer) 0
keydb-cli> set key 1
OK
keydb-cli> DBSIZE
(integer) 1
```

---



## DEBUG-OBJECT

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

`DEBUG OBJECT` is a debugging command that should not be used by clients.
Check the `OBJECT` command instead.

#### Return:

Simple String Reply

---




## DEBUG-SEGFAULT

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

`DEBUG SEGFAULT` performs an invalid memory access that crashes KeyDB.
It is used to simulate bugs during the development.

#### Example: 

```
keydb-cli>DEBUG SEGFAULT
Could not connect to Redis at 127.0.0.1:6379: Connection refused
not connected>
```

#### Return:

Simple String Reply

---



## DECR

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax :

```DECR <key>```

#### Description : 

Decrements the number stored at `key` by one.
If the key does not exist, it is set to `0` before performing the operation.
An error is returned if the key contains a value of the wrong type or contains a
string that can not be represented as integer.
This operation is limited to **64 bit signed integers**.

See `INCR` for extra information on increment/decrement operations.

#### Return:

Integer Reply: the value of `key` after the decrement

#### Examples:

```
keydb-cli> SET mykey "10"
OK
keydb-cli> DECR mykey
(integer) 9
keydb-cli> SET mykey "234293482390480948029348230948"
OK
keydb-cli> DECR mykey
(error) ERR value is not an integer or out of range
```
---



## DECRBY

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```DECRBY <key> <decrement>```

#### Description: 

Decrements the number stored at `key` by `decrement`.
If the key does not exist, it is set to `0` before performing the operation.
An error is returned if the key contains a value of the wrong type or contains a
string that can not be represented as integer.
This operation is limited to 64 bit signed integers.

See `INCR` for extra information on increment/decrement operations.

#### Return:

Integer Reply: the value of `key` after the decrement

#### Examples:

```
127.0.0.1:6379> SET mykey "10"
OK
127.0.0.1:6379> DECRBY mykey 3
(integer) 7127.0.0.1:6379> SET mykey "10"
OK
127.0.0.1:6379> DECRBY mykey 3
(integer) 7
```

---


## DEL

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

Removes the specified keys.
A key is ignored if it does not exist.

#### Syntax:

```DEL <key-1> ... <key-n>```

#### Return:

Integer Reply: The number of keys that were removed.

#### Examples:

```
keydb-cli> SET key1 "Hello"
OK
keydb-cli> SET key2 "World"
OK
keydb-cli> DEL key1 key2 key3
(integer) 2
```
---



## DISCARD

**Related Commands:** [DISCARD](/docs/commands/#discard), [EXEC](/docs/commands/#exec), [MULTI](/docs/commands/#multi), [UNWATCH](/docs/commands/#unwatch), [WATCH](/docs/commands/#watch)

#### Description: 

Flushes all previously queued commands in a [transaction](https://docs.keydb.dev/docs/transactions/) and restores the
connection state to normal.

If `WATCH` was used, `DISCARD` unwatches all keys watched by the connection.

#### Return:

Simple String Reply: always `OK`.

#### Examples:

```
keydb-cli> MULTI
OK
keydb-cli> DISCARD
OK
127.0.0.1:6379> EXEC
(error) ERR EXEC without MULTI
```

---




## DUMP

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

Serialize the value stored at key in a keydb-specific format and return it to
the user.
The returned value can be synthesized back into a KeyDB key using the `RESTORE`
command.

The serialization format is opaque and non-standard, however it has a few
semantic characteristics:

* It contains a 64-bit checksum that is used to make sure errors will be
  detected.
  The `RESTORE` command makes sure to check the checksum before synthesizing a
  key using the serialized value.
* Values are encoded in the same format used by RDB.
* An RDB version is encoded inside the serialized value, so that different KeyDB
  versions with incompatible RDB formats will refuse to process the serialized
  value.

The serialized value does NOT contain expire information.
In order to capture the time to live of the current value the `PTTL` command
should be used.

If `key` does not exist a nil bulk reply is returned.

#### Return:

Bulk String Reply: the serialized value.

#### Examples:

```
keydb-cli> SET mykey 10
OK
keydb-cli> DUMP mykey
"\x00\xc0\n\t\x00\xbem\x06\x89Z(\x00\n"
```
---




## ECHO

**Related Commands:** [AUTH](/docs/commands/#append), [ECHO](/docs/commands/#echo), [PING](/docs/commands/#ping), [QUIT](/docs/commands/#quit), [SELECT](/docs/commands/#select), [SWAPDB](/docs/commands/#swapdb)

#### Syntax:

```ECHO <message>```

#### Descripition:

Returns `message`.

#### Return:

Bulk String Reply

#### Examples:

```
keydb-cli> ECHO "Hello World!"
"hello world!"
```
---



## EVAL 

**Related Commands:** [EVAL](/docs/commands/#eval), [EVALSHA](/docs/commands/#evalsha), [SCRIPT DEBUG](/docs/commands/#script-debug), [SCRIPT EXISTS](/docs/commands/#script-exists), [SCRIPT FLUSH](/docs/commands/#script-flush), [SCRIPT KILL](/docs/commands/#script-kill), [SCRIPT LOAD](/docs/commands/#script-load)

#### Introduction to EVAL

`EVAL` and `EVALSHA` are used to evaluate scripts using the Lua interpreter
built into KeyDB

The first argument of `EVAL` is a Lua 5.1 script.
The script does not need to define a Lua function (and should not).
It is just a Lua program that will run in the context of the KeyDB server.

The second argument of `EVAL` is the number of arguments that follows the script
(starting from the third argument) that represent KeyDB key names.
The arguments can be accessed by Lua using the `!KEYS` global variable in the
form of a one-based array (so `KEYS[1]`, `KEYS[2]`, ...).

All the additional arguments should not represent key names and can be accessed
by Lua using the `ARGV` global variable, very similarly to what happens with
keys (so `ARGV[1]`, `ARGV[2]`, ...).

The following example should clarify what stated above:

```
keydb-cli> eval "return {KEYS[1],KEYS[2],ARGV[1],ARGV[2]}" 2 key1 key2 first second
1) "key1"
2) "key2"
3) "first"
4) "second"
```

Note: as you can see Lua arrays are returned as KeyDB multi bulk replies, that
is a KeyDB return type that your client library will likely convert into an
Array type in your programming language.

It is possible to call KeyDB commands from a Lua script using two different Lua
functions:

* `KeyDB.call()`
* `KeyDB.pcall()`

`KeyDB.call()` is similar to `KeyDB.pcall()`, the only difference is that if a
KeyDB command call will result in an error, `KeyDB.call()` will raise a Lua
error that in turn will force `EVAL` to return an error to the command caller,
while `KeyDB.pcall` will trap the error and return a Lua table representing the
error.

The arguments of the `KeyDB.call()` and `KeyDB.pcall()` functions are all
the arguments of a well formed KeyDB command:

```
> eval "return KeyDB.call('set','foo','bar')" 0
OK
```

The above script sets the key `foo` to the string `bar`.
However it violates the `EVAL` command semantics as all the keys that the script
uses should be passed using the `!KEYS` array:

```
> eval "return KeyDB.call('set',KEYS[1],'bar')" 1 foo
OK
```

All KeyDB commands must be analyzed before execution to determine which
keys the command will operate on.  In order for this to be true for `EVAL`, keys must be passed explicitly.
This is useful in many ways, but especially to make sure KeyDB Cluster
can forward your request to the appropriate cluster node.

Note this rule is not enforced in order to provide the user with
opportunities to abuse the KeyDB single instance configuration, at the cost of
writing scripts not compatible with KeyDB Cluster.

Lua scripts can return a value that is converted from the Lua type to the KeyDB
protocol using a set of conversion rules.

#### Conversion between Lua and KeyDB data types

KeyDB return values are converted into Lua data types when Lua calls a KeyDB
command using `call()` or `pcall()`.
Similarly, Lua data types are converted into the KeyDB protocol when calling
a KeyDB command and when a Lua script returns a value, so that scripts can
control what `EVAL` will return to the client.

This conversion between data types is designed in a way that if a KeyDB type is
converted into a Lua type, and then the result is converted back into a KeyDB
type, the result is the same as the initial value.

In other words there is a one-to-one conversion between Lua and KeyDB types.
The following table shows you all the conversions rules:

**KeyDB to Lua** conversion table.

* KeyDB integer reply -> Lua number
* KeyDB bulk reply -> Lua string
* KeyDB multi bulk reply -> Lua table (may have other KeyDB data types nested)
* KeyDB status reply -> Lua table with a single `ok` field containing the status
* KeyDB error reply -> Lua table with a single `err` field containing the error
* KeyDB Nil bulk reply and Nil multi bulk reply -> Lua false boolean type

**Lua to KeyDB** conversion table.

* Lua number -> KeyDB integer reply (the number is converted into an integer)
* Lua string -> KeyDB bulk reply
* Lua table (array) -> KeyDB multi bulk reply (truncated to the first nil inside the Lua array if any)
* Lua table with a single `ok` field -> KeyDB status reply
* Lua table with a single `err` field -> KeyDB error reply
* Lua boolean false -> KeyDB Nil bulk reply.

There is an additional Lua-to-KeyDB conversion rule that has no corresponding
KeyDB to Lua conversion rule:

* Lua boolean true -> KeyDB integer reply with value of 1.

Also there are two important rules to note:

* Lua has a single numerical type, Lua numbers. There is no distinction between integers and floats. So we always convert Lua numbers into integer replies, removing the decimal part of the number if any. **If you want to return a float from Lua you should return it as a string**, exactly like KeyDB itself does (see for instance the `ZSCORE` command).
* There is no simple way to have nils inside Lua arrays, this is a result of Lua table semantics, so when KeyDB converts a Lua array into KeyDB protocol the conversion is stopped if a nil is encountered.

Here are a few conversion Examples::

```
keydb-cli> eval "return 10" 0
(integer) 10

keydb-cli> eval "return {1,2,{3,'Hello World!'}}" 0
1) (integer) 1
2) (integer) 2
3) 1) (integer) 3
   2) "Hello World!"

> eval "return KeyDB.call('get','foo')" 0
"bar"
```
The last example shows how it is possible to receive the exact return value of
`KeyDB.call()` or `KeyDB.pcall()` from Lua that would be returned if the command
was called directly.

In the following example we can see how floats and arrays with nils are handled:

```
keydb-cli> eval "return {1,2,3.3333,'foo',nil,'bar'}" 0
1) (integer) 1
2) (integer) 2
3) (integer) 3
4) "foo"
```

As you can see 3.333 is converted into 3, and the *bar* string is never returned as there is a nil before.

#### Helper functions to return KeyDB types

There are two helper functions to return KeyDB types from Lua.

* `KeyDB.error_reply(error_string)` returns an error reply. This function simply returns a single field table with the `err` field set to the specified string for you.
* `KeyDB.status_reply(status_string)` returns a status reply. This function simply returns a single field table with the `ok` field set to the specified string for you.

There is no difference between using the helper functions or directly returning the table with the specified format, so the following two forms are equivalent:

    return {err="My Error"}
    return KeyDB.error_reply("My Error")

#### Atomicity of scripts

KeyDB uses the same Lua interpreter to run all the commands.
Also KeyDB guarantees that a script is executed in an atomic way: no other
script or KeyDB command will be executed while a script is being executed.
This semantic is similar to the one of `MULTI` / `EXEC`.
From the point of view of all the other clients the effects of a script are
either still not visible or already completed.

However this also means that executing slow scripts is not a good idea.
It is not hard to create fast scripts, as the script overhead is very low, but
if you are going to use slow scripts you should be aware that while the script
is running no other client can execute commands.

#### Error handling

As already stated, calls to `KeyDB.call()` resulting in a KeyDB command error
will stop the execution of the script and return an error, in a way that
makes it obvious that the error was generated by a script:

```
keydb-cli> del foo
(integer) 1
keydb-cli> lpush foo a
(integer) 1
keydb-cli> eval "return KeyDB.call('get','foo')" 0
(error) ERR Error running script (call to f_6b1bf486c81ceb7edf3c093f4c48582e38c0e791): ERR Operation against a key holding the wrong kind of value
```

Using `KeyDB.pcall()` no error is raised, but an error object is
returned in the format specified above (as a Lua table with an `err` field).
The script can pass the exact error to the user by returning the error object
returned by `KeyDB.pcall()`.

#### Bandwidth and EVALSHA

The `EVAL` command forces you to send the script body again and again.
KeyDB does not need to recompile the script every time as it uses an internal
caching mechanism, however paying the cost of the additional bandwidth may not
be optimal in many contexts.

On the other hand, defining commands using a special command or via `keydb.conf`
would be a problem for a few reasons:

*   Different instances may have different implementations of a command.

*   Deployment is hard if we have to make sure all instances contain a
    given command, especially in a distributed environment.

*   Reading application code, the complete semantics might not be clear since the
    application calls commands defined server side.

In order to avoid these problems while avoiding the bandwidth penalty, KeyDB
implements the `EVALSHA` command.

`EVALSHA` works exactly like `EVAL`, but instead of having a script as the first
argument it has the SHA1 digest of a script.
The behavior is the following:

*   If the server still remembers a script with a matching SHA1 digest, the
    script is executed.

*   If the server does not remember a script with this SHA1 digest, a special
    error is returned telling the client to use `EVAL` instead.

Example:

```
> set foo bar
OK
> eval "return KeyDB.call('get','foo')" 0
"bar"
> evalsha 6b1bf486c81ceb7edf3c093f4c48582e38c0e791 0
"bar"
> evalsha ffffffffffffffffffffffffffffffffffffffff 0
(error) `NOSCRIPT` No matching script. Please use `EVAL`.
```

The client library implementation can always optimistically send `EVALSHA` under
the hood even when the client actually calls `EVAL`, in the hope the script was
already seen by the server.
If the `NOSCRIPT` error is returned `EVAL` will be used instead.

Passing keys and arguments as additional `EVAL` arguments is also very useful in
this context as the script string remains constant and can be efficiently cached
by KeyDB.

#### Script cache semantics

Executed scripts are guaranteed to be in the script cache of a given execution
of a KeyDB instance forever. This means that if an `EVAL` is performed against a KeyDB instance all the subsequent `EVALSHA` calls will succeed.

The reason why scripts can be cached for long time is that it is unlikely for
a well written application to have enough different scripts to cause memory
problems. Every script is conceptually like the implementation of a new command, and even a large application will likely have just a few hundred of them.
Even if the application is modified many times and scripts will change, the
memory used is negligible.

The only way to flush the script cache is by explicitly calling the `SCRIPT FLUSH` command, which will _completely flush_ the scripts cache removing all the
scripts executed so far.

This is usually needed only when the instance is going to be instantiated for
another customer or application in a cloud environment.

Also, as already mentioned, restarting a KeyDB instance flushes the
script cache, which is not persistent. However from the point of view of the
client there are only two ways to make sure a KeyDB instance was not restarted
between two different commands.

* The connection we have with the server is persistent and was never closed so far.
* The client explicitly checks the `runid` field in the `INFO` command in order to make sure the server was not restarted and is still the same process.

Practically speaking, for the client it is much better to simply assume that in the context of a given connection, cached scripts are guaranteed to be there
unless an administrator explicitly called the `SCRIPT FLUSH` command.

The fact that the user can count on KeyDB not removing scripts is semantically
useful in the context of pipelining.

For instance an application with a persistent connection to KeyDB can be sure
that if a script was sent once it is still in memory, so EVALSHA can be used
against those scripts in a pipeline without the chance of an error being
generated due to an unknown script (we'll see this problem in detail later).

A common pattern is to call `SCRIPT LOAD` to load all the scripts that will
appear in a pipeline, then use `EVALSHA` directly inside the pipeline without
any need to check for errors resulting from the script hash not being
recognized.

#### The SCRIPT command

KeyDB offers a SCRIPT command that can be used in order to control the scripting
subsystem.
SCRIPT currently accepts three different commands:

*   `SCRIPT FLUSH`

    This command is the only way to force KeyDB to flush the scripts cache.
    It is most useful in a cloud environment where the same instance can be
    reassigned to a different user.
    It is also useful for testing client libraries' implementations of the
    scripting feature.

*   `SCRIPT EXISTS sha1 sha2 ... shaN`

    Given a list of SHA1 digests as arguments this command returns an array of
    1 or 0, where 1 means the specific SHA1 is recognized as a script already
    present in the scripting cache, while 0 means that a script with this SHA1
    was never seen before (or at least never seen after the latest SCRIPT FLUSH
    command).

*   `SCRIPT LOAD script`

    This command registers the specified script in the KeyDB script cache.
    The command is useful in all the contexts where we want to make sure that
    `EVALSHA` will not fail (for instance during a pipeline or MULTI/EXEC
    operation), without the need to actually execute the script.

*   `SCRIPT KILL`

    This command is the only way to interrupt a long-running script that reaches
    the configured maximum execution time for scripts.
    The SCRIPT KILL command can only be used with scripts that did not modify
    the dataset during their execution (since stopping a read-only script does
    not violate the scripting engine's guaranteed atomicity).
    See the next sections for more information about long running scripts.

#### Scripts as pure functions

*Note: starting with KeyDB 5, scripts are always replicated as effects and not sending the script verbatim. So the following section is mostly applicable to KeyDB version 4 or older.*

A very important part of scripting is writing scripts that are pure functions.
Scripts executed in a KeyDB instance are, by default, propagated to replicas
and to the AOF file by sending the script itself -- not the resulting
commands.

The reason is that sending a script to another KeyDB instance is often much
faster than sending the multiple commands the script generates, so if the
client is sending many scripts to the master, converting the scripts into
individual commands for the replica / AOF would result in too much bandwidth
for the replication link or the Append Only File (and also too much CPU since
dispatching a command received via network is a lot more work for KeyDB compared
to dispatching a command invoked by Lua scripts).

Normally replicating scripts instead of the effects of the scripts makes sense,
however not in all the cases. So starting with KeyDB 3.2,
the scripting engine is able to, alternatively, replicate the sequence of write
commands resulting from the script execution, instead of replication the
script itself. See the next section for more information.
In this section we'll assume that scripts are replicated by sending the whole
script. Let's call this replication mode **whole scripts replication**.

The main drawback with the *whole scripts replication* approach is that scripts are required to have the following property:

* The script must always evaluates the same KeyDB _write_ commands with the
  same arguments given the same input data set.
  Operations performed by the script cannot depend on any hidden (non-explicit)
  information or state that may change as script execution proceeds or between
  different executions of the script, nor can it depend on any external input
  from I/O devices.

Things like using the system time, calling KeyDB random commands like
`RANDOMKEY`, or using Lua random number generator, could result into scripts
that will not always evaluate in the same way.

In order to enforce this behavior in scripts KeyDB does the following:

* Lua does not export commands to access the system time or other external
  state.
* KeyDB will block the script with an error if a script calls a KeyDB
  command able to alter the data set **after** a KeyDB _random_ command like
  `RANDOMKEY`, `SRANDMEMBER`, `TIME`.
  This means that if a script is read-only and does not modify the data set it
  is free to call those commands.
  Note that a _random command_ does not necessarily mean a command that uses
  random numbers: any non-deterministic command is considered a random command
  (the best example in this regard is the `TIME` command).
* In KeyDB version 4, commands that may return elements in random order, like
  `SMEMBERS` (because KeyDB Sets are _unordered_) have a different behavior
  when called from Lua, and undergo a silent lexicographical sorting filter
  before returning data to Lua scripts. So `KeyDB.call("smembers",KEYS[1])`
  will always return the Set elements in the same order, while the same
  command invoked from normal clients may return different results even if
  the key contains exactly the same elements. However starting with KeyDB 5
  there is no longer such ordering step, because KeyDB 5 replicates scripts
  in a way that no longer needs non-deterministic commands to be converted
  into deterministic ones. In general, even when developing for KeyDB 4, never
  assume that certain commands in Lua will be ordered, but instead rely on
  the documentation of the original command you call to see the properties
  it provides.
* Lua pseudo random number generation functions `math.random` and
  `math.randomseed` are modified in order to always have the same seed every
  time a new script is executed.
  This means that calling `math.random` will always generate the same sequence
  of numbers every time a script is executed if `math.randomseed` is not used.

However the user is still able to write commands with random behavior using the
following simple trick.
Imagine I want to write a KeyDB script that will populate a list with N random
integers.

I can start with this small Ruby program:

```
require 'rubygems'
require 'KeyDB'

r = KeyDB.new

RandomPushScript = <<EOF
    local i = tonumber(ARGV[1])
    local res
    while (i > 0) do
        res = KeyDB.call('lpush',KEYS[1],math.random())
        i = i-1
    end
    return res
EOF

r.del(:mylist)
puts r.eval(RandomPushScript,[:mylist],[10,rand(2**32)])
```

Every time this script executed the resulting list will have exactly the
following elements:

```
> lrange mylist 0 -1
 1) "0.74509509873814"
 2) "0.87390407681181"
 3) "0.36876626981831"
 4) "0.6921941534114"
 5) "0.7857992587545"
 6) "0.57730350670279"
 7) "0.87046522734243"
 8) "0.09637165539729"
 9) "0.74990198051087"
10) "0.17082803611217"
```

In order to make it a pure function, but still be sure that every invocation
of the script will result in different random elements, we can simply add an
additional argument to the script that will be used in order to seed the Lua
pseudo-random number generator.
The new script is as follows:

```
RandomPushScript = <<EOF
    local i = tonumber(ARGV[1])
    local res
    math.randomseed(tonumber(ARGV[2]))
    while (i > 0) do
        res = KeyDB.call('lpush',KEYS[1],math.random())
        i = i-1
    end
    return res
EOF

r.del(:mylist)
puts r.eval(RandomPushScript,1,:mylist,10,rand(2**32))
```

What we are doing here is sending the seed of the PRNG as one of the arguments.
This way the script output will be the same given the same arguments, but we are
changing one of the arguments in every invocation, generating the random seed
client-side.
The seed will be propagated as one of the arguments both in the replication
link and in the Append Only File, guaranteeing that the same changes will be
generated when the AOF is reloaded or when the replica processes the script.

Note: an important part of this behavior is that the PRNG that KeyDB implements
as `math.random` and `math.randomseed` is guaranteed to have the same output
regardless of the architecture of the system running KeyDB.
32-bit, 64-bit, big-endian and little-endian systems will all produce the same
output.

#### Replicating commands instead of scripts

*Note: starting with KeyDB 5, the replication method described in this section (scripts effects replication) is the default and does not need to be explicitly enabled.*

Starting with KeyDB 3.2, it is possible to select an
alternative replication method. Instead of replication whole scripts, we
can just replicate single write commands generated by the script.
We call this **script effects replication**.

In this replication mode, while Lua scripts are executed, KeyDB collects
all the commands executed by the Lua scripting engine that actually modify
the dataset. When the script execution finishes, the sequence of commands
that the script generated are wrapped into a MULTI / EXEC transaction and
are sent to replicas and AOF.

This is useful in several ways depending on the use case:

* When the script is slow to compute, but the effects can be summarized by
a few write commands, it is a shame to re-compute the script on the replicas 
or when reloading the AOF. In this case to replicate just the effect of the
script is much better.
* When script effects replication is enabled, the controls about non
deterministic functions are disabled. You can, for example, use the `TIME`
or `SRANDMEMBER` commands inside your scripts freely at any place.
* The Lua PRNG in this mode is seeded randomly at every call.

In order to enable script effects replication, you need to issue the
following Lua command before any write operated by the script:

    KeyDB.replicate_commands()

The function returns true if the script effects replication was enabled,
otherwise if the function was called after the script already called
some write command, it returns false, and normal whole script replication
is used.

#### Selective replication of commands

When script effects replication is selected (see the previous section), it
is possible to have more control in the way commands are replicated to replicas
and AOF. This is a very advanced feature since **a misuse can do damage** by
breaking the contract that the master, replicas, and AOF, all must contain the
same logical content.

However this is a useful feature since, sometimes, we need to execute certain
commands only in the master in order to create, for example, intermediate
values.

Think at a Lua script where we perform an intersection between two sets.
Pick five random elements, and create a new set with this five random
elements. Finally we delete the temporary key representing the intersection
between the two original sets. What we want to replicate is only the creation
of the new set with the five elements. It's not useful to also replicate the
commands creating the temporary key.

For this reason, KeyDB 3.2 introduces a new command that only works when
script effects replication is enabled, and is able to control the scripting
replication engine. The command is called `KeyDB.set_repl()` and fails raising
an error if called when script effects replication is disabled.

The command can be called with four different arguments:

    KeyDB.set_repl(KeyDB.REPL_ALL) -- Replicate to AOF and replicas.
    KeyDB.set_repl(KeyDB.REPL_AOF) -- Replicate only to AOF.
    KeyDB.set_repl(KeyDB.REPL_REPLICA) -- Replicate only to replicas (KeyDB >= 5)
    KeyDB.set_repl(KeyDB.REPL_SLAVE) -- Used for backward compatibility, the same as REPL_REPLICA.
    KeyDB.set_repl(KeyDB.REPL_NONE) -- Don't replicate at all.

By default the scripting engine is always set to `REPL_ALL`. By calling
this function the user can switch on/off AOF and or replicas propagation, and
turn them back later at her/his wish.

A simple example follows:

    KeyDB.replicate_commands() -- Enable effects replication.
    KeyDB.call('set','A','1')
    KeyDB.set_repl(KeyDB.REPL_NONE)
    KeyDB.call('set','B','2')
    KeyDB.set_repl(KeyDB.REPL_ALL)
    KeyDB.call('set','C','3')

After running the above script, the result is that only keys A and C
will be created on replicas and AOF.

#### Global variables protection

KeyDB scripts are not allowed to create global variables, in order to avoid
leaking data into the Lua state.
If a script needs to maintain state between calls (a pretty uncommon need) it
should use KeyDB keys instead.

When global variable access is attempted the script is terminated and EVAL
returns with an error:

```
KeyDB 127.0.0.1:6379> eval 'a=10' 0
(error) ERR Error running script (call to f_933044db579a2f8fd45d8065f04a8d0249383e57): user_script:1: Script attempted to create global variable 'a'
```

Accessing a _non existing_ global variable generates a similar error.

Using Lua debugging functionality or other approaches like altering the meta
table used to implement global protections in order to circumvent globals
protection is not hard.
However it is difficult to do it accidentally.
If the user messes with the Lua global state, the consistency of AOF and
replication is not guaranteed: don't do it.

Note for Lua newbies: in order to avoid using global variables in your scripts
simply declare every variable you are going to use using the _local_ keyword.

#### Using SELECT inside scripts

It is possible to call `SELECT` inside Lua scripts like with normal clients,
However one subtle aspect of the behavior changes between KeyDB 2.8.11 and
KeyDB 2.8.12. Before the 2.8.12 release the database selected by the Lua
script was *transferred* to the calling script as current database.
Starting from KeyDB 2.8.12 the database selected by the Lua script only
affects the execution of the script itself, but does not modify the database
selected by the client calling the script.

The semantic change between patch level releases was needed since the old
behavior was inherently incompatible with the KeyDB replication layer and
was the cause of bugs.

#### Available libraries

The KeyDB Lua interpreter loads the following Lua libraries:

* `base` lib.
* `table` lib.
* `string` lib.
* `math` lib.
* `struct` lib.
* `cjson` lib.
* `cmsgpack` lib.
* `bitop` lib.
* `KeyDB.sha1hex` function.
* `KeyDB.breakpoint and KeyDB.debug` function in the context of the KeyDB Lua debugger.

Every KeyDB instance is _guaranteed_ to have all the above libraries so you can
be sure that the environment for your KeyDB scripts is always the same.

struct, CJSON and cmsgpack are external libraries, all the other libraries are standard
Lua libraries.

#### struct

struct is a library for packing/unpacking structures within Lua.

```
Valid formats:
> - big endian
< - little endian
![num] - alignment
x - pading
b/B - signed/unsigned byte
h/H - signed/unsigned short
l/L - signed/unsigned long
T   - size_t
i/In - signed/unsigned integer with size `n' (default is size of int)
cn - sequence of `n' chars (from/to a string); when packing, n==0 means
     the whole string; when unpacking, n==0 means use the previous
     read number as the string length
s - zero-terminated string
f - float
d - double
' ' - ignored
```


Example:

```
127.0.0.1:6379> eval 'return struct.pack("HH", 1, 2)' 0
"\x01\x00\x02\x00"
127.0.0.1:6379> eval 'return {struct.unpack("HH", ARGV[1])}' 0 "\x01\x00\x02\x00"
1) (integer) 1
2) (integer) 2
3) (integer) 5
127.0.0.1:6379> eval 'return struct.size("HH")' 0
(integer) 4
```

#### CJSON

The CJSON library provides extremely fast JSON manipulation within Lua.

Example:

```
KeyDB 127.0.0.1:6379> eval 'return cjson.encode({["foo"]= "bar"})' 0
"{\"foo\":\"bar\"}"
KeyDB 127.0.0.1:6379> eval 'return cjson.decode(ARGV[1])["foo"]' 0 "{\"foo\":\"bar\"}"
"bar"
```

#### cmsgpack

The cmsgpack library provides simple and fast MessagePack manipulation within Lua.

Example:

```
127.0.0.1:6379> eval 'return cmsgpack.pack({"foo", "bar", "baz"})' 0
"\x93\xa3foo\xa3bar\xa3baz"
127.0.0.1:6379> eval 'return cmsgpack.unpack(ARGV[1])' 0 "\x93\xa3foo\xa3bar\xa3baz"
1) "foo"
2) "bar"
3) "baz"
```

#### bitop

The Lua Bit Operations Module adds bitwise operations on numbers.
It is available for scripting in KeyDB since version 2.8.18.

Example:

```
127.0.0.1:6379> eval 'return bit.tobit(1)' 0
(integer) 1
127.0.0.1:6379> eval 'return bit.bor(1,2,4,8,16,32,64,128)' 0
(integer) 255
127.0.0.1:6379> eval 'return bit.tohex(422342)' 0
"000671c6"
```

It supports several other functions:
`bit.tobit`, `bit.tohex`, `bit.bnot`, `bit.band`, `bit.bor`, `bit.bxor`,
`bit.lshift`, `bit.rshift`, `bit.arshift`, `bit.rol`, `bit.ror`, `bit.bswap`.
All available functions are documented in the Lua BitOp documentation

#### `KeyDB.sha1hex`

Perform the SHA1 of the input string.

Example:

```
127.0.0.1:6379> eval 'return KeyDB.sha1hex(ARGV[1])' 0 "foo"
"0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33"
```

#### Emitting KeyDB logs from scripts

It is possible to write to the KeyDB log file from Lua scripts using the
`KeyDB.log` function.

```
KeyDB.log(loglevel,message)
```

`loglevel` is one of:

* `KeyDB.LOG_DEBUG`
* `KeyDB.LOG_VERBOSE`
* `KeyDB.LOG_NOTICE`
* `KeyDB.LOG_WARNING`

They correspond directly to the normal KeyDB log levels.
Only logs emitted by scripting using a log level that is equal or greater than
the currently configured KeyDB instance log level will be emitted.

The `message` argument is simply a string.
Example:

```
KeyDB.log(KeyDB.LOG_WARNING,"Something is wrong with this script.")
```

Will generate the following:

```
[32343] 22 Mar 15:21:39 # Something is wrong with this script.
```

#### Sandbox and maximum execution time

Scripts should never try to access the external system, like the file system or
any other system call.
A script should only operate on KeyDB data and passed arguments.

Scripts are also subject to a maximum execution time (five seconds by default).
This default timeout is huge since a script should usually run in under a
millisecond.
The limit is mostly to handle accidental infinite loops created during
development.

It is possible to modify the maximum time a script can be executed with
millisecond precision, either via `keydb.conf` or using the CONFIG GET / CONFIG
SET command.
The configuration parameter affecting max execution time is called
`lua-time-limit`.

When a script reaches the timeout it is not automatically terminated by KeyDB
since this violates the contract KeyDB has with the scripting engine to ensure
that scripts are atomic.
Interrupting a script means potentially leaving the dataset with half-written
data.
For this reasons when a script executes for more than the specified time the
following happens:

* KeyDB logs that a script is running too long.
* It starts accepting commands again from other clients, but will reply with a
  BUSY error to all the clients sending normal commands.
  The only allowed commands in this status are `SCRIPT KILL` and `SHUTDOWN
  NOSAVE`.
* It is possible to terminate a script that executes only read-only commands
  using the `SCRIPT KILL` command.
  This does not violate the scripting semantic as no data was yet written to the
  dataset by the script.
* If the script already called write commands the only allowed command becomes
  `SHUTDOWN NOSAVE` that stops the server without saving the current data set on
  disk (basically the server is aborted).

#### EVALSHA in the context of pipelining

Care should be taken when executing `EVALSHA` in the context of a pipelined
request, since even in a pipeline the order of execution of commands must be
guaranteed.
If `EVALSHA` will return a `NOSCRIPT` error the command can not be reissued
later otherwise the order of execution is violated.

The client library implementation should take one of the following approaches:

*   Always use plain `EVAL` when in the context of a pipeline.

*   Accumulate all the commands to send into the pipeline, then check for `EVAL`
    commands and use the `SCRIPT EXISTS` command to check if all the scripts are
    already defined.
    If not, add `SCRIPT LOAD` commands on top of the pipeline as required, and
    use `EVALSHA` for all the `EVAL` calls.

#### Debugging Lua scripts

Starting with KeyDB 3.2, KeyDB has support for native
Lua debugging. The KeyDB Lua debugger is a remote debugger consisting of
a server, which is KeyDB itself, and a client, which is by default `keydb-cli`.

The Lua debugger is described in the Lua scripts debugging document of the Troubleshooting section of the KeyDB documentation.

---





## EVALSHA

**Related Commands:** [EVAL](/docs/commands/#eval), [EVALSHA](/docs/commands/#evalsha), [SCRIPT DEBUG](/docs/commands/#script-debug), [SCRIPT EXISTS](/docs/commands/#script-exists), [SCRIPT FLUSH](/docs/commands/#script-flush), [SCRIPT KILL](/docs/commands/#script-kill), [SCRIPT LOAD](/docs/commands/#script-load)

Evaluates a script cached on the server side by its SHA1 digest.
Scripts are cached on the server side using the `SCRIPT LOAD` command.
The command is otherwise identical to `EVAL`.

---




## EXEC

**Related Commands:** [DISCARD](/docs/commands/#discard), [EXEC](/docs/commands/#exec), [MULTI](/docs/commands/#multi), [UNWATCH](/docs/commands/#unwatch), [WATCH](/docs/commands/#watch)

Executes all previously queued commands in a transaction and restores the
connection state to normal.

When using `WATCH`, `EXEC` will execute commands only if the watched keys were
not modified, allowing for a check-and-set mechanism

#### Return:

Array Reply: each element being the reply to each of the commands in the
atomic transaction.

When using `WATCH`, `EXEC` can return a nil-reply if the execution was aborted.

#### Examples:

```
keydb-cli> MULTI
OK
keydb-cli> SET KEY 1
QUEUED
keydb-cli> GET KEY
QUEUED
keydb-cli> EXEC
1) OK
2) "1"
```

---



## EXISTS

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```EXISTS <key>```

#### Description:

Returns if `key` exists.

Since KeyDB 3.0.3 it is possible to specify multiple keys instead of a single one. In such a case, it returns the total number of keys existing. Note that returning 1 or 0 for a single key is just a special case of the variadic usage, so the command is completely backward compatible.

The user should be aware that if the same existing key is mentioned in the arguments multiple times, it will be counted multiple times. So if `somekey` exists, `EXISTS somekey somekey` will return 2.

#### Return:

Integer Reply, specifically:

* `1` if the key exists.
* `0` if the key does not exist.

Since KeyDB 3.0.3 the command accepts a variable number of keys and the return value is generalized:

* The number of keys existing among the ones specified as arguments. Keys mentioned multiple times and existing are counted multiple times.

#### Examples:

```
keydb-cli> SET key1 "Hello"
OK
keydb-cli> EXISTS key1
(integer) 1
keydb-cli> EXISTS nosuchkey
(integer) 0
keydb-cli> SET key2 "World"
OK
keydb-cli> EXISTS key1 key2 nosuchkey
(integer) 2
```
---



## EXPIRE

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)


#### Syntax:

```EXPIRE <key> <timeout-in-seconds>```

#### Description: 

Set a timeout on `key`.
After the timeout has expired, the key will automatically be deleted.
A key with an associated timeout is often said to be _volatile_ in KeyDB
terminology.

The timeout will only be cleared by commands that delete or overwrite the
contents of the key, including `DEL`, `SET`, `GETSET` and all the `*STORE`
commands.
This means that all the operations that conceptually _alter_ the value stored at
the key without replacing it with a new one will leave the timeout untouched.
For instance, incrementing the value of a key with `INCR`, pushing a new value
into a list with `LPUSH`, or altering the field value of a hash with `HSET` are
all operations that will leave the timeout untouched.

The timeout can also be cleared, turning the key back into a persistent key,
using the `PERSIST` command.

If a key is renamed with `RENAME`, the associated time to live is transferred to
the new key name.

If a key is overwritten by `RENAME`, like in the case of an existing key `Key_A`
that is overwritten by a call like `RENAME Key_B Key_A`, it does not matter if
the original `Key_A` had a timeout associated or not, the new key `Key_A` will
inherit all the characteristics of `Key_B`.

Note that calling `EXPIRE`/`PEXPIRE` with a non-positive timeout or
`EXPIREAT`/`PEXPIREAT` with a time in the past will result in the key being
deleted rather than expired (accordingly, the emitted key event]
will be `del`, not `expired`).


#### Refreshing expires

It is possible to call `EXPIRE` using as argument a key that already has an
existing expire set.
In this case the time to live of a key is _updated_ to the new value.
There are many useful applications for this, an example is documented in the
_Navigation session_ pattern section below.

#### Return:

Integer Reply, specifically:

* `1` if the timeout was set.
* `0` if `key` does not exist.

#### Examples:

```
keydb-cli> SET mykey "Hello"
OK
keydb-cli> EXPIRE mykey 10
(integer) 1
keydb-cli> TTL mykey
(integer) 10
keydb-cli> EXPIRE thiskeydoesnotexist 10
(integer) 0
keydb-cli> SET mykey "Hello World"
OK
keydb-cli> TTL mykey
(integer) -1
```

#### Pattern: Navigation session

Imagine you have a web service and you are interested in the latest N pages
_recently_ visited by your users, such that each adjacent page view was not
performed more than 60 seconds after the previous.
Conceptually you may consider this set of page views as a _Navigation session_
of your user, that may contain interesting information about what kind of
products he or she is looking for currently, so that you can recommend related
products.

You can easily model this pattern in KeyDB using the following strategy: every
time the user does a page view you call the following commands:

```
keydb-cli> MULTI
keydb-cli> RPUSH pagewviews.user:<userid> http://.....
keydb-cli> EXPIRE pagewviews.user:<userid> 60
keydb-cli> EXEC
```

If the user will be idle more than 60 seconds, the key will be deleted and only
subsequent page views that have less than 60 seconds of difference will be
recorded.

This pattern is easily modified to use counters using `INCR` instead of lists
using `RPUSH`.

#### Appendix: KeyDB expires

#### Keys with an expire

Normally KeyDB keys are created without an associated time to live.
The key will simply live forever, unless it is removed by the user in an
explicit way, for instance using the `DEL` command.

The `EXPIRE` family of commands is able to associate an expire to a given key,
at the cost of some additional memory used by the key.
When a key has an expire set, KeyDB will make sure to remove the key when the
specified amount of time elapsed.

The key time to live can be updated or entirely removed using the `EXPIRE` and
`PERSIST` command (or other strictly related commands).

#### Expire accuracy

KeyDB the expire error is from 0 to 1 milliseconds.

#### Expires and persistence

Keys expiring information is stored as absolute Unix timestamps (in milliseconds)
This means that the time is flowing even when the KeyDB instance is not active.

For expires to work well, the computer time must be taken stable.
If you move an RDB file from two computers with a big desync in their clocks,
funny things may happen (like all the keys loaded to be expired at loading
time).

Even running instances will always check the computer clock, so for instance if
you set a key with a time to live of 1000 seconds, and then set your computer
time 2000 seconds in the future, the key will be expired immediately, instead of
lasting for 1000 seconds.

#### How KeyDB expires keys

KeyDB keys are expired in two ways: a passive way, and an active way.

A key is passively expired simply when some client tries to access it, and the
key is found to be timed out.

Of course this is not enough as there are expired keys that will never be
accessed again.
These keys should be expired anyway, so KeyDB actively seeks these out in a deterministic 
algorithm. This results in expired keys being deleted in very close to real time. 
KeyDB searches for expired keys in O(N) time and results in a very consistent deletion time
regardless of the number of expires where TTL>0. Prior to v5.1 a randomized algorithm was used
and overdue expires could build up significantly with potentially long delays in certain scenarios. Since
v5.1, expires also use up less memory. 

Take a look at [this article](https://docs.keydb.dev/blog/2019/10/21/blog-post/) to learn more about how v5.1 EXPIRE 
has major advantages over past versions 

#### How expires are handled in the replication link and AOF file

In order to obtain a correct behavior without sacrificing consistency, when a
key expires, a `DEL` operation is synthesized in both the AOF file and gains all
the attached replicas nodes.
This way the expiration process is centralized in the master instance, and there
is no chance of consistency errors.

However while the replicas connected to a master will not expire keys
independently (but will wait for the `DEL` coming from the master), they'll
still take the full state of the expires existing in the dataset, so when a
replica is elected to master it will be able to expire the keys independently,
fully acting as a master.

---



## EXPIREAT

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax :

```EXPIREAT <key> <expiration-timestamp>```

#### Descripition:

`EXPIREAT` has the same effect and semantic as `EXPIRE`, but instead of
specifying the number of seconds representing the TTL (time to live), it takes
an absolute [Unix timestamp](http://en.wikipedia.org/wiki/Unix_time) (seconds since January 1, 1970). A
timestamp in the past will delete the key immediately.

Please for the specific semantics of the command refer to the documentation of
`EXPIRE`.

#### Background

`EXPIREAT` was introduced in order to convert relative timeouts to absolute
timeouts for the AOF persistence mode.
Of course, it can be used directly to specify that a given key should expire at
a given time in the future.

#### Return:

Integer Reply, specifically:

* `1` if the timeout was set.
* `0` if `key` does not exist.

#### Examples:

```
keydb-cli> SET mykey "Hello"
OK
keydb-cli> EXISTS mykey
(integer) 1
keydb-cli> EXPIREAT mykey 1293840000
(integer) 1
keydb-cli> EXISTS mykey
(integer) 1
```
---

## EXPIREMEMBER

#### Syntax:

```EXPIRE <key> <subkey> <timeout-in-seconds> <OPTIONAL:unit-time-format>```

#### Description:

Sets a timeout on a subkey (individual member of a set).

After the timeout has expired, the subkey will automatically be deleted. This 
command is similar to the EXPIRE command but is associated to individual members
of a set. 

If a subkey has an expiration set and is later moved or deleted before expiry, 
then the expiration behavior is undefined. Examples of this may include `SMOVE and SADD`.

The timeout can also be cleared, turning the subkey back into a persistent subkey,
using the `PERSIST` command.

TTL (time to live) is by default set in seconds, however you can optionally specify the unit to milleseconds 
The command format is `EXPIREMEMBER key subkey delay [Unit: s,ms]`. This time similar to EXPIRE can be queried with TTL and PTTL

#### Refreshing expires

It is possible to call `EXPIREMEMBER` using as argument a subkey that already has an
existing expire set.
In this case the time to live of a subkey is _updated_ to the new value.

#### Return:

Integer Reply, specifically:

* `1` if the timeout was set.
* `0` if `key` does not exist.

#### Examples:

```
keydb-cli> SADD key member1 member2 member3
(integer) 3
keydb-cli> SMEMBERS key
1) "member1"
2) "member2"
3) "member3"
keydb-cli> EXPIREMEMBER key member1 10
(integer) 1
keydb-cli> TTL key member1
(integer) 10
keydb-cli> EXPIREMEMBER key member1 10000 ms
(integer) 1
keydb-cli> TTL key member1
(integer) 10
```
*10 seconds later...*
```
keydb-cli> SMEMBERS key
1) "member2"
2) "member3"
keydb-cli> EXPIREMEMBER key member1 10
(error) ERR subkey does not exist
```

---

## EXPIREMEMBERAT

#### Syntax:

```EXPIREMEMBERAT <key> <subkey> <expiration-timestamp>```

#### Descripition:

`EXPIREMEMBERAT` has the same effect and semantic as `EXPIREMEMBER`, but instead of
specifying the number of seconds representing the TTL (time to live), it takes
an absolute [Unix timestamp] (seconds since January 1, 1970). A
timestamp in the past will delete the key immediately.

http://en.wikipedia.org/wiki/Unix_time

#### Return:

Integer Reply, specifically:

* `OK` if the timeout was set.
* `(error) ERR subkey does not exist` if `subkey` does not exist.

#### Examples:

```
keydb-cli> SADD key member1 member2 member3
OK
keydb-cli> EXPIREMEMBERAT key member1 1571068620
OK
```
---

## FLUSHALL

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

Delete all the keys of all the existing databases, not just the currently
selected one.
This command never fails.

The time-complexity for this operation is O(N), N being the number of
keys in all existing databases.

`FLUSHALL ASYNC` (KeyDB 4.0.0 or greater)

KeyDB is now able to delete keys in the background in a different thread without blocking the server.
An `ASYNC` option was added to `FLUSHALL` and `FLUSHDB` in order to let the entire dataset or a single database to be freed asynchronously.

#### Return:

Simple String Reply

---




## FLUSHDB

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

Delete all the keys of the currently selected DB.
This command never fails.

The time-complexity for this operation is O(N), N being the number of
keys in the database.

`FLUSHDB ASYNC` (KeyDB 4.0.0 or greater)

See `FLUSHALL` for documentation.

#### Return:

Simple String Reply

---



## GEOADD

**Related Commands:** [GEOADD](/docs/commands/#geoadd), [GEODIST](/docs/commands/#geodist), [GEOHASH](/docs/commands/#geohash), [GEOPOS](/docs/commands/#geopos), [GEORADIUS](/docs/commands/#georadius), [GEORADIUSBYMEMBER](/docs/commands/#georadiusbymember)

#### Syntax:

```GEOADD <key> <longitude-1> <latitude-1> <name-1> ... <longitude-n> <latitude-n> <name-n>```

#### Descripition:

Adds the specified geospatial items (latitude, longitude, name) to the specified
key. Data is stored into the key as a sorted set, in a way that makes it possible to later retrieve items using a query by radius with the `GEORADIUS` or `GEORADIUSBYMEMBER` commands.

The command takes arguments in the standard format x,y so the longitude must
be specified before the latitude. There are limits to the coordinates that
can be indexed: areas very near to the poles are not indexable. The exact
limits, as specified by EPSG:900913 / EPSG:3785 / OSGEO:41001 are the following:

* Valid longitudes are from -180 to 180 degrees.
* Valid latitudes are from -85.05112878 to 85.05112878 degrees.

The command will report an error when the user attempts to index coordinates outside the specified ranges.

**LIMITATION:** there is no **GEODEL** command because you can use `ZREM` in order to remove elements. The Geo index structure is just a sorted set.

#### How does it work?

The way the sorted set is populated is using a technique called
Geohash. Latitude and Longitude
bits are interleaved in order to form an unique 52 bit integer. We know
that a sorted set double score can represent a 52 bit integer without losing
precision.

This format allows for radius querying by checking the 1+8 areas needed
to cover the whole radius, and discarding elements outside the radius.
The areas are checked by calculating the range of the box covered removing
enough bits from the less significant part of the sorted set score, and
computing the score range to query in the sorted set for each area.

#### What Earth model does it use?

It just assumes that the Earth is a sphere, since the used distance formula
is the Haversine formula. This formula is only an approximation when applied to the Earth, which is not a perfect sphere. The introduced errors are not an issue when used in the context of social network sites that need to query by radius
and most other applications. However in the worst case the error may be up to
0.5%, so you may want to consider other systems for error-critical applications.

#### Return:

Integer Reply, specifically:

* The number of elements added to the sorted set, not including elements
  already existing for which the score was updated.

#### Examples:

```
keydb-cli> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
keydb-cli> GEODIST Sicily Palermo Catania
"166274.1516"
keydb-cli> GEORADIUS Sicily 15 37 100 km
1) "Catania"
keydb-cli> GEORADIUS Sicily 15 37 200 km
1) "Palermo"
2) "Catania"
```

---




## GEODECODE

**Related Commands:** [GEOADD](/docs/commands/#geoadd), [GEODIST](/docs/commands/#geodist), [GEOHASH](/docs/commands/#geohash), [GEOPOS](/docs/commands/#geopos), [GEORADIUS](/docs/commands/#georadius), [GEORADIUSBYMEMBER](/docs/commands/#georadiusbymember)

#### Syntax: 

```GEOCODE <52-bit-integer>```

#### Description:

Geospatial KeyDB commands encode positions of objects in a single 52 bit integer, using a technique called geohash. Those 52 bit integers are:

1. Returned by `GEOAENCODE` as return value.
2. Used by `GEOADD` as sorted set scores of members.

The `GEODECODE` command is able to translate the 52 bit integers back into a position expressed as longitude and latitude. The command also returns the corners of the box that the 52 bit integer identifies on the earth surface, since each 52 integer actually represent not a single point, but a small area.

This command usefulness is limited to the rare situations where you want to
fetch raw data from the sorted set, for example with `ZRANGE`, and later
need to decode the scores into positions. The other obvious use is debugging.

#### Return:

Array Reply, specifically:

The command returns an array of three elements. Each element of the main array is an array of two elements, specifying a longitude and a latitude. So the returned value is in the following form:

* center-longitude, center-latitude
* min-longitude, min-latitude
* max-longitude, max-latitude

#### Examples:

```
keydb-cli> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
keydb-cli> ZSCORE Sicily "Palermo"
"3479099956230698"
keydb-cli> GEODECODE 3479099956230698
```
---




## GEODIST

**Related Commands:** [GEOADD](/docs/commands/#geoadd), [GEODIST](/docs/commands/#geodist), [GEOHASH](/docs/commands/#geohash), [GEOPOS](/docs/commands/#geopos), [GEORADIUS](/docs/commands/#georadius), [GEORADIUSBYMEMBER](/docs/commands/#georadiusbymember)

#### Syntax:

```GEODIST <key> <member-1> <member-2> <OPTIONAL:distance-unit>```

#### Description:

Return the distance between two members in the geospatial index represented by the sorted set.

Given a sorted set representing a geospatial index, populated using the `GEOADD` command, the command returns the distance between the two specified members in the specified unit.

If one or both the members are missing, the command returns NULL.

The unit must be one of the following, and defaults to meters:

* **m** for meters.
* **km** for kilometers.
* **mi** for miles.
* **ft** for feet.

The distance is computed assuming that the Earth is a perfect sphere, so errors up to 0.5% are possible in edge cases.

#### Return:

Bulk String Reply, specifically:

The command returns the distance as a double (represented as a string)
in the specified unit, or NULL if one or both the elements are missing.

#### Examples:

```
keydb-cli> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
keydb-cli> GEODIST Sicily Palermo Catania
"166274.1516"
keydb-cli> GEODIST Sicily Palermo Catania km
"166.2742"
keydb-cli> GEODIST Sicily Palermo Catania mi
"103.3182"
keydb-cli> GEODIST Sicily Foo Bar
(nil)
```

---




## GEOENCODE

**Related Commands:** [GEOADD](/docs/commands/#geoadd), [GEODIST](/docs/commands/#geodist), [GEOHASH](/docs/commands/#geohash), [GEOPOS](/docs/commands/#geopos), [GEORADIUS](/docs/commands/#georadius), [GEORADIUSBYMEMBER](/docs/commands/#georadiusbymember)

#### Syntax:

```GEOENCODE <longitude> <latitude> <OPTIONAL:radius> <OPTIONAL:distance-unit>```

#### Descripition:

Geospatial KeyDB commands encode positions of objects in a single 52 bit integer, using a technique called geohash. The encoding is further explained in the `GEODECODE` and `GEOADD` documentation. The `GEOENCODE` command, documented in this page, is able to convert a longitude and latitude pair into such 52 bit integer, which is used as the *score* for the sorted set members representing geopositional information.

Normally you don't need to use this command, unless you plan to implement low level code in the client side interacting with the KeyDB geo commands. This command may also be useful for debugging purposes.

`GEOENCODE` takes as input:

1. The longitude and latitude of a point on the Earth surface.
2. Optionally a radius represented by an integer and an unit.

And returns a set of information, including the representation of the position as a 52 bit integer, the min and max corners of the bounding box represented by the geo hash, the center point in the area covered by the geohash integer, and finally the two sorted set scores to query in order to retrieve all the elements included in the geohash area.

The radius optionally provided to the command is used in order to compute the two scores returned by the command for range query purposes. Moreover the returned geohash integer will only have the most significant bits set, according to the number of bits needed to approximate the specified radius.

#### Use case


As already specified this command is mostly not needed if not for debugging. However there are actual use cases, which is, when there is to query for the same areas multiple times, or with a different granularity or area shape compared to what KeyDB `GEORADIUS` is able to provide, the client may implement using this command part of the logic on the client side. Score ranges representing given areas can be cached client side and used to retrieve elements directly using `ZRANGEBYSCORE`.

#### Return:

Array Reply, specifically:

The command returns an array of give elements in the following order:

* The 52 bit geohash
* min-longitude, min-latitude of the area identified
* max-longitude, max-latitude of the area identified
* center-longitude, center-latitude
* min-score and max-score of the sorted set to retrieve the members inside the area

#### Examples:

```
keydb-cli> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
keydb-cli> ZSCORE Sicily "Palermo"
"3479099956230698"
keydb-cli> GEOENCODE 13.361389 38.115556 100 km
```
---




## GEOHASH

**Related Commands:** [GEOADD](/docs/commands/#geoadd), [GEODIST](/docs/commands/#geodist), [GEOHASH](/docs/commands/#geohash), [GEOPOS](/docs/commands/#geopos), [GEORADIUS](/docs/commands/#georadius), [GEORADIUSBYMEMBER](/docs/commands/#georadiusbymember)


#### Syntax:

```GEOHASH <key> <member-1> ... <member-n>```

#### Description:

Return valid [Geohash](https://en.wikipedia.org/wiki/Geohash) strings representing the position of one or more elements in a sorted set value representing a geospatial index (where elements were added using `GEOADD`).

Normally KeyDB represents positions of elements using a variation of the Geohash
technique where positions are encoded using 52 bit integers. The encoding is
also different compared to the standard because the initial min and max
coordinates used during the encoding and decoding process are different. This
command however **returns a standard Geohash** in the form of a string as
described in the [Wikipedia article](https://en.wikipedia.org/wiki/Geohash) and compatible with the [geohash.org](http://geohash.org) web site.

#### Geohash string properties


The command returns 11 characters Geohash strings, so no precision is loss
compared to the KeyDB internal 52 bit representation. The returned Geohashes
have the following properties:

1. They can be shortened removing characters from the right. It will lose precision but will still point to the same area.
2. It is possible to use them in `geohash.org` URLs such as `http://geohash.org/<geohash-string>`. This is an [example of such URL](http://geohash.org/sqdtr74hyu0).
3. Strings with a similar prefix are nearby, but the contrary is not true, it is possible that strings with different prefixes are nearby too.

#### Return:

Array Reply, specifically:

The command returns an array where each element is the Geohash corresponding to
each member name passed as argument to the command.

#### Examples:

```
keydb-cli> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
keydb-cli> GEOHASH Sicily Palermo Catania
1) "sqc8b49rny0"
2) "sqdtr74hyu0"
```

---





## GEOPOS

**Related Commands:** [GEOADD](/docs/commands/#geoadd), [GEODIST](/docs/commands/#geodist), [GEOHASH](/docs/commands/#geohash), [GEOPOS](/docs/commands/#geopos), [GEORADIUS](/docs/commands/#georadius), [GEORADIUSBYMEMBER](/docs/commands/#georadiusbymember)


#### Syntax

```GEOPOS <key> <member-1> ... <member-n>```

#### Description:

Return the positions (longitude,latitude) of all the specified members of the geospatial index represented by the sorted set at *key*.

Given a sorted set representing a geospatial index, populated using the `GEOADD` command, it is often useful to obtain back the coordinates of specified members. When the geospatial index is populated via `GEOADD` the coordinates are converted into a 52 bit geohash, so the coordinates returned may not be exactly the ones used in order to add the elements, but small errors may be introduced.

The command can accept a variable number of arguments so it always returns an array of positions even when a single element is specified.

#### Return:

Array Reply, specifically:

The command returns an array where each element is a two elements array
representing longitude and latitude (x,y) of each member name passed as
argument to the command.

Non existing elements are reported as NULL elements of the array.

#### Examples:

```
keydb-cli> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
keydb-cli> GEOPOS Sicily Palermo Catania NonExisting
1) 1) "13.36138933897018433"
   2) "38.11555639549629859"
2) 1) "15.08726745843887329"
   2) "37.50266842333162032"
3) (nil)
```

---





## GEORADIUS

**Related Commands:** [GEOADD](/docs/commands/#geoadd), [GEODIST](/docs/commands/#geodist), [GEOHASH](/docs/commands/#geohash), [GEOPOS](/docs/commands/#geopos), [GEORADIUS](/docs/commands/#georadius), [GEORADIUSBYMEMBER](/docs/commands/#georadiusbymember)

#### Syntax:

```GEORADIUS <key> <longitude> <latitude> <radius> <distance-unit:m|km|ft|mi> <OPTIONAL:WITHDIST> <OPTIONAL:WITHCOORD> <OPTIONAL:WITHHASH>```

#### Description:

Return the members of a sorted set populated with geospatial information using `GEOADD`, which are within the borders of the area specified with the center location and the maximum distance from the center (the radius).

This manual page also covers the `GEORADIUS_RO` and `GEORADIUSBYMEMBER_RO` variants (see the section below for more information).

The common use case for this command is to retrieve geospatial items near a specified point not farther than a given amount of meters (or other units). This allows, for example, to suggest mobile users of an application nearby places.

The radius is specified in one of the following units:

* **m** for meters.
* **km** for kilometers.
* **mi** for miles.
* **ft** for feet.

The command optionally returns additional information using the following options:

* `WITHDIST`: Also return the distance of the returned items from the specified center. The distance is returned in the same unit as the unit specified as the radius argument of the command.
* `WITHCOORD`: Also return the longitude,latitude coordinates of the matching items.
* `WITHHASH`: Also return the raw geohash-encoded sorted set score of the item, in the form of a 52 bit unsigned integer. This is only useful for low level hacks or debugging and is otherwise of little interest for the general user.

The command default is to return unsorted items. Two different sorting methods can be invoked using the following two options:

* `ASC`: Sort returned items from the nearest to the farthest, relative to the center.
* `DESC`: Sort returned items from the farthest to the nearest, relative to the center.

By default all the matching items are returned. It is possible to limit the results to the first N matching items by using the **COUNT `<count>`** option. However note that internally the command needs to perform an effort proportional to the number of items matching the specified area, so to query very large areas with a very small `COUNT` option may be slow even if just a few results are returned. On the other hand `COUNT` can be a very effective way to reduce bandwidth usage if normally just the first results are used.

#### Return:

Array Reply, specifically:

* Without any `WITH` option specified, the command just returns a linear array like ["New York","Milan","Paris"].
* If `WITHCOORD`, `WITHDIST` or `WITHHASH` options are specified, the command returns an array of arrays, where each sub-array represents a single item.

When additional information is returned as an array of arrays for each item, the first item in the sub-array is always the name of the returned item. The other information is returned in the following order as successive elements of the sub-array.

1. The distance from the center as a floating point number, in the same unit specified in the radius.
2. The geohash integer.
3. The coordinates as a two items x,y array (longitude,latitude).

So for example the command `GEORADIUS Sicily 15 37 200 km WITHCOORD WITHDIST` will return each item in the following way:

    ["Palermo","190.4424",["13.361389338970184","38.115556395496299"]]

#### Read only variants

Since `GEORADIUS` and `GEORADIUSBYMEMBER` have a `STORE` and `STOKeyDBT` option they are technically flagged as writing commands in the KeyDB command table. For this reason read-only replicas will flag them, and KeyDB Cluster replicas will redirect them to the master instance even if the connection is in read only mode (See the `READONLY` command of KeyDB Cluster).

Breaking the compatibility with the past was considered but rejected, at least for KeyDB 4.0, so instead two read only variants of the commands were added. They are exactly like the original commands but refuse the `STORE` and `STOKeyDBT` options. The two variants are called `GEORADIUS_RO` and `GEORADIUSBYMEMBER_RO`, and can safely be used in replicas.

Both commands were introduced in KeyDB 3.2.10 and KeyDB 4.0.0 respectively.

#### Examples:

```
keydb-cli> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
keydb-cli> GEORADIUS Sicily 15 37 200 km WITHDIST
1) 1) "Palermo"
   2) "190.4424"
2) 1) "Catania"
   2) "56.4413"
keydb-cli> GEORADIUS Sicily 15 37 200 km WITHCOORD
1) 1) "Palermo"
   2) 1) "13.36138933897018433"
      2) "38.11555639549629859"
2) 1) "Catania"
   2) 1) "15.08726745843887329"
      2) "37.50266842333162032"
keydb-cli> GEORADIUS Sicily 15 37 200 km WITHDIST WITHCOORD
1) 1) "Palermo"
   2) "190.4424"
   3) 1) "13.36138933897018433"
      2) "38.11555639549629859"
2) 1) "Catania"
   2) "56.4413"
   3) 1) "15.08726745843887329"
      2) "37.50266842333162032
```

---




## GEORADIUSBYMEMBER

**Related Commands:** [GEOADD](/docs/commands/#geoadd), [GEODIST](/docs/commands/#geodist), [GEOHASH](/docs/commands/#geohash), [GEOPOS](/docs/commands/#geopos), [GEORADIUS](/docs/commands/#georadius), [GEORADIUSBYMEMBER](/docs/commands/#georadiusbymember)

#### Syntax:

```GEORADIUSBYMEMBER <key> <member> <radius> <distance-unit:m|km|ft|mi> <OPTIONAL:WITHDIST> <OPTIONAL:WITHCOORD> <OPTIONAL:WITHHASH>```

#### Description:

This command is exactly like `GEORADIUS` with the sole difference that instead
of taking, as the center of the area to query, a longitude and latitude value, it takes the name of a member already existing inside the geospatial index represented by the sorted set.

The position of the specified member is used as the center of the query.

Please check the example below and the `GEORADIUS` documentation for more information about the command and its options.

Note that `GEORADIUSBYMEMBER_RO` is also available since KeyDB 3.2.10 and KeyDB 4.0.0 in order to provide a read-only command that can be used in replicas. See the `GEORADIUS` page for more information.

#### Examples:

```
keydb-cli> GEOADD Sicily 13.583333 37.316667 "Agrigento"
(integer) 1
keydb-cli> GEOADD Sicily 13.361389 38.115556 "Palermo" 15.087269 37.502669 "Catania"
(integer) 2
keydb-cli> GEORADIUSBYMEMBER Sicily Agrigento 100 km
1) "Agrigento"
2) "Palermo"
```
---




## GET

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```GET <key>```

#### Description:

Get the value of `key`.
If the key does not exist the special value `nil` is returned.
An error is returned if the value stored at `key` is not a string, because `GET`
only handles string values.

#### Return:

Bulk String Reply: the value of `key`, or `nil` when `key` does not exist.

#### Examples:

```
keydb-cli> GET nonexisting
(nil)
keydb-cli> SET mykey "Hello"
OK
keydb-cli> GET mykey
"Hello"
```

---




## GETBIT

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```GETBIT <key> <offset>```

#### Description:

Returns the bit value at _offset_ in the string value stored at _key_.

When _offset_ is beyond the string length, the string is assumed to be a
contiguous space with 0 bits.
When _key_ does not exist it is assumed to be an empty string, so _offset_ is
always out of range and the value is also assumed to be a contiguous space with
0 bits.

#### Return:

Integer Reply: the bit value stored at _offset_.

#### Examples:

```
keydb-cli> SETBIT mykey 7 1
(integer) 0
keydb-cli> GETBIT mykey 0
(integer) 0
keydb-cli> GETBIT mykey 7
(integer) 1
keydb-cli> GETBIT mykey 100
(integer) 0
```
---




## GETRANGE

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```GETRANGE <key> <start> <end>```

#### Description:

**Warning**: this command was renamed to `GETRANGE`, it is called `SUBSTR` in
KeyDB versions `<= 2.0`.

Returns the substring of the string value stored at `key`, determined by the
offsets `start` and `end` (both are inclusive).
Negative offsets can be used in order to provide an offset starting from the end
of the string.
So -1 means the last character, -2 the penultimate and so forth.

The function handles out of range requests by limiting the resulting range to
the actual length of the string.

#### Return:

Bulk String Reply

#### Examples:

```
keydb-cli> SET mykey "This is a string"
OK
keydb-cli> GETRANGE mykey 0 3
"This"
keydb-cli> GETRANGE mykey -3 -1
"ing"
keydb-cli> GETRANGE mykey 0 -1
"This is a string"
keydb-cli> GETRANGE mykey 10 100
"string"
```
---





## GETSET

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```GETSET <key> <value>```

#### Description:

Atomically sets `key` to `value` and returns the old value stored at `key`.
Returns an error when `key` exists but does not hold a string value.

#### Design pattern

`GETSET` can be used together with `INCR` for counting with atomic reset.
For example: a process may call `INCR` against the key `mycounter` every time
some event occurs, but from time to time we need to get the value of the counter
and reset it to zero atomically.
This can be done using `GETSET mycounter "0"`:

```
keydb-cli> INCR mycounter
(integer) 1
keydb-cli> GETSET mycounter "0"
"1"
keydb-cli> GET mycounter
"0"
```

#### Return:

Bulk String Reply: the old value stored at `key`, or `nil` when `key` did not exist.

#### Examples:

```
keydb-cli> SET mykey "Hello"
OK
keydb-cli> GETSET mykey "World"
"Hello"
keydb-cli> GET mykey
"World"
```

---




## HDEL

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)

#### Syntax:

```HDEL <key> <field-1> ..  <field-n>```

#### Description:

Removes the specified fields from the hash stored at `key`.
Specified fields that do not exist within this hash are ignored.
If `key` does not exist, it is treated as an empty hash and this command returns
`0`.

#### Return:

Integer Reply: the number of fields that were removed from the hash, not
including specified but non existing fields.


#### Examples:

```
keydb-cli> HSET myhash field1 "foo"
(integer) 1
keydb-cli> HDEL myhash field1
(integer) 1
keydb-cli> HDEL myhash field2
(integer) 0
```
---




## HEXISTS

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)

#### Syntax:

```HEXISTS <key> <field>```

#### Description:

Returns if `field` is an existing field in the hash stored at `key`.

#### Return:

Integer Reply, specifically:

* `1` if the hash contains `field`.
* `0` if the hash does not contain `field`, or `key` does not exist.

#### Examples:

```
keydb-cli> HSET myhash field1 "foo"
(integer) 1
keydb-cli> HEXISTS myhash field1
(integer) 1
keydb-cli> HEXISTS myhash field2
(integer) 0
```
---




## HGET

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)

Returns the value associated with `field` in the hash stored at `key`.

#### Syntax:

```HGET <key> <field>```

#### Return:

Bulk String Reply: the value associated with `field`, or `nil` when `field` is not
present in the hash or `key` does not exist.

#### Examples:

```
keydb-cli> HSET myhash field1 "foo"
(integer) 1
keydb-cli> HGET myhash field1
"foo"
keydb-cli> HGET myhash field2
(nil)
```
---




## HGETALL

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)


#### Syntax:

```HGETALL <key>```

#### Description:

Returns all fields and values of the hash stored at `key`.
In the returned value, every field name is followed by its value, so the length
of the reply is twice the size of the hash.

#### Return:

Array Reply: list of fields and their values stored in the hash, or an
empty list when `key` does not exist.

#### Examples:

```
keydb-cli> HSET myhash field1 "Hello"
(integer) 1
keydb-cli> HSET myhash field2 "World"
(integer) 1
keydb-cli> HGETALL myhash
1) "field1"
2) "Hello"
3) "field2"
4) "World" 
```

---




## HINCRBY

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)

#### Syntax:

```HINCRBY <key> <field> <increment>```

#### Description:

Increments the number stored at `field` in the hash stored at `key` by
`increment`.
If `key` does not exist, a new key holding a hash is created.
If `field` does not exist the value is set to `0` before the operation is
performed.

The range of values supported by `HINCRBY` is limited to 64 bit signed integers.

#### Return:

Integer Reply: the value at `field` after the increment operation.

#### Examples:

Since the `increment` argument is signed, both increment and decrement
operations can be performed:

```
keydb-cli> HSET myhash field 5
(integer) 1
keydb-cli> HINCRBY myhash field 1
(integer) 6
keydb-cli> HINCRBY myhash field -1
(integer) 5
keydb-cli> HINCRBY myhash field -10
(integer) -5
```

---




## HINCRBYFLOAT

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)


#### Syntax:

```HINCRBYFLOAT <key> <field> <increment>```

#### Description:

Increment the specified `field` of a hash stored at `key`, and representing a
floating point number, by the specified `increment`. If the increment value
is negative, the result is to have the hash field value **decremented** instead of incremented.
If the field does not exist, it is set to `0` before performing the operation.
An error is returned if one of the following conditions occur:

* The field contains a value of the wrong type (not a string).
* The current field content or the specified increment are not parsable as a
  double precision floating point number.

The exact behavior of this command is identical to the one of the `INCRBYFLOAT`
command, please refer to the documentation of `INCRBYFLOAT` for further
information.

#### Return:

Bulk String Reply: the value of `field` after the increment.

#### Examples:

```
keydb-cli> HSET mykey field 10.50
(integer) 1
keydb-cli> HINCRBYFLOAT mykey field 0.1
"10.6"
keydb-cli> HINCRBYFLOAT mykey field -5
"5.6"
keydb-cli> HSET mykey field 5.0e3
(integer) 0
keydb-cli> HINCRBYFLOAT mykey field 2.0e2
"5200"
```

#### Implementation details

The command is always propagated in the replication link and the Append Only
File as a `HSET` operation, so that differences in the underlying floating point
math implementation will not be sources of inconsistency.

---





## HKEYS

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)

#### Syntax:

```HKEYS <key>```

#### Description:

Returns all field names in the hash stored at `key`.

#### Return:

Array Reply: list of fields in the hash, or an empty list when `key` does
not exist.

#### Examples:

```
keydb-cli> HSET myhash field1 "Hello"
(integer) 1
keydb-cli> HSET myhash field2 "World"
(integer) 1
keydb-cli> HKEYS myhash
1) "field1"
2) "field2"
```
---




## HLEN

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)


#### Syntax:

```HLEN <key>```

#### Description:

Returns the number of fields contained in the hash stored at `key`.

#### Return:

Integer Reply: number of fields in the hash, or `0` when `key` does not exist.

#### Examples:

```
keydb-cli> HSET myhash field1 "Hello"
(integer) 1
keydb-cli> HSET myhash field2 "World"
(integer) 1
keydb-cli> HLEN myhash
(integer) 2
```
---




## HMGET

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)


#### Syntax

```HMGET <key> <field-1> ... <field-n>```

#### Description:

Returns the values associated with the specified `fields` in the hash stored at
`key`.

For every `field` that does not exist in the hash, a `nil` value is returned.
Because non-existing keys are treated as empty hashes, running `HMGET` against
a non-existing `key` will return a list of `nil` values.

#### Return:

Array Reply: list of values associated with the given fields, in the same
order as they are requested.

```
keydb-cli> HSET myhash field1 "Hello"
(integer) 1
keydb-cli> HSET myhash field2 "World"
(integer) 1
keydb-cli> HMGET myhash field1 field2 nofield
1) "Hello"
2) "World"
3) (nil)
```
---




## HMSET

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)

#### Syntax:

```HMSET <key> <field-1> <value-1> ... <field-n> <value-n>```

#### Description:

Sets the specified fields to their respective values in the hash stored at
`key`.
This command overwrites any specified fields already existing in the hash.
If `key` does not exist, a new key holding a hash is created.

#### Return:

Simple String Reply

#### Examples:

```
keydb-cli> HMSET myhash field1 "Hello" field2 "World"
OK
keydb-cli> HGET myhash field1
"Hello"
keydb-cli> HGET myhash field2
"World"
```
---




## HSCAN

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)

See `SCAN` for `HSCAN` documentation.

---




## HSET

Sets `field` in the hash stored at `key` to `value`.
If `key` does not exist, a new key holding a hash is created.
If `field` already exists in the hash, it is overwritten.

#### Syntax:

```HSET <key> <field> <value>```

#### Return:

Integer Reply, specifically:

* `1` if `field` is a new field in the hash and `value` was set.
* `0` if `field` already exists in the hash and the value was updated.

#### Examples:

```
keydb-cli> HSET myhash field1 "Hello"
(integer) 1
keydb-cli> HGET myhash field1
"Hello"
```

---




## HSETNX

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)

#### Syntax:

```HSETNX <key> <field> <value>```

#### Description:

Sets `field` in the hash stored at `key` to `value`, only if `field` does not
yet exist.
If `key` does not exist, a new key holding a hash is created.
If `field` already exists, this operation has no effect.

#### Return:

Integer Reply, specifically:

* `1` if `field` is a new field in the hash and `value` was set.
* `0` if `field` already exists in the hash and no operation was performed.

#### Examples:

```
keydb-cli> HSETNX myhash field "Hello"
(integer) 1
keydb-cli> HSETNX myhash field "World"
(integer) 0
keydb-cli> HGET myhash field
"Hello"
```
---




## HSTRLEN

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)

#### Syntax:

```HSTRLEN <key> <value>```

#### Description:

Returns the string length of the value associated with `field` in the hash stored at `key`. If the `key` or the `field` do not exist, 0 is returned.

#### Return:

Integer Reply: the string length of the value associated with `field`, or zero when `field` is not present in the hash or `key` does not exist at all.

#### Examples:

```
keydb-cli> HMSET myhash f1 HelloWorld f2 99 f3 -256
OK
keydb-cli> HSTRLEN myhash f1
(integer) 10
keydb-cli> HSTRLEN myhash f2
(integer) 2
keydb-cli> HSTRLEN myhash f3
(integer) 4
```
---





## HVALS

**Related Commands:** [HDEL](/docs/commands/#hdel), [HEXISTS](/docs/commands/#hexists), [HGET](/docs/commands/#hget), [HGETALL](/docs/commands/#hgetall), [HINCRBY](/docs/commands/#hincrby), [HINCRBYFLOAT](/docs/commands/#hincrbyfloat), [HKEYS](/docs/commands/#hkeys), [HLEN](/docs/commands/#hlen), [HMGET](/docs/commands/#hmget), [HMSET](/docs/commands/#hmset), [HSCAN](/docs/commands/#hscan), [HSET](/docs/commands/#hset), [HSETNX](/docs/commands/#hsetnx), [HSTRLEN](/docs/commands/#hstrlen), [HVALS](/docs/commands/#hvals)

#### Syntax:

```HVALS <key>```

#### Description:

Returns all values in the hash stored at `key`.

#### Return:

Array Reply: list of values in the hash, or an empty list when `key` does
not exist.

#### Examples:

```
keydb-cli> HSET myhash field1 "Hello"
(integer) 1
keydb-cli> HSET myhash field2 "World"
(integer) 1
keydb-cli> HVALS myhash
1) "Hello"
2) "World"
```
---





## INCR

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```INCR <key>```

#### Description:

Increments the number stored at `key` by one.
If the key does not exist, it is set to `0` before performing the operation.
An error is returned if the key contains a value of the wrong type or contains a
string that can not be represented as integer.
This operation is limited to 64 bit signed integers.

**Note**: this is a string operation because KeyDB does not have a dedicated
integer type.
The string stored at the key is interpreted as a base-10 **64 bit signed
integer** to execute the operation.

KeyDB stores integers in their integer representation, so for string values
that actually hold an integer, there is no overhead for storing the string
representation of the integer.

#### Return:

Integer Reply: the value of `key` after the increment

#### Examples:

```
keydb-cli> SET mykey "10"
OK
keydb-cli> INCR mykey
(integer) 11
keydb-cli> GET mykey
```

#### Pattern: Counter

The counter pattern is the most obvious thing you can do with KeyDB atomic
increment operations.
The idea is simply send an `INCR` command to KeyDB every time an operation
occurs.
For instance in a web application we may want to know how many page views this
user did every day of the year.

To do so the web application may simply increment a key every time the user
performs a page view, creating the key name concatenating the User ID and a
string representing the current date.

This simple pattern can be extended in many ways:

* It is possible to use `INCR` and `EXPIRE` together at every page view to have
  a counter counting only the latest N page views separated by less than the
  specified amount of seconds.
* A client may use GETSET in order to atomically get the current counter value
  and reset it to zero.
* Using other atomic increment/decrement commands like `DECR` or `INCRBY` it
  is possible to handle values that may get bigger or smaller depending on the
  operations performed by the user.
  Imagine for instance the score of different users in an online game.

#### Pattern: Rate limiter

The rate limiter pattern is a special counter that is used to limit the rate at
which an operation can be performed.
The classical materialization of this pattern involves limiting the number of
requests that can be performed against a public API.

We provide two implementations of this pattern using `INCR`, where we assume
that the problem to solve is limiting the number of API calls to a maximum of
_ten requests per second per IP address_.

#### Pattern: Rate limiter 1

The more simple and direct implementation of this pattern is the following:

```
FUNCTION LIMIT_API_CALL(ip)
ts = CURRENT_UNIX_TIME()
keyname = ip+":"+ts
current = GET(keyname)
IF current != NULL AND current > 10 THEN
    ERROR "too many requests per second"
ELSE
    MULTI
        INCR(keyname,1)
        EXPIRE(keyname,10)
    EXEC
    PERFORM_API_CALL()
END
```

Basically we have a counter for every IP, for every different second.
But this counters are always incremented setting an expire of 10 seconds so that
they'll be removed by KeyDB automatically when the current second is a different
one.

Note the used of `MULTI` and `EXEC` in order to make sure that we'll both
increment and set the expire at every API call.

#### Pattern: Rate limiter 2

An alternative implementation uses a single counter, but is a bit more complex
to get it right without race conditions.
We'll examine different variants.

```
FUNCTION LIMIT_API_CALL(ip):
current = GET(ip)
IF current != NULL AND current > 10 THEN
    ERROR "too many requests per second"
ELSE
    value = INCR(ip)
    IF value == 1 THEN
        EXPIRE(ip,1)
    END
    PERFORM_API_CALL()
END
```

The counter is created in a way that it only will survive one second, starting
from the first request performed in the current second.
If there are more than 10 requests in the same second the counter will reach a
value greater than 10, otherwise it will expire and start again from 0.

**In the above code there is a race condition**.
If for some reason the client performs the `INCR` command but does not perform
the `EXPIRE` the key will be leaked until we'll see the same IP address again.

This can be fixed easily turning the `INCR` with optional `EXPIRE` into a Lua
script that is send using the `EVAL` command.

```
local current
current = KeyDB.call("incr",KEYS[1])
if tonumber(current) == 1 then
    KeyDB.call("expire",KEYS[1],1)
end
```

There is a different way to fix this issue without using scripting, but using
KeyDB lists instead of counters.
The implementation is more complex and uses more advanced features but has the
advantage of remembering the IP addresses of the clients currently performing an
API call, that may be useful or not depending on the application.

```
FUNCTION LIMIT_API_CALL(ip)
current = LLEN(ip)
IF current > 10 THEN
    ERROR "too many requests per second"
ELSE
    IF EXISTS(ip) == FALSE
        MULTI
            RPUSH(ip,ip)
            EXPIRE(ip,1)
        EXEC
    ELSE
        RPUSHX(ip,ip)
    END
    PERFORM_API_CALL()
END
```

The `RPUSHX` command only pushes the element if the key already exists.

Note that we have a race here, but it is not a problem: `EXISTS` may return
false but the key may be created by another client before we create it inside
the `MULTI` / `EXEC` block.
However this race will just miss an API call under rare conditions, so the rate
limiting will still work correctly.

---





## INCRBY

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```INCRBY <key> <increment>```

#### Dsescription:

Increments the number stored at `key` by `increment`.
If the key does not exist, it is set to `0` before performing the operation.
An error is returned if the key contains a value of the wrong type or contains a
string that can not be represented as integer.
This operation is limited to 64 bit signed integers.

See `INCR` for extra information on increment/decrement operations.

#### Return:

Integer Reply: the value of `key` after the increment

#### Examples:

```
keydb-cli> SET mykey "10"
OK
keydb-cli> INCRBY mykey 5
(integer) 15
```
---





## INCRBYFLOAT

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```INCRBYFLOAT <key> <increment>```

#### Description:

Increment the string representing a floating point number stored at `key` by the
specified `increment`. By using a negative `increment` value, the result is
that the value stored at the key is decremented (by the obvious properties
of addition).
If the key does not exist, it is set to `0` before performing the operation.
An error is returned if one of the following conditions occur:

* The key contains a value of the wrong type (not a string).
* The current key content or the specified increment are not parsable as a
  double precision floating point number.

If the command is successful the new incremented value is stored as the new
value of the key (replacing the old one), and returned to the caller as a
string.

Both the value already contained in the string key and the increment argument
can be optionally provided in exponential notation, however the value computed
after the increment is stored consistently in the same format, that is, an
integer number followed (if needed) by a dot, and a variable number of digits
representing the decimal part of the number.
Trailing zeroes are always removed.

The precision of the output is fixed at 17 digits after the decimal point
regardless of the actual internal precision of the computation.

#### Return:

Bulk String Reply: the value of `key` after the increment.

#### Examples:

```
keydb-cli> SET mykey 10.50
OK
keydb-cli> INCRBYFLOAT mykey 0.1
"10.6"
keydb-cli> INCRBYFLOAT mykey -5
"5.6"
keydb-cli> SET mykey 5.0e3
OK
keydb-cli> INCRBYFLOAT mykey 2.0e2
"5200"
```

#### Implementation details

The command is always propagated in the replication link and the Append Only
File as a `SET` operation, so that differences in the underlying floating point
math implementation will not be sources of inconsistency.


---




## INFO

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `INFO` command returns information and statistics about the server in a
format that is simple to parse by computers and easy to read by humans.

The optional parameter can be used to select a specific section of information:

*   `server`: General information about the KeyDB server
*   `clients`: Client connections section
*   `memory`: Memory consumption related information
*   `persistence`: RDB and AOF related information
*   `stats`: General statistics
*   `replication`: Master/replica replication information
*   `cpu`: CPU consumption statistics
*   `commandstats`: KeyDB command statistics
*   `cluster`: KeyDB Cluster section
*   `keyspace`: Database related statistics

It can also take the following values:

*   `all`: Return all sections
*   `default`: Return only the default set of sections

When no parameter is provided, the `default` option is assumed.

#### Return:

Bulk String Reply: as a collection of text lines.

Lines can contain a section name (starting with a # character) or a property.
All the properties are in the form of `field:value` terminated by `\r\n`.

```
INFO
```

#### Notes

Please note depending on the version of KeyDB some of the fields have been
added or removed. A robust client application should therefore parse the
result of this command by skipping unknown properties, and gracefully handle
missing fields.

Here is the description of fields for KeyDB >= 2.4.


Here is the meaning of all fields in the **server** section:

*   `KeyDB_version`: Version of the KeyDB server
*   `KeyDB_git_sha1`:  Git SHA1
*   `KeyDB_git_dirty`: Git dirty flag
*   `KeyDB_build_id`: The build id
*   `KeyDB_mode`: The server's mode ("standalone", "sentinel" or "cluster")
*   `os`: Operating system hosting the KeyDB server
*   `arch_bits`: Architecture (32 or 64 bits)
*   `multiplexing_api`: Event loop mechanism used by KeyDB
*   `atomicvar_api`: Atomicvar API used by KeyDB
*   `gcc_version`: Version of the GCC compiler used to compile the KeyDB server
*   `process_id`: PID of the server process
*   `run_id`: Random value identifying the KeyDB server (to be used by Sentinel
     and Cluster)
*   `tcp_port`: TCP/IP listen port
*   `uptime_in_seconds`: Number of seconds since KeyDB server start
*   `uptime_in_days`: Same value expressed in days
*   `hz`: The server's frequency setting
*   `lru_clock`: Clock incrementing every minute, for LRU management
*   `executable`: The path to the server's executable
*   `config_file`: The path to the config file

Here is the meaning of all fields in the **clients** section:

*   `connected_clients`: Number of client connections (excluding connections
     from replicas)
*   `client_longest_output_list`: longest output list among current client
     connections
*   `client_biggest_input_buf`: biggest input buffer among current client
     connections
*   `blocked_clients`: Number of clients pending on a blocking call (BLPOP, 
     BRPOP, BRPOPLPUSH)

Here is the meaning of all fields in the **memory** section:

*   `used_memory`: Total number of bytes allocated by KeyDB using its
     allocator (either standard **libc**, **jemalloc**, or an alternative
     allocator such as [**tcmalloc**][hcgcpgp])
*   `used_memory_human`: Human readable representation of previous value
*   `used_memory_rss`: Number of bytes that KeyDB allocated as seen by the
     operating system (a.k.a resident set size). This is the number reported by
     tools such as `top(1)` and `ps(1)`
*   `used_memory_rss_human`: Human readable representation of previous value
*   `used_memory_peak`: Peak memory consumed by KeyDB (in bytes)
*   `used_memory_peak_human`: Human readable representation of previous value
*   `used_memory_peak_perc`: The percentage of `used_memory_peak` out of
     `used_memory`
*   `used_memory_overhead`: The sum in bytes of all overheads that the server
     allocated for managing its internal data structures
*   `used_memory_startup`: Initial amount of memory consumed by KeyDB at startup
     in bytes
*   `used_memory_dataset`: The size in bytes of the dataset
     (`used_memory_overhead` subtracted from `used_memory`)
*   `used_memory_dataset_perc`: The percentage of `used_memory_dataset` out of
     the net memory usage (`used_memory` minus `used_memory_startup`)
*   `total_system_memory`: The total amount of memory that the KeyDB host has
*   `total_system_memory_human`: Human readable representation of previous value
*   `used_memory_lua`: Number of bytes used by the Lua engine
*   `used_memory_lua_human`: Human readable representation of previous value
*   `maxmemory`: The value of the `maxmemory` configuration directive
*   `maxmemory_human`: Human readable representation of previous value
*   `maxmemory_policy`: The value of the `maxmemory-policy` configuration
     directive
*   `mem_fragmentation_ratio`: Ratio between `used_memory_rss` and `used_memory`
*   `mem_allocator`: Memory allocator, chosen at compile time
*   `active_defrag_running`: Flag indicating if active defragmentation is active
*   `lazyfree_pending_objects`: The number of objects waiting to be freed (as a
     result of calling `UNLINK`, or `FLUSHDB` and `FLUSHALL` with the **ASYNC**
     option)

Ideally, the `used_memory_rss` value should be only slightly higher than
`used_memory`.
When rss >> used, a large difference means there is memory fragmentation
(internal or external), which can be evaluated by checking
`mem_fragmentation_ratio`.
When used >> rss, it means part of KeyDB memory has been swapped off by the
operating system: expect some significant latencies.

Because KeyDB does not have control over how its allocations are mapped to
memory pages, high `used_memory_rss` is often the result of a spike in memory
usage.

When KeyDB frees memory, the memory is given back to the allocator, and the
allocator may or may not give the memory back to the system. There may be
a discrepancy between the `used_memory` value and memory consumption as
reported by the operating system. It may be due to the fact memory has been
used and released by KeyDB, but not given back to the system. The 
`used_memory_peak` value is generally useful to check this point.

Additional introspective information about the server's memory can be obtained
by referring to the `MEMORY STATS` command and the `MEMORY DOCTOR`.

Here is the meaning of all fields in the **persistence** section:

*   `loading`: Flag indicating if the load of a dump file is on-going
*   `rdb_changes_since_last_save`: Number of changes since the last dump
*   `rdb_bgsave_in_progress`: Flag indicating a RDB save is on-going
*   `rdb_last_save_time`: Epoch-based timestamp of last successful RDB save
*   `rdb_last_bgsave_status`: Status of the last RDB save operation
*   `rdb_last_bgsave_time_sec`: Duration of the last RDB save operation in
     seconds
*   `rdb_current_bgsave_time_sec`: Duration of the on-going RDB save operation
     if any
*   `rdb_last_cow_size`: The size in bytes of copy-on-write allocations during
     the last RBD save operation
*   `aof_enabled`: Flag indicating AOF logging is activated
*   `aof_rewrite_in_progress`: Flag indicating a AOF rewrite operation is
     on-going
*   `aof_rewrite_scheduled`: Flag indicating an AOF rewrite operation
     will be scheduled once the on-going RDB save is complete.
*   `aof_last_rewrite_time_sec`: Duration of the last AOF rewrite operation in
     seconds
*   `aof_current_rewrite_time_sec`: Duration of the on-going AOF rewrite
     operation if any
*   `aof_last_bgrewrite_status`: Status of the last AOF rewrite operation
*   `aof_last_write_status`: Status of the last write operation to the AOF
*   `aof_last_cow_size`: The size in bytes of copy-on-write allocations during
     the last AOF rewrite operation

`changes_since_last_save` refers to the number of operations that produced
some kind of changes in the dataset since the last time either `SAVE` or
`BGSAVE` was called.

If AOF is activated, these additional fields will be added:

*   `aof_current_size`: AOF current file size
*   `aof_base_size`: AOF file size on latest startup or rewrite
*   `aof_pending_rewrite`: Flag indicating an AOF rewrite operation
     will be scheduled once the on-going RDB save is complete.
*   `aof_buffer_length`: Size of the AOF buffer
*   `aof_rewrite_buffer_length`: Size of the AOF rewrite buffer
*   `aof_pending_bio_fsync`: Number of fsync pending jobs in background I/O
     queue
*   `aof_delayed_fsync`: Delayed fsync counter

If a load operation is on-going, these additional fields will be added:

*   `loading_start_time`: Epoch-based timestamp of the start of the load
     operation
*   `loading_total_bytes`: Total file size
*   `loading_loaded_bytes`: Number of bytes already loaded
*   `loading_loaded_perc`: Same value expressed as a percentage
*   `loading_eta_seconds`: ETA in seconds for the load to be complete

Here is the meaning of all fields in the **stats** section:

*   `total_connections_received`: Total number of connections accepted by the
     server
*   `total_commands_processed`: Total number of commands processed by the server
*   `instantaneous_ops_per_sec`: Number of commands processed per second
*   `total_net_input_bytes`: The total number of bytes read from the network
*   `total_net_output_bytes`: The total number of bytes written to the network
*   `instantaneous_input_kbps`: The network's read rate per second in KB/sec
*   `instantaneous_output_kbps`: The network's write rate per second in KB/sec
*   `rejected_connections`: Number of connections rejected because of
     `maxclients` limit
*   `sync_full`: The number of full resyncs with replicas
*   `sync_partial_ok`: The number of accepted partial resync requests
*   `sync_partial_err`: The number of denied partial resync requests
*   `expired_keys`: Total number of key expiration events
*   `evicted_keys`: Number of evicted keys due to `maxmemory` limit
*   `keyspace_hits`: Number of successful lookup of keys in the main dictionary
*   `keyspace_misses`: Number of failed lookup of keys in the main dictionary
*   `pubsub_channels`: Global number of pub/sub channels with client
     subscriptions
*   `pubsub_patterns`: Global number of pub/sub pattern with client
     subscriptions
*   `latest_fork_usec`: Duration of the latest fork operation in microseconds
*   `migrate_cached_sockets`: The number of sockets open for `MIGRATE` purposes
*   `slave_expires_tracked_keys`: The number of keys tracked for expiry purposes
     (applicable only to writable replicas)
*   `active_defrag_hits`: Number of value reallocations performed by active the
     defragmentation process
*   `active_defrag_misses`: Number of aborted value reallocations started by the
     active defragmentation process
*   `active_defrag_key_hits`: Number of keys that were actively defragmented
*   `active_defrag_key_misses`: Number of keys that were skipped by the active
     defragmentation process

Here is the meaning of all fields in the **replication** section:

*   `role`: Value is "master" if the instance is replica of no one, or "slave" if the instance is a replica of some master instance.
     Note that a replica can be master of another replica (chained replication).
*   `master_replid`: The replication ID of the KeyDB server.
*   `master_replid2`: The secondary replication ID, used for PSYNC after a failover.
*   `master_repl_offset`: The server's current replication offset
*   `second_repl_offset`: The offset up to which replication IDs are accepted
*   `repl_backlog_active`: Flag indicating replication backlog is active
*   `repl_backlog_size`: Total size in bytes of the replication backlog buffer
*   `repl_backlog_first_byte_offset`: The master offset of the replication
     backlog buffer
*   `repl_backlog_histlen`: Size in bytes of the data in the replication backlog
     buffer

If the instance is a replica, these additional fields are provided:

*   `master_host`: Host or IP address of the master
*   `master_port`: Master listening TCP port
*   `master_link_status`: Status of the link (up/down)
*   `master_last_io_seconds_ago`: Number of seconds since the last interaction
     with master
*   `master_sync_in_progress`: Indicate the master is syncing to the replica 
*   `slave_repl_offset`: The replication offset of the replica instance
*   `slave_priority`: The priority of the instance as a candidate for failover
*   `slave_read_only`: Flag indicating if the replica is read-only

If a SYNC operation is on-going, these additional fields are provided:

*   `master_sync_left_bytes`: Number of bytes left before syncing is complete
*   `master_sync_last_io_seconds_ago`: Number of seconds since last transfer I/O
     during a SYNC operation

If the link between master and replica is down, an additional field is provided:

*   `master_link_down_since_seconds`: Number of seconds since the link is down

The following field is always provided:

*   `connected_slaves`: Number of connected replicas

If the server is configured with the `min-slaves-to-write` (or starting with KeyDB 5 with the `min-replicas-to-write`) directive, an additional field is provided:

*   `min_slaves_good_slaves`: Number of replicas currently considered good 

For each replica, the following line is added:

*   `slaveXXX`: id, IP address, port, state, offset, lag

Here is the meaning of all fields in the **cpu** section:

*   `used_cpu_sys`: System CPU consumed by the KeyDB server
*   `used_cpu_user`:User CPU consumed by the KeyDB server
*   `used_cpu_sys_children`: System CPU consumed by the background processes
*   `used_cpu_user_children`: User CPU consumed by the background processes

The **commandstats** section provides statistics based on the command type,
including the number of calls, the total CPU time consumed by these commands,
and the average CPU consumed per command execution.

For each command type, the following line is added:

*   `cmdstat_XXX`: `calls=XXX,usec=XXX,usec_per_call=XXX`

The **cluster** section currently only contains a unique field:

*   `cluster_enabled`: Indicate KeyDB cluster is enabled

The **keyspace** section provides statistics on the main dictionary of each
database.
The statistics are the number of keys, and the number of keys with an expiration.

For each database, the following line is added:

*   `dbXXX`: `keys=XXX,expires=XXX`

http://code.google.com/p/google-perftools/

**A note about the word slave used in this man page**: Starting with KeyDB 5, if not for backward compatibility, the KeyDB project no longer uses the word slave. Unfortunately in this command the word slave is part of the protocol, so we'll be able to remove such occurrences only when this API will be naturally deprecated.


---




## KEYDB.*

All commands prefixed with "KEYDB." are commands specific to KeyDB whereby the prefix ensures a clear differentiation from Redis commands & potential future Redis commands. This will help ensure compatability with all Redis clients and protocol moving forwards.


---




## KEYDB.CRON

**Related Commands:** [DEL](/docs/commands/#del), [EVAL](/docs/commands/#eval)

KeyDB's CRON function schedules LUA scripts to run at specified times and intervals.

#### Returns:

`OK` if the task was accepted and successfully scheduled.

#### Syntax:

```
KEYDB.CRON <name> <single|repeat> <OPTIONAL:start> <delay> <script> <numkeys> <key-N> <arg-N>
```
where:
* `name` is the name of the KEY. This will be visible in the keyspace, can be searched, and deleted with `DEL`. Each cron task will have its own name.
* `single/repeat` specifies if the script will run only once, or if it will be repeated at the specified interval
* `start` is an integer specified in milliseconds since Epoch. If specified, the script will not execute until this Unix time has been reached. If the delay is greater than zero, this delay time will need to elapse prior to the script executing (timer begins to elapse at start time). If a start time 
is specified, the delay will always remain in reference intervals to that start time.
* `delay` is an integer specified in milliseconds used as the initial delay. If `repeat` is specified, this will also be the length of the repeating timer which will execute the script each time the delay elapses (will continue to execute indefinitely).
* `script` is the LUA script to execute. This should be the LUA script itself and NOT the SHA1 digest of a loaded script.
* `numkeys <key-N> <arg-N>` are the number of keys, keys, and arguments for the script, similar to usage with [EVAL](/docs/commands/#eval)

#### Persistence:

Unlike traditional LUA scripts that may be loaded (cached only), the KEYDB.CRON task will persist across server boots if saved. It can be seen as a KEY in the keyspace and deleted or modified. 

If the cron function is on repeat and already executing at its interval, then the keydb-server is rebooted, the interval will continue to be referenced to the start time. For example if you had scheduled the task at the beginning of each hour, 
once booted the task will continue to execute at the beginning of each hour regardless of when the server boots.

#### Examples:


```
keydb-cli> KEYDB.CRON mytestname REPEAT 1610941618000 60000 "redis.call('incr',KEYS[1])" 1 mytestcounter
OK
```

The example above increments the value of 'mytestcounter" every 60 seconds starting at the Unix Timestamp of 1610941618000 milliseconds.

```
keydb-cli> KEYDB.CRON mytestname2 SINGLE 1610941618000 1 "redis.call('set',KEYS[1],'0')" 1 mytestcounter
OK
```

The above command sets `mytestcounter` to zero at Unix Timestamp 1610941618000 milliseconds. This will occur only once. Note that we must specify a delay time. Once the task has completed the KEY will be removed and the name `mytestname2` will no longer exist.

For more information and examples on KEYDB.CRON, take a look at this blog post: https://docs.keydb.dev/blog/2021/01/26/blog-post/

---




## KEYS

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```KEYS <pattern>```

#### Description:

Returns all keys matching `pattern`.

While the time complexity for this operation is O(N), the constant times are
fairly low.
For example, KeyDB running on an entry level laptop can scan a 1 million key
database in 40 milliseconds.

Keys commands performed on one databases will not have as much of an effect
on other databses being queried at the same time.

**Warning**: consider `KEYS` as a command that should only be used in production
environments with extreme care.
It may ruin performance when it is executed against large databases.
This command is intended for debugging and special operations, such as changing
your keyspace layout.
Don't use `KEYS` in your regular application code.
If you're looking for a way to find keys in a subset of your keyspace, consider
using `SCAN` or sets.


Supported glob-style patterns:

* `h?llo` matches `hello`, `hallo` and `hxllo`
* `h*llo` matches `hllo` and `heeeello`
* `h[ae]llo` matches `hello` and `hallo,` but not `hillo`
* `h[^e]llo` matches `hallo`, `hbllo`, ... but not `hello`
* `h[a-b]llo` matches `hallo` and `hbllo`

Use `\` to escape special characters if you want to match them verbatim.

#### Return:

Array Reply: list of keys matching `pattern`.

#### Examples:

```
127.0.0.1:6379> MSET firstname Jack lastname Stuntman age 35
OK
127.0.0.1:6379> KEYS *name*
1) "lastname"
2) "firstname"
127.0.0.1:6379> KEYS a??
1) "age"
127.0.0.1:6379> KEYS *
1) "age"
2) "lastname"
3) "firstname"
```

---





## LASTSAVE

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

Return the UNIX TIME of the last DB save executed with success.
A client may check if a `BGSAVE` command succeeded reading the `LASTSAVE` value,
then issuing a `BGSAVE` command and checking at regular intervals every N
seconds if `LASTSAVE` changed.

#### Return:

Integer Reply: an UNIX time stamp.

---





## LINDEX

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```LINDEX <key> <index>```

#### Description:

Returns the element at index `index` in the list stored at `key`.
The index is zero-based, so `0` means the first element, `1` the second element
and so on.
Negative indices can be used to designate elements starting at the tail of the
list.
Here, `-1` means the last element, `-2` means the penultimate and so forth.

When the value at `key` is not a list, an error is returned.

#### Return:

Bulk String Reply: the requested element, or `nil` when `index` is out of range.

#### Examples:

```
keydb-cli> LPUSH mylist "World"
(integer) 1
keydb-cli> LPUSH mylist "Hello"
(integer) 2
keydb-cli> LINDEX mylist 0
"Hello"
keydb-cli> LINDEX mylist -1
"World"
keydb-cli> LINDEX mylist 3
(nil)
```

---




## LINSERT

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```LINSERT <key> <BEFORE|AFTER> <pivot> <element>```

#### Description:

Inserts `value` in the list stored at `key` either before or after the reference
value `pivot`.

When `key` does not exist, it is considered an empty list and no operation is
performed.

An error is returned when `key` exists but does not hold a list value.

#### Return:

Integer Reply: the length of the list after the insert operation, or `-1` when
the value `pivot` was not found.

#### Examples:

```
keydb-cli> RPUSH mylist "Hello"
(integer) 1
keydb-cli> RPUSH mylist "World"
(integer) 2
keydb-cli> LINSERT mylist BEFORE "World" "There"
(integer) 3
keydb-cli> LRANGE mylist 0 -1
1) "Hello"
2) "There"
3) "World"
```

---





## LLEN

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```LLEN <key>```

#### Description:

Returns the length of the list stored at `key`.
If `key` does not exist, it is interpreted as an empty list and `0` is returned.
An error is returned when the value stored at `key` is not a list.

#### Return:

Integer Reply: the length of the list at `key`.

#### Examples:

```
keydb-cli> LPUSH mylist "World"
(integer) 1
keydb-cli> LPUSH mylist "Hello"
(integer) 2
keydb-cli> LLEN mylist
(integer) 2
```

---





## LPOP

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```LPOP <key>```

#### Description:

Removes and returns the first element of the list stored at `key`.

#### Return:

Bulk String Reply: the value of the first element, or `nil` when `key` does not exist.

#### Examples:

```
keydb-cli> RPUSH mylist "one"
(integer) 1
keydb-cli> RPUSH mylist "two"
(integer) 2
keydb-cli> RPUSH mylist "three"
(integer) 3
keydb-cli> LPOP mylist
"one"
keydb-cli> LRANGE mylist 0 -1
1) "two"
2) "three"
```

---





## LPUSH

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```LPUSH <key> <element-1> ... <element-n>```

#### Description:

Insert all the specified values at the head of the list stored at `key`.
If `key` does not exist, it is created as empty list before performing the push
operations.
When `key` holds a value that is not a list, an error is returned.

It is possible to push multiple elements using a single command call just
specifying multiple arguments at the end of the command.
Elements are inserted one after the other to the head of the list, from the
leftmost element to the rightmost element.
So for instance the command `LPUSH mylist a b c` will result into a list
containing `c` as first element, `b` as second element and `a` as third element.

#### Return:

Integer Reply: the length of the list after the push operations.


#### Examples:

```
keydb-cli> LPUSH mylist "world"
(integer) 1
keydb-cli> LPUSH mylist "hello"
(integer) 2
keydb-cli> LRANGE mylist 0 -1
1) "hello"
2) "world"
```

---





## LPUSHX

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 


#### Syntax:

```LPUSHX <key> <value>```

#### Description:

Inserts `value` at the head of the list stored at `key`, only if `key` already
exists and holds a list.
In contrary to `LPUSH`, no operation will be performed when `key` does not yet
exist.

#### Return:

Integer Reply: the length of the list after the push operation.

#### Examples:

```
keydb-cli> LPUSH mylist "World"
(integer) 1
keydb-cli> LPUSHX mylist "Hello"
(integer) 2
keydb-cli> LPUSHX myotherlist "Hello"
(integer) 0
keydb-cli> LRANGE mylist 0 -1
1) "Hello"
2) "World"
keydb-cli> LRANGE myotherlist 0 -1
(empty array)
```

---




## LRANGE

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 


#### Syntax:

```LRANGE <key> <start> <stop>```

#### Description:

Returns the specified elements of the list stored at `key`.
The offsets `start` and `stop` are zero-based indexes, with `0` being the first
element of the list (the head of the list), `1` being the next element and so
on.

These offsets can also be negative numbers indicating offsets starting at the
end of the list.
For example, `-1` is the last element of the list, `-2` the penultimate, and so
on.

#### Consistency with range functions in various programming languages

Note that if you have a list of numbers from 0 to 100, `LRANGE list 0 10` will
return 11 elements, that is, the rightmost item is included.
This **may or may not** be consistent with behavior of range-related functions
in your programming language of choice (think Ruby's `Range.new`, `Array#slice`
or Python's `range()` function).

#### Out-of-range indexes

Out of range indexes will not produce an error.
If `start` is larger than the end of the list, an empty list is returned.
If `stop` is larger than the actual end of the list, KeyDB will treat it like
the last element of the list.

#### Return:

Array Reply: list of elements in the specified range.

#### Examples:

```
keydb-cli> RPUSH mylist "one"
(integer) 1
keydb-cli> RPUSH mylist "two"
(integer) 2
keydb-cli> RPUSH mylist "three"
(integer) 3
keydb-cli> LRANGE mylist 0 0
1) "one"
keydb-cli> LRANGE mylist -3 2
1) "one"
2) "two"
3) "three"
keydb-cli> LRANGE mylist -100 100
1) "one"
2) "two"
3) "three"
keydb-cli> LRANGE mylist 5 10
(empty array)
```

---





## LREM

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```LREM <key> <count> <element>```

#### Description:

Removes the first `count` occurrences of elements equal to `value` from the list
stored at `key`.
The `count` argument influences the operation in the following ways:

* `count > 0`: Remove elements equal to `value` moving from head to tail.
* `count < 0`: Remove elements equal to `value` moving from tail to head.
* `count = 0`: Remove all elements equal to `value`.

For example, `LREM list -2 "hello"` will remove the last two occurrences of
`"hello"` in the list stored at `list`.

Note that non-existing keys are treated like empty lists, so when `key` does not
exist, the command will always return `0`.

#### Return:

Integer Reply: the number of removed elements.

#### Examples:

```
keydb-cli> RPUSH mylist "hello"
(integer) 1
keydb-cli> RPUSH mylist "hello"
(integer) 2
keydb-cli> RPUSH mylist "foo"
(integer) 3
keydb-cli> RPUSH mylist "hello"
(integer) 4
keydb-cli> LREM mylist -2 "hello"
(integer) 2
keydb-cli> LRANGE mylist 0 -1
1) "hello"
2) "foo"
```

---






## LSET

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```LSET <key> <index> <element>```

#### Description:

Sets the list element at `index` to `value`.
For more information on the `index` argument, see `LINDEX`.

An error is returned for out of range indexes.

#### Return:

Simple String Reply

#### Examples:

```
keydb-cli> RPUSH mylist "one"
(integer) 1
keydb-cli> RPUSH mylist "two"
(integer) 2
keydb-cli> RPUSH mylist "three"
(integer) 3
keydb-cli> LSET mylist 0 "four"
OK
keydb-cli> LSET mylist -2 "five"
OK
keydb-cli> LRANGE mylist 0 -1
1) "four"
2) "five"
3) "three"
```

---





## LTRIM

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```LTRIM <key> <start> <stop>```

#### Description:

Trim an existing list so that it will contain only the specified range of
elements specified.
Both `start` and `stop` are zero-based indexes, where `0` is the first element
of the list (the head), `1` the next element and so on.

For example: `LTRIM foobar 0 2` will modify the list stored at `foobar` so that
only the first three elements of the list will remain.

`start` and `end` can also be negative numbers indicating offsets from the end
of the list, where `-1` is the last element of the list, `-2` the penultimate
element and so on.

Out of range indexes will not produce an error: if `start` is larger than the
end of the list, or `start > end`, the result will be an empty list (which
causes `key` to be removed).
If `end` is larger than the end of the list, KeyDB will treat it like the last
element of the list.

A common use of `LTRIM` is together with `LPUSH` / `RPUSH`.
For example:

```
keydb-cli> LPUSH mylist someelement
(integer) 1
keydb-cli> LTRIM mylist 0 99
OK
```

This pair of commands will push a new element on the list, while making sure
that the list will not grow larger than 100 elements.
This is very useful when using KeyDB to store logs for example.
It is important to note that when used in this way `LTRIM` is an O(1) operation
because in the average case just one element is removed from the tail of the
list.

#### Return:

Simple String Reply

#### Examples:

```
keydb-cli> RPUSH mylist "one"
(integer) 1
keydb-cli> RPUSH mylist "two"
(integer) 2
keydb-cli> RPUSH mylist "three"
(integer) 3
keydb-cli> LTRIM mylist 1 -1
OK
keydb-cli> LRANGE mylist 0 -1
1) "two"
2) "three"
```

---





## MEMORY-DOCTOR

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `MEMORY DOCTOR` command reports about different memory-related issues that
the KeyDB server experiences, and advises about possible remedies.

#### Return:

Bulk String Reply 

---




## MEMORY-HELP

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `MEMORY HELP` command returns a helpful text describing the different
subcommands.

#### Return:

Array Reply: a list of subcommands and their descriptions

---





## MEMORY-MALLOC-STATS

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `MEMORY MALLOC-STATS` command provides an internal statistics report from
the memory allocator.

This command is currently implemented only when using **jemalloc** as an
allocator, and evaluates to a benign NOOP for all others.

#### Return:

Bulk String Reply: the memory allocator's internal statistics report

---




## MEMORY-PURGE

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `MEMORY PURGE` command attempts to purge dirty pages so these can be
reclaimed by the allocator.

This command is currently implemented only when using **jemalloc** as an
allocator, and evaluates to a benign NOOP for all others.

#### Return:

Simple String Reply

---




## MEMORY-STATS

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `MEMORY STATS` command returns an Array Reply about the memory usage of the
server.

The information about memory usage is provided as metrics and their respective
values. The following metrics are reported:

*   `peak.allocated`: Peak memory consumed by KeyDB in bytes (see `INFO`'s
     `used_memory`)
*   `total.allocated`: Total number of bytes allocated by KeyDB using its
     allocator (see `INFO`'s `used_memory`)
*   `startup.allocated`: Initial amount of memory consumed by KeyDB at startup
     in bytes (see `INFO`'s `used_memory_startup`)
*   `replication.backlog`: Size in bytes of the replication backlog (see
     `INFO`'s `repl_backlog_size`)
*   `clients.slaves`: The total size in bytes of all replicas overheads (output
     and query buffers, connection contexts)
*   `clients.normal`: The total size in bytes of all clients overheads (output
     and query buffers, connection contexts)
*   `aof.buffer`: The summed size in bytes of the current and rewrite AOF
     buffers (see `INFO`'s `aof_buffer_length` and `aof_rewrite_buffer_length`,
     respectively)
*   `dbXXX`: For each of the server's databases, the overheads of the main and
     expiry dictionaries (`overhead.hashtable.main` and
    `overhead.hashtable.expires`, respectively) are reported in bytes
*   `overhead.total`: The sum of all overheads, i.e. `startup.allocated`,
     `replication.backlog`, `clients.slaves`, `clients.normal`, `aof.buffer` and
     those of the internal data structures that are used in managing the
     KeyDB keyspace (see `INFO`'s `used_memory_overhead`)
*   `keys.count`: The total number of keys stored across all databases in the
     server
*   `keys.bytes-per-key`: The ratio between **net memory usage** (`total.allocated`
     minus `startup.allocated`) and `keys.count` 
*   `dataset.bytes`: The size in bytes of the dataset, i.e. `overhead.total`
     subtracted from `total.allocated` (see `INFO`'s `used_memory_dataset`)
*   `dataset.percentage`: The percentage of `dataset.bytes` out of the net
     memory usage
*   `peak.percentage`: The percentage of `peak.allocated` out of
     `total.allocated`
*   `fragmentation`: See `INFO`'s `mem_fragmentation_ratio`

#### Return:

Array Reply: nested list of memory usage metrics and their values

**A note about the word slave used in this man page**: Starting with KeyDB 5, if not for backward compatibility, the KeyDB project no longer uses the word slave. Unfortunately in this command the word slave is part of the protocol, so we'll be able to remove such occurrences only when this API will be naturally deprecated.

---





## MEMORY-USAGE

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

#### Syntax:

```MEMORY USAGE <key>```

#### Description:

The `MEMORY USAGE` command reports the number of bytes that a key and its value
require to be stored in RAM.

The reported usage is the total of memory allocations for data and
administrative overheads that a key its value require.

For nested data types, the optional `SAMPLES` option can be provided, where
`count` is the number of sampled nested values. By default, this option is set
to `5`. To sample the all of the nested values, use `SAMPLES 0`. 

#### Examples:

With KeyDB v4.0.1 64-bit and **jemalloc**, the empty string measures as follows:

```
keydb-cli> SET "" ""
OK
kedyb-cli> MEMORY USAGE ""
(integer) 50
```

These bytes are pure overhead at the moment as no actual data is stored, and are
used for maintaining the internal data structures of the server. Longer keys and
values show asymptotically linear usage.

```
keydb-cli> SET foo bar
OK
keydb-cli> MEMORY USAGE foo
(integer) 53
keydb-cli> SET cento 01234567890123456789012345678901234567890123
45678901234567890123456789012345678901234567890123456789
OK
keydb-cli> MEMORY USAGE cento
(integer) 160
```

#### Return:

Integer Reply: the memory usage in bytes 

---





## MGET

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```MGET <key-1> ... <key-n>```

#### Description:

Returns the values of all specified keys.
For every key that does not hold a string value or does not exist, the special
value `nil` is returned.
Because of this, the operation never fails.

#### Return:

Array Reply: list of values at the specified keys.

#### Examples:

```
keydb-cli> SET key1 "Hello"
OK
keydb-cli> SET key2 "World"
OK
keydb-cli> MGET key1 key2 nonexisting
1) "Hello"
2) "World"
3) (nil)
```

---




## MIGRATE

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```MIGRATE <host> <port> <KEY|""> <destination-db> <timeout> <OPTIONAL:COPY> <OPTIONAL:REPLACE> <KEYS> <key-1> ... <key-n>```

#### Description:

Atomically transfer a key from a source KeyDB instance to a destination KeyDB
instance.
On success the key is deleted from the original instance and is guaranteed to
exist in the target instance.

The command is atomic and blocks the two instances for the time required to
transfer the key, at any given time the key will appear to exist in a given
instance or in the other instance, unless a timeout error occurs. In 3.2 and
above, multiple keys can be pipelined in a single call to `MIGRATE` by passing
the empty string ("") as key and adding the `KEYS` clause.

The command internally uses `DUMP` to generate the serialized version of the key
value, and `RESTORE` in order to synthesize the key in the target instance.
The source instance acts as a client for the target instance.
If the target instance returns OK to the `RESTORE` command, the source instance
deletes the key using `DEL`.

The timeout specifies the maximum idle time in any moment of the communication
with the destination instance in milliseconds.
This means that the operation does not need to be completed within the specified
amount of milliseconds, but that the transfer should make progresses without
blocking for more than the specified amount of milliseconds.

`MIGRATE` needs to perform I/O operations and to honor the specified timeout.
When there is an I/O error during the transfer or if the timeout is reached the
operation is aborted and the special error - `IOERR` returned.
When this happens the following two cases are possible:

* The key may be on both the instances.
* The key may be only in the source instance.

It is not possible for the key to get lost in the event of a timeout, but the
client calling `MIGRATE`, in the event of a timeout error, should check if the
key is _also_ present in the target instance and act accordingly.

When any other error is returned (starting with `ERR`) `MIGRATE` guarantees that
the key is still only present in the originating instance (unless a key with the
same name was also _already_ present on the target instance).

If there are no keys to migrate in the source instance `NOKEY` is returned.
Because missing keys are possible in normal conditions, from expiry for example,
`NOKEY` isn't an error. 

#### Migrating multiple keys with a single command call

Starting with KeyDB 3.0.6 `MIGRATE` supports a new bulk-migration mode that
uses pipelining in order to migrate multiple keys between instances without
incurring in the round trip time latency and other overheads that there are
when moving each key with a single `MIGRATE` call.

In order to enable this form, the `KEYS` option is used, and the normal *key*
argument is set to an empty string. The actual key names will be provided
after the `KEYS` argument itself, like in the following example:

`keydb-cli> MIGRATE 192.168.1.34 6379 "" 0 5000 KEYS key1 key2 key3`

When this form is used the `NOKEY` status code is only returned when none
of the keys is present in the instance, otherwise the command is executed, even if
just a single key exists.

#### Options

* `COPY` -- Do not remove the key from the local instance.
* `REPLACE` -- Replace existing key on the remote instance.
* `KEYS` -- If the key argument is an empty string, the command will instead migrate all the keys that follow the `KEYS` option (see the above section for more info).

`COPY` and `REPLACE` are available only in 3.0 and above.
`KEYS` is available starting with KeyDB 3.0.6.

#### Return:

Simple String Reply: The command returns OK on success, or `NOKEY` if no keys were
found in the source instance.  

---





## MONITOR

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

`MONITOR` is a debugging command that streams back every command processed by
the KeyDB server.
It can help in understanding what is happening to the database.
This command can both be used via `keydb-cli` and via `telnet`.

The ability to see all the requests processed by the server is useful in order
to spot bugs in an application both when using KeyDB as a database and as a
distributed caching system.

```
$ keydb-cli monitor
1339518083.107412 [0 127.0.0.1:60866] "keys" "*"
1339518087.877697 [0 127.0.0.1:60866] "dbsize"
1339518090.420270 [0 127.0.0.1:60866] "set" "x" "6"
1339518096.506257 [0 127.0.0.1:60866] "get" "x"
1339518099.363765 [0 127.0.0.1:60866] "del" "x"
1339518100.544926 [0 127.0.0.1:60866] "get" "x"
```

Use `SIGINT` (Ctrl-C) to stop a `MONITOR` stream running via `keydb-cli`.

```
$ telnet localhost 6379
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
MONITOR
+OK
+1339518083.107412 [0 127.0.0.1:60866] "keys" "*"
+1339518087.877697 [0 127.0.0.1:60866] "dbsize"
+1339518090.420270 [0 127.0.0.1:60866] "set" "x" "6"
+1339518096.506257 [0 127.0.0.1:60866] "get" "x"
+1339518099.363765 [0 127.0.0.1:60866] "del" "x"
+1339518100.544926 [0 127.0.0.1:60866] "get" "x"
QUIT
+OK
Connection closed by foreign host.
```

Manually issue the `QUIT` command to stop a `MONITOR` stream running via
`telnet`.

#### Commands not logged by MONITOR

For security concerns, certain special administration commands like `CONFIG`
are not logged into the `MONITOR` output.

#### Cost of running `MONITOR`

Because `MONITOR` streams back **all** commands, its use comes at a cost.
The following (totally unscientific) benchmark numbers illustrate what the cost
of running `MONITOR` can be.

Benchmark result **without** `MONITOR` running:

```
$ src/keydb-benchmark -c 10 -n 100000 -q
PING_INLINE: 101936.80 requests per second
PING_BULK: 102880.66 requests per second
SET: 95419.85 requests per second
GET: 104275.29 requests per second
INCR: 93283.58 requests per second
```

Benchmark result **with** `MONITOR` running (`keydb-cli monitor > /dev/null`):

```
$ src/keydb-benchmark -c 10 -n 100000 -q
PING_INLINE: 58479.53 requests per second
PING_BULK: 59136.61 requests per second
SET: 41823.50 requests per second
GET: 45330.91 requests per second
INCR: 41771.09 requests per second
```

In this particular case, running a single `MONITOR` client can reduce the
throughput by more than 50%.
Running more `MONITOR` clients will reduce throughput even more.

#### Return:

**Non standard return value**, just dumps the received commands in an infinite
flow.

---





## MOVE

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```MOVE <key> <db>```

#### Description:

Move `key` from the currently selected database (see `SELECT`) to the specified
destination database.
When `key` already exists in the destination database, or it does not exist in
the source database, it does nothing.
It is possible to use `MOVE` as a locking primitive because of this.

#### Return:

Integer Reply, specifically:

* `1` if `key` was moved.
* `0` if `key` was not moved.

---




## MSET

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```MSET <key-1> <value-1> ... <key-n> <value-n>```

#### Description:

Sets the given keys to their respective values.
`MSET` replaces existing values with new values, just as regular `SET`.
See `MSETNX` if you don't want to overwrite existing values.

`MSET` is atomic, so all given keys are set at once.
It is not possible for clients to see that some of the keys were updated while
others are unchanged.

#### Return:

Simple String Reply: always `OK` since `MSET` can't fail.

#### Examples:

```
keydb-cli> MSET key1 "Hello" key2 "World"
OK
keydb-cli> GET key1
"Hello"
keydb-cli> GET key2
"World"
```

---




## MSETNX

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 


#### Syntax:

```MSETNX <key-1> <value-1> ... <key-n> <value-n>```

#### Description:

Sets the given keys to their respective values.
`MSETNX` will not perform any operation at all even if just a single key already
exists.

Because of this semantic `MSETNX` can be used in order to set different keys
representing different fields of an unique logic object in a way that ensures
that either all the fields or none at all are set.

`MSETNX` is atomic, so all given keys are set at once.
It is not possible for clients to see that some of the keys were updated while
others are unchanged.

#### Return:

Integer Reply, specifically:

* `1` if the all the keys were set.
* `0` if no key was set (at least one key already existed).

#### Examples:

```
keydb-cli> MSETNX key1 "Hello" key2 "there"
(integer) 1
keydb-cli> MSETNX key2 "there" key3 "world"
(integer) 0
keydb-cli> MGET key1 key2 key3
1) "Hello"
2) "there"
3) (nil)
```

---




## MULTI

**Related Commands:** [DISCARD](/docs/commands/#discard), [EXEC](/docs/commands/#exec), [MULTI](/docs/commands/#multi), [UNWATCH](/docs/commands/#unwatch), [WATCH](/docs/commands/#watch)

Marks the start of a [transaction](https://docs.keydb.dev/docs/transactions/) block.
Subsequent commands will be queued for atomic execution using `EXEC`.


#### Return:

Simple String Reply: always `OK`.

#### Examples:

```
keydb-cli> MULTI
OK
keydb-cli> SET k 1
QUEUED
keydb-cli> GET k
QUEUED
keydb-cli> EXEC
1) OK
2) "1"
```


---




## OBJECT

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

The `OBJECT` command allows to inspect the internals of KeyDB Objects associated
with keys.
It is useful for debugging or to understand if your keys are using the specially
encoded data types to save space.
Your application may also use the information reported by the `OBJECT` command
to implement application level key eviction policies when using KeyDB as a
Cache.

The `OBJECT` command supports multiple sub commands:

* `OBJECT REFCOUNT <key>` returns the number of references of the value
  associated with the specified key.
  This command is mainly useful for debugging.
* `OBJECT ENCODING <key>` returns the kind of internal representation used in
  order to store the value associated with a key.
* `OBJECT IDLETIME <key>` returns the number of seconds since the object stored
  at the specified key is idle (not requested by read or write operations).
  While the value is returned in seconds the actual resolution of this timer is
  10 seconds, but may vary in future implementations. This subcommand is
  available when `maxmemory-policy` is set to an LRU policy or `noeviction`. 
* `OBJECT LASTMODIFIED <key>` Returns the time elapsed (in seconds) since the key 
  was last modified.  This differs from idletime as it is not affected by reads 
  of a key.
* `OBJECT FREQ <key>` returns the logarithmic access frequency counter of the
  object stored at the specified key. This subcommand is available when
  `maxmemory-policy` is set to an LFU policy.
* `OBJECT HELP` returns a succint help text.

Objects can be encoded in different ways:

* Strings can be encoded as `raw` (normal string encoding) or `int` (strings
  representing integers in a 64 bit signed interval are encoded in this way in
  order to save space).
* Lists can be encoded as `ziplist`, `quicklist`, or `linkedlist`.
  The `ziplist` is the special representation that is used to save space for
  small lists.
* Sets can be encoded as `intset` or `hashtable`.
  The `intset` is a special encoding used for small sets composed solely of
  integers.
* Hashes can be encoded as `ziplist` or `hashtable`.
  The `ziplist` is a special encoding used for small hashes.
* Sorted Sets can be encoded as `ziplist` or `skiplist` format.
  As for the List type small sorted sets can be specially encoded using
  `ziplist`, while the `skiplist` encoding is the one that works with sorted
  sets of any size.

All the specially encoded types are automatically converted to the general type
once you perform an operation that makes it impossible for KeyDB to retain the
space saving encoding.

#### Return:

Different return values are used for different subcommands.

* Subcommands `refcount` and `idletime` return integers.
* Subcommand `encoding` returns a bulk reply.

If the object you try to inspect is missing, a null bulk reply is returned.

#### Examples:

```
keydb-cli> LPUSH mylist "Hello World"
(integer) 1
keydb-cli> OBJECT REFCOUNT mylist
(integer) 1
keydb-cli> OBJECT ENCODING mylist
"quicklist"
keydb-cli> OBJECT IDLETIME mylist
(integer) 17
```

In the following example you can see how the encoding changes once KeyDB is no
longer able to use the space saving encoding.

```
keydb-cli> SET foo 1000
OK
keydb-cli> OBJECT ENCODING foo
"int"
keydb-cli> APPEND foo bar
(integer) 7
keydb-cli> GET foo
"1000bar"
keydb-cli> OBJECT ENCODING foo
"raw"
```

---




## PERSIST

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```PERSIST <key>```

```PERSIST <key> <subkey>```

#### Description:

Remove the existing timeout on `key`, turning the key from _volatile_ (a key
with an expire set) to _persistent_ (a key that will never expire as no timeout
is associated).

PERSIST also works similarly with subkey expires (members of a set)

#### Return:

Integer Reply, specifically:

* `1` if the timeout was removed.
* `0` if `key` does not exist or does not have an associated timeout.

#### Examples:

```
keydb-cli> SET mykey "Hello"
OK
keydb-cli> EXPIRE mykey 100
(integer) 1
keydb-cli> TTL mykey
(integer) 97
keydb-cli> PERSIST mykey
(integer) 1
keydb-cli> TTL mykey
(integer) -1
```

```
keydb-cli> SADD myset member1 member2
(integer) 2
keydb-cli> EXPIREMEMBER myset member2 100
(integer) 1
keydb-cli> TTL myset member2
(integer) 95
keydb-cli> PERSIST myset member2
(integer) 1
keydb-cli> TTL myset member2
(integer) -1
```

---




## PEXPIRE

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```PEXPIRE <key> <time-to-live>```

#### Description:

This command works exactly like `EXPIRE` but the time to live of the key is
specified in milliseconds instead of seconds.

#### Return:

Integer Reply, specifically:

* `1` if the timeout was set.
* `0` if `key` does not exist.

#### Examples:

```
keydb-cli> SET mykey "Hello"
OK
keydb-cli> PEXPIRE mykey 15000
(integer) 1
keydb-cli> TTL mykey
(integer) 11
keydb-cli> PTTL mykey
(integer) 4569
```

---




## PEXPIREAT

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```PEXPIREAT <key> <milliseconds-unit-timestamp>```

#### Description:

`PEXPIREAT` has the same effect and semantic as `EXPIREAT`, but the Unix time at
which the key will expire is specified in milliseconds instead of seconds.

#### Return:

Integer Reply, specifically:

* `1` if the timeout was set.
* `0` if `key` does not exist.

#### Examples:

```
keydb-cli> SET mykey "Hello"
OK
keydb-cli> PEXPIREAT mykey 2000000000000
(integer) 1
keydb-cli> TTL mykey
(integer) 368952269
keydb-cli> PTTL mykey
(integer) 368952265316
```

---





## PFADD

**Related Commands:** [PFADD](/docs/commands/#pfadd), [PFCOUNT](/docs/commands/#pfcount), [PFMERGE](/docs/commands/#pfmerge)

#### Syntax:

```PFADD <key> <element-1> ... <element-n>```

#### Description:

Adds all the element arguments to the HyperLogLog data structure stored at the variable name specified as first argument.

As a side effect of this command the HyperLogLog internals may be updated to reflect a different estimation of the number of unique items added so far (the cardinality of the set).

If the approximated cardinality estimated by the HyperLogLog changed after executing the command, `PFADD` returns 1, otherwise 0 is returned. The command automatically creates an empty HyperLogLog structure (that is, a KeyDB String of a specified length and with a given encoding) if the specified key does not exist.

To call the command without elements but just the variable name is valid, this will result into no operation performed if the variable already exists, or just the creation of the data structure if the key does not exist (in the latter case 1 is returned).

For an introduction to HyperLogLog data structure check the `PFCOUNT` command page.

#### Return:

Integer Reply, specifically:

* 1 if at least 1 HyperLogLog internal register was altered. 0 otherwise.

#### Examples:

```
keydb-cli> PFADD hll a b c d e f g
(integer) 1
keydb-cli> PFCOUNT hll
(integer) 7
```

---




## PFCOUNT

**Related Commands:** [PFADD](/docs/commands/#pfadd), [PFCOUNT](/docs/commands/#pfcount), [PFMERGE](/docs/commands/#pfmerge)

#### Syntax:

```PFCOUNT <key>```

```PFCOUNT <key-1> ... <key-n>```

#### Description:

When called with a single key, returns the approximated cardinality computed by the HyperLogLog data structure stored at the specified variable, which is 0 if the variable does not exist.

When called with multiple keys, returns the approximated cardinality of the union of the HyperLogLogs passed, by internally merging the HyperLogLogs stored at the provided keys into a temporary HyperLogLog.

The HyperLogLog data structure can be used in order to count **unique** elements in a set using just a small constant amount of memory, specifically 12k bytes for every HyperLogLog (plus a few bytes for the key itself).

The returned cardinality of the observed set is not exact, but approximated with a standard error of 0.81%.

For example in order to take the count of all the unique search queries performed in a day, a program needs to call `PFADD` every time a query is processed. The estimated number of unique queries can be retrieved with `PFCOUNT` at any time.

Note: as a side effect of calling this function, it is possible that the HyperLogLog is modified, since the last 8 bytes encode the latest computed cardinality
for caching purposes. So `PFCOUNT` is technically a write command.

#### Return:

Integer Reply, specifically:

* The approximated number of unique elements observed via `PFADD`.

#### Examples:

```
keydb-cli> PFADD hll foo bar zap
(integer) 1
keydb-cli> PFADD hll zap zap zap
(integer) 0
keydb-cli> PFADD hll foo bar
(integer) 0
keydb-cli> PFCOUNT hll
(integer) 3
keydb-cli> PFADD some-other-hll 1 2 3
(integer) 1
keydb-cli> PFCOUNT hll some-other-hll
(integer) 6
```

#### Performances


When `PFCOUNT` is called with a single key, performances are excellent even if
in theory constant times to process a dense HyperLogLog are high. This is
possible because the `PFCOUNT` uses caching in order to remember the cardinality
previously computed, that rarely changes because most `PFADD` operations will
not update any register. Hundreds of operations per second are possible.

When `PFCOUNT` is called with multiple keys, an on-the-fly merge of the
HyperLogLogs is performed, which is slow, moreover the cardinality of the union
can't be cached, so when used with multiple keys `PFCOUNT` may take a time in
the order of magnitude of the millisecond, and should be not abused.

The user should take in mind that single-key and multiple-keys executions of
this command are semantically different and have different performances.

#### HyperLogLog representation


KeyDB HyperLogLogs are represented using a double representation: the *sparse* representation suitable for HLLs counting a small number of elements (resulting in a small number of registers set to non-zero value), and a *dense* representation suitable for higher cardinalities. KeyDB automatically switches from the sparse to the dense representation when needed.

The sparse representation uses a run-length encoding optimized to store efficiently a big number of registers set to zero. The dense representation is a KeyDB string of 12288 bytes in order to store 16384 6-bit counters. The need for the double representation comes from the fact that using 12k (which is the dense representation memory requirement) to encode just a few registers for smaller cardinalities is extremely suboptimal.

Both representations are prefixed with a 16 bytes header, that includes a magic, an encoding / version field, and the cached cardinality estimation computed, stored in little endian format (the most significant bit is 1 if the estimation is invalid since the HyperLogLog was updated since the cardinality was computed).

The HyperLogLog, being a KeyDB string, can be retrieved with `GET` and restored with `SET`. Calling `PFADD`, `PFCOUNT` or `PFMERGE` commands with a corrupted HyperLogLog is never a problem, it may return random values but does not affect the stability of the server. Most of the times when corrupting a sparse representation, the server recognizes the corruption and returns an error.

The representation is neutral from the point of view of the processor word size and endianness, so the same representation is used by 32 bit and 64 bit processor, big endian or little endian.

The source code of the implementation in the `hyperloglog.c` file is also easy to read and understand, and includes a full specification for the exact encoding used for the sparse and dense representations.

---




## PFMERGE

**Related Commands:** [PFADD](/docs/commands/#pfadd), [PFCOUNT](/docs/commands/#pfcount), [PFMERGE](/docs/commands/#pfmerge)

#### Syntax:

```PFMERGE <destination-key> <source-key-1> ... <source-key-n>```

#### Description:

Merge multiple HyperLogLog values into an unique value that will approximate
the cardinality of the union of the observed Sets of the source HyperLogLog
structures.

The computed merged HyperLogLog is set to the destination variable, which is
created if does not exist (defaulting to an empty HyperLogLog).

#### Return:

Simple String Reply: The command just returns `OK`.

#### Examples:

```
keydb-cli> PFADD hll1 foo bar zap a
(integer) 1
keydb-cli> PFADD hll2 a b c foo
(integer) 1
keydb-cli> PFMERGE hll3 hll1 hll2
OK
keydb-cli> PFCOUNT hll3
(integer) 6
```

---




## PING

**Related Commands:** [AUTH](/docs/commands/#append), [ECHO](/docs/commands/#echo), [PING](/docs/commands/#ping), [QUIT](/docs/commands/#quit), [SELECT](/docs/commands/#select), [SWAPDB](/docs/commands/#swapdb)

#### Syntax:

```PING <message>```

#### Description:

Returns `PONG` if no argument is provided, otherwise return a copy of the
argument as a bulk.
This command is often used to test if a connection is still alive, or to measure
latency.

If the client is subscribed to a channel or a pattern, it will instead return a
multi-bulk with a "pong" in the first position and an empty bulk in the second
position, unless an argument is provided in which case it returns a copy
of the argument.

#### Return:

Simple String Reply

#### Examples:

```
keydb-cli> PING
PONG
keydb-cli> PING "hello world"
"hello world"
```

---




## PSETEX

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```PSETEX <key> <milliseconds-to-expire> <value>```

#### Description:

`PSETEX` works exactly like `SETEX` with the sole difference that the expire
time is specified in milliseconds instead of seconds.

#### Examples:

```
keydb-cli> PSETEX mykey 1000 "Hello"
OK
keydb-cli> PTTL mykey
(integer) -2
keydb-cli> GET mykey
(nil)
```

---




## PSUBSCRIBE

**Related Commands:** [PSUBSCRIBE](/docs/commands/#psubscribe), [PUBLISH](/docs/commands/#publish), [PUBSUB](/docs/commands/#pubsub), [PUNSUBSCRIBE](/docs/commands/#punsubscribe), [SUBSCRIBE](/docs/commands/#subscribe), [UNSUBSCRIBE](/docs/commands/#unsubscribe)

Subscribes the client to the given patterns.

Supported glob-style patterns:

* `h?llo` subscribes to `hello`, `hallo` and `hxllo`
* `h*llo` subscribes to `hllo` and `heeeello`
* `h[ae]llo` subscribes to `hello` and `hallo,` but not `hillo`

Use `\` to escape special characters if you want to match them verbatim.

---


## PSYNC

Initiates a replication stream from the master.

The PSYNC command is called by KeyDB replicas for initiating a replication stream from the master.

For more information about replication in KeyDB, please check the [replication page](/docs/replication).

#### Return value:

Non standard return value, a bulk transfer of the data followed by PING and write requests from the master.




---





## PTTL

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```PTTL <key>```

#### Description:

Like `TTL` this command returns the remaining time to live of a key or subkey that has an
expire set, with the sole difference that `TTL` returns the amount of remaining
time in seconds while `PTTL` returns it in milliseconds.

#### Return:

Integer Reply: TTL in milliseconds, or a negative value in order to signal an error (see the description above).

#### Examples:

```
127.0.0.1:6379> SET mykey "Hello"
OK
127.0.0.1:6379> EXPIRE mykey 10
(integer) 1
127.0.0.1:6379> PTTL mykey
(integer) 5846
```

```
127.0.0.1:6379> SADD myset member1 member2
(integer) 2
127.0.0.1:6379> EXPIREMEMBER myset member2 10
(integer) 1
127.0.0.1:6379> PTTL myset member2
(integer) 4159
```

---




## PUBLISH

**Related Commands:** [PSUBSCRIBE](/docs/commands/#psubscribe), [PUBLISH](/docs/commands/#publish), [PUBSUB](/docs/commands/#pubsub), [PUNSUBSCRIBE](/docs/commands/#punsubscribe), [SUBSCRIBE](/docs/commands/#subscribe), [UNSUBSCRIBE](/docs/commands/#unsubscribe)

Posts a message to the given channel.

#### Return:

Integer Reply: the number of clients that received the message.

---




## PUBSUB

**Related Commands:** [PSUBSCRIBE](/docs/commands/#psubscribe), [PUBLISH](/docs/commands/#publish), [PUBSUB](/docs/commands/#pubsub), [PUNSUBSCRIBE](/docs/commands/#punsubscribe), [SUBSCRIBE](/docs/commands/#subscribe), [UNSUBSCRIBE](/docs/commands/#unsubscribe)

The PUBSUB command is an introspection command that allows to inspect the
state of the Pub/Sub subsystem. It is composed of subcommands that are
documented separately. The general form is:

    PUBSUB <subcommand> ... args ...

### PUBSUB CHANNELS
PUBSUB CHANNELS [pattern]

Lists the currently *active channels*. An active channel is a Pub/Sub channel
with one or more subscribers (not including clients subscribed to patterns).

If no `pattern` is specified, all the channels are listed, otherwise if pattern
is specified only channels matching the specified glob-style pattern are
listed.

#### Return:

Array Reply: a list of active channels, optionally matching the specified pattern.

### PUBSUB NUMSUB
`PUBSUB NUMSUB [channel-1 ... channel-N]`

Returns the number of subscribers (not counting clients subscribed to patterns)
for the specified channels.

#### Return:

Array Reply: a list of channels and number of subscribers for every channel. The format is channel, count, channel, count, ..., so the list is flat.
The order in which the channels are listed is the same as the order of the
channels specified in the command call.

Note that it is valid to call this command without channels. In this case it
will just return an empty list.

### PUBSUB NUMPAT

Returns the number of subscriptions to patterns (that are performed using the
`PSUBSCRIBE` command). Note that this is not just the count of clients subscribed
to patterns but the total number of patterns all the clients are subscribed to.

#### Return:

Integer Reply: the number of patterns all the clients are subscribed to.

---





## PUNSUBSCRIBE

**Related Commands:** [PSUBSCRIBE](/docs/commands/#psubscribe), [PUBLISH](/docs/commands/#publish), [PUBSUB](/docs/commands/#pubsub), [PUNSUBSCRIBE](/docs/commands/#punsubscribe), [SUBSCRIBE](/docs/commands/#subscribe), [UNSUBSCRIBE](/docs/commands/#unsubscribe)

Unsubscribes the client from the given patterns, or from all of them if none is
given.

When no patterns are specified, the client is unsubscribed from all the
previously subscribed patterns.
In this case, a message for every unsubscribed pattern will be sent to the
client.

---




## QUIT

**Related Commands:** [AUTH](/docs/commands/#append), [ECHO](/docs/commands/#echo), [PING](/docs/commands/#ping), [QUIT](/docs/commands/#quit), [SELECT](/docs/commands/#select), [SWAPDB](/docs/commands/#swapdb)

Ask the server to close the connection.
The connection is closed as soon as all pending replies have been written to the
client.

#### Return:

Simple String Reply: always OK.

---




## RANDOMKEY

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

Return a random key from the currently selected database.

#### Return:

Bulk String Reply: the random key, or `nil` when the database is empty.

#### Examples

```
keydb-cli> flushall
OK
keydb-cli> RANDOMKEY
(nil)
keydb-cli> SET k 1
OK
keydb-cli> RANDOMKEY
"k"
keydb-cli> SET l 2
OK
keydb-cli> RANDOMKEY
"k"
keydb-cli> RANDOMKEY
"l"
```
---




## READONLY

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

Enables read queries for a connection to a KeyDB Cluster replica node. 

Normally replica nodes will redirect clients to the authoritative master for
the hash slot involved in a given command, however clients can use replicas
in order to scale reads using the `READONLY` command.

`READONLY` tells a KeyDB Cluster replica node that the client is willing to
read possibly stale data and is not interested in running write queries.

When the connection is in readonly mode, the cluster will send a redirection
to the client only if the operation involves keys not served by the replica's
master node. This may happen because:

1. The client sent a command about hash slots never served by the master of this replica.
2. The cluster was reconfigured (for example resharded) and the replica is no longer able to serve commands for a given hash slot.

#### Return:

Simple String Reply

---




## READWRITE

**Related Commands:** [CLUSTER ADDSLOTS](/docs/commands/#cluster-addslots), [CLUSTER BUMPEPOCH](/docs/commands/#cluster-bumpepoch), [CLUSTER ](/docs/commands/#cluster ), [COUNT-FAILURE-REPORTS](/docs/commands/#count-failure-reports), [CLUSTER COUNTKEYSINSLOT](/docs/commands/#cluster-countkeysinslot), [CLUSTER DELSLOTS](/docs/commands/#cluster-delslots), [CLUSTER FAILOVER](/docs/commands/#cluster-failover), [CLUSTER FLUSHSLOTS](/docs/commands/#cluster-flushslots), [CLUSTER FORGET](/docs/commands/#cluster-forget), [CLUSTER GETKEYSINSLOT](/docs/commands/#cluster-getkeysinslot), [CLUSTER INFO](/docs/commands/#cluster-info), [CLUSTER KEYSLOT](/docs/commands/#cluster-keyslot), [CLUSTER MEET](/docs/commands/#cluster-meet), [CLUSTER MYID](/docs/commands/#cluster-myid), [CLUSTER NODES](/docs/commands/#cluster-nodes), [CLUSTER REPLICAS](/docs/commands/#cluster-replicas), [CLUSTER REPLICATE](/docs/commands/#cluster-replicate), [CLUSTER RESET](/docs/commands/#cluster-reset), [CLUSTER SAVECONFIG](/docs/commands/#cluster-saveconfig), [CLUSTER SET-CONFIG-EPOCH](/docs/commands/#cluster-set-config-epoch), [CLUSTER SETSLOT](/docs/commands/#cluster-setslot), [CLUSTER SLAVES](/docs/commands/#cluster-slaves), [CLUSTER SLOTS](/docs/commands/#cluster-slots), [READONLY](/docs/commands/#readonly), [READWRITE](/docs/commands/#readwrite)

Disables read queries for a connection to a KeyDB Cluster slave node.

Read queries against a KeyDB Cluster slave node are disabled by default,
but you can use the `READONLY` command to change this behavior on a per-
connection basis. The `READWRITE` command resets the readonly mode flag
of a connection back to readwrite.

#### Return:

Simple String Reply

---




## RENAME

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```RENAME <key> <newkey>```

#### Description:

Renames `key` to `newkey`.
It returns an error when `key` does not exist.
If `newkey` already exists it is overwritten, when this happens `RENAME` executes an implicit `DEL` operation, so if the deleted key contains a very big value it may cause high latency even if `RENAME` itself is usually a constant-time operation.

**REMINDER:** Before KeyDB 3.2.0, an error is returned if source and destination names are the same.

#### Return:

Simple String Reply

#### Examples:

```
keydb-cli> SET mykey "Hello"
OK
keydb-cli> RENAME mykey myotherkey
OK
keydb-cli> GET myotherkey
"Hello"
```

---




## RENAMENX

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```RENAMENX <key> <newkey>```

#### Description:

Renames `key` to `newkey` if `newkey` does not yet exist.
It returns an error when `key` does not exist.

**REMINDER:** Before KeyDB 3.2.0, an error is returned if source and destination names are the same.

#### Return:

Integer Reply, specifically:

* `1` if `key` was renamed to `newkey`.
* `0` if `newkey` already exists.

#### Examples:

```
keydb-cli> SET mykey "Hello"
OK
keydb-cli> SET myotherkey "World"
OK
keydb-cli> RENAMENX mykey myotherkey
(integer) 0
keydb-cli> GET myotherkey
"World"
```

---





## REPLICAOF

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `REPLICAOF` command can change the replication settings of a replica on the fly.

If a KeyDB server is already acting as replica, the command `REPLICAOF NO ONE` will turn off the replication, turning the KeyDB server into a MASTER.  In the proper form `REPLICAOF <hostname> <port>` will make the server a replica of another server listening at the specified hostname and port.

If a server is already a replica of some master, `REPLICAOF <hostname> <port>` will stop the replication against the old server and start the synchronization against the new one, discarding the old dataset.

The form `REPLICAOF NO ONE` will stop replication, turning the server into a MASTER, but will not discard the replication. So, if the old master stops working, it is possible to turn the replica into a master and set the application to use this new master in read/write. Later when the other KeyDB server is fixed, it can be reconfigured to work as a replica.

#### Return:

Simple String Reply

---

## REPLPING

**Related Commands:** [PING](/docs/commands/#ping)

Identical to [PING](/docs/commands/#ping), except that a blocked server will
respond to it. Used internally to keep replication connections alive.

#### Return:

Simple String Reply

#### Examples:

```
keydb-cli> REPLPING
PONG
```

---

## RESTORE

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```RESTORE <key> <ttl> <serialized-value> <OPTIONAL:REPLACE> <OPTIONAL:ABSTTL> <OPTIONAL:IDLETIME> <IDLETIME-argument:seconds> <OPTIONAL:FREQ> <FREQ-argument:frequency> ```

#### Description:

Create a key associated with a value that is obtained by deserializing the
provided serialized value (obtained via `DUMP`).

If `ttl` is 0 the key is created without any expire, otherwise the specified
expire time (in milliseconds) is set.

If the `ABSTTL` modifier was used, `ttl` should represent an absolute
[Unix timestamp](http://en.wikipedia.org/wiki/Unix_time) (in milliseconds) in which the key will expire.
(KeyDB 5.0 or greater).


For eviction purposes, you may use the `IDLETIME` or `FREQ` modifiers. See
`OBJECT` for more information (KeyDB 5.0 or greater).

`RESTORE` will return a "Target key name is busy" error when `key` already
exists unless you use the `REPLACE` modifier (KeyDB 3.0 or greater).

`RESTORE` checks the RDB version and data checksum.
If they don't match an error is returned.

#### Return:

Simple String Reply: The command returns OK on success.

#### Examples:

```
keydb-cli> DEL mykey
0
keydb-cli> RESTORE mykey 0 "\n\x17\x17\x00\x00\x00\x12\x00\x00\x00\x03\x00\
                        x00\xc0\x01\x00\x04\xc0\x02\x00\x04\xc0\x03\x00\
                        xff\x04\x00u#<\xc0;.\xe9\xdd"
OK
keydb-cli> TYPE mykey
list
keydb-cli> LRANGE mykey 0 -1
1) "1"
2) "2"
3) "3"
```

---





## ROLE

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

Provide information on the role of a KeyDB instance in the context of replication, by returning if the instance is currently a `master`, `slave`, or `sentinel`. The command also returns additional information about the state of the replication (if the role is master or slave) or the list of monitored master names (if the role is sentinel).

#### Output format

The command returns an array of elements. The first element is the role of
the instance, as one of the following three strings:

* "master"
* "slave"
* "sentinel"

The additional elements of the array depends on the role.

#### Master output

An example of output when `ROLE` is called in a master instance:

```
1) "master"
2) (integer) 3129659
3) 1) 1) "127.0.0.1"
      2) "9001"
      3) "3129242"
   2) 1) "127.0.0.1"
      2) "9002"
      3) "3129543"
```

The master output is composed of the following parts:

1. The string `master`.
2. The current master replication offset, which is an offset that masters and replicas share to understand, in partial resynchronizations, the part of the replication stream the replicas needs to fetch to continue.
3. An array composed of three elements array representing the connected replicas. Every sub-array contains the replica IP, port, and the last acknowledged replication offset.

#### Output of the command on replicas

An example of output when `ROLE` is called in a replica instance:

```
1) "slave"
2) "127.0.0.1"
3) (integer) 9000
4) "connected"
5) (integer) 3167038
```

The replica output is composed of the following parts:

1. The string `slave`, because of backward compatbility (see note at the end of this page).
2. The IP of the master.
3. The port number of the master.
4. The state of the replication from the point of view of the master, that can be `connect` (the instance needs to connect to its master), `connecting` (the master-replica connection is in progress), `sync` (the master and replica are trying to perform the synchronization), `connected` (the replica is online).
5. The amount of data received from the replica so far in terms of master replication offset.

#### Sentinel output

An example of Sentinel output:

```
1) "sentinel"
2) 1) "resque-master"
   2) "html-fragments-master"
   3) "stats-master"
   4) "metadata-master"
```

The sentinel output is composed of the following parts:

1. The string `sentinel`.
2. An array of master names monitored by this Sentinel instance.

#### Return:

Array Reply: where the first element is one of `master`, `slave`, `sentinel` and the additional elements are role-specific as illustrated above.


#### Examples:

```
keydb-cli> ROLE
1) "master"
2) (integer) 0
3) (empty array)
```

**A note about the word slave used in this man page**: Starting with KeyDB 5, if not for backward compatibility, the KeyDB project no longer uses the word slave. Unfortunately in this command the word slave is part of the protocol, so we'll be able to remove such occurrences only when this API will be naturally deprecated.

---




## RPOP

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```RPOP <key>```

#### Description:

Removes and returns the last element of the list stored at `key`.

#### Return:

Bulk String Reply: the value of the last element, or `nil` when `key` does not exist.

#### Examples:

```
keydb-cli> RPUSH mylist "one"
(integer) 1
keydb-cli> RPUSH mylist "two"
(integer) 2
keydb-cli> RPUSH mylist "three"
(integer) 3
keydb-cli> RPOP mylist
"three"
keydb-cli> LRANGE mylist 0 -1
1) "one"
2) "two"
```

---





## RPOPLPUSH

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```RPOPLPUSH <source> <destination>```

#### Description:

Atomically returns and removes the last element (tail) of the list stored at
`source`, and pushes the element at the first element (head) of the list stored
at `destination`.

For example: consider `source` holding the list `a,b,c`, and `destination`
holding the list `x,y,z`.
Executing `RPOPLPUSH` results in `source` holding `a,b` and `destination`
holding `c,x,y,z`.

If `source` does not exist, the value `nil` is returned and no operation is
performed.
If `source` and `destination` are the same, the operation is equivalent to
removing the last element from the list and pushing it as first element of the
list, so it can be considered as a list rotation command.

#### Return:

Bulk String Reply: the element being popped and pushed.

#### Examples:

```
keydb-cli> RPUSH mylist "one"
(integer) 1
keydb-cli> RPUSH mylist "two"
(integer) 2
keydb-cli> RPUSH mylist "three"
(integer) 3
keydb-cli> RPOPLPUSH mylist myotherlist
"three"
keydb-cli> LRANGE mylist 0 -1
1) "one"
2) "two"
keydb-cli> LRANGE myotherlist 0 -1
1) "three"
```

#### Pattern: Reliable queue

KeyDB is often used as a messaging server to implement processing of background
jobs or other kinds of messaging tasks.
A simple form of queue is often obtained pushing values into a list in the
producer side, and waiting for this values in the consumer side using `RPOP`
(using polling), or `BRPOP` if the client is better served by a blocking
operation.

However in this context the obtained queue is not _reliable_ as messages can
be lost, for example in the case there is a network problem or if the consumer
crashes just after the message is received but it is still to process.

`RPOPLPUSH` (or `BRPOPLPUSH` for the blocking variant) offers a way to avoid
this problem: the consumer fetches the message and at the same time pushes it
into a _processing_ list.
It will use the `LREM` command in order to remove the message from the
_processing_ list once the message has been processed.

An additional client may monitor the _processing_ list for items that remain
there for too much time, and will push those timed out items into the queue
again if needed.

#### Pattern: Circular list

Using `RPOPLPUSH` with the same source and destination key, a client can visit
all the elements of an N-elements list, one after the other, in O(N) without
transferring the full list from the server to the client using a single `LRANGE`
operation.

The above pattern works even if the following two conditions:

* There are multiple clients rotating the list: they'll fetch different 
  elements, until all the elements of the list are visited, and the process 
  restarts.
* Even if other clients are actively pushing new items at the end of the list.

The above makes it very simple to implement a system where a set of items must
be processed by N workers continuously as fast as possible.
An example is a monitoring system that must check that a set of web sites are
reachable, with the smallest delay possible, using a number of parallel workers.

Note that this implementation of workers is trivially scalable and reliable,
because even if a message is lost the item is still in the queue and will be
processed at the next iteration.

---




## RPUSH

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```RPUSH <key> <element-1> ... <element-n>``` 

#### Description:

Insert all the specified values at the tail of the list stored at `key`.
If `key` does not exist, it is created as empty list before performing the push
operation.
When `key` holds a value that is not a list, an error is returned.

It is possible to push multiple elements using a single command call just
specifying multiple arguments at the end of the command.
Elements are inserted one after the other to the tail of the list, from the
leftmost element to the rightmost element.
So for instance the command `RPUSH mylist a b c` will result into a list
containing `a` as first element, `b` as second element and `c` as third element.

#### Return:

Integer Reply: the length of the list after the push operation.


#### Examples:

```
keydb-cli> RPUSH mylist "hello"
(integer) 1
keydb-cli> RPUSH mylist "world"
(integer) 2
keydb-cli> LRANGE mylist 0 -1
1) "hello"
2) "world"
```

---




## RPUSHX

**Related Commands:** [BLPOP](/docs/commands/#blpop), [BRPOP](/docs/commands/#brpop), [BRPOPLPUSH](/docs/commands/#brpoplpush), [LINDEX](/docs/commands/#lindex), [LINSERT](/docs/commands/#linsert), [LLEN](/docs/commands/#llen), [LPOP](/docs/commands/#lpop), [LPUSH](/docs/commands/#lpush), [LPUSHX](/docs/commands/#lpushx), [LRANGE](/docs/commands/#lrange), [LREM](/docs/commands/#lrem), [LSET](/docs/commands/#LSET), [LTRIM](/docs/commands/#LTRIM), [RPOP](/docs/commands/#RPOP), [RPOPLPUSH](/docs/commands/#RPOPLPUSH), [RPUSH](/docs/commands/#rpush), [RPUSHX](/docs/commands/#rpushx) 

#### Syntax:

```RPUSHX <key> <value>```

#### Description:

Inserts `value` at the tail of the list stored at `key`, only if `key` already
exists and holds a list.
In contrary to `RPUSH`, no operation will be performed when `key` does not yet
exist.

#### Return:

Integer Reply: the length of the list after the push operation.

#### Examples:

```
keydb-cli> RPUSH mylist "Hello"
(integer) 1
keydb-cli> RPUSHX mylist "World"
(integer) 2
keydb-cli> RPUSHX myotherlist "World"
(integer) 0
keydb-cli> LRANGE mylist 0 -1
1) "Hello"
2) "World"
keydb-cli> LRANGE myotherlist 0 -1
(empty array)
```

---




## SADD

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```SADD <key> <member-1> ... <member-n>```

#### Description:

Add the specified members to the set stored at `key`.
Specified members that are already a member of this set are ignored.
If `key` does not exist, a new set is created before adding the specified
members.

An error is returned when the value stored at `key` is not a set.

#### Return:

Integer Reply: the number of elements that were added to the set, not including
all the elements already present into the set.


#### Examples:

```
keydb-cli> SADD myset "Hello"
(integer) 1
keydb-cli> SADD myset "World"
(integer) 1
keydb-cli> SADD myset "World"
(integer) 0
keydb-cli> SMEMBERS myset
1) "Hello"
2) "World"
```

---




## SAVE

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `SAVE` commands performs a **synchronous** save of the dataset producing a
_point in time_ snapshot of all the data inside the KeyDB instance, in the form
of an RDB file.

You almost never want to call `SAVE` in production environments where it will
block all the other clients.
Instead usually `BGSAVE` is used.
However in case of issues preventing KeyDB to create the background saving child
(for instance errors in the fork(2) system call), the `SAVE` command can be a
good last resort to perform the dump of the latest dataset.

Please refer to the [persistence documentation](https://docs.keydb.dev/docs/persistence/) for detailed information.


#### Return:

Simple String Reply: The commands returns OK on success.

---




## SCAN

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```SCAN <cursor> <OPTIONAL:MATCH> <MATCH-argument:pattern> <OPTIONAL:COUNT> <COUNT-argument:count> <OPTIONAL:TYPE> <TYPE-argument:type>```

#### Description:

The `SCAN` command and the closely related commands `SSCAN`, `HSCAN` and `ZSCAN` are used in order to incrementally iterate over a collection of elements.

* `SCAN` iterates the set of keys in the currently selected KeyDB database.
* `SSCAN` iterates elements of Sets types.
* `HSCAN` iterates fields of Hash types and their associated values.
* `ZSCAN` iterates elements of Sorted Set types and their associated scores.

Since these commands allow for incremental iteration, returning only a small number of elements per call, they can be used in production without the downside of commands like `KEYS` or `SMEMBERS` that may block the server for a long time (even several seconds) when called against big collections of keys or elements.

However while blocking commands like `SMEMBERS` are able to provide all the elements that are part of a Set in a given moment, The SCAN family of commands only offer limited guarantees about the returned elements since the collection that we incrementally iterate can change during the iteration process.

Note that `SCAN`, `SSCAN`, `HSCAN` and `ZSCAN` all work very similarly, so this documentation covers all the four commands. However an obvious difference is that in the case of `SSCAN`, `HSCAN` and `ZSCAN` the first argument is the name of the key holding the Set, Hash or Sorted Set value. The `SCAN` command does not need any key name argument as it iterates keys in the current database, so the iterated object is the database itself.

#### SCAN basic usage

SCAN is a cursor based iterator. This means that at every call of the command, the server returns an updated cursor that the user needs to use as the cursor argument in the next call.

An iteration starts when the cursor is set to 0, and terminates when the cursor returned by the server is 0. The following is an example of SCAN iteration:

```
keydb-cli> scan 0
1) "17"
2)  1) "key:12"
    2) "key:8"
    3) "key:4"
    4) "key:14"
    5) "key:16"
    6) "key:17"
    7) "key:15"
    8) "key:10"
    9) "key:3"
   10) "key:7"
   11) "key:1"
keydb-cli> scan 17
1) "0"
2) 1) "key:5"
   2) "key:18"
   3) "key:0"
   4) "key:2"
   5) "key:19"
   6) "key:13"
   7) "key:6"
   8) "key:9"
   9) "key:11"
```

In the example above, the first call uses zero as a cursor, to start the iteration. The second call uses the cursor returned by the previous call as the first element of the reply, that is, 17.

As you can see the **SCAN return value** is an array of two values: the first value is the new cursor to use in the next call, the second value is an array of elements.

Since in the second call the returned cursor is 0, the server signaled to the caller that the iteration finished, and the collection was completely explored. Starting an iteration with a cursor value of 0, and calling `SCAN` until the returned cursor is 0 again is called a **full iteration**.

#### Scan guarantees

The `SCAN` command, and the other commands in the `SCAN` family, are able to provide to the user a set of guarantees associated to full iterations.

* A full iteration always retrieves all the elements that were present in the collection from the start to the end of a full iteration. This means that if a given element is inside the collection when an iteration is started, and is still there when an iteration terminates, then at some point `SCAN` returned it to the user.
* A full iteration never returns any element that was NOT present in the collection from the start to the end of a full iteration. So if an element was removed before the start of an iteration, and is never added back to the collection for all the time an iteration lasts, `SCAN` ensures that this element will never be returned.

However because `SCAN` has very little state associated (just the cursor) it has the following drawbacks:

* A given element may be returned multiple times. It is up to the application to handle the case of duplicated elements, for example only using the returned elements in order to perform operations that are safe when re-applied multiple times.
* Elements that were not constantly present in the collection during a full iteration, may be returned or not: it is undefined.

#### Number of elements returned at every SCAN call

`SCAN` family functions do not guarantee that the number of elements returned per call are in a given range. The commands are also allowed to return zero elements, and the client should not consider the iteration complete as long as the returned cursor is not zero.

However the number of returned elements is reasonable, that is, in practical terms SCAN may return a maximum number of elements in the order of a few tens of elements when iterating a large collection, or may return all the elements of the collection in a single call when the iterated collection is small enough to be internally represented as an encoded data structure (this happens for small sets, hashes and sorted sets).

However there is a way for the user to tune the order of magnitude of the number of returned elements per call using the **COUNT** option.

### The COUNT option

While `SCAN` does not provide guarantees about the number of elements returned at every iteration, it is possible to empirically adjust the behavior of `SCAN` using the **COUNT** option. Basically with COUNT the user specified the *amount of work that should be done at every call in order to retrieve elements from the collection*. This is **just a hint** for the implementation, however generally speaking this is what you could expect most of the times from the implementation.

* The default COUNT value is 10.
* When iterating the key space, or a Set, Hash or Sorted Set that is big enough to be represented by a hash table, assuming no **MATCH** option is used, the server will usually return *count* or a bit more than *count* elements per call. Please check the *why SCAN may return all the elements at once* section later in this document.
* When iterating Sets encoded as intsets (small sets composed of just integers), or Hashes and Sorted Sets encoded as ziplists (small hashes and sets composed of small individual values), usually all the elements are returned in the first `SCAN` call regardless of the COUNT value.

Important: **there is no need to use the same COUNT value** for every iteration. The caller is free to change the count from one iteration to the other as required, as long as the cursor passed in the next call is the one obtained in the previous call to the command.

### The MATCH option

It is possible to only iterate elements matching a given glob-style pattern, similarly to the behavior of the `KEYS` command that takes a pattern as only argument.

To do so, just append the `MATCH <pattern>` arguments at the end of the `SCAN` command (it works with all the SCAN family commands).

This is an example of iteration using **MATCH**:

```
keydb-cli> sadd myset 1 2 3 foo foobar feelsgood
(integer) 6
keydb-cli> sscan myset 0 match f*
1) "0"
2) 1) "foo"
   2) "feelsgood"
   3) "foobar"
```

It is important to note that the **MATCH** filter is applied after elements are retrieved from the collection, just before returning data to the client. This means that if the pattern matches very little elements inside the collection, `SCAN` will likely return no elements in most iterations. An example is shown below:

```
keydb-cli> scan 0 MATCH *11*
1) "288"
2) 1) "key:911"
keydb-cli> scan 288 MATCH *11*
1) "224"
2) (empty list or set)
keydb-cli> scan 224 MATCH *11*
1) "80"
2) (empty list or set)
keydb-cli> scan 80 MATCH *11*
1) "176"
2) (empty list or set)
keydb-cli> scan 176 MATCH *11* COUNT 1000
1) "0"
2)  1) "key:611"
    2) "key:711"
    3) "key:118"
    4) "key:117"
    5) "key:311"
    6) "key:112"
    7) "key:111"
    8) "key:110"
    9) "key:113"
   10) "key:211"
   11) "key:411"
   12) "key:115"
   13) "key:116"
   14) "key:114"
   15) "key:119"
   16) "key:811"
   17) "key:511"
   18) "key:11"
```

As you can see most of the calls returned zero elements, but the last call where a COUNT of 1000 was used in order to force the command to do more scanning for that iteration.

#### Multiple parallel iterations

It is possible for an infinite number of clients to iterate the same collection at the same time, as the full state of the iterator is in the cursor, that is obtained and returned to the client at every call. Server side no state is taken at all.

#### Terminating iterations in the middle

Since there is no state server side, but the full state is captured by the cursor, the caller is free to terminate an iteration half-way without signaling this to the server in any way. An infinite number of iterations can be started and never terminated without any issue.

#### Calling SCAN with a corrupted cursor

Calling `SCAN` with a broken, negative, out of range, or otherwise invalid cursor, will result into undefined behavior but never into a crash. What will be undefined is that the guarantees about the returned elements can no longer be ensured by the `SCAN` implementation.

The only valid cursors to use are:

* The cursor value of 0 when starting an iteration.
* The cursor returned by the previous call to SCAN in order to continue the iteration.

#### Guarantee of termination

The `SCAN` algorithm is guaranteed to terminate only if the size of the iterated collection remains bounded to a given maximum size, otherwise iterating a collection that always grows may result into `SCAN` to never terminate a full iteration.

This is easy to see intuitively: if the collection grows there is more and more work to do in order to visit all the possible elements, and the ability to terminate the iteration depends on the number of calls to `SCAN` and its COUNT option value compared with the rate at which the collection grows.

#### Why SCAN may return all the items of an aggregate data type in a single call?

In the `COUNT` option documentation, we state that sometimes this family of commands may return all the elements of a Set, Hash or Sorted Set at once in a single call, regardless of the `COUNT` option value. The reason why this happens is that the cursor-based iterator can be implemented, and is useful, only when the aggregate data type that we are scanning is represented as an hash table. However KeyDB uses a memory optimization where small aggregate data types, until they reach a given amount of items or a given max size of single elements, are represented using a compact single-allocation packed encoding. When this is the case, `SCAN` has no meaningful cursor to return, and must iterate the whole data structure at once, so the only sane behavior it has is to return everything in a call.

However once the data structures are bigger and are promoted to use real hash tables, the `SCAN` family of commands will resort to the normal behavior. Note that since this special behavior of returning all the elements is true only for small aggregates, it has no effects on the command complexity or latency. However the exact limits to get converted into real hash tables are user configurable (see memroy optimization in 'More' section), so the maximum number of elements you can see returned in a single call depends on how big an aggregate data type could be and still use the packed representation.

Also note that this behavior is specific of `SSCAN`, `HSCAN` and `ZSCAN`. `SCAN` itself never shows this behavior because the key space is always represented by hash tables.

#### Return value

`SCAN`, `SSCAN`, `HSCAN` and `ZSCAN` return a two elements multi-bulk reply, where the first element is a string representing an unsigned 64 bit number (the cursor), and the second element is a multi-bulk with an array of elements.

* `SCAN` array of elements is a list of keys.
* `SSCAN` array of elements is a list of Set members.
* `HSCAN` array of elements contain two elements, a field and a value, for every returned element of the Hash.
* `ZSCAN` array of elements contain two elements, a member and its associated score, for every returned element of the sorted set.

#### Additional Examples:

Iteration of a Hash value.

```
keydb-cli> hmset hash name Jack age 33
OK
keydb-cli> hscan hash 0
1) "0"
2) 1) "name"
   2) "Jack"
   3) "age"
   4) "33"
```

---





## SCARD

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)


#### Syntax:

```SCARD <key>```

#### Description:

Returns the set cardinality (number of elements) of the set stored at `key`.

#### Return:

Integer Reply: the cardinality (number of elements) of the set, or `0` if `key`
does not exist.

#### Examples:

```
keydb-cli> SADD myset "Hello"
(integer) 1
keydb-cli> SADD myset "World"
(integer) 1
keydb-cli> SCARD myset
(integer) 2
```

---




## SCRIPT-DEBUG

**Related Commands:** [EVAL](/docs/commands/#eval), [EVALSHA](/docs/commands/#evalsha), [SCRIPT DEBUG](/docs/commands/#script-debug), [SCRIPT EXISTS](/docs/commands/#script-exists), [SCRIPT FLUSH](/docs/commands/#script-flush), [SCRIPT KILL](/docs/commands/#script-kill), [SCRIPT LOAD](/docs/commands/#script-load)

Set the debug mode for subsequent scripts executed with `EVAL`. KeyDB includes a
complete Lua debugger, codename LDB, that can be used to make the task of
writing complex scripts much simpler. In debug mode KeyDB acts as a remote
debugging server and a client, such as `keydb-cli`, can execute scripts step by
step, set breakpoints, inspect variables and more - for additional information
about LDB refer to the KeyDB Lua debugger page.

**Important note:** avoid debugging Lua scripts using your KeyDB production
server. Use a development server instead.

LDB can be enabled in one of two modes: asynchronous or synchronous. In
asynchronous mode the server creates a forked debugging session that does not
block and all changes to the data are **rolled back** after the session
finishes, so debugging can be restarted using the same initial state. The
alternative synchronous debug mode blocks the server while the debugging session
is active and retains all changes to the data set once it ends.

* `YES`. Enable non-blocking asynchronous debugging of Lua scripts (changes are discarded).
* `SYNC`. Enable blocking synchronous debugging of Lua scripts (saves changes to data).
* `NO`. Disables scripts debug mode.

#### Return:

Simple String Reply: `OK`.

#### Examples:

```
keydb-cli> SCRIPT DEBUG NO
OK
```


---



## SCRIPT-EXISTS

**Related Commands:** [EVAL](/docs/commands/#eval), [EVALSHA](/docs/commands/#evalsha), [SCRIPT DEBUG](/docs/commands/#script-debug), [SCRIPT EXISTS](/docs/commands/#script-exists), [SCRIPT FLUSH](/docs/commands/#script-flush), [SCRIPT KILL](/docs/commands/#script-kill), [SCRIPT LOAD](/docs/commands/#script-load)

Returns information about the existence of the scripts in the script cache.

This command accepts one or more SHA1 digests and returns a list of ones or
zeros to signal if the scripts are already defined or not inside the script
cache.
This can be useful before a pipelining operation to ensure that scripts are
loaded (and if not, to load them using `SCRIPT LOAD`) so that the pipelining
operation can be performed solely using `EVALSHA` instead of `EVAL` to save
bandwidth.

Please refer to the `EVAL` documentation for detailed information about KeyDB
Lua scripting.

#### Return:

Array Reply The command returns an array of integers that correspond to
the specified SHA1 digest arguments.
For every corresponding SHA1 digest of a script that actually exists in the
script cache, an 1 is returned, otherwise 0 is returned.

---




## SCRIPT-FLUSH

**Related Commands:** [EVAL](/docs/commands/#eval), [EVALSHA](/docs/commands/#evalsha), [SCRIPT DEBUG](/docs/commands/#script-debug), [SCRIPT EXISTS](/docs/commands/#script-exists), [SCRIPT FLUSH](/docs/commands/#script-flush), [SCRIPT KILL](/docs/commands/#script-kill), [SCRIPT LOAD](/docs/commands/#script-load)

Flush the Lua scripts cache.

Please refer to the `EVAL` documentation for detailed information about KeyDB
Lua scripting.

#### Return:

Simple String Reply

---



## SCRIPT-KILL

**Related Commands:** [EVAL](/docs/commands/#eval), [EVALSHA](/docs/commands/#evalsha), [SCRIPT DEBUG](/docs/commands/#script-debug), [SCRIPT EXISTS](/docs/commands/#script-exists), [SCRIPT FLUSH](/docs/commands/#script-flush), [SCRIPT KILL](/docs/commands/#script-kill), [SCRIPT LOAD](/docs/commands/#script-load)

Kills the currently executing Lua script, assuming no write operation was yet
performed by the script.

This command is mainly useful to kill a script that is running for too much
time(for instance because it entered an infinite loop because of a bug).
The script will be killed and the client currently blocked into EVAL will see
the command returning with an error.

If the script already performed write operations it can not be killed in this
way because it would violate Lua script atomicity contract.
In such a case only `SHUTDOWN NOSAVE` is able to kill the script, killing
the KeyDB process in an hard way preventing it to persist with half-written
information.

Please refer to the `EVAL` documentation for detailed information about KeyDB
Lua scripting.

#### Return:

Simple String Reply

---




## SCRIPT-LOAD

**Related Commands:** [EVAL](/docs/commands/#eval), [EVALSHA](/docs/commands/#evalsha), [SCRIPT DEBUG](/docs/commands/#script-debug), [SCRIPT EXISTS](/docs/commands/#script-exists), [SCRIPT FLUSH](/docs/commands/#script-flush), [SCRIPT KILL](/docs/commands/#script-kill), [SCRIPT LOAD](/docs/commands/#script-load)

Load a script into the scripts cache, without executing it.
After the specified command is loaded into the script cache it will be callable
using `EVALSHA` with the correct SHA1 digest of the script, exactly like after
the first successful invocation of `EVAL`.

The script is guaranteed to stay in the script cache forever (unless `SCRIPT
FLUSH` is called).

The command works in the same way even if the script was already present in the
script cache.

Please refer to the `EVAL` documentation for detailed information about KeyDB
Lua scripting.

#### Return:

Bulk String Reply This command returns the SHA1 digest of the script added into the
script cache.

---




## SDIFF

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```SDIFF <key-1> ... <key-n>```

#### Description:

Returns the members of the set resulting from the difference between the first
set and all the successive sets.

For example:

```
key1 = {a,b,c,d}
key2 = {c}
key3 = {a,c,e}
SDIFF key1 key2 key3 = {b,d}
```

Keys that do not exist are considered to be empty sets.

#### Return:

Array Reply: list with members of the resulting set.

#### Examples:

```
127.0.0.1:6379> SADD key1 "a"
(integer) 1
127.0.0.1:6379> SADD key1 "b"
(integer) 1
127.0.0.1:6379> SADD key1 "c"
(integer) 1
127.0.0.1:6379> SADD key2 "c"
(integer) 1
127.0.0.1:6379> SADD key2 "d"
(integer) 1
127.0.0.1:6379> SADD key2 "e"
(integer) 1
127.0.0.1:6379> SDIFF key1 key2
1) "a"
2) "b"
```

---




## SDIFFSTORE

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```
SDIFFSTORE <destination> <key-1> ... <key-n>
```

#### Description:

This command is equal to `SDIFF`, but instead of returning the resulting set, it
is stored in `destination`.

If `destination` already exists, it is overwritten.

#### Return:

Integer Reply: the number of elements in the resulting set.

#### Examples:

```
keydb-cli> SADD key1 "a"
(integer) 0
keydb-cli> SADD key1 "b"
(integer) 0
keydb-cli> SADD key1 "c"
(integer) 0
keydb-cli> SADD key2 "c"
(integer) 0
keydb-cli> SADD key2 "d"
(integer) 0
keydb-cli> SADD key2 "3"
(integer) 1
keydb-cli> SDIFFSTORE key key1 key2
(integer) 2
keydb-cli> SMEMBERS key
1) "a"
2) "b"
```
---




## SELECT

**Related Commands:** [AUTH](/docs/commands/#append), [ECHO](/docs/commands/#echo), [PING](/docs/commands/#ping), [QUIT](/docs/commands/#quit), [SELECT](/docs/commands/#select), [SWAPDB](/docs/commands/#swapdb)

#### Syntax:

```SELECT <index>```

#### Description:

Select the KeyDB logical database having the specified zero-based numeric index.
New connections always use the database 0.

KeyDB different selectable databases are a form of namespacing: all the databases are anyway persisted together in the same RDB / AOF file. However different databases can have keys having the same name, and there are commands available like `FLUSHDB`, `SWAPDB` or `RANDOMKEY` that work on specific databases.

In practical terms, KeyDB databases should mainly used in order to, if needed, separate different keys belonging to the same application, and not in order to use a single KeyDB instance for multiple unrelated applications.

When using KeyDB Cluster, the `SELECT` command cannot be used, since KeyDB Cluster only supports database zero. In the case of KeyDB Cluster, having multiple databases would be useless, and a worthless source of complexity, because anyway commands operating atomically on a single database would not be possible with the KeyDB Cluster design and goals.

Since the currently selected database is a property of the connection, clients should track the currently selected database and re-select it on reconnection. While there is no command in order to query the selected database in the current connection, the `CLIENT LIST` output shows, for each client, the currently selected database.

#### Return:

Simple String Reply

#### Examples:

```
127.0.0.1:6379> SELECT 1
OK
127.0.0.1:6379[1]> SELECT 0
OK
```


---




## SET

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```SET <key> <value>```

#### Description:

Set `key` to hold the string `value`.
If `key` already holds a value, it is overwritten, regardless of its type.
Any previous time to live associated with the key is discarded on successful `SET` operation.

#### Options

`SET` supports a set of options that modify its
behavior:

* `EX` *seconds* -- Set the specified expire time, in seconds.
* `PX` *milliseconds* -- Set the specified expire time, in milliseconds.
* `NX` -- Only set the key if it does not already exist.
* `XX` -- Only set the key if it already exist.

Note: Since the `SET` command options can replace `SETNX`, `SETEX`, `PSETEX`, it is possible that in future versions of KeyDB these three commands will be deprecated and finally removed.

#### Return:

Simple String Reply: `OK` if `SET` was executed correctly.
nil-reply: a Null Bulk Reply is returned if the `SET` operation was not performed because the user specified the `NX` or `XX` option but the condition was not met.

#### Examples:

```
keydb-cli> SET mykey "Hello"
OK
keydb-cli> GET mykey
"Hello"
```

#### Patterns

**Note:** The following pattern is discouraged in favor of the Redlock algorithm which is only a bit more complex to implement, but offers better guarantees and is fault tolerant.

The command `SET resource-name anystring NX EX max-lock-time` is a simple way to implement a locking system with KeyDB.

A client can acquire the lock if the above command returns `OK` (or retry after some time if the command returns Nil), and remove the lock just using `DEL`.

The lock will be auto-released after the expire time is reached.

It is possible to make this system more robust modifying the unlock schema as follows:

* Instead of setting a fixed string, set a non-guessable large random string, called token.
* Instead of releasing the lock with `DEL`, send a script that only removes the key if the value matches.

This avoids that a client will try to release the lock after the expire time deleting the key created by another client that acquired the lock later.

An example of unlock script would be similar to the following:

    if KeyDB.call("get",KEYS[1]) == ARGV[1]
    then
        return KeyDB.call("del",KEYS[1])
    else
        return 0
    end

The script should be called with `EVAL ...script... 1 resource-name token-value`

---




## SETBIT

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```SETBIT <key> <offset> <value>```

#### Description:

Sets or clears the bit at _offset_ in the string value stored at _key_.

The bit is either set or cleared depending on _value_, which can be either 0 or
1.
When _key_ does not exist, a new string value is created.
The string is grown to make sure it can hold a bit at _offset_.
The _offset_ argument is required to be greater than or equal to 0, and smaller
than 2^32 (this limits bitmaps to 512MB).
When the string at _key_ is grown, added bits are set to 0.

**Warning**: When setting the last possible bit (_offset_ equal to 2^32 -1) and
the string value stored at _key_ does not yet hold a string value, or holds a
small string value, KeyDB needs to allocate all intermediate memory which can
block the server for some time.
On a 2010 MacBook Pro, setting bit number 2^32 -1 (512MB allocation) takes
~300ms, setting bit number 2^30 -1 (128MB allocation) takes ~80ms, setting bit
number 2^28 -1 (32MB allocation) takes ~30ms and setting bit number 2^26 -1 (8MB
allocation) takes ~8ms.
Note that once this first allocation is done, subsequent calls to `SETBIT` for
the same _key_ will not have the allocation overhead.

#### Return:

Integer Reply: the original bit value stored at _offset_.

#### Examples:

```
keydb-cli> SETBIT mykey 7 1
(integer) 0
keydb-cli> SETBIT mykey 7 0
(integer) 1
keydb-cli> GET mykey
"\x00"
```

---




## SETEX

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```SETEX <key> <timeout> <value>```

#### Description:

Set `key` to hold the string `value` and set `key` to timeout after a given
number of seconds.
This command is equivalent to executing the following commands:

```
SET mykey value
EXPIRE mykey seconds
```

`SETEX` is atomic, and can be reproduced by using the previous two commands
inside an `MULTI` / `EXEC` block.
It is provided as a faster alternative to the given sequence of operations,
because this operation is very common when KeyDB is used as a cache.

An error is returned when `seconds` is invalid.

#### Return:

Simple String Reply

#### Examples:

```
keydb-cli> SETEX mykey 10 "Hello"
OK
keydb-cli> TTL mykey
(integer) 8
keydb-cli> GET mykey
"Hello"
```
---



## SETNX

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```SETNX <key> <value>```

#### Description:

Set `key` to hold string `value` if `key` does not exist.
In that case, it is equal to `SET`.
When `key` already holds a value, no operation is performed.
`SETNX` is short for "**SET** if **N**ot e**X**ists".

#### Return:

Integer Reply, specifically:

* `1` if the key was set
* `0` if the key was not set

#### Examples:

```
keydb-cli> SETNX mykey "Hello"
(integer) 1
keydb-cli> SETNX mykey "World"
(integer) 0
keydb-cli> GET mykey
"Hello"
```

#### Design pattern: Locking with `!SETNX`

**Please note that:**

1. The following pattern is discouraged in favor of the Redlock algorithm which is only a bit more complex to implement, but offers better guarantees and is fault tolerant.
2. We document the old pattern anyway because certain existing implementations link to this page as a reference. Moreover it is an interesting example of how KeyDB commands can be used in order to mount programming primitives.
3. Anyway even assuming a single-instance locking primitive, it is possible to create a much simpler locking primitive, equivalent to the one discussed here, using the `SET` command to acquire the lock, and a simple Lua script to release the lock. The pattern is documented in the `SET` command page.

That said, `SETNX` can be used, and was historically used, as a locking primitive. For example, to acquire the lock of the key `foo`, the client could try the
following:

```
SETNX lock.foo <current Unix time + lock timeout + 1>
```

If `SETNX` returns `1` the client acquired the lock, setting the `lock.foo` key
to the Unix time at which the lock should no longer be considered valid.
The client will later use `DEL lock.foo` in order to release the lock.

If `SETNX` returns `0` the key is already locked by some other client.
We can either return to the caller if it's a non blocking lock, or enter a loop
retrying to hold the lock until we succeed or some kind of timeout expires.

#### Handling deadlocks

In the above locking algorithm there is a problem: what happens if a client
fails, crashes, or is otherwise not able to release the lock?
It's possible to detect this condition because the lock key contains a UNIX
timestamp.
If such a timestamp is equal to the current Unix time the lock is no longer
valid.

When this happens we can't just call `DEL` against the key to remove the lock
and then try to issue a `SETNX`, as there is a race condition here, when
multiple clients detected an expired lock and are trying to release it.

* C1 and C2 read `lock.foo` to check the timestamp, because they both received
  `0` after executing `SETNX`, as the lock is still held by C3 that crashed
  after holding the lock.
* C1 sends `DEL lock.foo`
* C1 sends `SETNX lock.foo` and it succeeds
* C2 sends `DEL lock.foo`
* C2 sends `SETNX lock.foo` and it succeeds
* **ERROR**: both C1 and C2 acquired the lock because of the race condition.

Fortunately, it's possible to avoid this issue using the following algorithm.
Let's see how C4, our sane client, uses the good algorithm:

*   C4 sends `SETNX lock.foo` in order to acquire the lock

*   The crashed client C3 still holds it, so KeyDB will reply with `0` to C4.

*   C4 sends `GET lock.foo` to check if the lock expired.
    If it is not, it will sleep for some time and retry from the start.

*   Instead, if the lock is expired because the Unix time at `lock.foo` is older
    than the current Unix time, C4 tries to perform:

    ```
    GETSET lock.foo <current Unix timestamp + lock timeout + 1>
    ```

*   Because of the `GETSET` semantic, C4 can check if the old value stored at
    `key` is still an expired timestamp.
    If it is, the lock was acquired.

*   If another client, for instance C5, was faster than C4 and acquired the lock
    with the `GETSET` operation, the C4 `GETSET` operation will return a non
    expired timestamp.
    C4 will simply restart from the first step.
    Note that even if C4 set the key a bit a few seconds in the future this is
    not a problem.

In order to make this locking algorithm more robust, a
client holding a lock should always check the timeout didn't expire before
unlocking the key with `DEL` because client failures can be complex, not just
crashing but also blocking a lot of time against some operations and trying
to issue `DEL` after a lot of time (when the LOCK is already held by another
client).

---





## SETRANGE

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```SETRANGE <key> <offset> <value>```

#### Description:

Overwrites part of the string stored at _key_, starting at the specified offset,
for the entire length of _value_.
If the offset is larger than the current length of the string at _key_, the
string is padded with zero-bytes to make _offset_ fit.
Non-existing keys are considered as empty strings, so this command will make
sure it holds a string large enough to be able to set _value_ at _offset_.

Note that the maximum offset that you can set is 2^29 -1 (536870911), as KeyDB
Strings are limited to 512 megabytes.
If you need to grow beyond this size, you can use multiple keys.

**Warning**: When setting the last possible byte and the string value stored at
_key_ does not yet hold a string value, or holds a small string value, KeyDB
needs to allocate all intermediate memory which can block the server for some
time.
On a 2010 MacBook Pro, setting byte number 536870911 (512MB allocation) takes
~300ms, setting byte number 134217728 (128MB allocation) takes ~80ms, setting
bit number 33554432 (32MB allocation) takes ~30ms and setting bit number 8388608
(8MB allocation) takes ~8ms.
Note that once this first allocation is done, subsequent calls to `SETRANGE` for
the same _key_ will not have the allocation overhead.

#### Patterns

Thanks to `SETRANGE` and the analogous `GETRANGE` commands, you can use KeyDB
strings as a linear array with O(1) random access.
This is a very fast and efficient storage in many real world use cases.

#### Return:

Integer Reply: the length of the string after it was modified by the command.

#### Examples:

Basic usage:

```
keydb-cli> SET key1 "Hello World"
OK
keydb-cli> SETRANGE key1 6 "KeyDB"
(integer) 11
keydb-cli> GET key1
"Hello KeyDB"
```

Example of zero padding:

```
keydb-cli> SETRANGE key2 6 "KeyDB"
(integer) 11
keydb-cli> GET key2
"\x00\x00\x00\x00\x00\x00KeyDB"
```

---





## SHUTDOWN

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The command behavior is the following:

* Stop all the clients.
* Perform a blocking SAVE if at least one **save point** is configured.
* Flush the Append Only File if AOF is enabled.
* Quit the server.

If persistence is enabled this commands makes sure that KeyDB is switched off
without the lost of any data.
This is not guaranteed if the client uses simply `SAVE` and then `QUIT` because
other clients may alter the DB data between the two commands.

**REMINDER**: A KeyDB instance that is configured for not persisting on disk (no AOF
configured, nor "save" directive) will not dump the RDB file on `SHUTDOWN`, as
usually you don't want KeyDB instances used only for caching to block on when
shutting down.

#### SAVE and NOSAVE modifiers

It is possible to specify an optional modifier to alter the behavior of the
command.
Specifically:

* **SHUTDOWN SAVE** will force a DB saving operation even if no save points are
  configured.
* **SHUTDOWN NOSAVE** will prevent a DB saving operation even if one or more
  save points are configured.
  (You can think of this variant as an hypothetical **ABORT** command that just
  stops the server).

#### Conditions where a SHUTDOWN fails

When the Append Only File is enabled the shutdown may fail because the
system is in a state that does not allow to safely immediately persist
on disk.

Normally if there is an AOF child process performing an AOF rewrite, KeyDB
will simply kill it and exit. However there are two conditions where it is
unsafe to do so, and the **SHUTDOWN** command will be refused with an error
instead. This happens when:

* The user just turned on AOF, and the server triggered the first AOF rewrite in order to create the initial AOF file. In this context, stopping will result in losing the dataset at all: once restarted, the server will potentially have AOF enabled without having any AOF file at all.
* A replica with AOF enabled, reconnected with its master, performed a full resynchronization, and restarted the AOF file, triggering the initial AOF creation process. In this case not completing the AOF rewrite is dangerous because the latest dataset received from the master would be lost. The new master can actually be even a different instance (if the **REPLICAOF** or **SLAVEOF** command was used in order to reconfigure the replica), so it is important to finish the AOF rewrite and start with the correct data set representing the data set in memory when the server was terminated.

There are conditions when we want just to terminate a KeyDB instance ASAP, regardless of what its content is. In such a case, the right combination of commands is to send a **CONFIG appendonly no** followed by a **SHUTDOWN NOSAVE**. The first command will turn off the AOF if needed, and will terminate the AOF rewriting child if there is one active. The second command will not have any problem to execute since the AOF is no longer enabled.

#### Return:

Simple String Reply on error.
On success nothing is returned since the server quits and the connection is
closed.

---




## SINTER

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax

```SINTER <key-1> ... <key-n>```

#### Description:

Returns the members of the set resulting from the intersection of all the given
sets.

For example:

```
key1 = {a,b,c,d}
key2 = {c}
key3 = {a,c,e}
SINTER key1 key2 key3 = {c}
```

Keys that do not exist are considered to be empty sets.
With one of the keys being an empty set, the resulting set is also empty (since
set intersection with an empty set always results in an empty set).

#### Return:

Array Reply: list with members of the resulting set.

#### Examples:

```
keydb-cli> SADD key1 "a"
(integer) 1
keydb-cli> SADD key1 "b"
(integer) 1
keydb-cli> SADD key1 "c"
(integer) 1
keydb-cli> SADD key2 "c"
(integer) 1
keydb-cli> SADD key2 "d"
(integer) 1
keydb-cli> SADD key2 "e"
(integer) 1
keydb-cli> SINTER key1 key2
1) "c"
```
---




## SINTERSTORE

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```
SINTERSTORE <destination> <key-1> ... <key-n>
```

#### Description:

This command is equal to `SINTER`, but instead of returning the resulting set,
it is stored in `destination`.

If `destination` already exists, it is overwritten.

#### Return:

Integer Reply: the number of elements in the resulting set.

#### Examples:

```
keydb-cli> SADD key1 "a"
(integer) 1
keydb-cli> SADD key1 "b"
(integer) 1
keydb-cli> SADD key1 "c"
(integer) 1
keydb-cli> SADD key2 "c"
(integer) 1
keydb-cli> SADD key2 "d"
(integer) 1
keydb-cli> SADD key2 "e"
(integer) 1
keydb-cli> SINTERSTORE key key1 key2
(integer) 1
keydb-cli> SMEMBERS key
1) "c"
```

---




## SISMEMBER

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```SISMEMBER <key> <member>```

#### Description:

Returns if `member` is a member of the set stored at `key`.

#### Return:

Integer Reply, specifically:

* `1` if the element is a member of the set.
* `0` if the element is not a member of the set, or if `key` does not exist.

#### Examples:

```
keydb-cli> SADD myset "one"
(integer) 1
keydb-cli> SISMEMBER myset "one"
(integer) 1
keydb-cli> SISMEMBER myset "two"
(integer) 0
```

---



## SLAVEOF

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

**A note about the word slave used in this man page and command name**: Starting with KeyDB 5 this command: starting with KeyDB version 5, if not for backward compatibility, the KeyDB project no longer uses the word slave. Please use the new command `REPLICAOF`. The command `SLAVEOF` will continue to work for backward compatibility.

The `SLAVEOF` command can change the replication settings of a replica on the fly.
If a KeyDB server is already acting as replica, the command `SLAVEOF NO ONE` will
turn off the replication, turning the KeyDB server into a MASTER.
In the proper form `SLAVEOF` hostname port will make the server a replica of
another server listening at the specified hostname and port.

If a server is already a replica of some master, `SLAVEOF <hostname> <port>` will stop
the replication against the old server and start the synchronization against the
new one, discarding the old dataset.

The form `SLAVEOF NO ONE` will stop replication, turning the server into a
MASTER, but will not discard the replication.
So, if the old master stops working, it is possible to turn the replica into a
master and set the application to use this new master in read/write.
Later when the other KeyDB server is fixed, it can be reconfigured to work as a
replica.

#### Return:

Simple String Reply

---





## SLOWLOG

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

#### Syntax:

```SLOWLOG GET <N-entries>```

```SLOWLOG LEN```

```SLOWLOG RESET```

#### Description:

This command is used in order to read and reset the KeyDB slow queries log.

#### KeyDB slow log overview

The KeyDB Slow Log is a system to log queries that exceeded a specified
execution time.
The execution time does not include I/O operations like talking with the client,
sending the reply and so forth, but just the time needed to actually execute the
command (this is the only stage of command execution where the thread is blocked
and can not serve other requests in the meantime).

You can configure the slow log with two parameters: _slowlog-log-slower-than_
tells KeyDB what is the execution time, in microseconds, to exceed in order for
the command to get logged.
Note that a negative number disables the slow log, while a value of zero forces
the logging of every command.
_slowlog-max-len_ is the length of the slow log.
The minimum value is zero.
When a new command is logged and the slow log is already at its maximum length,
the oldest one is removed from the queue of logged commands in order to make
space.

The configuration can be done by editing `keydb.conf` or while the server is
running using the `CONFIG GET` and `CONFIG SET` commands.

#### Reading the slow log

The slow log is accumulated in memory, so no file is written with information
about the slow command executions.
This makes the slow log remarkably fast at the point that you can enable the
logging of all the commands (setting the _slowlog-log-slower-than_ config
parameter to zero) with minor performance hit.

To read the slow log the **SLOWLOG GET** command is used, that returns every
entry in the slow log.
It is possible to return only the N most recent entries passing an additional
argument to the command (for instance **SLOWLOG GET 10**).

Note that you need a recent version of keydb-cli in order to read the slow log
output, since it uses some features of the protocol that were not formerly
implemented in keydb-cli (deeply nested multi bulk replies).

#### Output format

```
keydb-cli> slowlog get 2
1) 1) (integer) 14
   2) (integer) 1309448221
   3) (integer) 15
   4) 1) "ping"
2) 1) (integer) 13
   2) (integer) 1309448128
   3) (integer) 30
   4) 1) "slowlog"
      2) "get"
      3) "100"
```

There are also optional fields emitted only by KeyDB 4.0 or greater:

```
5) "127.0.0.1:58217"
6) "worker-123"
```

Every entry is composed of four (or six starting with KeyDB 4.0) fields:

* A unique progressive identifier for every slow log entry.
* The unix timestamp at which the logged command was processed.
* The amount of time needed for its execution, in microseconds.
* The array composing the arguments of the command.
* Client IP address and port (4.0 only).
* Client name if set via the `CLIENT SETNAME` command (4.0 only).

The entry's unique ID can be used in order to avoid processing slow log entries
multiple times (for instance you may have a script sending you an email alert
for every new slow log entry).

The ID is never reset in the course of the KeyDB server execution, only a server
restart will reset it.

#### Obtaining the current length of the slow log

It is possible to get just the length of the slow log using the command
**SLOWLOG LEN**.

#### Resetting the slow log.

You can reset the slow log using the **SLOWLOG RESET** command.
Once deleted the information is lost forever.

---




## SMEMBERS

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```SMEMBERS <key>```

#### Description:

Returns all the members of the set value stored at `key`.

This has the same effect as running `SINTER` with one argument `key`.

#### Return:

Array Reply: all elements of the set.

#### Examples:

```
keydb-cli> SADD myset "Hello"
(integer) 1
keydb-cli> SADD myset "World"
(integer) 1
keydb-cli> SMEMBERS myset
1) "Hello"
2) "World"
```

---





## SMOVE

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```SMOVE <source> <destination> <member>```

#### Description:

Move `member` from the set at `source` to the set at `destination`.
This operation is atomic.
In every given moment the element will appear to be a member of `source` **or**
`destination` for other clients.

If the source set does not exist or does not contain the specified element, no
operation is performed and `0` is returned.
Otherwise, the element is removed from the source set and added to the
destination set.
When the specified element already exists in the destination set, it is only
removed from the source set.

An error is returned if `source` or `destination` does not hold a set value.

#### Return:

Integer Reply, specifically:

* `1` if the element is moved.
* `0` if the element is not a member of `source` and no operation was performed.

#### Examples:

```
keydb-cli> SADD myset "one"
(integer) 1
keydb-cli> SADD myset "two"
(integer) 1
keydb-cli> SADD myotherset "three"
(integer) 1
keydb-cli> SMOVE myset myotherset "two"
(integer) 1
keydb-cli> SMEMBERS myset
1) "one"
keydb-cli> SMEMBERS myotherset
1) "three"
2) "two"
```

---




## SORT

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

Returns or stores the elements contained in the list, set or sorted set at `key`.
By default, sorting is numeric and elements are compared by their value
interpreted as double precision floating point number.
This is `SORT` in its simplest form:

```
SORT mylist
```

Assuming `mylist` is a list of numbers, this command will return the same list
with the elements sorted from small to large.
In order to sort the numbers from large to small, use the `!DESC` modifier:

```
SORT mylist DESC
```

When `mylist` contains string values and you want to sort them
lexicographically, use the `!ALPHA` modifier:

```
SORT mylist ALPHA
```

KeyDB is UTF-8 aware, assuming you correctly set the `!LC_COLLATE` environment
variable.

The number of returned elements can be limited using the `!LIMIT` modifier.
This modifier takes the `offset` argument, specifying the number of elements to
skip and the `count` argument, specifying the number of elements to return from
starting at `offset`.
The following example will return 10 elements of the sorted version of `mylist`,
starting at element 0 (`offset` is zero-based):

```
SORT mylist LIMIT 0 10
```

Almost all modifiers can be used together.
The following example will return the first 5 elements, lexicographically sorted
in descending order:

```
SORT mylist LIMIT 0 5 ALPHA DESC
```

#### Sorting by external keys

Sometimes you want to sort elements using external keys as weights to compare
instead of comparing the actual elements in the list, set or sorted set.
Let's say the list `mylist` contains the elements `1`, `2` and `3` representing
unique IDs of objects stored in `object_1`, `object_2` and `object_3`.
When these objects have associated weights stored in `weight_1`, `weight_2` and
`weight_3`, `SORT` can be instructed to use these weights to sort `mylist` with
the following statement:

```
SORT mylist BY weight_*
```

The `BY` option takes a pattern (equal to `weight_*` in this example) that is
used to generate the keys that are used for sorting.
These key names are obtained substituting the first occurrence of `*` with the
actual value of the element in the list (`1`, `2` and `3` in this example).

#### Skip sorting the elements

The `!BY` option can also take a non-existent key, which causes `SORT` to skip
the sorting operation.
This is useful if you want to retrieve external keys (see the `!GET` option
below) without the overhead of sorting.

```
SORT mylist BY nosort
```

#### Retrieving external keys

Our previous example returns just the sorted IDs.
In some cases, it is more useful to get the actual objects instead of their IDs
(`object_1`, `object_2` and `object_3`).
Retrieving external keys based on the elements in a list, set or sorted set can
be done with the following command:

```
SORT mylist BY weight_* GET object_*
```

The `!GET` option can be used multiple times in order to get more keys for every
element of the original list, set or sorted set.

It is also possible to `!GET` the element itself using the special pattern `#`:

```
SORT mylist BY weight_* GET object_* GET #
```

#### Storing the result of a SORT operation

By default, `SORT` returns the sorted elements to the client.
With the `!STORE` option, the result will be stored as a list at the specified
key instead of being returned to the client.

```
SORT mylist BY weight_* STORE resultkey
```

An interesting pattern using `SORT ... STORE` consists in associating an
`EXPIRE` timeout to the resulting key so that in applications where the result
of a `SORT` operation can be cached for some time.
Other clients will use the cached list instead of calling `SORT` for every
request.
When the key will timeout, an updated version of the cache can be created by
calling `SORT ... STORE` again.

Note that for correctly implementing this pattern it is important to avoid
multiple clients rebuilding the cache at the same time.
Some kind of locking is needed here (for instance using `SETNX`).

#### Using hashes in `!BY` and `!GET`

It is possible to use `!BY` and `!GET` options against hash fields with the
following syntax:

```
SORT mylist BY weight_*->fieldname GET object_*->fieldname
```

The string `->` is used to separate the key name from the hash field name.
The key is substituted as documented above, and the hash stored at the resulting
key is accessed to retrieve the specified hash field.

#### Return:

Array Reply: without passing the `store` option the command returns a list of sorted elements.
Integer Reply: when the `store` option is specified the command returns the number of sorted elements in the destination list.

---




## SPOP

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)


#### Syntax:

```SPOP <key> <OPTIONAL:count>```

#### Description:

Removes and returns one or more random elements from the set value store at `key`.

This operation is similar to `SRANDMEMBER`, that returns one or more random elements from a set but does not remove it.

The `count` argument is available since version 3.2.

#### Return:

Bulk String Reply: the removed element, or `nil` when `key` does not exist.

#### Examples:

```
keydb-cli> SADD myset "one"
(integer) 1
keydb-cli> SADD myset "two"
(integer) 1
keydb-cli> SADD myset "three"
(integer) 1
keydb-cli> SPOP myset
"two"
keydb-cli> SMEMBERS myset
1) "one"
2) "three"
keydb-cli> SADD myset "four"
(integer) 1
keydb-cli> SADD myset "five"
(integer) 1
keydb-cli> SPOP myset 3
1) "four"
2) "three"
3) "five"
keydb-cli> SMEMBERS myset
1) "one"
```

#### Specification of the behavior when count is passed

If count is bigger than the number of elements inside the Set, the command will only return the whole set without additional elements.

#### Distribution of returned elements

Note that this command is not suitable when you need a guaranteed uniform distribution of the returned elements. For more information about the algorithms used for SPOP, look up both the Knuth sampling and Floyd sampling algorithms.

#### Count argument extension

KeyDB 3.2 introduced an optional `count` argument that can be passed to `SPOP` in order to retrieve multiple elements in a single call.

---




## SRANDMEMBER

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```SRANDMEMBER <key> <OPTIONAL:count>```

#### Description:

When called with just the `key` argument, return a random element from the set value stored at `key`.

when called with the additional `count` argument, return an array of `count` **distinct elements** if `count` is positive. If called with a negative `count` the behavior changes and the command is allowed to return the **same element multiple times**. In this case the number of returned elements is the absolute value of the specified `count`.

When called with just the key argument, the operation is similar to `SPOP`, however while `SPOP` also removes the randomly selected element from the set, `SRANDMEMBER` will just return a random element without altering the original set in any way.

#### Return:

Bulk String Reply: without the additional `count` argument the command returns a Bulk Reply with the randomly selected element, or `nil` when `key` does not exist.
Array Reply: when the additional `count` argument is passed the command returns an array of elements, or an empty array when `key` does not exist.

#### Examples:

```
keydb-cli> SADD myset one two three
(integer) 3
keydb-cli> SRANDMEMBER myset
"two"
keydb-cli> SRANDMEMBER myset 2
1) "one"
2) "three"
keydb-cli> SRANDMEMBER myset -5
1) "three"
2) "two"
3) "two"
4) "three"
5) "three"
```

#### Specification of the behavior when count is passed

When a count argument is passed and is positive, the elements are returned
as if every selected element is removed from the set (like the extraction
of numbers in the game of Bingo). However elements are **not removed** from
the Set. So basically:

* No repeated elements are returned.
* If count is bigger than the number of elements inside the Set, the command will only return the whole set without additional elements.

When instead the count is negative, the behavior changes and the extraction happens as if you put the extracted element inside the bag again after every extraction, so repeated elements are possible, and the number of elements requested is always returned as we can repeat the same elements again and again, with the exception of an empty Set (non existing key) that will always produce an empty array as a result.

#### Distribution of returned elements

The distribution of the returned elements is far from perfect when the number of elements in the set is small, this is due to the fact that we used an approximated random element function that does not really guarantees good distribution.

The algorithm used, that is implemented inside dict.c, samples the hash table buckets to find a non-empty one. Once a non empty bucket is found, since we use chaining in our hash table implementation, the number of elements inside the bucket is checked and a random element is selected.

This means that if you have two non-empty buckets in the entire hash table, and one has three elements while one has just one, the element that is alone in its bucket will be returned with much higher probability.

---





## SREM

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```SREM <key> <member-1> ... <member-n>```

#### Description:

Remove the specified members from the set stored at `key`.
Specified members that are not a member of this set are ignored.
If `key` does not exist, it is treated as an empty set and this command returns
`0`.

An error is returned when the value stored at `key` is not a set.

#### Return:

Integer Reply: the number of members that were removed from the set, not
including non existing members.


#### Examples:

```
keydb-cli> SADD myset "one"
(integer) 1
keydb-cli> SADD myset "two"
(integer) 1
keydb-cli> SADD myset "three"
(integer) 1
keydb-cli> SREM myset "one"
(integer) 1
keydb-cli> SREM myset "four"
(integer) 0
keydb-cli> SMEMBERS myset
1) "three"
2) "two"
```
---





## SSCAN

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

See `SCAN` for `SSCAN` documentation.

---




## STRLEN

**Related Commands:** [APPEND](/docs/commands/#append), [BITCOUNT](/docs/commands/#bitcount), [BITFIELD](/docs/commands/#bitfield), [BITOP](/docs/commands/#bitop), [BITPOS](/docs/commands/#bitpos), [DECR](/docs/commands/#decr), [DECRBY](/docs/commands/#decrby), [GET](/docs/commands/#get), [GETBIT](/docs/commands/#getbit), [GETRANGE](/docs/commands/#getrange), [GETSET](/docs/commands/#getset), [INCR](/docs/commands/#incr), [INCRBY](/docs/commands/#incrby), [INCRBYFLOAT](/docs/commands/#incrbyfloat), [MGET](/docs/commands/#mget), [MSET](/docs/commands/#mset), [MSETNX](/docs/commands/#msetnx), [PSETEX](/docs/commands/#psetex), [SET](/docs/commands/#set), [SETBIT](/docs/commands/#setbit), [SETEX](/docs/commands/#setex), [SETNX](/docs/commands/#setnx), [SETRANGE](/docs/commands/#setrange), [STRLEN](/docs/commands/#strlen) 

#### Syntax:

```STRLEN <key>```

#### Description:

Returns the length of the string value stored at `key`.
An error is returned when `key` holds a non-string value.

#### Return:

Integer Reply: the length of the string at `key`, or `0` when `key` does not
exist.

#### Examples:

```
keydb-cli> SET mykey "Hello world"
OK
keydb-cli> STRLEN mykey
(integer) 11
keydb-cli> STRLEN nonexisting
(integer) 0
```
---



## SUBSCRIBE

**Related Commands:** [PSUBSCRIBE](/docs/commands/#psubscribe), [PUBLISH](/docs/commands/#publish), [PUBSUB](/docs/commands/#pubsub), [PUNSUBSCRIBE](/docs/commands/#punsubscribe), [SUBSCRIBE](/docs/commands/#subscribe), [UNSUBSCRIBE](/docs/commands/#unsubscribe)

Subscribes the client to the specified channels.

Once the client enters the subscribed state it is not supposed to issue any
other commands, except for additional `SUBSCRIBE`, `PSUBSCRIBE`, `UNSUBSCRIBE`
and `PUNSUBSCRIBE` commands.

---




## SUNION

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```SUNION <key-1> ... <key-n>```

#### Description:

Returns the members of the set resulting from the union of all the given sets.

For example:

```
key1 = {a,b,c,d}
key2 = {c}
key3 = {a,c,e}
SUNION key1 key2 key3 = {a,b,c,d,e}
```

Keys that do not exist are considered to be empty sets.

#### Return:

Array Reply: list with members of the resulting set.

#### Examples:

```
keydb-cli> SADD key1 "a"
(integer) 1
keydb-cli> SADD key1 "b"
(integer) 1
keydb-cli> SADD key1 "c"
(integer) 1
keydb-cli> SADD key2 "c"
(integer) 1
keydb-cli> SADD key2 "d"
(integer) 1
keydb-cli> SADD key2 "e"
(integer) 1
keydb-cli> SUNION key1 key2
1) "b"
2) "c"
3) "a"
4) "e"
5) "d"
```

---




## SUNIONSTORE

**Related Commands:** [SADD](/docs/commands/#sadd), [SCARD](/docs/commands/#scard), [SDIFF](/docs/commands/#sdiff), [SDIFFSTORE](/docs/commands/#sdiffstore), [SINTER](/docs/commands/#sinter), [SINTERSTORE](/docs/commands/#sinterstore), [SISMEMBER](/docs/commands/#sismember), [SMEMBERS](/docs/commands/#smembers), [SMOVE](/docs/commands/#smove), [SPOP](/docs/commands/#spop), [SRANDMEMBER](/docs/commands/#srandmember), [SREM](/docs/commands/#srem), [SSCAN](/docs/commands/#sscan), [SUNION](/docs/commands/#sunion), [SUNIONSTORE](/docs/commands/#sunionstore)

#### Syntax:

```
SUNIONSTORE <destination> <set-1> ... <set-n>
```

#### Description:

This command is equal to `SUNION`, but instead of returning the resulting set,
it is stored in `destination`.

If `destination` already exists, it is overwritten.

#### Return:

Integer Reply: the number of elements in the resulting set.

#### Examples:

```
keydb-cli> SADD key1 "a"
(integer) 1
keydb-cli> SADD key1 "b"
(integer) 1
keydb-cli> SADD key1 "c"
(integer) 1
keydb-cli> SADD key2 "c"
(integer) 1
keydb-cli> SADD key2 "d"
(integer) 1
keydb-cli> SADD key2 "e"
(integer) 1
keydb-cli> SUNIONSTORE key key1 key2
(integer) 5
keydb-cli> SMEMBERS key
1) "b"
2) "c"
3) "a"
4) "e"
5) "d"
```

---




## SWAPDB

**Related Commands:** [AUTH](/docs/commands/#append), [ECHO](/docs/commands/#echo), [PING](/docs/commands/#ping), [QUIT](/docs/commands/#quit), [SELECT](/docs/commands/#select), [SWAPDB](/docs/commands/#swapdb)

#### Syntax:

```SWAPDB <index-1> <index-2>```

#### Description:

This command swaps two KeyDB databases, so that immediately all the
clients connected to a given database will see the data of the other database, and
the other way around. Example:

    SWAPDB 0 1

This will swap database 0 with database 1. All the clients connected with database 0 will immediately see the new data, exactly like all the clients connected with database 1 will see the data that was formerly of database 0.

#### Return:

Simple String Reply: `OK` if `SWAPDB` was executed correctly.

#### Examples:

```
keydb-cli> SWAPDB 0 1
OK
```

---




## SYNC

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

Initiates a replication stream from the master.

The SYNC command is called by Redis replicas for initiating a replication stream from the master. It has been replaced in newer versions of KeyDB by [PSYNC](/docs/commands/#psync).

For more information about replication in Redis please check the replication page.

#### Return value:
Non standard return value, a bulk transfer of the data followed by [PING](/docs/commands/#ping) and write requests from the master.


---




## TIME

**Related Commands:** [BGREWRITEAOF](/docs/commands/#bgrewriteaof), [BGSAVE](/docs/commands/#bgsave), [CLIENT-GETNAME](/docs/commands/#client-getname), [CLIENT ID](/docs/commands/#client-id), [CLIENT-KILL](/docs/commands/#client-kill), [CLIENT-LIST](/docs/commands/#client-list), [CLIENT PAUSE](/docs/commands/#client-pause), [CLIENT REPLY](/docs/commands/#client-reply), [CLIENT SETNAME](/docs/commands/#client-setname), [CLIENT UNBLOCK](/docs/commands/#client-unblock), [COMMAND](/docs/commands/#command), [COMMAND COUNT](/docs/commands/#command-count), [COMMAND GETKEYS](/docs/commands/#command-getkeys), [COMMAND INFO](/docs/commands/#command-info), [CONFIG GET](/docs/commands/#config-get), [CONFIG RESETSTAT](/docs/commands/#config-resetstat), [CONFIG REWRITE](/docs/commands/#config-rewrite), [CONFIG SET](/docs/commands/#config-set), [DBSIZE](/docs/commands/#dbsize), [DEBUG OBJECT](/docs/commands/#debug-object), [DEBUG SEGFAULT](/docs/commands/#debug-segfault), [FLUSHALL](/docs/commands/#flushall), [FLUSHDB](/docs/commands/#flushdb), [INFO](/docs/commands/#info), [LASTSAVE](/docs/commands/#lastsave), [LATENCY DOCTOR](/docs/commands/#latency-doctor), [LATENCY GRAPH](/docs/commands/#latency-graph), [LATENCY HELP](/docs/commands/#latency-help), [LATENCY HISTORY](/docs/commands/#latency-history), [LATENCY LATEST](/docs/commands/#latency-latest), [LATENCY RESET](/docs/commands/#latency-reset), [LOLWUT](/docs/commands/#lolwut), [MEMORY DOCTOR](/docs/commands/#memory-doctor), [MEMORY HELP](/docs/commands/#memory-help), [MEMORY MALLOC-STATS](/docs/commands/#memory-malloc-stats), [MEMORY PURGE](/docs/commands/#MEMORY-PURGE), [MEMORY STATS](/docs/commands/#memory-stats), [MEMORY USAGE](/docs/commands/#memory-usage), [MODULE LIST](/docs/commands/#module-list), [MODULE LOAD](/docs/commands/#module-load), [MODULE UNLOAD](/docs/commands/#module-unload), [MONITOR](/docs/commands/#monitor), [PSYNC](/docs/commands/#psync), [REPLICAOF](/docs/commands/#replicaof), [ROLE](/docs/commands/#role), [SAVE](/docs/commands/#save), [SHUTDOWN](/docs/commands/#shutdown), [SLAVEOF](/docs/commands/#slaveof), [SLOWLOG](/docs/commands/#slowlog), [SYNC](/docs/commands/#sync), [TIME](/docs/commands/#time) 

The `TIME` command returns the current server time as a two items lists: a Unix
timestamp and the amount of microseconds already elapsed in the current second.
Basically the interface is very similar to the one of the `gettimeofday` system
call.

#### Return:

Array Reply, specifically:

A multi bulk reply containing two elements:

* unix time in seconds.
* microseconds.

#### Examples:

```
keydb-cli> TIME
1) "1631131723"
2) "621317"
keydb-cli> TIME
1) "1631131724"
2) "525306"
```

---





## TOUCH

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```TOUCH <key-1> ... <key-n>```

#### Description:

Alters the last access time of a key(s).
A key is ignored if it does not exist.

#### Return:

Integer Reply: The number of keys that were touched.

#### Examples:

```
keydb-cli> SET key1 "Hello"
OK
keydb-cli> SET key2 "World"
OK
keydb-cli> TOUCH key1 key2
(integer) 2
```
---





## TTL

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```TTL <key>```

```TTL <key> <subkey>```
#### Description:

Returns the remaining time to live of a key or subkey that has a timeout.
This introspection capability allows a KeyDB client to check how many seconds a
given key or subkey will continue to be part of the dataset.

See also the `PTTL` command that returns the same information with milliseconds resolution.

#### Return:

Integer Reply: TTL in seconds, or a negative value in order to signal an error (see the description above).

#### Examples:

```
keydb-cli> SET mykey "Hello"
OK
keydb-cli> EXPIRE mykey 10
(integer) 1
keydb-cli> TTL mykey
(integer) 10
```

```
keydb-cli> SADD myset member1 member2
(integer) 2
keydb-cli> EXPIREMEMBER myset member2 10
(integer) 1
keydb-cli> TTL myset member2
(integer) 6
```
---





## TYPE

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```TYPE <key>```

#### Description:

Returns the string representation of the type of the value stored at `key`.
The different types that can be returned are: `string`, `list`, `set`, `zset`,
`hash` and `stream`.

#### Return:

Simple String Reply: type of `key`, or `none` when `key` does not exist.

#### Examples:

```
keydb-cli> SET key1 "value"
OK
keydb-cli> LPUSH key2 "value"
(integer) 1
keydb-cli> SADD key3 "value"
(integer) 1
keydb-cli> TYPE key1
string
keydb-cli> TYPE key2
list
keydb-cli> TYPE key3
set
```
---




## UNLINK

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

#### Syntax:

```UNLINK <key-1> ... <key-n>```

#### Description:

This command is very similar to `DEL`: it removes the specified keys.
Just like `DEL` a key is ignored if it does not exist. However the command
performs the actual memory reclaiming in a different thread, so it is not
blocking, while `DEL` is. This is where the command name comes from: the
command just **unlinks** the keys from the keyspace. The actual removal
will happen later asynchronously.

#### Return:

Integer Reply: The number of keys that were unlinked.

#### Examples:

```
keydb-cli> SET key1 "Hello"
OK
keydb-cli> SET key2 "World"
OK
keydb-cli> UNLINK key1 key2 key3
(integer) 2
```

---




## UNSUBSCRIBE

**Related Commands:** [PSUBSCRIBE](/docs/commands/#psubscribe), [PUBLISH](/docs/commands/#publish), [PUBSUB](/docs/commands/#pubsub), [PUNSUBSCRIBE](/docs/commands/#punsubscribe), [SUBSCRIBE](/docs/commands/#subscribe), [UNSUBSCRIBE](/docs/commands/#unsubscribe)

Unsubscribes the client from the given channels, or from all of them if none is
given.

When no channels are specified, the client is unsubscribed from all the
previously subscribed channels.
In this case, a message for every unsubscribed channel will be sent to the
client.

---




## UNWATCH

**Related Commands:** [DISCARD](/docs/commands/#discard), [EXEC](/docs/commands/#exec), [MULTI](/docs/commands/#multi), [UNWATCH](/docs/commands/#unwatch), [WATCH](/docs/commands/#watch)

Flushes all the previously watched keys for a transaction

If you call `EXEC` or `DISCARD`, there's no need to manually call `UNWATCH`.

#### Return:

Simple String Reply: always `OK`.

---




## WAIT

**Related Commands:** [DEL](/docs/commands/#del), [DUMP](/docs/commands/#dump), [EXISTS](/docs/commands/#exists), [EXPIRE](/docs/commands/#expire), [EXPIREAT](/docs/commands/#expireat), [KEYS](/docs/commands/#keys), [MIGRATE](/docs/commands/#migrate), [MOVE](/docs/commands/#move), [OBJECT](/docs/commands/#object), [PERSIST](/docs/commands/#persist), [PEXPIRE](/docs/commands/#pexpire), [PEXPIREAT](/docs/commands/#pexpireat), [PTTL](/docs/commands/#pttl), [RANDOMKEY](/docs/commands/#randomkey), [RENAME](/docs/commands/#rename), [RENAMENX](/docs/commands/#renamenx), [RESTORE](/docs/commands/#restore), [SCAN](/docs/commands/#scan), [SORT](/docs/commands/#sort), [TOUCH](/docs/commands/#touch), [TTL](/docs/commands/#ttl), [TYPE](/docs/commands/#type), [UNLINK](/docs/commands/#unlink), [WAIT](/docs/commands/#wait)

This command blocks the current client until all the previous write commands
are successfully transferred and acknowledged by at least the specified number
of replicas. If the timeout, specified in milliseconds, is reached, the command
returns even if the specified number of replicas were not yet reached.

The command **will always return** the number of replicas that acknowledged
the write commands sent before the `WAIT` command, both in the case where
the specified number of replicas are reached, or when the timeout is reached.

A few remarks:

1. When `WAIT` returns, all the previous write commands sent in the context of the current connection are guaranteed to be received by the number of replicas returned by `WAIT`.
2. If the command is sent as part of a `MULTI` transaction, the command does not block but instead just return ASAP the number of replicas that acknowledged the previous write commands.
3. A timeout of 0 means to block forever.
4. Since `WAIT` returns the number of replicas reached both in case of failure and success, the client should check that the returned value is equal or greater to the replication level it demanded.

#### Consistency and WAIT

Note that `WAIT` does not make KeyDB a strongly consistent store: while synchronous replication is part of a replicated state machine, it is not the only thing needed. However in the context of Sentinel or KeyDB Cluster failover, `WAIT` improves the real world data safety.

Specifically if a given write is transferred to one or more replicas, it is more likely (but not guaranteed) that if the master fails, we'll be able to promote, during a failover, a replica that received the write: both Sentinel and KeyDB Cluster will do a best-effort attempt to promote the best replica among the set of available replicas.

However this is just a best-effort attempt so it is possible to still lose a write synchronously replicated to multiple replicas.

#### Implementation details


Since the introduction of partial resynchronization with replicas (PSYNC feature) KeyDB replicas asynchronously ping their master with the offset they already processed in the replication stream. This is used in multiple ways:

1. Detect timed out replicas.
2. Perform a partial resynchronization after a disconnection.
3. Implement `WAIT`.

In the specific case of the implementation of `WAIT`, KeyDB remembers, for each client, the replication offset of the produced replication stream when a given
write command was executed in the context of a given client. When `WAIT` is
called KeyDB checks if the specified number of replicas already acknowledged
this offset or a greater one.

#### Return:

Integer Reply: The command returns the number of replicas reached by all the writes performed in the context of the current connection.

#### Examples:

```
> SET foo bar
OK
> WAIT 1 0
(integer) 1
> WAIT 2 1000
(integer) 1
```

In the following example the first call to `WAIT` does not use a timeout and asks for the write to reach 1 replica. It returns with success. In the second attempt instead we put a timeout, and ask for the replication of the write to two replicas. Since there is a single replica available, after one second `WAIT` unblocks and returns 1, the number of replicas reached.

---





## WATCH

**Related Commands:** [DISCARD](/docs/commands/#discard), [EXEC](/docs/commands/#exec), [MULTI](/docs/commands/#multi), [UNWATCH](/docs/commands/#unwatch), [WATCH](/docs/commands/#watch)

Marks the given keys to be watched for conditional execution of a
transaction

#### Return:

Simple String Reply: always `OK`.

---




## XACK

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

The `XACK` command removes one or multiple messages from the
*pending entries list* (PEL) of a stream consumer group. A message is pending,
and as such stored inside the PEL, when it was delivered to some consumer,
normally as a side effect of calling `XREADGROUP`, or when a consumer took
ownership of a message calling `XCLAIM`. The pending message was delivered to
some consumer but the server is yet not sure it was processed at least once.
So new calls to `XREADGROUP` to grab the messages history for a consumer
(for instance using an ID of 0), will return such message.
Similarly the pending message will be listed by the `XPENDING` command,
that inspects the PEL.

Once a consumer *succesfully* processes a message, it should call `XACK`
so that such message does not get processed again, and as a side effect,
the PEL entry about this message is also purged, releasing memory from the
KeyDB server.

#### Return:

Integer Reply, specifically:

The command returns the number of messages successfully acknowledged.
Certain message IDs may no longer be part of the PEL (for example because
they have been already acknowledge), and XACK will not count them as
successfully acknowledged.

```cli
XACK mystream mygroup 1526569495631-0
```

---





## XADD

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

Appends the specified stream entry to the stream at the specified key.
If the key does not exist, as a side effect of running this command the
key is created with a stream value.

An entry is composed of a set of field-value pairs, it is basically a
small dictionary. The field-value pairs are stored in the same order
they are given by the user, and commands to read the stream such as
`XRANGE` or `XREAD` are guaranteed to return the fields and values
exactly in the same order they were added by `XADD`.

`XADD` is the *only KeyDB command* that can add data to a stream, but 
there are other commands, such as `XDEL` and `XTRIM`, that are able to
remove data from a stream.

#### Specifying a Stream ID as an argument

A stream entry ID identifies a given entry inside a stream.
The `XADD` command will auto-generate a unique ID for you if the ID argument
specified is the `*` character (asterisk ASCII character). However, while
useful only in very rare cases, it is possible to specify a well-formed ID, so
that the new entry will be added exactly with the specified ID.

IDs are specified by two numbers separated by a `-` character:

    1526919030474-55

Both quantities are 64-bit numbers. When an ID is auto-generated, the
first part is the Unix time in milliseconds of the KeyDB instance generating
the ID. The second part is just a sequence number and is used in order to
distinguish IDs generated in the same millisecond.

IDs are guaranteed to be always incremental: If you compare the ID of the
entry just inserted it will be greater than any other past ID, so entries
are totally ordered inside a stream. In order to guarantee this property,
if the current top ID in the stream has a time greater than the current
local time of the instance, the top entry time will be used instead, and
the sequence part of the ID incremented. This may happen when, for instance,
the local clock jumps backward, or if after a failover the new master has
a different absolute time.

When a user specified an explicit ID to `XADD`, the minimum valid ID is
`0-1`, and the user *must* specify an ID which is greater than any other
ID currently inside the stream, otherwise the command will fail. Usually
resorting to specific IDs is useful only if you have another system generating
unique IDs (for instance an SQL table) and you really want the KeyDB stream
IDs to match the one of this other system.

#### Capped streams

It is possible to limit the size of the stream to a maximum number of
elements using the **MAXLEN** option. 

Trimming with **MAXLEN** can be expensive compared to just adding entries with 
`XADD`: streams are represented by macro nodes into a radix tree, in order to
be very memory efficient. Altering the single macro node, consisting of a few
tens of elements, is not optimal. So it is possible to give the command in the
following special form:

    XADD mystream MAXLEN ~ 1000 * ... entry fields here ...

The `~` argument between the **MAXLEN** option and the actual count means that
the user is not really requesting that the stream length is exactly 1000 items,
but instead it could be a few tens of entries more, but never less than 1000
items. When this option modifier is used, the trimming is performed only when
KeyDB is able to remove a whole macro node. This makes it much more efficient,
and it is usually what you want.

#### Additional information about streams

For further information about KeyDB streams please check our
introduction to KeyDB Streams document in 'commands' section..

#### Return:

Bulk String Reply, specifically:

The command returns the ID of the added entry. The ID is the one auto-generated
if `*` is passed as ID argument, otherwise the command just returns the same ID
specified by the user during insertion.

#### Examples:

```cli
XADD mystream * name Sara surname OConnor
XADD mystream * field1 value1 field2 value2 field3 value3
XLEN mystream
XRANGE mystream - +
```

---




## XCLAIM

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

In the context of a stream consumer group, this command changes the ownership
of a pending message, so that the new owner is the consumer specified as the
command argument. Normally this is what happens:

1. There is a stream with an associated consumer group.
2. Some consumer A reads a message via `XREADGROUP` from a stream, in the context of that consumer group.
3. As a side effect a pending message entry is created in the pending entries list (PEL) of the consumer group: it means the message was delivered to a given consumer, but it was not yet acknowledged via `XACK`.
4. Then suddenly that consumer fails forever.
5. Other consumers may inspect the list of pending messages, that are stale for quite some time, using the `XPENDING` command. In order to continue processing such messages, they use `XCLAIM` to acquire the ownership of the message and continue.

This dynamic is clearly explained in the Stream intro documentation.

Note that the message is claimed only if its idle time is greater the minimum idle time we specify when calling `XCLAIM`. Because as a side effect `XCLAIM` will also reset the idle time (since this is a new attempt at processing the message), two consumers trying to claim a message at the same time will never both succeed: only one will successfully claim the message. This avoids that we process a given message multiple times in a trivial way (yet multiple processing is possible and unavoidable in the general case).

Moreover, as a side effect, `XCLAIM` will increment the count of attempted deliveries of the message unless the `JUSTID` option has been specified (which only delivers the message ID, not the message itself). In this way messages that cannot be processed for some reason, for instance because the consumers crash attempting to process them, will start to have a larger counter and can be detected inside the system.

#### Command options

The command has multiple options, however most are mainly for internal use in
order to transfer the effects of `XCLAIM` or other commands to the AOF file
and to propagate the same effects to the slaves, and are unlikely to be
useful to normal users:

1. `IDLE <ms>`: Set the idle time (last time it was delivered) of the message. If IDLE is not specified, an IDLE of 0 is assumed, that is, the time count is reset because the message has now a new owner trying to process it.
2. `TIME <ms-unix-time>`: This is the same as IDLE but instead of a relative amount of milliseconds, it sets the idle time to a specific Unix time (in milliseconds). This is useful in order to rewrite the AOF file generating `XCLAIM` commands.
3. `RETRYCOUNT <count>`: Set the retry counter to the specified value. This counter is incremented every time a message is delivered again. Normally `XCLAIM` does not alter this counter, which is just served to clients when the XPENDING command is called: this way clients can detect anomalies, like messages that are never processed for some reason after a big number of delivery attempts.
4. `FORCE`: Creates the pending message entry in the PEL even if certain specified IDs are not already in the PEL assigned to a different client. However the message must be exist in the stream, otherwise the IDs of non existing messages are ignored.
5. `JUSTID`: Return just an array of IDs of messages successfully claimed, without returning the actual message. Using this option means the retry counter is not incremented.

#### Return:

Array Reply, specifically:

The command returns all the messages successfully claimed, in the same format
as `XRANGE`. However if the `JUSTID` option was specified, only the message
IDs are reported, without including the actual message.

Example:

```
> XCLAIM mystream mygroup Alice 3600000 1526569498055-0
1) 1) 1526569498055-0
   2) 1) "message"
      2) "orange"
```

In the above example we claim the message with ID `1526569498055-0`, only if the message is idle for at least one hour without the original consumer or some other consumer making progresses (acknowledging or claiming it), and assigns the ownership to the consumer `Alice`.

---





## XDEL

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

Removes the specified entries from a stream, and returns the number of entries
deleted, that may be different from the number of IDs passed to the command in
case certain IDs do not exist.

Normally you may think at a KeyDB stream as an append-only data structure,
however KeyDB streams are represented in memory, so we are able to also
delete entries. This may be useful, for instance, in order to comply with
certain privacy policies.

#### Understanding the low level details of entries deletion

KeyDB streams are represented in a way that makes them memory efficient:
a radix tree is used in order to index macro-nodes that pack linearly tens
of stream entries. Normally what happens when you delete an entry from a stream
is that the entry is not *really* evicted, it just gets marked as deleted.

Eventually if all the entries in a macro-node are marked as deleted, the whole
node is destroyed and the memory reclaimed. This means that if you delete
a large amount of entries from a stream, for instance more than 50% of the
entries appended to the stream, the memory usage per entry may increment, since
what happens is that the stream will start to be fragmented. However the stream
performances will remain the same.

In future versions of KeyDB it is possible that we'll trigger a node garbage
collection in case a given macro-node reaches a given amount of deleted
entries. Currently with the usage we anticipate for this data structure, it is
not a good idea to add such complexity.

#### Return:

Integer Reply: the number of entries actually deleted.

#### Examples:

```
> XADD mystream * a 1
1538561698944-0
> XADD mystream * b 2
1538561700640-0
> XADD mystream * c 3
1538561701744-0
> XDEL mystream 1538561700640-0
(integer) 1
127.0.0.1:6379> XRANGE mystream - +
1) 1) 1538561698944-0
   2) 1) "a"
      2) "1"
2) 1) 1538561701744-0
   2) 1) "c"
      2) "3"
```

---





## XGROUP

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

This command is used in order to manage the consumer groups associated
with a stream data structure. Using `XGROUP` you can:

* Create a new consumer group associated with a stream.
* Destroy a consumer group.
* Remove a specific consumer from a consumer group.
* Set the consumer group *last delivered ID* to something else.

To create a new consumer group, use the following form:

    XGROUP CREATE mystream consumer-group-name $

The last argument is the ID of the last item in the stream to consider already
delivered. In the above case we used the special ID '$' (that means: the ID
of the last item in the stream). In this case the consumers fetching data
from that consumer group will only see new elements arriving in the stream.

If instead you want consumers to fetch the whole stream history, use
zero as the starting ID for the consumer group:

    XGROUP CREATE mystream consumer-group-name 0

Of course it is also possible to use any other valid ID. If the specified
consumer group already exists, the command returns a `-BUSYGROUP` error.
Otherwise the operation is performed and OK is returned. There are no hard
limits to the number of consumer groups you can associate to a given stream.

A consumer can be destroyed completely by using the following form:

    XGROUP DESTROY mystream consumer-group-name

The consumer group will be destroyed even if there are active consumers
and pending messages, so make sure to call this command only when really
needed.

To just remove a given consumer from a consumer group, the following
form is used:

    XGROUP DELCONSUMER mystream consumer-group-name myconsumer123

Consumers in a consumer group are auto-created every time a new consumer
name is mentioned by some command. However sometimes it may be useful to
remove old consumers since they are no longer used. This form returns
the number of pending messages that the consumer had before it was deleted.

Finally it possible to set the next message to deliver using the
`SETID` subcommand. Normally the next ID is set when the consumer is
created, as the last argument of `XGROUP CREATE`. However using this form
the next ID can be modified later without deleting and creating the consumer
group again. For instance if you want the consumers in a consumer group
to re-process all the messages in a stream, you may want to set its next
ID to 0:

    XGROUP SETID mystream consumer-group-name 0

Finally to get some help if you don't remember the syntax, use the
HELP subcommand:

    XGROUP HELP
---




## XINFO

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

This is an introspection command used in order to retrieve different information
about the streams and associated consumer groups. Three forms are possible:

* `XINFO STREAM <key>`

In this form the command returns general information about the stream stored
at the specified key.

```
> XINFO STREAM mystream
 1) length
 2) (integer) 2
 3) radix-tree-keys
 4) (integer) 1
 5) radix-tree-nodes
 6) (integer) 2
 7) groups
 8) (integer) 2
 9) last-generated-id
10) 1538385846314-0
11) first-entry
12) 1) 1538385820729-0
    2) 1) "foo"
       2) "bar"
13) last-entry
14) 1) 1538385846314-0
    2) 1) "field"
       2) "value"
```

In the above example you can see that the reported information are the number
of elements of the stream, details about the radix tree representing the
stream mostly useful for optimization and debugging tasks, the number of
consumer groups associated with the stream, the last generated ID that may
not be the same as the last entry ID in case some entry was deleted. Finally
the full first and last entry in the stream are shown, in order to give some
sense about what is the stream content.

* `XINFO GROUPS <key>`

In this form we just get as output all the consumer groups associated with the
stream:

```
> XINFO GROUPS mystream
1) 1) name
   2) "mygroup"
   3) consumers
   4) (integer) 2
   5) pending
   6) (integer) 2
2) 1) name
   2) "some-other-group"
   3) consumers
   4) (integer) 1
   5) pending
   6) (integer) 0
```

For each consumer group listed the command also shows the number of consumers
known in that group and the pending messages (delivered but not yet acknowledged)
in that group.

* `XINFO CONSUMERS <key> <group>`

Finally it is possible to get the list of every consumer in a specific consumer
group:

```
> XINFO CONSUMERS mystream mygroup
1) 1) name
   2) "Alice"
   3) pending
   4) (integer) 1
   5) idle
   6) (integer) 9104628
2) 1) name
   2) "Bob"
   3) pending
   4) (integer) 1
   5) idle
   6) (integer) 83841983
```

We can see the idle time in milliseconds (last field) together with the
consumer name and the number of pending messages for this specific
consumer.

**Note that you should not rely on the fields exact position**, nor on the
number of fields, new fields may be added in the future. So a well behaving
client should fetch the whole list, and report it to the user, for example,
as a dictionary data structure. Low level clients such as C clients where
the items will likely be reported back in a linear array should document
that the order is undefined.

Finally it is possible to get help from the command, in case the user can't
remember the exact syntax, by using the `HELP` subcommnad:

```
> XINFO HELP
1) XINFO <subcommand> arg arg ... arg. Subcommands are:
2) CONSUMERS <key> <groupname>  -- Show consumer groups of group <groupname>.
3) GROUPS <key>                 -- Show the stream consumer groups.
4) STREAM <key>                 -- Show information about the stream.
5) HELP
```

---




## XLEN

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

Returns the number of entries inside a stream. If the specified key does not
exist the command returns zero, as if the stream was empty.
However note that unlike other KeyDB types, zero-length streams are
possible, so you should call `TYPE` or `EXISTS` in order to check if
a key exists or not.

Streams are not auto-deleted once they have no entries inside (for instance
after an `XDEL` call), because the stream may have consumer groups
associated with it.

#### Return:

Integer Reply: the number of entries of the stream at `key`.

#### Examples:

```cli
XADD mystream * item 1
XADD mystream * item 2
XADD mystream * item 3
XLEN mystream
```
---




## XSPENDING

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

Fetching data from a stream via a consumer group, and not acknowledging
such data, has the effect of creating *pending entries*. This is
well explained in the `XREADGROUP` command, and even better in our
introduction to KeyDB Streams. The `XACK` command
will immediately remove the pending entry from the Pending Entry List (PEL)
since once a message is successfully processed, there is no longer need
for the consumer group to track it and to remember the current owner
of the message.

The `XPENDING` command is the interface to inspect the list of pending
messages, and is as thus a very important command in order to observe
and understand what is happening with a streams consumer groups: what
clients are active, what messages are pending to be consumed, or to see
if there are idle messages. Moreover this command, together with `XCLAIM`
is used in order to implement recovering of consumers that are failing
for a long time, and as a result certain messages are not processed: a
different consumer can claim the message and continue. This is better
explained in the streams intro and in the
`XCLAIM` command page, and is not covered here.

#### Summary form of XPENDING

When `XPENDING` is called with just a key name and a consumer group
name, it just outputs a summary about the pending messages in a given
consumer group. In the following example, we create a consumed group and
immediatelycreate a pending message by reading from the group with
`XREADGROUP`.

```
> XGROUP CREATE mystream group55 0-0
OK

> XREADGROUP GROUP group55 consumer-123 COUNT 1 STREAMS mystream >
1) 1) "mystream"
   2) 1) 1) 1526984818136-0
         2) 1) "duration"
            2) "1532"
            3) "event-id"
            4) "5"
            5) "user-id"
            6) "7782813"
```

We expect the pending entries list for the consumer group `group55` to
have a message right now: consumer named `consumer-123` fetched the
message without acknowledging its processing. The simples `XPENDING`
form will give us this information:

```
> XPENDING mystream group55
1) (integer) 1
2) 1526984818136-0
3) 1526984818136-0
4) 1) 1) "consumer-123"
      2) "1"
```

In this form, the command outputs the total number of pending messages for this
consumer group, which is one, followed by the smallest and greatest ID among the
pending messages, and then list every consumer in the consumer group with
at least one pending message, and the number of pending messages it has.

This is a good overview, but sometimes we are interested in the details.
In order to see all the pending messages with more associated information
we need to also pass a range of IDs, in a similar way we do it with
`XRANGE`, and a non optional *count* argument, to limit the number
of messages returned per call:

```
> XPENDING mystream group55 - + 10
1) 1) 1526984818136-0
   2) "consumer-123"
   3) (integer) 196415
   4) (integer) 1
```

In the extended form we no longer see the summary information, instead there
are detailed information for each message in the pending entries list. For
each message four attributes are returned:

1. The ID of the message.
2. The name of the consumer that fetched the message and has still to acknowledge it. We call it the current *owner* of the message.
3. The number of milliseconds that elapsed since the last time this message was delivered to this consumer.
4. The number of times this message was delivered.

The deliveries counter, that is the fourth element in the array, is incremented
when some other consumer *claims* the message with `XCLAIM`, or when the
message is delivered again via `XREADGROUP`, when accessing the history
of a consumer in a consumer group (see the `XREADGROUP` page for more info).

Finally it is possible to pass an additional argument to the command, in order
to see the messages having a specific owner:

```
> XPENDING mystream group55 - + 10 consumer-123
```

But in the above case the output would be the same, since we have pending
messages only for a single consumer. However what is important to keep in
mind is that this operation, filtering by a specific consumer, is not
inefficient even when there are many pending messages from many consumers:
we have a pending entries list data structure both globally, and for
every consumer, so we can very efficiently show just messages pending for
a single consumer.

#### Return:

Array Reply, specifically:

The command returns data in different format depending on the way it is
called, as previously explained in this page. However the reply is always
an array of items.

---




## XRANGE

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

The command returns the stream entries matching a given range of IDs.
The range is specified by a minimum and maximum ID. All the entires having
an ID between the two specified or exactly one of the two IDs specified
(closed interval) are returned.

The `XRANGE` command has a number of applications:

* Returning items in a specific time range. This is possible because
  Stream IDs are related to time.
* Iteratating a stream incrementally, returning just
  a few items at every iteration. However it is semantically much more
  robust than the `SCAN` family of functions.
* Fetching a single entry from a stream, providing the ID of the entry
  to fetch two times: as start and end of the query interval.

The command also has a reciprocal command returning items in the
reverse order, called `XREVRANGE`, which is otherwise identical.

#### `-` and `+` special IDs

The `-` and `+` special IDs mean respectively the minimum ID possible
and the maximum ID possible inside a stream, so the following command
will just return every entry in the stream:

```
> XRANGE somestream - +
1) 1) 1526985054069-0
   2) 1) "duration"
      2) "72"
      3) "event-id"
      4) "9"
      5) "user-id"
      6) "839248"
2) 1) 1526985069902-0
   2) 1) "duration"
      2) "415"
      3) "event-id"
      4) "2"
      5) "user-id"
      6) "772213"
... other entries here ...
```

The `-` ID is effectively just exactly as specifying `0-0`, while
`+` is equivalent to `18446744073709551615-18446744073709551615`, however
they are nicer to type.

#### Incomplete IDs

Stream IDs are composed of two parts, a Unix millisecond time stamp and a
sequence number for entries inserted in the same millisecond. It is possible
to use `XRANGE` specifying just the first part of the ID, the millisecond time,
like in the following example:

```
> XRANGE somestream 1526985054069 1526985055069
```

In this case, `XRANGE` will auto-complete the start interval with `-0`
and end interval with `-18446744073709551615`, in order to return all the
entries that were generated between a given millisecond and the end of
the other specified millisecond. This also means that repeating the same
millisecond two times, we get all the entries within such millisecond,
because the sequence number range will be from zero to the maximum.

Used in this way `XRANGE` works as a range query command to obtain entries
in a specified time. This is very handy in order to access the history
of past events in a stream.

#### Returning a maximum number of entries

Using the **COUNT** option it is possible to reduce the number of entries
reported. This is a very important feature even if it may look marginal,
because it allows, for instance, to model operations such as *give me
the entry greater or equal to the following*:

```
> XRANGE somestream 1526985054069-0 + COUNT 1
1) 1) 1526985054069-0
   2) 1) "duration"
      2) "72"
      3) "event-id"
      4) "9"
      5) "user-id"
      6) "839248"
```

In the above case the entry `1526985054069-0` exists, otherwise the server
would have sent us the next one. Using `COUNT` is also the base in order to
use `XRANGE` as an iterator.

#### Iterating a stream

In order to iterate a stream, we can proceed as follows. Let's assume that
we want two elements per iteration. We start fetching the first two
elements, which is trivial:

```
> XRANGE writers - + COUNT 2
1) 1) 1526985676425-0
   2) 1) "name"
      2) "Virginia"
      3) "surname"
      4) "Woolf"
2) 1) 1526985685298-0
   2) 1) "name"
      2) "Jane"
      3) "surname"
      4) "Austen"
```

Then instead of starting the iteration again from `-`, as the start
of the range we use the entry ID of the *last* entry returned by the
previous `XRANGE` call, adding the sequence part of the ID by one.

The ID of the last entry is `1526985685298-0`, so we just add 1 to the
sequence to obtain `1526985685298-1`, and continue our iteration:

```
> XRANGE writers 1526985685298-1 + COUNT 2
1) 1) 1526985691746-0
   2) 1) "name"
      2) "Toni"
      3) "surname"
      4) "Morris"
2) 1) 1526985712947-0
   2) 1) "name"
      2) "Agatha"
      3) "surname"
      4) "Christie"
```

And so forth. Eventually this will allow to visit all the entries in the
stream. Obviously, we can start the iteration from any ID, or even from
a specific time, by providing a given incomplete start ID. Moreover, we
can limit the iteration to a given ID or time, by providing an end
ID or incomplete ID instead of `+`.

The command `XREAD` is also able to iterate the stream.
The command `XREVRANGE` can iterate the stream reverse, from higher IDs
(or times) to lower IDs (or times).

#### Fetching single items

If you look for an `XGET` command you'll be disappointed because `XRANGE`
is effectively the way to go in order to fetch a single entry from a
stream. All you have to do is to specify the ID two times in the arguments
of XRANGE:

```
> XRANGE mystream 1526984818136-0 1526984818136-0
1) 1) 1526984818136-0
   2) 1) "duration"
      2) "1532"
      3) "event-id"
      4) "5"
      5) "user-id"
      6) "7782813"
```

#### Additional information about streams

For further information about KeyDB streams please check our
introduction to KeyDB Streams document.

#### Return:

Array Reply, specifically:

The command returns the entries with IDs matching the specified range.
The returned entries are complete, that means that the ID and all the fields
they are composed are returned. Moreover, the entries are returned with
their fields and values in the exact same order as `XADD` added them.

#### Examples:

```cli
XADD writers * name Virginia surname Woolf
XADD writers * name Jane surname Austen
XADD writers * name Toni surname Morris
XADD writers * name Agatha surname Christie
XADD writers * name Ngozi surname Adichie
XLEN writers
XRANGE writers - + COUNT 2
```

---






## XREAD

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

Read data from one or multiple streams, only returning entries with an
ID greater than the last received ID reported by the caller.
This command has an option to block if items are not available, in a similar
fashion to `BRPOP` or `BZPOPMIN` and others.

Please note that before reading this page, if you are new to streams,
we recommend to read our introduction to KeyDB Streams.

#### Non-blocking usage

If the **BLOCK** option is not used, the command is synchronous, and can
be considered somewhat related to `XRANGE`: it will return a range of items
inside streams, however it has two fundamental differences compared to `XRANGE`
even if we just consider the synchronous usage:

* This command can be called with multiple streams if we want to read at
  the same time from a number of keys. This is a key feature of `XREAD` because
  especially when blocking with **BLOCK**, to be able to listen with a single
  connection to multiple keys is a vital feature.
* While `XRANGE` returns items in a range of IDs, `XREAD` is more suited in
  order to consume the stream starting from the first entry which is greater
  than any other entry we saw so far. So what we pass to `XREAD` is, for each
  stream, the ID of the last element that we received from that stream.

For example, if I have two streams `mystream` and `writers`, and I want to
read data from both the streams starting from the first element they contain,
I could call `XREAD` like in the following example.

Note: we use the **COUNT** option in the example, so that for each stream
the call will return at maximum two elements per stream.

```
> XREAD COUNT 2 STREAMS mystream writers 0-0 0-0
1) 1) "mystream"
   2) 1) 1) 1526984818136-0
         2) 1) "duration"
            2) "1532"
            3) "event-id"
            4) "5"
            5) "user-id"
            6) "7782813"
      2) 1) 1526999352406-0
         2) 1) "duration"
            2) "812"
            3) "event-id"
            4) "9"
            5) "user-id"
            6) "388234"
2) 1) "writers"
   2) 1) 1) 1526985676425-0
         2) 1) "name"
            2) "Virginia"
            3) "surname"
            4) "Woolf"
      2) 1) 1526985685298-0
         2) 1) "name"
            2) "Jane"
            3) "surname"
            4) "Austen"
```

The **STREAMS** option is mandatory and MUST be the final option because
such option gets a variable length of argument in the following format:

    STREAMS key_1 key_2 key_3 ... key_N ID_1 ID_2 ID_3 ... ID_N

So we start with a list of keys, and later continue with all the associated
IDs, representing *the last ID we received for that stream*, so that the
call will serve us only greater IDs from the same stream.

For instance in the above example, the last items that we received
for the stream `mystream` has ID `1526999352406-0`, while for the
stream `writers` has the ID `1526985685298-0`.

To continue iterating the two streams I'll call:

```
> XREAD COUNT 2 STREAMS mystream writers 1526999352406-0 1526985685298-0
1) 1) "mystream"
   2) 1) 1) 1526999626221-0
         2) 1) "duration"
            2) "911"
            3) "event-id"
            4) "7"
            5) "user-id"
            6) "9488232"
2) 1) "writers"
   2) 1) 1) 1526985691746-0
         2) 1) "name"
            2) "Toni"
            3) "surname"
            4) "Morris"
      2) 1) 1526985712947-0
         2) 1) "name"
            2) "Agatha"
            3) "surname"
            4) "Christie"
```

And so forth. Eventually, the call will not return any item, but just an
empty array, then we know that there is nothing more to fetch from our
stream (and we would have to retry the operation, hence this command
also supports a blocking mode).

#### Incomplete IDs

To use incomplete IDs is valid, like it is valid for `XRANGE`. However
here the sequence part of the ID, if missing, is always interpreted as
zero, so the command:

```
> XREAD COUNT 2 STREAMS mystream writers 0 0
```

is exactly equivalent to

```
> XREAD COUNT 2 STREAMS mystream writers 0-0 0-0
```

#### Blocking for data

In its synchronous form, the command can get new data as long as there
are more items available. However, at some point, we'll have to wait for
producers of data to use `XADD` to push new entries inside the streams
we are consuming. In order to avoid polling at a fixed or adaptive interval
the command is able to block if it could not return any data, according
to the specified streams and IDs, and automatically unblock once one of
the requested keys accept data.

It is important to understand that this command is *fans out* to all the
clients that are waiting for the same range of IDs, so every consumer will
get a copy of the data, unlike to what happens when blocking list pop
operations are used.

In order to block, the **BLOCK** option is used, together with the number
of milliseconds we want to block before timing out. Normally KeyDB blocking
commands take timeouts in seconds, however this command takes a millisecond
timeout, even if normally the server will have a timeout resolution near
to 0.1 seconds. This time it is possible to block for a shorter time in
certain use cases, and if the server internals will improve over time, it is
possible that the resolution of timeouts will improve.

When the **BLOCK** command is passed, but there is data to return at
least in one of the streams passed, the command is executed synchronously
*exactly like if the BLOCK option would be missing*.

This is an example of blocking invocation, where the command later returns
a null reply because the timeout has elapsed without new data arriving:

```
> XREAD BLOCK 1000 STREAMS mystream 1526999626221-0
(nil)
```

#### The special `$` ID.

When blocking sometimes we want to receive just entries that are added
to the stream via `XADD` starting from the moment we block. In such a case
we are not interested in the history of already added entries. For
this use case, we would have to check the stream top element ID, and use
such ID in the `XREAD` command line. This is not clean and requires to
call other commands, so instead it is possible to use the special `$`
ID to signal the stream that we want only the new things.

It is **very important** to understand that you should use the `$`
ID only for the first call to `XREAD`. Later the ID should be the one
of the last reported item in the stream, otherwise you could miss all
the entries that are added in between.

This is how a typical `XREAD` call looks like in the first iteration
of a consumer willing to consume only new entries:

```
> XREAD BLOCK 5000 COUNT 100 STREAMS mystream $
```

Once we get some replies, the next call will be something like:

```
> XREAD BLOCK 5000 COUNT 100 STREAMS mystream 1526999644174-3
```

And so forth.

#### How multiple clients blocked on a single stream are served

Blocking list operations on lists or sorted sets have a *pop* behavior.
Bascially, the element is removed from the list or sorted set in order
to be returned to the client. In this scenario you want the items
to be consumed in a fair way, depending on the moment clients blocked
on a given key arrived. Normally KeyDB uses the FIFO semantics in this
use cases.

However note that with streams this is not a problem: stream entries
are not removed from the stream when clients are served, so every
client waiting will be served as soon as an `XADD` command provides
data to the stream.

#### Return:

Array Reply, specifically:

The command returns an array of results: each element of the returned
array is an array composed of a two element containing the key name and
the entries reported for that key. The entries reported are full stream
entries, having IDs and the list of all the fields and values. Field and
values are guaranteed to be reported in the same order they were added
by `XADD`.

When **BLOCK** is used, on timeout a null reply is returned.

Reading the KeyDB Streams introduction is highly
suggested in order to understand more about the streams overall behavior
and semantics.

---





## XREADGROUP

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

The `XREADGROUP` command is a special version of the `XREAD` command
with support for consumer groups. Probably you will have to understand the
`XREAD` command before reading this page will makes sense.

Moreover, if you are new to streams, we recommend to read our
introduction to KeyDB Streams.
Make sure to understand the concept of consumer group in the introduction
so that following how this command works will be simpler.

#### Consumer groups in 30 seconds

The difference between this command and the vanilla `XREAD` is that this
one supports consumer groups.

Without consumer groups, just using `XREAD`, all the clients are served with all the entries arriving in a stream. Instead using consumer groups with `XREADGROUP`, it is possible to create groups of clients that consume different parts of the messages arriving in a given stream. If, for instance, the stream gets the new entires A, B, and C and there are two consumers reading via a consumer group, one client will get, for instance, the messages A and C, and the other the message B, and so forth.

Within a consumer group, a given consumer (that is, just a client consuming messages from the stream), has to identify with an unique *consumer name*. Which is just a string.

One of the guarantees of consumer groups is that a given consumer can only see the history of messages that were delivered to it, so a message has just a single owner. However there is a special feature called *message claiming* that allows other consumers to claim messages in case there is a non recoverable failure of some consumer. In order to implement such semantics, consumer groups require explicit acknowledgement of the messages successfully processed by the consumer, via the `XACK` command. This is needed because the stream will track, for each consumer group, who is processing what message.

This is how to understand if you want to use a consumer group or not:

1. If you have a stream and multiple clients, and you want all the clients to get all the messages, you do not need a consumer group.
2. If you have a stream and multiple clients, and you want the stream to be *partitioned* or *shareded* across your clients, so that each client will get a sub set of the messages arriving in a stream, you need a consumer group.

#### Differences between XREAD and XREADGROUP

From the point of view of the syntax, the commands are almost the same,
however `XREADGROUP` *requires* a special and mandatory option:

    GROUP <group-name> <consumer-name>

The group name is just the name of a consumer group associated to the stream.
The group is created using the `XGROUP` command. The consumer name is the
string that is used by the client to identify itself inside the group.
The consumer is auto created inside the consumer group the first time it
is saw. Different clients should select a different consumer name.

When you read with `XREADGROUP`, the server will *remember* that a given
message was delivered to you: the message will be stored inside the
consumer group in what is called a Pending Entries List (PEL), that is
a list of message IDs delivered but not yet acknowledged.

The client will have to acknowledge the message processing using `XACK`
in order for the pending entry to be removed from the PEL. The PEL
can be inspected using the `XPENDING` command.

The `NOACK` subcommand can be used to avoid adding the message to the PEL in
cases where reliability is not a requirement and the occasional message loss
is acceptable. This is equivalent to acknowledging the message when it is read.

The ID to specify in the **STREAMS** option when using `XREADGROUP` can
be one of the following two:

* The special `>` ID, which means that the consumer want to receive only messages that were *never delivered to any other consumer*. It just means, give me new messages.
* Any other ID, that is, 0 or any other valid ID or incomplete ID (just the millisecond time part), will have the effect of returning entries that are pending for the consumer sending the command. So basically if the ID is not `>`, then the command will just let the client access its pending entries: delivered to it, but not yet acknowledged.

Like `XREAD` the `XREADGROUP` command can be used in a blocking way. There
are no differences in this regard.

#### What happens when a message is delivered to a consumer?

Two things:

1. If the message was never delivered to anyone, that is, if we are talking about a new message, then a PEL (Pending Entry List) is created.
2. If instead the message was already delivered to this consumer, and it is just re-fetching the same message again, then the *last delivery counter* is updated to the current time, and the *number of deliveries* is incremented by one. You can access those message properties using the `XPENDING` command.

#### Usage example

Normally you use the command like that in order to get new messages and
process them. In pseudo-code:

```
WHILE true
    entries = XREADGROUP $GroupName $ConsumerName BLOCK 2000 COUNT 10 STREAMS mystream >
    if entries == nil
        puts "Timeout... try again"
        CONTINUE
    end

    FOREACH entries AS stream_entries
        FOREACH stream_entries as message
            process_message(message.id,message.fields)

            #### ACK the message as processed
            XACK mystream $GroupName message.id
        END
    END
END
```

In this way the example consumer code will fetch only new messages, process
them, and acknowledge them via `XACK`. However the example code above is
not complete, because it does not handle recovering after a crash. What
will happen if we crash in the middle of processing messages, is that our
messages will remain in the pending entries list, so we can access our
history by giving `XREADGROUP` initially an ID of 0, and performing the same
loop. Once providing and ID of 0 the reply is an empty set of messages, we
know that we processed and acknowledged all the pending messages: we
can start to use `>` as ID, in order to get the new messages and rejoin the
consumers that are processing new things.

To see how the command actually replies, please check the `XREAD` command page.

---





## XREVRANGE

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

This command is exactly like `XRANGE`, but with the notable difference of
returning the entries in reverse order, and also taking the start-end
range in reverse order: in `XREVRANGE` you need to state the *end* ID
and later the *start* ID, and the command will produce all the element
between (or exactly like) the two IDs, starting from the *end* side.

So for instance, to get all the elements from the higher ID to the lower
ID one could use:

    XREVRANGE somestream + -

Similarly to get just the last element added into the stream it is
enough to send:

    XREVRANGE somestream + - COUNT 1

#### Iterating with XREVRANGE

Like `XRANGE` this command can be used in order to iterate the whole
stream content, however note that in this case, the next command calls
should use the ID of the last entry, with the sequence number decremneted
by one. However if the sequence number is already 0, the time part of the
ID should be decremented by 1, and the sequence part should be set to
the maxium possible sequence number, that is, 18446744073709551615, or
could be omitted at all, and the command will automatically assume it to
be such a number (see `XRANGE` for more info about incomplete IDs).

Example:

```
> XREVRANGE writers + - COUNT 2
1) 1) 1526985723355-0
   2) 1) "name"
      2) "Ngozi"
      3) "surname"
      4) "Adichie"
2) 1) 1526985712947-0
   2) 1) "name"
      2) "Agatha"
      3) "surname"
      4) "Christie"
```

The last ID returned is `1526985712947-0`, since the sequence number is
already zero, the next ID I'll use instead of the `+` special ID will
be `1526985712946-18446744073709551615`, or just `18446744073709551615`:

```
> XREVRANGE writers 1526985712946-18446744073709551615 - COUNT 2
1) 1) 1526985691746-0
   2) 1) "name"
      2) "Toni"
      3) "surname"
      4) "Morris"
2) 1) 1526985685298-0
   2) 1) "name"
      2) "Jane"
      3) "surname"
      4) "Austen"
```

And so for until the iteration is complete and no result is returned.
See the `XRANGE` page about iterating for more information.

#### Return:

Array Reply, specifically:

The command returns the entries with IDs matching the specified range,
from the higher ID to the lower ID matching.
The returned entries are complete, that means that the ID and all the fields
they are composed are returned. Moreover the entries are returned with
their fields and values in the exact same order as `XADD` added them.

#### Examples:

```cli
XADD writers * name Virginia surname Woolf
XADD writers * name Jane surname Austen
XADD writers * name Toni surname Morris
XADD writers * name Agatha surname Christie
XADD writers * name Ngozi surname Adichie
XLEN writers
XREVRANGE writers + - COUNT 1
```

---




## XTRIM

**Related Commands:** [XACK](/docs/commands/#xack), [XADD](/docs/commands/#xadd), [XCLAIM](/docs/commands/#xclaim), [XDEL](/docs/commands/#xdel), [XGROUP](/docs/commands/#xgroup), [XINFO](/docs/commands/#xinfo), [XLEN](/docs/commands/#xlen), [XPENDING](/docs/commands/#xpending), [XRANGE](/docs/commands/#xrange), [XREAD](/docs/commands/#xread), [XREADGROUP](/docs/commands/#xreadgroup), [XREVRANGE](/docs/commands/#xrevrange), [XTRIM](/docs/commands/#xtrim)

`XTRIM` trims the stream to a given number of items, evicting older items
(items with lower IDs) if needed. The command is conceived to accept multiple
trimming strategies, however currently only a single one is implemented,
which is `MAXLEN`, and works exactly as the `MAXLEN` option in `XADD`.

For example the following command will trim the stream to exactly
the latest 1000 items:

```
XTRIM mystream MAXLEN 1000
```

It is possible to give the command in the following special form in
order to make it more efficient:

```
XTRIM mystream MAXLEN ~ 1000
```

The `~` argument between the **MAXLEN** option and the actual count means that
the user is not really requesting that the stream length is exactly 1000 items,
but instead it could be a few tens of entries more, but never less than 1000
items. When this option modifier is used, the trimming is performed only when
KeyDB is able to remove a whole macro node. This makes it much more efficient,
and it is usually what you want.

#### Return:

Integer Reply, specifically:

The command returns the number of entries deleted from the stream.

```cli
XADD mystream * field1 A field2 B field3 C field4 D
XTRIM mystream MAXLEN 2
XRANGE mystream - +
```

---




## ZADD

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

Adds all the specified members with the specified scores to the sorted set
stored at `key`.
It is possible to specify multiple score / member pairs.
If a specified member is already a member of the sorted set, the score is
updated and the element reinserted at the right position to ensure the correct
ordering.

If `key` does not exist, a new sorted set with the specified members as sole
members is created, like if the sorted set was empty. If the key exists but does not hold a sorted set, an error is returned.

The score values should be the string representation of a double precision floating point number. `+inf` and `-inf` values are valid values as well.

#### ZADD options (KeyDB 3.0.2 or greater)


ZADD supports a list of options, specified after the name of the key and before
the first score argument. Options are:

* **XX**: Only update elements that already exist. Never add elements.
* **NX**: Don't update already existing elements. Always add new elements.
* **CH**: Modify the return value from the number of new elements added, to the total number of elements changed (CH is an abbreviation of *changed*). Changed elements are **new elements added** and elements already existing for which **the score was updated**. So elements specified in the command line having the same score as they had in the past are not counted. Note: normally the return value of `ZADD` only counts the number of new elements added.
* **INCR**: When this option is specified `ZADD` acts like `ZINCRBY`. Only one score-element pair can be specified in this mode.

#### Range of integer scores that can be expressed precisely


KeyDB sorted sets use a *double 64-bit floating point number* to represent the score. In all the architectures we support, this is represented as an **IEEE 754 floating point number**, that is able to represent precisely integer numbers between `-(2^53)` and `+(2^53)` included. In more practical terms, all the integers between -9007199254740992 and 9007199254740992 are perfectly representable. Larger integers, or fractions, are internally represented in exponential form, so it is possible that you get only an approximation of the decimal number, or of the very big integer, that you set as score.

#### Sorted sets 101


Sorted sets are sorted by their score in an ascending way.
The same element only exists a single time, no repeated elements are
permitted. The score can be modified both by `ZADD` that will update the
element score, and as a side effect, its position on the sorted set, and
by `ZINCRBY` that can be used in order to update the score relatively to its
previous value.

The current score of an element can be retrieved using the `ZSCORE` command,
that can also be used to verify if an element already exists or not.

For an introduction to sorted sets, see the data types page on [sorted
sets](/docs/commands/#zadd)

#### Elements with the same score


While the same element can't be repeated in a sorted set since every element
is unique, it is possible to add multiple different elements *having the same score*. When multiple elements have the same score, they are *ordered lexicographically* (they are still ordered by score as a first key, however, locally, all the elements with the same score are relatively ordered lexicographically).

The lexicographic ordering used is binary, it compares strings as array of bytes.

If the user inserts all the elements in a sorted set with the same score (for example 0), all the elements of the sorted set are sorted lexicographically, and range queries on elements are possible using the command `ZRANGEBYLEX` (Note: it is also possible to query sorted sets by range of scores using `ZRANGEBYSCORE`).

#### Return:

Integer Reply, specifically:

* The number of elements added to the sorted sets, not including elements
  already existing for which the score was updated.

If the `INCR` option is specified, the return value will be Bulk String Reply:

* the new score of `member` (a double precision floating point number), represented as string.


#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 1 "uno"
(integer) 1
keydb-cli> ZADD myzset 2 "two" 3 "three"
(integer) 2
keydb-cli> ZRANGE myzset 0 -1 WITHSCORES
1) "one"
2) "1"
3) "uno"
4) "1"
5) "two"
6) "2"
7) "three"
8) "3"
```

---




## ZCARD

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

Returns the sorted set cardinality (number of elements) of the sorted set stored
at `key`.

#### Return:

Integer Reply: the cardinality (number of elements) of the sorted set, or `0`
if `key` does not exist.

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZCARD myzset
(integer) 2
```
---





## ZCOUNT

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

Returns the number of elements in the sorted set at `key` with a score between
`min` and `max`.

The `min` and `max` arguments have the same semantic as described for
`ZRANGEBYSCORE`.

Note: the command has a complexity of just O(log(N)) because it uses elements ranks (see `ZRANK`) to get an idea of the range. Because of this there is no need to do a work proportional to the size of the range.

#### Return:

Integer Reply: the number of elements in the specified score range.

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZCOUNT myzset -inf +inf
(integer) 3
keydb-cli> ZCOUNT myzset (1 3
(integer) 2
```

---




## ZINCRBY

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

Increments the score of `member` in the sorted set stored at `key` by
`increment`.
If `member` does not exist in the sorted set, it is added with `increment` as
its score (as if its previous score was `0.0`).
If `key` does not exist, a new sorted set with the specified `member` as its
sole member is created.

An error is returned when `key` exists but does not hold a sorted set.

The `score` value should be the string representation of a numeric value, and
accepts double precision floating point numbers.
It is possible to provide a negative value to decrement the score.

#### Return:

Bulk String Reply: the new score of `member` (a double precision floating point
number), represented as string.

#### Examples:

```
127.0.0.1:6379> ZADD myzset 1 "one"
(integer) 1
127.0.0.1:6379> ZADD myzset 2 "two"
(integer) 1
127.0.0.1:6379> ZINCRBY myzset 2 "one"
"3"
127.0.0.1:6379> ZRANGE myzset 0 -1 WITHSCORES
1) "two"
2) "2"
3) "one"
4) "3"
```

---





## ZINTERSTORE

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax:

```ZINTERSTORE <destination> <numkeys> <key-of-zset1> ... [key-of-zsetn]```

```ZINTERSTORE <destination> <numkeys> <key-of-zset1> ... [key-of-zsetn] WEIGHTS <weight-1> ... <weight-numkeys> ```

Computes the intersection of `numkeys` sorted sets given by the specified keys,
and stores the result in `destination`.
It is mandatory to provide the number of input keys (`numkeys`) before passing
the input keys and the other (optional) arguments.

By default, the resulting score of an element is the sum of its scores in the
sorted sets where it exists.
Because intersection requires an element to be a member of every given sorted
set, this results in the score of every element in the resulting sorted set to
be equal to the number of input sorted sets.

For a description of the `WEIGHTS` and `AGGREGATE` options, see `ZUNIONSTORE`.



If `destination` already exists, it is overwritten.

#### Return:

Integer Reply: the number of elements in the resulting sorted set at
`destination`.

#### Examples:

```
keydb-cli> ZADD zset1 1 "one"
(integer) 1
keydb-cli> ZADD zset1 2 "two"
(integer) 1
keydb-cli> ZADD zset2 1 "one"
(integer) 1
keydb-cli> ZADD zset2 2 "two"
(integer) 1
keydb-cli> ZADD zset2 3 "three"
(integer) 1
keydb-cli> ZINTERSTORE out 2 zset1 zset2 WEIGHTS 2 3
(integer) 2
keydb-cli> ZRANGE out 0 -1 WITHSCORES
1) "one"
2) "5"
3) "two"
4) "10"
```

"one" : 5 = 1 X 2 + 1 X 3 (sorted set score X weight)

"two" : 10 = 2 X 2 + 2 X 3 (sorted set score X weight)

---





## ZLEXCOUNT

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax : 

```ZLEXCOUNT <key> <min> <max>```


When all the elements in a sorted set are inserted with the same score, in order to force lexicographical ordering, this command returns the number of elements in the sorted set at `key` with a value between `min` and `max`.

The `min` and `max` arguments have the same meaning as described for
`ZRANGEBYLEX`.

Note: the command has a complexity of just O(log(N)) because it uses elements ranks (see `ZRANK`) to get an idea of the range. Because of this there is no need to do a work proportional to the size of the range.

#### Return:

Integer Reply: the number of elements in the specified score range.

#### Examples:

```
keydb-cli> ZADD myzset 0 a 0 b 0 c 0 d 0 e
(integer) 5
keydb-cli> ZADD myzset 0 f 0 g
(integer) 2
keydb-cli> ZLEXCOUNT myzset - +
(integer) 7
keydb-cli> ZLEXCOUNT myzset [b [f
(integer) 5
```

---





## ZPOPMAX

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

Removes and returns up to `count` members with the highest scores in the sorted
set stored at `key`.

When left unspecified, the default value for `count` is 1. Specifying a `count`
value that is higher than the sorted set's cardinality will not produce an
error. When returning multiple elements, the one with the highest score will
be the first, followed by the elements with lower scores.

#### Return:

Array Reply: list of popped elements and scores.

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZPOPMAX myzset
1) "three"
2) "3"
```

----





## ZPOPMIN

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

Removes and returns up to `count` members with the lowest scores in the sorted
set stored at `key`.

When left unspecified, the default value for `count` is 1. Specifying a `count`
value that is higher than the sorted set's cardinality will not produce an
error. When returning multiple elements, the one with the lowest score will
be the first, followed by the elements with greater scores.

#### Return:

Array Reply: list of popped elements and scores.

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZPOPMIN myzset
1) "one"
2) "1"
```
---




## ZRANGE

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

Returns the specified range of elements in the sorted set stored at `key`.
The elements are considered to be ordered from the lowest to the highest score.
Lexicographical order is used for elements with equal score.

See `ZREVRANGE` when you need the elements ordered from highest to lowest score
(and descending lexicographical order for elements with equal score).

Both `start` and `stop` are zero-based indexes, where `0` is the first element,
`1` is the next element and so on.
They can also be negative numbers indicating offsets from the end of the sorted
set, with `-1` being the last element of the sorted set, `-2` the penultimate
element and so on.

`start` and `stop` are **inclusive ranges**, so for example `ZRANGE myzset 0 1`
will return both the first and the second element of the sorted set.

Out of range indexes will not produce an error.
If `start` is larger than the largest index in the sorted set, or `start >
stop`, an empty list is returned.
If `stop` is larger than the end of the sorted set KeyDB will treat it like it
is the last element of the sorted set.

It is possible to pass the `WITHSCORES` option in order to return the scores of
the elements together with the elements.
The returned list will contain `value1,score1,...,valueN,scoreN` instead of
`value1,...,valueN`.
Client libraries are free to return a more appropriate data type (suggestion: an
array with (value, score) arrays/tuples).

#### Return:

Array Reply: list of elements in the specified range (optionally with
their scores, in case the `WITHSCORES` option is given).

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZRANGE myzset 0 -1
1) "one"
2) "two"
3) "three"
keydb-cli> ZRANGE myzset 2 3
1) "three"
keydb-cli> ZRANGE myzset -2 -1
1) "two"
2) "three"
```

The following example using `WITHSCORES` shows how the command returns always an array, but this time, populated with *element_1*, *score_1*, *element_2*, *score_2*, ..., *element_N*, *score_N*.

```
keydb-cli> ZRANGE myzset 0 1 withscores
1) "one"
2) "1"
3) "two"
4) "2"
```

---






## ZRANGEBYLEX

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

When all the elements in a sorted set are inserted with the same score, in order to force lexicographical ordering, this command returns all the elements in the sorted set at `key` with a value between `min` and `max`.

If the elements in the sorted set have different scores, the returned elements are unspecified.

The elements are considered to be ordered from lower to higher strings as compared byte-by-byte using the `memcmp()` C function. Longer strings are considered greater than shorter strings if the common part is identical.

The optional `LIMIT` argument can be used to only get a range of the matching
elements (similar to _SELECT LIMIT offset, count_ in SQL). A negative `count`
returns all elements from the `offset`.
Keep in mind that if `offset` is large, the sorted set needs to be traversed for
`offset` elements before getting to the elements to return, which can add up to
O(N) time complexity.

#### How to specify intervals

Valid *start* and *stop* must start with `(` or `[`, in order to specify
if the range item is respectively exclusive or inclusive.
The special values of `+` or `-` for *start* and *stop* have the special
meaning or positively infinite and negatively infinite strings, so for
instance the command **ZRANGEBYLEX myzset - +** is guaranteed to return
all the elements in the sorted set, if all the elements have the same
score.

#### Details on strings comparison

Strings are compared as binary array of bytes. Because of how the ASCII character
set is specified, this means that usually this also have the effect of comparing
normal ASCII characters in an obvious dictionary way. However this is not true
if non plain ASCII strings are used (for example utf8 strings).

However the user can apply a transformation to the encoded string so that
the first part of the element inserted in the sorted set will compare as the
user requires for the specific application. For example if I want to
add strings that will be compared in a case-insensitive way, but I still
want to retrieve the real case when querying, I can add strings in the
following way:

    ZADD autocomplete 0 foo:Foo 0 bar:BAR 0 zap:zap

Because of the first *normalized* part in every element (before the colon character), we are forcing a given comparison, however after the range is queries using `ZRANGEBYLEX` the application can display to the user the second part of the string, after the colon.

The binary nature of the comparison allows to use sorted sets as a general
purpose index, for example the first part of the element can be a 64 bit
big endian number: since big endian numbers have the most significant bytes
in the initial positions, the binary comparison will match the numerical
comparison of the numbers. This can be used in order to implement range
queries on 64 bit values. As in the example below, after the first 8 bytes
we can store the value of the element we are actually indexing.

#### Return:

Array Reply: list of elements in the specified score range.

#### Examples:

```
keydb-cli> ZADD myzset 0 a 0 b 0 c 0 d 0 e 0 f 0 g
(integer) 7
keydb-cli> ZRANGEBYLEX myzset - [c
1) "a"
2) "b"
3) "c"
keydb-cli> ZRANGEBYLEX myzset - (c
1) "a"
2) "b"
keydb-cli> ZRANGEBYLEX myzset [aaa (g
1) "b"
2) "c"
3) "d"
4) "e"
5) "f"
```

---




## ZRANGEBYSCORE

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

Returns all the elements in the sorted set at `key` with a score between `min`
and `max` (including elements with score equal to `min` or `max`).
The elements are considered to be ordered from low to high scores.

The elements having the same score are returned in lexicographical order (this
follows from a property of the sorted set implementation in KeyDB and does not
involve further computation).

The optional `LIMIT` argument can be used to only get a range of the matching
elements (similar to _SELECT LIMIT offset, count_ in SQL). A negative `count`
returns all elements from the `offset`.
Keep in mind that if `offset` is large, the sorted set needs to be traversed for
`offset` elements before getting to the elements to return, which can add up to
O(N) time complexity.

The optional `WITHSCORES` argument makes the command return both the element and
its score, instead of the element alone.
This option is available since KeyDB 2.0.

#### Exclusive intervals and infinity

`min` and `max` can be `-inf` and `+inf`, so that you are not required to know
the highest or lowest score in the sorted set to get all elements from or up to
a certain score.

By default, the interval specified by `min` and `max` is closed (inclusive).
It is possible to specify an open interval (exclusive) by prefixing the score
with the character `(`.
For example:

```
ZRANGEBYSCORE zset (1 5
```

Will return all elements with `1 < score <= 5` while:

```
ZRANGEBYSCORE zset (5 (10
```

Will return all the elements with `5 < score < 10` (5 and 10 excluded).

#### Return:

Array Reply: list of elements in the specified score range (optionally
with their scores).

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZRANGEBYSCORE myzset -inf +inf
1) "one"
2) "two"
3) "three"
keydb-cli> ZRANGEBYSCORE myzset 1 2
1) "one"
2) "two"
keydb-cli> ZRANGEBYSCORE myzset (1 2
1) "two"
keydb-cli> ZRANGEBYSCORE myzset (1 (2
(empty array)
```

#### Pattern: weighted random selection of an element

Normally `ZRANGEBYSCORE` is simply used in order to get range of items
where the score is the indexed integer key, however it is possible to do less
obvious things with the command.

For example a common problem when implementing Markov chains and other algorithms
is to select an element at random from a set, but different elements may have
different weights that change how likely it is they are picked.

This is how we use this command in order to mount such an algorithm:

Imagine you have elements A, B and C with weights 1, 2 and 3.
You compute the sum of the weights, which is 1+2+3 = 6

At this point you add all the elements into a sorted set using this algorithm:

```
SUM = ELEMENTS.TOTAL_WEIGHT // 6 in this case.
SCORE = 0
FOREACH ELE in ELEMENTS
    SCORE += ELE.weight / SUM
    ZADD KEY SCORE ELE
END
```

This means that you set:

```
A to score 0.16
B to score .5
C to score 1
```

Since this involves approximations, in order to avoid C is set to,
like, 0.998 instead of 1, we just modify the above algorithm to make sure
the last score is 1 (left as an exercise for the reader...).

At this point, each time you want to get a weighted random element,
just compute a random number between 0 and 1 (which is like calling
`rand()` in most languages), so you can just do:

    RANDOM_ELE = ZRANGEBYSCORE key RAND() +inf LIMIT 0 1

---




## ZRANK

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

Returns the rank of `member` in the sorted set stored at `key`, with the scores
ordered from low to high.
The rank (or index) is 0-based, which means that the member with the lowest
score has rank `0`.

Use `ZREVRANK` to get the rank of an element with the scores ordered from high
to low.

#### Return:

* If `member` exists in the sorted set, Integer Reply: the rank of `member`.
* If `member` does not exist in the sorted set or `key` does not exist,
  Bulk String Reply: `nil`.

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZRANK myzset "three"
(integer) 2
keydb-cli> ZRANK myzset "four"
(nil)
```
---





## ZREM

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax

```ZREM <key> <member-1> ... <member-n>```

Removes the specified members from the sorted set stored at `key`.
Non existing members are ignored.

An error is returned when `key` exists and does not hold a sorted set.

#### Return:

Integer Reply, specifically:

* The number of members removed from the sorted set, not including non existing
  members.


#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZREM myzset "two"
(integer) 1
keydb-cli> ZRANGE myzset 0 -1 WITHSCORES
1) "one"
2) "1"
3) "three"
4) "3"
```

---






## ZREMRANGEBYLEX

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax

```ZREMRANGEBYLEX <key> <min> <max>```

When all the elements in a sorted set are inserted with the same score, in order to force lexicographical ordering, this command removes all elements in the sorted set stored at `key` between the lexicographical range specified by `min` and `max`.

The meaning of `min` and `max` are the same of the `ZRANGEBYLEX` command. Similarly, this command actually returns the same elements that `ZRANGEBYLEX` would return if called with the same `min` and `max` arguments.

#### Return:

Integer Reply: the number of elements removed.

#### Examples:

```
keydb-cli> ZADD myzset 0 aaaa 0 b 0 c 0 d 0 e
(integer) 5
keydb-cli> ZADD myzset 0 foo 0 zap 0 zip 0 ALPHA 0 alpha
(integer) 5
keydb-cli> ZRANGE myzset 0 -1
 1) "ALPHA"
 2) "aaaa"
 3) "alpha"
 4) "b"
 5) "c"
 6) "d"
 7) "e"
 8) "foo"
 9) "zap"
10) "zip"
keydb-cli> ZREMRANGEBYLEX myzset [alpha [omega
(integer) 6
keydb-cli> ZRANGE myzset 0 -1
1) "ALPHA"
2) "aaaa"
3) "zap"
4) "zip"
```
---





## ZREMRANGEBYRANK

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax:

```ZREMRANGEBYRANK <key> <start> <stop>```

Removes all elements in the sorted set stored at `key` with rank between `start`
and `stop`.
Both `start` and `stop` are `0` -based indexes with `0` being the element with
the lowest score.
These indexes can be negative numbers, where they indicate offsets starting at
the element with the highest score.
For example: `-1` is the element with the highest score, `-2` the element with
the second highest score and so forth.

#### Return:

Integer Reply: the number of elements removed.

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZREMRANGEBYRANK myzset 0 1
(integer) 2
keydb-cli> ZRANGE myzset 0 -1 WITHSCORES
1) "three"
2) "3"
```
---



## ZREMRANGEBYSCORE

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax:

```ZEMRANGEBYSCORE <key> <min> <max>```

Removes all elements in the sorted set stored at `key` with a score between
`min` and `max` (inclusive).

Since version 2.1.6, `min` and `max` can be exclusive, following the syntax of
`ZRANGEBYSCORE`.

#### Return:

Integer Reply: the number of elements removed.

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZREMRANGEBYSCORE myzset -inf (2
(integer) 1
keydb-cli> ZRANGE myzset 0 -1 WITHSCORES
1) "two"
2) "2"
3) "three"
4) "3"
```
---





## ZREVRANGE

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax: 

```ZREVRANGE <key> <start> <stop>```

Returns the specified range of elements in the sorted set stored at `key`.
The elements are considered to be ordered from the highest to the lowest score.
Descending lexicographical order is used for elements with equal score.

Apart from the reversed ordering, `ZREVRANGE` is similar to `ZRANGE`.

#### Return:

Array Reply: list of elements in the specified range (optionally with
their scores).

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZREVRANGE myzset 0 -1
1) "three"
2) "two"
3) "one"
keydb-cli> ZREVRANGE myzset 2 3
1) "one"
keydb-cli> ZREVRANGE myzset -2 -1
1) "two"
2) "one"
```
---





## ZREVRANGEBYLEX

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax:

```ZREVRANGEBYLEX <key> <max> <min>```

When all the elements in a sorted set are inserted with the same score, in order to force lexicographical ordering, this command returns all the elements in the sorted set at `key` with a value between `max` and `min`.

Apart from the reversed ordering, `ZREVRANGEBYLEX` is similar to `ZRANGEBYLEX`.

#### Return:

Array Reply: list of elements in the specified score range.

#### Examples:

```
keydb-cli> ZADD myzset 0 a 0 b 0 c 0 d 0 e 0 f 0 g
(integer) 7
keydb-cli> ZREVRANGEBYLEX myzset [c -
1) "c"
2) "b"
3) "a"
keydb-cli> ZREVRANGEBYLEX myzset (c -
1) "b"
2) "a"
keydb-cli> ZREVRANGEBYLEX myzset (g [aaa
1) "f"
2) "e"
3) "d"
4) "c"
5) "b"
```
---




## ZREVRANGEBYSCORE

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax: 

```ZREVRANGEBYSCORE <key> <max> <min>```

Returns all the elements in the sorted set at `key` with a score between `max`
and `min` (including elements with score equal to `max` or `min`).
In contrary to the default ordering of sorted sets, for this command the
elements are considered to be ordered from high to low scores.

The elements having the same score are returned in reverse lexicographical
order.

Apart from the reversed ordering, `ZREVRANGEBYSCORE` is similar to
`ZRANGEBYSCORE`.

#### Return:

Array Reply: list of elements in the specified score range (optionally
with their scores).

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZREVRANGEBYSCORE myzset +inf -inf
1) "three"
2) "two"
3) "one"
keydb-cli> ZREVRANGEBYSCORE myzset 2 1
1) "two"
2) "one"
keydb-cli> ZREVRANGEBYSCORE myzset 2 (1
1) "two"
keydb-cli> ZREVRANGEBYSCORE myzset (2 (1
(empty array)
```
---






## ZREVRANK

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax :

```ZREVRANK <key> <member>``` 

Returns the rank of `member` in the sorted set stored at `key`, with the scores
ordered from high to low.
The rank (or index) is 0-based, which means that the member with the highest
score has rank `0`.

Use `ZRANK` to get the rank of an element with the scores ordered from low to
high.

#### Return:

* If `member` exists in the sorted set, Integer Reply: the rank of `member`.
* If `member` does not exist in the sorted set or `key` does not exist,
  Bulk String Reply: `nil`.

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZADD myzset 2 "two"
(integer) 1
keydb-cli> ZADD myzset 3 "three"
(integer) 1
keydb-cli> ZREVRANK myzset "one"
(integer) 2
keydb-cli> ZREVRANK myzset "four"
(nil)
```
---





## ZSCAN

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

See `SCAN` for `ZSCAN` documentation.

---




## ZSCORE

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax:

```ZSCORE <key> <member>```

#### Description:

Returns the score of `member` in the sorted set at `key`.

If `member` does not exist in the sorted set, or `key` does not exist, `nil` is
returned.

#### Return:

Bulk String Reply: the score of `member` (a double precision floating point number),
represented as string.

#### Examples:

```
keydb-cli> ZADD myzset 1 "one"
(integer) 1
keydb-cli> ZSCORE myzset "one"
"1"
```
---




## ZUNIONSTORE

**Related Commands:** [BZPOPMAX](/docs/commands/#bzpopmax), [BZPOPMIN](/docs/commands/#bzpopmin), [ZADD](/docs/commands/#zadd), [ZCARD](/docs/commands/#zcard), [ZCOUNT](/docs/commands/#zcount), [ZINCRBY](/docs/commands/#zincrby), [ZINTERSTORE](/docs/commands/#zinterstore), [ZLEXCOUNT](/docs/commands/#zlexcount), [ZPOPMAX](/docs/commands/#zpopmax), [ZPOPMIN](/docs/commands/#zpopmin), [ZRANGE](/docs/commands/#zrange), [ZRANGEBYLEX](/docs/commands/#zrangebylex), [ZRANGEBYSCORE](/docs/commands/#zrangebyscore), [ZRANK](/docs/commands/#zrank), [ZREM](/docs/commands/#zrem), [ZREMRANGEBYLEX](/docs/commands/#zremrangebylex), [ZREMRANGEBYRANK](/docs/commands/#zremrangebyrank), [ZREMRANGEBYSCORE](/docs/commands/#zremrangebyscore), [ZREVRANGE](/docs/commands/#zrevrange), [ZREVRANGEBYLEX](/docs/commands/#zrevrangebylex), [ZREVRANGEBYSCORE](/docs/commands/#zrevrangebyscore), [ZREVRANK](/docs/commands/#zrevrank), [ZSCAN](/docs/commands/#zscan), [ZSCORE](/docs/commands/#zscore), [ZUNIONSTORE](/docs/commands/#zunionstore)

#### Syntax: 

```ZUNIONSTORE <destination> <numkeys> <key-of-zset1> ... <key-of-zsetn>```

```ZUNIONSTORE <destination> <numkeys> <key-of-zset1> ... <key-of-zsetn> WEIGHTS <weight-1> ... <weight-numkeys>```

#### Description: 

Computes the union of `numkeys` sorted sets given by the specified keys, and
stores the result in `destination`.
It is mandatory to provide the number of input keys (`numkeys`) before passing
the input keys and the other (optional) arguments.

By default, the resulting score of an element is the sum of its scores in the
sorted sets where it exists.

Using the `WEIGHTS` option, it is possible to specify a multiplication factor
for each input sorted set.
This means that the score of every element in every input sorted set is
multiplied by this factor before being passed to the aggregation function.
When `WEIGHTS` is not given, the multiplication factors default to `1`.

With the `AGGREGATE` option, it is possible to specify how the results of the
union are aggregated.
This option defaults to `SUM`, where the score of an element is summed across
the inputs where it exists.
When this option is set to either `MIN` or `MAX`, the resulting set will contain
the minimum or maximum score of an element across the inputs where it exists.

If `destination` already exists, it is overwritten.

#### Return:

Integer Reply: the number of elements in the resulting sorted set at
`destination`.

#### Examples:

```
keydb-cli> ZADD zset1 1 "one"
(integer) 1
keydb-cli> ZADD zset1 2 "two"
(integer) 1
keydb-cli> ZADD zset2 1 "one"
(integer) 1
keydb-cli> ZADD zset2 2 "two"
(integer) 1
keydb-cli> ZADD zset2 3 "three"
(integer) 1
keydb-cli> ZUNIONSTORE out 2 zset1 zset2 WEIGHTS 2 3
(integer) 3
keydb-cli> ZRANGE out 0 -1 WITHSCORES
1) "one"
2) "5"
3) "three"
4) "9"
5) "two"
6) "10"
```

"one" : 5 = 1 X 2 + 1 X 3 (sorted set score X weight)

"three" : 9 = 3 X 3 (sorted set score X weight)

"two" : 10 = 2 X 2 + 2 X 3 (sorted set score X weight)



