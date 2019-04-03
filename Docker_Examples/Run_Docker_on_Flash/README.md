# Take Advantage of NVMe SSDs with KeyDB support for flash

### Docker image to use

First ensure you are pulling the correct image "eqalpha/keydb:flash". This is built with make=MALLOC=memkind and is not our 'latest' image (traditional make) so ensure you use the tag "flash" when pulling. Binaries for this image were generated on the latest release and currently for x86-64 (amd64).

### Setting up flash

See our [wiki](https://github.com/JohnSully/KeyDB/wiki/FLASH-Storage) for some background on this topic.

You will have to make btrfs file system on your SSD. We will mount a folder to use specifically for this purpose, check out mount.sh as example. You should configure systemd unit files or fstab to ensure this persists on boot.

### Run Container

Once your volume is set up and mounted you can run your docker image with flash support enabled. You have to specify in the run command you are binding the directory we specified internally for the scratch-file-path (/tmp/keydbflash) to your mount location on host. Limit the size if you want by specifying limit in redis.conf
```
docker run -it --name mykeydb --mount type=bind,target=/tmp/keydbflash,source=/path-to-btrfs-ssd-mount-location-you-made/ eqalpha/keydb:flash
```
You will see with "df", "df -h", "lsof" the use of your mounted directory.

### Testing

If you are trying to test, you can feed in large numbers of commands via cat and keydb-cli --pipe. As example generate a txt file via python loop creating a million lines of "SET key0 val0" with the integer as i.  
```
import sys
f = open('data.text', 'w')
for i in range (0,1000000):
    f.write('SET key' + str(i) + ' val' + str(i) + '\n')
f.close()
```
Now get ip of you container `docker inspect --format '{{ .NetworkSettings.IPAddress }}' <contianer name>` and run cat:
```
cat data1.txt | keydb-cli --pipe -h <ipaddress-of-container> -p 6379
```
You should be able to reboot your machine and the mount location you set up should still be there. Check with "lsblk", "df" where it should still be there. Values will be backed up to dump.rdb when the server stops. This is stored on a VOLUME that was created in the dockerfile and is stored by docker in their /var/lib/docker/volumes/


