#!/usr/bin/env bash

set -euxf -o pipefail

dnf update -y

dnf groupinstall -y 'Development Tools'
dnf groupinstall -y 'System Tools'

dnf install -y  \
    autoconf \
    automake \
    bash-completion \
    bat \
    ccls \
    cmake \
    docker-compose \
    fd-find \
    file \
    gcc-c++ \
    gdb \
    golang \
    java-1.8.0-openjdk-devel \
    jq \
    lsof \
    lib{a,l,t,ub}san \
    neovim \
    net-tools \
    nodejs \
    openssh-server \
    perf \
    python3-devel \
    python3-neovim \
    python3-tkinter \
    redhat-rpm-config \
    ripgrep \
    rsync \
    strace \
    time \
    ShellCheck \
    sysstat \
    tcpdump \
    vim \
    xauth \
    xclip

dnf install 'dnf-command(copr)'
dnf copr -y enable @dotnet-sig/dotnet
dnf install -y dotnet-sdk-2.2

pip2 install neovim
pip3 install psrecord matplotlib

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
curl -fsSL https://github.com/rizsotto/Bear/archive/2.4.2.tar.gz | tar xzvf -
mkdir build
cd build
cmake ../Bear-2.4.2
make all
make install
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

# ctop
curl -fsSL -o /usr/local/bin/ctop https://github.com/bcicen/ctop/releases/download/v0.7.2/ctop-0.7.2-linux-amd64
chmod +x /usr/local/bin/ctop

# # coz dependency: libelfin
# TMP=$(mktemp -d)
# cd "$TMP"
# curl -fsSL https://github.com/aclements/libelfin/archive/v0.3.tar.gz | tar xzvf - --strip-components=1
# make
# make install
# cd /
# rm -rf "$TMP"

# # coz causal profiler:
# TMP=$(mktemp -d)
# cd "$TMP"
# git clone https://github.com/plasma-umass/coz.git .
# make
# make install
# cd /
# rm -rf "$TMP"

# clean up
dnf clean all
npm cache --force clean
