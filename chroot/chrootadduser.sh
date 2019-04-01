#!/bin/bash -x

#This script to automatically generate new user in  chroot jail

#Useage: chrootadduser.sh  [username] [location of redis.config to be used]

# Note that this example contains several different options you may want to include include. This example sets up in home directory
# but change to wherever you would like to store. In this example we ammend username to "chrootjail", however you can just use your
# username as the directory pending it meets the regex standard.


#add user to own this chrooted environment. This examplpe is to add automatically without password/setup
adduser --disabled-password --no-create-home --gecos "" $1
usermod -aG keydb_users $1

# set up basic directories
mkdir /home/chrootjail_$1
chmod 755 /home/chrootjail_$1
mkdir -p /home/chrootjail_$1/{bin,lib64,lib,var}
mkdir /home/chrootjail_$1/var/log
mkdir /home/chrootjail_$1/var/log/redis

# make some optional directories to use
mkdir /home/chrootjail_$1/scratchfile
mkdir -p /home/chrootjail_$1/var/modules
mkdir /ebsdump/ebs_$1

# make a volume that will not be removed from server machine, possibly cheaper ebs volume where we will save our dump.rdb files and logfiles.
# you do not have to do it this way, especially if your rooted environment is not temporary/depending on your needs
# ensure you update the "dir" location in redis.conf to reflect this.
mkdir /home/chrootjail_$1/ebsdump
mount --rbind /ebsdump/ebs_$1 /home/chrootjail_$1/ebsdump
touch /home/chrootjail_$1/ebsdump/keydbserver.log

# if you want to enable flash storage you can mount the scratchfile directory we made above, to your nvme/SSD volume (btrfs filesystem).
# ensure you uncomment the scratch-file-path in redis.conf and updae it to your rooted path location
mount --rbind /my-flash-brtfs-location/scratchfile_$1 /home/chrootjail_$1/scratchfile

# copy binary to chrooted environment
cp /path-to-binaries-to-be-used/keydb-server /home/chrootjail_$1/bin

# load minimum dependencies required to run keydb-server in chroot
chmod 755 /home/chrootjail_$1/bin/keydb-server
cp /usr/lib/x86_64-linux-gnu/libnuma.so.1 /home/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/libm.so.6 /home/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/libdl.so.2 /home/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/librt.so.1 /home/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/libpthread.so.0 /home/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/libgcc_s.so.1 /home/chrootjail_$1/lib
cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /home/chrootjail_$1/lib
cp /lib/x86_64-linux-gnu/libc.so.6 /home/chrootjail_$1/lib
cp /lib64/ld-linux-x86-64.so.2 /home/chrootjail_$1/lib64

# if you want to include redis modules such as redisearch. Note you must add a line in the redis.conf file to load the redisearch module
cp /path-to-redisearch-module/redisearch.so /home/chrootjail_$1/var/modules

# copy over configuration file
cp $2 /home/chrootjail_$1/bin/redis.conf

# make sure this user owns all folders and processes within envrionment
chown -R $1:keydb_users /home/chrootjail_$1

# Add these dependencies if you want to be able to run bash 
#cp /bin/{bash,ls} /home/chrootjail_$1/bin
#cp -v /lib/x86_64-linux-gnu/libtinfo.so.5 /home/chrootjail_$1/lib

# Add these dependencies if you want to be able to use the ls command 
#cp -v /lib/x86_64-linux-gnu/libselinux.so.1 /home/chrootjail_$1/lib
#cp -v /lib/x86_64-linux-gnu/libpcre.so.3 /home/chrootjail_$1/lib

# start your chrooted environment. --userspec will start the binaries as the user. Specify to run keydb-server and load with the redis.conf file
# Write to a logfile the output if you would like.
chroot --userspec=$1:keydb_users /home/chrootjail_$1/ /bin/keydb-server /bin/redis.conf &>> /path-to-logfile-location/you-logfile.log &

exit

# you should now see this process running as the user you created. 
