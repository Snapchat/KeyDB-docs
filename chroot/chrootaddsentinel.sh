#!/bin/bash -x
#
#This script to automatically generate new user in  chroot jail
#Keydb instance  tp be set up and run upon generating user
#
#Useage: chrootadduser.sh  [username] [location of redis.config to be used]
#
adduser --disabled-password --no-create-home --gecos "" $1
usermod -aG vortex_users $1
mkdir /mnt/cache/chrootjail_$1
#chown $1:vortex_users /mnt/cache/chrootjail_$1
chmod 755 /mnt/cache/chrootjail_$1
mkdir -p /mnt/cache/chrootjail_$1/{bin,lib64,lib,var,tmp}
#chown $1:vortex_users /mnt/cache/chrootjail_$1/{bin,lib64,lib,var,tmp}
mkdir /mnt/cache/chrootjail_$1/var/log
mkdir /mnt/cache/chrootjail_$1/var/log/redis
mkdir /mnt/cache/chrootjail_$1/ebsdump
mount --rbind /ebsdump/ebs_$1 /mnt/cache/chrootjail_$1/ebsdump
#chown $1:vortex_users /ebsdump/ebs_$1
touch /mnt/cache/chrootjail_$1/ebsdump/keydbsentinel.log
cp /usr/local/bin/keydb-sentinel /mnt/cache/chrootjail_$1/bin
#wget -O /mnt/cache/chrootjail_$1/bin/keydb-server -P /mnt/cache/chrootjail_$1/bin/ https://download.keydb.dev/keydb-sentinel
chmod 755 /mnt/cache/chrootjail_$1/bin/keydb-sentinel
#chown $1:vortex_users /mnt/cache/chrootjail_$1/bin/keydb-sentinel
cp /usr/lib/x86_64-linux-gnu/libnuma.so.1 /mnt/cache/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/libm.so.6 /mnt/cache/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/libdl.so.2 /mnt/cache/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/librt.so.1 /mnt/cache/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/libpthread.so.0 /mnt/cache/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/libgcc_s.so.1 /mnt/cache/chrootjail_$1/lib
cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /mnt/cache/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/libc.so.6 /mnt/cache/chrootjail_$1/lib
cp /lib64/ld-linux-x86-64.so.2 /mnt/cache/chrootjail_$1/lib64
cp $2 /mnt/cache/chrootjail_$1/bin/sentinel.conf
#chown $1:vortex_users /mnt/cache/chrootjail_$1/bin/sentinel.conf

chown -R $1:vortex_users /mnt/cache/chrootjail_$1

###for bash###
#cp /bin/{bash,ls} /mnt/cache/chrootjail_$1/bin
#cp -v /lib/x86_64-linux-gnu/libtinfo.so.5 /mnt/cache/chrootjail_$1/lib

###for ls###
#cp -v /lib/x86_64-linux-gnu/libselinux.so.1 /mnt/cache/chrootjail_$1/lib
#cp -v /lib/x86_64-linux-gnu/libpcre.so.3 /mnt/cache/chrootjail_$1/lib

./startsentinelchroot.sh $1 &
#chroot --userspec=$1:vortex_users /mnt/cache/chrootjail_$1/ /bin/keydb-server /bin/redis.conf
exit
#nohup
