---
id: benchmarking
title: Putting KeyDB to the Test!
sidebar_label: How To Benchmark
---

## Use Memtier

KeyDB is multithreaded on several levels and seeing the differences becomes apparent when using a multithreaded benchmarking tool. When you use memtier the differences between Redis and KeyDB's performance starts to become very apparent.


## Install Memtier

You can visit [memtiers github rep](https://github.com/RedisLabs/memtier_benchmark) or follow these quick steps to get up and running on typical Ubuntu/Debian:
```
apt-get install build-essential autoconf automake libpcre3-dev libevent-dev pkg-config zlib1g-dev
git clone https://github.com/RedisLabs/memtier_benchmark.git
cd memtier_benchmark
autoreconf -ivf
./configure
make
make install
```

## Using Memtier

Specify # of threads when you run keydb-server with "server-threads" `keydb-server --server-threads 4`
You can also specify memtiers threads (default=4) `--threads=NUMBER`. Ensure your benchmarking setup (keydb threads + memtier threads) is reflective of your hardware. 

Use `memtier_benchmark --help` to see options for your testing such as pipelining, data size, etc. for example `memtier_benchmark  -s 172.31.38.149 -p 6379 --hide-histogram --requests=20000 --clients=100 --pipeline=20 --data-size=128`

Memtier has a lot of options you can configure to hopefully predict what your application might experience at high loads. If you are comparing with Redis, make sure you use the same machines, and same benchmark setup. 

## Quick Test

This is to get you started for connecting. Once you're able to run it, start tuning settings. Ideally you run memtier on a different machine to go through NICs and see more realistic behavior. Below case running through loopback adapter after programs installed:

```
keydb-server --daemonize yes --requirepass mypassword123 --port 6379
memtier_benchmark -s 127.0.0.1 -p 6379 --authenticate=mypassword123
```

## Feedback

If you have questions regarding testing, or if you would like to share your results, we would be happy to hear from you. Please reach out to support@eqalpha.com
