#!/usr/bin/env bash

set -o errexit

MANIFEST_BRANCH="${1:-main}"
MANIFEST_URL="https://github.com/jhnc-oss/yocto-manifests.git"

repo init \
  --manifest-url ${MANIFEST_URL} \
  --no-clone-bundle \
  --depth=1 \
  --manifest-branch ${MANIFEST_BRANCH}

repo sync \
  --fetch-submodules \
  --current-branch \
  --no-clone-bundle

source poky/oe-init-build-env
