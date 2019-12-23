---
id: first-test
title: If you have Never Used Redis or KeyDB...
sidebar_label: Your First Command
---

If you have never used Redis or KeyDB before but want to play around with some commands, install KeyDB then run the server.

Below line asks to run the server with the default config file loaded. the '--' modifies the configuration parameters. Here for testing we disable protected mode (not recommended especially if port is exposed -- ideally you secure this instance). Since we will run client on same node using loopback for our test we will keep simple. We also damonize so it will run in the background if you dont have multipke command prompt windows open.
```
keydb-server --protected-mode no --daemonize yes
```

Now connect with the client:
```
keydb-cli -p 6379
```

You can now start sending commands such as set, get, etc... A full list of commands can be seen in the commands section.

To properly set up it is recommended you look through the config file shown next to see options pertaining to a customized secure setup.


A bit more detail...
===

Reading below will help you:

* Use **keydb-cli** to access the server.
* Use KeyDB from your application.
* Understand how KeyDB persistence works.
* Install KeyDB properly.
* Find out what to read next to understand more about KeyDB.

After you have built your project, you can test if your build works correctly by typing **make test**, but this is an optional step. After the compilation the **src** directory inside the KeyDB distribution is populated with the different executables that are part of KeyDB:

* **keydb-server** is the KeyDB Server itself.
* **keydb-sentinel** is the KeyDB Sentinel executable (monitoring and failover).
* **keydb-cli** is the command line interface utility to talk with KeyDB.
* **keydb-benchmark** is used to check KeyDB performances.
* **keydb-check-aof** and **keydb-check-dump** are useful in the rare event of corrupted data files.

It is a good idea to copy both the KeyDB server and the command line interface in proper places, either manually using the following commands:

* sudo cp src/keydb-server /usr/local/bin/
* sudo cp src/keydb-cli /usr/local/bin/

Or just using `sudo make install`.

In the following documentation we assume that /usr/local/bin is in your PATH environment variable so that you can execute both the binaries without specifying the full path.

Starting KeyDB
===

The simplest way to start the KeyDB server is just executing the **keydb-server** binary without any argument.

    $ keydb-server
    [28550] 01 Aug 19:29:28 # Warning: no config file specified, using the default config. In order to specify a config file use 'keydb-server /path/to/redis.conf'
    [28550] 01 Aug 19:29:28 * Server started, KeyDB version 2.2.12
    [28550] 01 Aug 19:29:28 * The server is now ready to accept connections on port 6379
    ... more logs ...

In the above example KeyDB was started without any explicit configuration file, so all the parameters will use the internal default.
This is perfectly fine if you are starting KeyDB just to play a bit with it or for development, but for production environments you should use a configuration file.

In order to start KeyDB with a configuration file use the full path of the configuration file as first argument, like in the following example: **keydb-server /etc/redis.conf**. You should use the `redis.conf` file included in the root directory of the KeyDB source code distribution as a template to write your configuration file.

Check if KeyDB is working
=========================

External programs talk to KeyDB using a TCP socket and a KeyDB specific protocol. This protocol is implemented in the KeyDB client libraries for the different programming languages. However to make hacking with KeyDB simpler KeyDB provides a command line utility that can be used to send commands to KeyDB. This program is called **keydb-cli**.

The first thing to do in order to check if KeyDB is working properly is sending a **PING** command using keydb-cli:

    $ keydb-cli ping
    PONG

Running **keydb-cli** followed by a command name and its arguments will send this command to the KeyDB instance running on localhost at port 6379. You can change the host and port used by keydb-cli, just try the --help option to check the usage information.

Another interesting way to run keydb-cli is without arguments: the program will start in interactive mode, you can type different commands and see their replies.

    $ keydb-cli                                                                
    KeyDB 127.0.0.1:6379> ping
    PONG
    KeyDB 127.0.0.1:6379> set mykey somevalue
    OK
    KeyDB 127.0.0.1:6379> get mykey
    "somevalue"

At this point you are able to talk with KeyDB. It is the right time to pause a bit with this tutorial and start the fifteen minutes introduction to KeyDB data types in order to learn a few KeyDB commands. Otherwise if you already know a few basic KeyDB commands you can keep reading.

Securing KeyDB
===

By default KeyDB binds to **all the interfaces** and has no authentication at
all. If you use KeyDB into a very controlled environment, separated from the
external internet and in general from attackers, that's fine. However if KeyDB
without any hardening is exposed to the internet, it is a big security
concern. If you are not 100% sure your environment is secured properly, please
check the following steps in order to make KeyDB more secure, which are
enlisted in order of increased security.

