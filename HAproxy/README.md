### Examples of using HAproxy with KeyBD

for reference here is a [link to HAproxy v1.8 configuration manual](https://cbonte.github.io/haproxy-dconv/1.8/configuration.html#2)

HAproxy can be used as reverse proxy load balancer. The latest version has seamless reloads for when you are updating HAproxy with new or altered configs and will not effect your connections.




See example for a traditional master slave setup which will write to the masters in round robin balance. No balance if only one master and one or 2 slaves..

If using active replica we will have 2 masters replicated to eachother, and we need to decide what the ideal way is for them to behave. You may want a roundrobin balance, however depending on sync speed, etc it might make more sense to go with 'first' for balence so we read/write to one until it hits its maxconn, then start writing to the other. The beauty is that we can take full advantage of both instances instead of writing to master and maybe reading from slave on high traffic. Being able to read and write to both as needed is highly beneficial while maintaining redundancy. On a faliure you can reboot your instance quickly. 



option 1: balance first
option 2:	server          redis1 192.168.70.91:6379        inter 1000  maxconn 1024 check
	   	server          redis2 192.168.70.92:6379 backup inter 1000  maxconn 1024 check
	where 'backup' specifies server wont be considered for load balancing as long as any normal server is 'up'
option 3: balance roundrobin


keepalived 
