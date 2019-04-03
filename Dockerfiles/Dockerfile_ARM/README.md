# Dockerifle used for ARM support

This Dockerfile generates the image used for ARM and ARM 64 pulls of EQAlpha/keydb. This is built on Rasbian Stretch image. The binaries copied into this are generated on a rbp emulator. We use the latest release to generate these, not unstable. This is manifested so the pull will reference the correct image for your system.

### Build using the following:
```
$ docker build . -t your-tag-for-this-image
'''

