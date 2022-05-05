#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

MANIFEST_BRANCH="${1:-main}"
YOCTO_TARGET_ARCH="x86_64"

YOCTO_USER="yocto"
YOCTO_WORKDIR="/opt/${YOCTO_USER}"

[[ -d "$PWD"/download ]] || mkdir "$PWD"/download
[[ -d "$PWD"/sstate ]] || mkdir "$PWD"/sstate

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
  --env YOCTO_TARGET_ARCH="${YOCTO_TARGET_ARCH}" \
  --env TEMPLATECONF="${YOCTO_WORKDIR}"/protos/conf/templates \
  --env "BB_ENV_EXTRAWHITE=YOCTO_TARGET_ARCH" \
  ghcr.io/jhnc-oss/yocto-image/yocto:34 \
  bash -c "dev/init_env.sh ${MANIFEST_BRANCH}"
