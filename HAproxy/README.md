# Examples of using HAproxy with KeyBD

for reference here is a [link to HAproxy v1.8 configuration manual](https://cbonte.github.io/haproxy-dconv/1.8/configuration.html#2)

HAproxy can be used as reverse proxy load balancer. The latest version has seamless reloads for when you are updating HAproxy with new or altered configs and will not effect your connections.


See the haproxy.cfg example for a traditional setup which will write to the master instance. With active-replica option where we have 2 masters the setup is similar however you may want to consider choosing balance as 'first' or defining one of the servers as 'backup'.

The HAproxy performs health checks to decide where to direct traffic and maintains high availablilty. If you are looking to keep your load balancers and highly available (redundant), consider using keepalived. You could also write your own heartbeat server to reassociate an aws elastic IP address when a server goes down. Keepalived seems very common though for HAproxy load balancer redundancy.

### Performance 

If you are having performance issues consider increasing maxconn for the servers (backend) as well as in defaults and global sections. If you are still having perfomance issues check your cpu useage during high loads to find the bottleneck. HAproxy can run multiple threads and this may need to be configured.