1. Make sure the port KeyDB uses to listen for connections (by default 6379 and additionally 16379 if you run KeyDB in cluster mode, plus 26379 for Sentinel) is firewalled, so that it is not possible to contact KeyDB from the outside world.
2. Use a configuration file where the `bind` directive is set in order to guarantee that KeyDB listens just in as little network interfaces you are using. For example only the loopback interface (127.0.0.1) if you are accessing KeyDB just locally from the same computer, and so forth.
3. Use the `requirepass` option in order to add an additional layer of security so that clients will require to authenticate using the `AUTH` command.
4. Use [spiped](http://www.tarsnap.com/spiped.html) or another SSL tunnelling software in order to encrypt traffic between KeyDB servers and KeyDB clients if your environment requires encryption.

Using KeyDB from your application
===

Of course using KeyDB just from the command line interface is not enough as
the goal is to use it from your application. In order to do so you need to
download and install a KeyDB client library for your programming language.
You'll find a [full list of redis clients that will also work for KeyDB for different languages in this page](http://redis.io/clients).

KeyDB persistence
=================

You can learn more in the Commands/Persistence document, however what is important to understand for a quick start is that by default, if you start KeyDB with the default configuration, KeyDB will spontaneously save the dataset only from time to time (for instance after at least five minutes if you have at least 100 changes in your data), so if you want your database to persist and be reloaded after a restart make sure to call the **SAVE** command manually every time you want to force a data set snapshot. Otherwise make sure to shutdown the database using the **SHUTDOWN** command:

    $ keydb-cli shutdown

This way KeyDB will make sure to save the data on disk before quitting.

Installing KeyDB properly
==============================

Running KeyDB from the command line is fine just to hack a bit with it or for
development. However at some point you'll have some actual application to run
on a real server. For this kind of usage you have two different choices:

* Run KeyDB using screen.
* Install KeyDB in your Linux box in a proper way using an init script, so that after a restart everything will start again properly.

A proper install using an init script is strongly suggested.
The following instructions can be used to perform a proper installation using the init script shipped with KeyDB 2.4 in a Debian or Ubuntu based distribution.

We assume you already copied **keydb-server** and **keydb-cli** executables under /usr/local/bin.

* Create a directory where to store your KeyDB config files and your data:

        sudo mkdir /etc/KeyDB
        sudo mkdir /var/KeyDB

* Copy the init script that you'll find in the KeyDB distribution under the **utils** directory into /etc/init.d. We suggest calling it with the name of the port where you are running this instance of KeyDB. For example:

        sudo cp utils/KeyDB_init_script /etc/init.d/KeyDB_6379

* Edit the init script.

        sudo vi /etc/init.d/KeyDB_6379

Make sure to modify **KeyDBPORT** accordingly to the port you are using.
Both the pid file path and the configuration file name depend on the port number.

* Copy the template configuration file you'll find in the root directory of the KeyDB distribution into /etc/KeyDB/ using the port number as name, for instance:

        sudo cp redis.conf /etc/KeyDB/6379.conf

* Create a directory inside /var/KeyDB that will work as data and working directory for this KeyDB instance:

        sudo mkdir /var/KeyDB/6379

* Edit the configuration file, making sure to perform the following changes:
    * Set **daemonize** to yes (by default it is set to no).
    * Set the **pidfile** to `/var/run/KeyDB_6379.pid` (modify the port if needed).
    * Change the **port** accordingly. In our example it is not needed as the default port is already 6379.
    * Set your preferred **loglevel**.
    * Set the **logfile** to `/var/log/KeyDB_6379.log`
    * Set the **dir** to /var/KeyDB/6379 (very important step!)
* Finally add the new KeyDB init script to all the default runlevels using the following command:

        sudo update-rc.d KeyDB_6379 defaults

You are done! Now you can try running your instance with:

    sudo /etc/init.d/KeyDB_6379 start

Make sure that everything is working as expected:

* Try pinging your instance with keydb-cli.
* Do a test save with **keydb-cli save** and check that the dump file is correctly stored into /var/KeyDB/6379/ (you should find a file called dump.rdb).
* Check that your KeyDB instance is correctly logging in the log file.
* If it's a new machine where you can try it without problems make sure that after a reboot everything is still working.

Note: In the above instructions we skipped many KeyDB configuration parameters that you would like to change, for instance in order to use AOF persistence instead of RDB persistence, or to setup replication, and so forth.
Make sure to read the example `redis.conf` file (that is heavily commented) and the other documentation you can find in this web site for more information.

