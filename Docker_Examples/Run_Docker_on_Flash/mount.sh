#! /bin/bash
#
#
#
# In this case we have a SSD volume nvme0n1. You will see your volume with command "lsblk"
# We are mounting to a directory we made /mnt/cache. You can see this mounted with "lsblk" and "df"
#
##### set up raid0 #####
set -e
mdadm --zero-superblock /dev/nvme0n1
mdadm --create /dev/md0 --level=0 --raid-devices=1 --force /dev/nvme0n1
mkfs.btrfs -f /dev/md0
mount /dev/md0 /mnt/cache -o ssd,nobarrier
