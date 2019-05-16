#!/usr/bin/env bash

set -euxf -o pipefail

dnf update -y

dnf groupinstall -y 'Development Tools'
dnf groupinstall -y 'System Tools'

dnf install -y  \
    autoconf \
    automake \
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
    sudo \
    ShellCheck \
    sysstat \
    vim

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

# not working on docker hub
#    fd-find \
TMP=$(mktemp -d)
cd "$TMP"
curl -fsSL https://github.com/sharkdp/fd/releases/download/v7.3.0/fd-v7.3.0-x86_64-unknown-linux-gnu.tar.gz | tar xzvf - --strip-components=1
mv fd /usr/local/bin/.
mv autocomplete/fd.bash-completion "$(pkg-config --variable=completionsdir bash-completion)"/fd
cd /
rm -rf "$TMP"

TMP=$(mktemp -d)
cd "$TMP"
curl -fsSL https://github.com/BurntSushi/ripgrep/releases/download/11.0.1/ripgrep-11.0.1-x86_64-unknown-linux-musl.tar.gz | tar xzvf - --strip-components=1
mv rg /usr/local/bin/.
mv complete/rg.bash "$(pkg-config --variable=completionsdir bash-completion)"/rg
cd /
rm -rf "$TMP"

# universal ctags
TMP=$(mktemp -d)
cd "$TMP"
git clone http://github.com/universal-ctags/ctags.git .
./autogen.sh
./configure
make
make install
cd /
rm -rf "$TMP"

# clean up
dnf clean all
npm cache --force clean
