# Build a fresh set of binaries for x86_64 (amd64)

### This dockerfile is whats used to generate our image EQAlpha/keydb-build-binaries. Run on Ubuntu 18.04

### In order to use specify the location on your host you would like the docker image to dump binaries, then run the command below with your updated path:
```
$ docker run -it --rm -v /path-to-dump-binaries:/keydb_bin eqalpha/keydb-build-bin
'''

You should now have the latest.
