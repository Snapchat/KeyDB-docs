# KeyDB Dockerfile for ARM
#
#
# Pull base image.
FROM raspbian/stretch:latest

RUN mkdir /etc/keydb

# Copy redis.conf and binaries to container
ADD ./app/keydb* /usr/bin/
ADD ./app/redis.conf /etc/keydb/

# edit config file for use in container
RUN \
	sed -i 's/^\(bind .*\)$/# \1/' /etc/keydb/redis.conf && \
	sed -i 's/^\(daemonize .*\)$/# \1/' /etc/keydb/redis.conf && \
	sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/keydb/redis.conf && \
	sed -i 's/^\(logfile .*\)$/# \1/' /etc/keydb/redis.conf && \
	sed -i 's/protected-mode yes/protected-mode no/g' /etc/keydb/redis.conf

VOLUME ["/data"]
WORKDIR /data

EXPOSE 6379

CMD ["keydb-server", "/etc/keydb/redis.conf"]
