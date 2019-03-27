# KeyDB Fresh Build
# 
# This Dcoker image will be used to generate the latest binaries from github
#
# Useage: docker run -it --rm -v /path-to-dump-binaries:/keydb_bin eqalpha/keydb-build-bin
#
# pull the base image
FROM ubuntu:18.04
# setup up container with dependencies for build
RUN apt-get update -y && \
 DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
 build-essential apt-utils nasm autotools-dev autoconf libjemalloc-dev tcl tcl-dev uuid-dev git -y && \
 apt-get clean && \
 mkdir /keydb_bin
# upon launch we will build the 
CMD ["sh","-c", "cd /tmp && git clone https://github.com/JohnSully/KeyDB.git && \
 cd KeyDB  && \
 make && \
 cp ./src/keydb-* /keydb_bin"]
