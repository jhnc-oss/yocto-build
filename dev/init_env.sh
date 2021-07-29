#!/usr/bin/env bash

set -o errexit

MANIFEST_BRANCH="dunfell-23.0.9"
MANIFEST_URL="https://github.com/jhnc-oss/yocto-manifests.git"
PATH="$HOME/.local/bin:$PATH"

cat > "$HOME/.gitconfig" <<EOF
[color]
  ui = "always"
[user]
  name = "yocto"
  email = "yocto@localhost"
EOF

pip install gitrepo

repo init \
  --manifest-url $MANIFEST_URL \
  --no-clone-bundle \
  --depth=1 \
  --manifest-branch $MANIFEST_BRANCH

repo sync \
  --verbose \
  --jobs="$(grep -c ^proc /proc/cpuinfo)" \
  --fetch-submodules \
  --current-branch \
  --no-clone-bundle

source poky/oe-init-build-env

exec /bin/bash

