#!/usr/bin/env bash

set -euf -o pipefail

dnf update -y

dnf groupinstall -y 'Development Tools'

dnf install -y  \
    bash-completion \
    ccls \
    cmake \
    file \
    gcc-c++ \
    gdb \
    golang \
    jq \
    lsof \
    lib{a,l,t,ub}san \
    neovim \
    net-tools \
    nodejs \
    openssh-server \
    perf \
    procps \
    python3-neovim \
    ripgrep \
    sudo \
    ShellCheck \
    sysstat \
    vim

# not working on docker hub
#    fd-find \
dnf copr enable keefle/fd
dnf install fd

pip2 install neovim

# install node based utilities
npm install -g \
    dockerfile-language-server-nodejs \
    flow-bin \
    javascript-typescript-langserver \
    neovim \
    standard \
    vscode-html-languageserver-bin

# https://github.com/mads-hartmann/bash-language-server/issues/93#issuecomment-476144999
npm install --unsafe-perm -g bash-language-server

# build ear tool
TMP=$(mktemp -d)
cd "$TMP"
curl -fsSL https://github.com/rizsotto/Bear/archive/2.3.13.tar.gz | tar xzvf -
mkdir build
cd build
cmake ../Bear-2.3.13
make all
make install
cd /
rm -rf "$TMP"

# clean up
dnf clean all
npm cache --force clean
