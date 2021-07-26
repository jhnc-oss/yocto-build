#!/usr/bin/env bash

YOCTO_USER="yocto"
YOCTO_WORKDIR="/opt/${YOCTO_USER}"

podman run \
  -ti \
  --rm \
  --pull=always \
  --userns=keep-id \
  --user "${YOCTO_USER}" \
  --workdir "${YOCTO_WORKDIR}" \
  -v "${PWD}"/dev:"${YOCTO_WORKDIR}"/dev \
  --env TEMPLATECONF="${YOCTO_WORKDIR}"/meta-protos/conf/templates \
  ghcr.io/jhnc-oss/yocto-image/yocto:latest \
  bash -c 'dev/init_env.sh'

