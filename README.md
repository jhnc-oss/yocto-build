# Yocto Build Container Environment using podman(1)

[![ci](https://github.com/jhnc-oss/yocto-build/actions/workflows/ci.yml/badge.svg)](https://github.com/jhnc-oss/yocto-build/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)

## Prerequisites

Ensure that you have installed the following prerequisites on your host machine:
* containerd
* podman

Should permission problems occure with the file mappings `/etc/subuid` and `/etc/subgid` have to be edited.


## Bootstrapping the Yocto Build Container
Run the following commands to set up the build container environment:
```sh
$ git clone https://github.com/jhnc-oss/yocto-build.git
$ cd yocto-build
$ ./dev/bootstrap.sh

  — or:
$ ./dev/bootstrap.sh <manifest branch>
```

Layer manifest `main` is used by default, use `dev/bootstrap.sh <Manifest Branch>` to select another one.

## Known Issues

There are known issues running the build container on systems with enabled SELinux in Enforcing mode. If you get permission errors try to set SELinux mode to permissive by running:
```sh
sudo setenforce 0
```

You may face further issues with SELinux being enabled during builds resulting in
errors such as:
```sh
Command 'cp -afl --preserve=xattr ...' failed
```

As the podman container runs unprivileged (rootless) the cause might be
container-storage setting driver to "overlay" by default.
Try  switching to "vfs" using the following user-specific configuration
snippet:
```sh
mkdir -p ~/.config/containers
cat > ~/.config/containers/storage.conf <<EOF
[storage]
driver = "vfs"
EOF
```

After changing the driver setting when running podman you may face errors such as:
```
ERRO[0000] User-selected graph driver "vfs" overwritten by graph driver "overlay" from database - delete libpod local files to resolve
```

In this case, you have to reset your database, e.g. by running:
```sh
(sudo) rm -rf ~/.local/share/containers
```

For further details please refer to containers-storage.conf(5).


## Available Versions

| Yocto Release Branch | Status | Note |
|:--------------------:|:------:|------|
| **`kirkstone`**      | :heavy_check_mark: LTS | :arrows_clockwise: Synced from `main` — *do not contribute directly* |
| **`dunfell`**        | :heavy_check_mark: LTS | |
