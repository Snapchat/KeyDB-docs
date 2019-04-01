# Using create-cluster tool

Once you clone the github folder you can navigate to utils/create-cluster. This expects you have compiled the program already and binaries have been built in the src folder. 

You can see the [readme file for this script](https://github.com/JohnSully/KeyDB/tree/unstable/utils/create-cluster), however we will go over a quick setup using this utility

You can create a config.sh script in this folder if you do not want to edit create-cluster.sh. If present it will use this rather than the defaults.

Whether you create you own config file or edit top of create-cluster.sh, the values you will update are:
```
PORT=30000	-->this is the starting port number to use for the cluster, however script may start at +1 so nodes would be 30001-30006 instead of 30000-30005. for purposes of this tutorial user PORT=29999 
TIMEOUT=2000	-->timeout setting
NODES=6		-->the number of nodes in the cluster (port numbers incrementing from PORT setting)
REPLICAS=1	-->number of replicas. here we want one replica created for each master instance
```
if we specify 6 nodes, with one replica per master, we will end up with 3 masters and 3 replicas/slaves for this cluster setup.

to run simply start (launch cluster instances... runs instances of keydb-server with auto-appended config files instead of creating spearate)
and create the cluster (`keydb-cli --cluster create 127.0.0.1:30000 127.0.0.1:30001 127.0.0.1:30002 127.0.0.1:30003 127.0.0.1:30004 127.0.0.1:30005 --cluster-replicas 1`) :
```
./create-cluster start
./create-cluster create
```
you will see there a bunch of cluster nodes and files creted now in this folder.

in order to stop the cluster:
```
./create-cluster stop
```
to clean up files in this folder:
```
./create-cluster clean
```

### Testing the cluster setup

connect with keydb-cli to port 30000 in cluster mode (-c) and try the following:
```
$ redis-cli -c -p 30000
redis 127.0.0.1:30000> set foo bar
-> Redirected to slot [12182] located at 127.0.0.1:30002
OK
redis 127.0.0.1:30002> set hello world
-> Redirected to slot [866] located at 127.0.0.1:30000
OK
redis 127.0.0.1:30000> get foo
-> Redirected to slot [12182] located at 127.0.0.1:30002
"bar"
redis 127.0.0.1:30000> get hello
-> Redirected to slot [866] located at 127.0.0.1:30000
"world"
```
