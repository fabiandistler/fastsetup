#!/usr/bin/env bash

`which sudo` curl -L https://rig.r-pkg.org/deb/rig.gpg -o /etc/apt/trusted.gpg.d/rig.gpg

`which sudo` sh -c 'echo "deb http://rig.r-pkg.org/deb rig main" > /etc/apt/sources.list.d/rig.list'

`which sudo` apt-fast update
`which sudo` apt-fast install -yq r-rig 

rig add

# Install radian
pip3 install -U radian
