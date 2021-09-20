---
id: haproxy
title: HAProxy Configuration with KeyDB
sidebar_label: HAProxy Configuration
---

for reference [here is a link to the HAproxy v1.8 configuration manual](https://cbonte.github.io/haproxy-dconv/1.8/configuration.html)

HAproxy can be used here as a reverse proxy load balancer for high availability. The latest version has seamless reloads for when you are updating HAproxy with new or altered configs and will not effect your connections.

See the haproxy.cfg example for a traditional setup which will write to the master instance. With active-replica option where we have 2 masters the setup is similar however you may want to consider choosing balance as 'first' or defining one of the servers as 'backup'.

HAproxy performs health checks to decide where to direct traffic and maintains high availability. If you are looking to keep your load balancers highly available (redundant), consider using keepalived. You could also write your own heartbeat server to reassociate an aws elastic IP address when a server goes down. Keepalived seems very common though for HAproxy load balancer redundancy.

Performance
If you are having performance issues consider increasing maxconn for the servers (backend) as well as in defaults and global sections. Believe the default is 2000. If you are still having performance issues check your cpu useage during high loads to find the bottleneck. HAproxy can run multiple threads and this may need to be configured.


```
    
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# The lines below enable multithreading. This should correlate to number of threads available you want to use.
	nbproc 1
	nbthread 4
	cpu-map auto:1/1-4 0-3

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	# An alternative list with additional directives can be obtained from
	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3
        maxconn 40000

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http

# Below is a common setup for HAproxy. In this example we are connecting to 2 instances with a shared port for keydb-cli
# Client connects to port 6380 and is redirected to one of the two nodes based on setup and checks.
#
# For active-replica support you will have 2 masters that are replicas of eachother with data syncing. 
# No need for a sentinel node as there is no replica that needs to be promoted to master. 
# HAproxy will check if one instance goes down and write to the other node. This is done with the health checks 
# Default config for balance is roundrobin. If you have preference for which server is primary, you can place the
# word "backup" beside the server ip address. That way HA will send traffic to 'not-backup' instance unless it is unreachable.
# You can also consider adding weights to the end of the server line. Weights are expressed as "weight 50%" combining to 100% or otherwise between 1 and 256 if no % sign
# Choosing "balance first" will use the first connected instance and only start using the second if maxconn is exceeded.
# If you have a password you will have to include it here and set the same for both nodes.

# Note that in a common master-replica setup you will "expect string role:master" to validate you are only sending traffic to the healthy master
# With Active-rep, you will "expect string role: active-replica" as that is the role when in active-rep mode. Understanding this concept of getting data and
# health checking you can probe for other info if needed.

listen mykeydb 
    bind *:6380
    maxconn 40000 
    mode tcp
    balance first
    option tcplog
    option tcp-check
    #uncomment these lines if you have basic auth
    #tcp-check send AUTH\ yourpassword\r\n
    #tcp-check expect string +OK
    tcp-check send PING\r\n
    tcp-check expect string +PONG
    tcp-check send info\ replication\r\n
    tcp-check expect string role: master
    tcp-check send QUIT\r\n
    tcp-check expect string +OK
    server keydb3 172.19.0.3:6379 maxconn 20000 check inter 1s
    server keydb2 172.19.0.2:6379 maxconn 20000 check inter 1s

# Sending PING is one health check to make sure server is active. Retrieving the replication info is to find if the node is
# a master. If not master then don't write to it. This prevents trying to write to a replica instance.
# The QUIT command prevents unwanted logging info every time this is run

# A common master-replica HAproxy setup does not need to include a "balance" option or "backup" as only the master
# will see incoming traffic (through checks). If you have sentinel nodes they will automatically promote the replica to master at which
# time the checks will redirect traffic there.
```
