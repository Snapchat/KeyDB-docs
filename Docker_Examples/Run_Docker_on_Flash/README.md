# Take Advantage of NVMe SSDs with KeyDB support for flash

First ensure you are pulling the correct image "eqalpha/keydb:flash". This is built with make=MALLOC=memkind and is not our base image so ensure you use the tag "flash" when pulling

You will have to make btrfs file system on your SSD. We will mount a folder to use specifically for this purpose.
