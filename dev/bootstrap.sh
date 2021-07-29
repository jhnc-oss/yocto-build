#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

[[ -d "$PWD"/download ]] || mkdir "$PWD"/download
[[ -d "$PWD"/sstate ]] || mkdir "$PWD"/sstate

YOCTO_USER="yocto"
YOCTO_WORKDIR="/opt/${YOCTO_USER}"

sudo chmod -R 775 "${PWD}"/{download,sstate}

podman run \
  -ti \
  --rm \
  --pull=always \
  --userns=keep-id \
  --user "${YOCTO_USER}" \
  --workdir "${YOCTO_WORKDIR}" \
  -v "${PWD}"/dev:"${YOCTO_WORKDIR}"/dev \
  -v "${PWD}"/download:"${YOCTO_WORKDIR}"/download \
  -v "${PWD}"/sstate:"${YOCTO_WORKDIR}"/sstate \
  --env TEMPLATECONF="${YOCTO_WORKDIR}"/meta-protos/conf/templates \
  ghcr.io/jhnc-oss/yocto-image/yocto:latest \
  bash -c 'dev/init_env.sh'

