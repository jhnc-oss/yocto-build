# Yocto Build Container Environment using podman

[![ci](https://github.com/jhnc-oss/yocto-build/actions/workflows/ci.yml/badge.svg)](https://github.com/jhnc-oss/yocto-build/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)

:warning: **Ensure SELinux state is set to disabled** otherwise you very likely will face issues (cp -afl --preserver ... failing) within the podman build container due to bitbake trying to create hard-links in the course of build tasks.

## Prerequisites
Make sure that you have installed the following prerequisites on your host machine:
* containerd
* podman

## Bootstrapping the Yocto Build Container
Run the following commands to set up the build container environment:
```
$ git clone https://github.com/jhnc-oss/yocto-build.git 
$ cd yocto-build
$ ./dev/bootstrap.sh
```
