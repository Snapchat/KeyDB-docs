#
# KeyDB Dockerfile for x86_64
#
# Useage: docker run -it --name mykeydb --mount type=bind,target=/tmp/keydbflash,source=/path-to-my-btrfs-volume/ eqalpha/keydb:flash
#
# Pull base image.
FROM ubuntu:18.04

# Load binaries to image. Much smaller size than building.
ADD ./app/* /usr/local/bin/

RUN \
  apt-get update && \
  apt-get install -y libnuma-dev libtool && \
  cd /usr/local/bin && \
  mkdir -p /etc/keydb && \
  mkdir /tmp/keydbflash && \
  mv -f *.conf /etc/keydb && \
# update config file for use in container
  sed -i 's/^\(bind .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/keydb/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/keydb/redis.conf && \
  sed -i 's/protected-mode yes/protected-mode no/g' /etc/keydb/redis.conf && \
  sed -i '/scratch-file-path/a \scratch-file-path /tmp/keydbflash' /etc/keydb/redis.conf

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["keydb-server", "/etc/keydb/redis.conf"]

# Expose ports.
EXPOSE 6379

