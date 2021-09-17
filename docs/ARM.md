---
id: ARM          
title: KeyDB on ARM
sidebar_label:  ARM Support
---


KeyDB supports the ARM processor in general, and
the Raspberry Pi specifically, as a main platform, exactly like it happens
for Linux/x86. It means that every new release of KeyDB is tested on the Pi
environment, and that we take this documentation page updated with information
about supported devices and other useful info. While KeyDB already runs on
Android, in the future we look forward to extend our testing efforts to Android
to also make it an officially supported platform.

We believe that KeyDB is ideal for IoT and Embedded devices for several
reasons:

* KeyDB has a very small memory footprint and CPU requirements. Can run in small devices like the Raspberry Pi Zero without impacting the overall performance, using a small amount of memory, while delivering good performance for many use cases.
* The data structures of KeyDB are often a good way to model IoT/embedded use cases. For example in order to accumulate time series data, to receive or queue commands to execute or responses to send back to the remote servers and so forth.
* Modeling data inside KeyDB can be very useful in order to make in-device decisions for appliances that must respond very quickly or when the remote servers are offline.
* KeyDB can be used as an interprocess communication system between the processes running in the device.
* The append only file storage of KeyDB is well suited for the SSD cards.

## KeyDB /proc/cpu/alignment requirements

Linux on ARM allows to trap unaligned accesses and fix them inside the kernel
in order to continue the execution of the offending program instead of
generating a SIGBUS. KeyDB avoids any kind
of unaligned access, so there is no need to have a specific value for this
kernel configuration. Even when kernel alignment fixing is disabled KeyDB should
run as expected.

## Building KeyDB in the Pi

Same as regular build. KeyDB builds its binaries used in the docker image on a rbp emulator for use in the rasbian-stretch image. 

