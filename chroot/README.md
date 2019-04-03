# How to run your KeyDB servers in a chrooted environment

Take a look at the attached scripts for a walthrough example of setting up a chrooted environment to run your applications in.

Making a chroot jail is fairly simple. Set up your minimal system files and dependencies, load binaries, and run with chroot. The minimal requirements needed to run are as follows:

        libdl.so.2
        librt.so.1
        libuuid.so.1
        libstdc++.so.6
        libm.so.6
        libgcc_s.so.1
        libpthread.so.0
        libc.so.6
        ld-linux-x86-64.so.2
	# if you are running with flash storage option enabled you will need to add libnuma:
        libnuma.so.1

Note that the above listed files may be in different locations on your system than in the example. Try to find them with "whereis" command or also use "lld /path-to-keydb-bin/keydb-server". The same if you want to run an instance of keydb-sentinel. Dependencies are however essentially the same.

