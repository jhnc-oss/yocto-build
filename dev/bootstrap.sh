#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

MANIFEST_BRANCH="${1:-dunfell}"
YOCTO_TARGET_ARCH="x86_64"

YOCTO_GID="4040"
YOCTO_UID="2000"
YOCTO_USER="yocto"
YOCTO_WORKDIR="/opt/${YOCTO_USER}"

[[ -d "$PWD"/download ]] || mkdir "$PWD"/download
[[ -d "$PWD"/sstate ]] || mkdir "$PWD"/sstate

sudo chmod -R 775 "${PWD}"/{download,sstate}

subgidSize=$(( $(podman info --format "{{ range .Host.IDMappings.GIDMap }}+{{.Size }}{{end }}" ) - 1 ))
subuidSize=$(( $(podman info --format "{{ range .Host.IDMappings.UIDMap }}+{{.Size }}{{end }}" ) - 1 ))

podman run \
  -ti \
  --rm \
  --pull=always \
  --gidmap ${YOCTO_GID}:0:1 \
  --gidmap $((YOCTO_GID+1)):$((YOCTO_GID+1)):$((subgidSize-YOCTO_GID)) \
  --gidmap 0:1:${YOCTO_GID} \
  --uidmap ${YOCTO_UID}:0:1 \
  --uidmap $((YOCTO_UID+1)):$((YOCTO_UID+1)):$((subuidSize-YOCTO_UID)) \
  --uidmap 0:1:${YOCTO_UID} \
  --user "${YOCTO_USER}:${YOCTO_USER}" \
  --workdir "${YOCTO_WORKDIR}" \
  -v "${PWD}"/dev:"${YOCTO_WORKDIR}"/dev:Z \
  -v "${PWD}"/download:"${YOCTO_WORKDIR}"/download:Z \
  -v "${PWD}"/sstate:"${YOCTO_WORKDIR}"/sstate:Z \
  --env YOCTO_TARGET_ARCH="${YOCTO_TARGET_ARCH}" \
  --env TEMPLATECONF="${YOCTO_WORKDIR}"/protos/conf/templates \
  --env "BB_ENV_EXTRAWHITE=YOCTO_TARGET_ARCH" \
  ghcr.io/jhnc-oss/yocto-image/yocto:36 \
  bash -c "dev/init_env.sh ${MANIFEST_BRANCH}"
