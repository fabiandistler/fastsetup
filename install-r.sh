#!/usr/bin/env bash

set -Eeuo pipefail

`which sudo` curl -L https://rig.r-pkg.org/deb/rig.gpg -o /etc/apt/trusted.gpg.d/rig.gpg

`which sudo` sh -c 'echo "deb http://rig.r-pkg.org/deb rig main" > /etc/apt/sources.list.d/rig.list'

`which sudo` apt-fast update
`which sudo` apt-fast install -yq r-rig 

rig add

# Add common R systems deps
sudo apt-fast install -yq \
libcurl4-openssl-dev libssl-dev libxml2-dev libudunits2-dev libgdal-dev cargo \
libfontconfig1-dev libcairo2-dev libgit2-dev  \
libfribidi-dev libharfbuzz-dev pandoc

sudo apt -qy autoremove


