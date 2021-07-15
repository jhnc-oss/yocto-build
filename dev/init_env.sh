#!/usr/bin/env bash

PATH="$HOME/.local/bin:$PATH"

cat > "$HOME/.gitconfig" <<EOF
[color]
  ui = "always"
[user]
  name = "yocto"
  email = "yocto@localhost"
EOF

pip install gitrepo
repo init -u https://github.com/jhnc-oss/yocto-manifests.git --no-clone-bundle --depth=1 -b dunfell-23.0.9
repo sync --verbose --jobs=8 --fetch-submodules --current-branch --no-clone-bundle

source poky/oe-init-build-env

exec /bin/bash

