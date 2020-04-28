#!/usr/bin/env bash

set -euxf -o pipefail

# enable man pages - https://unix.stackexchange.com/a/525250
sed -i -e '/tsflags=nodocs/s/^/#/' /etc/dnf/dnf.conf

dnf update -y

dnf groupinstall -y 'Development Tools'

dnf install -y  \
    ShellCheck \
    autoconf \
    automake \
    bash-completion \
    bat \
    bear \
    bzip2 \
    ccls \
    cmake \
    cpio \
    diffutils \
    docker-compose \
    fd-find \
    file \
    findutils \
    gcc-c++ \
    gdb \
    golang \
    iputils \
    java-1.8.0-openjdk-devel \
    jq \
    lib{a,l,t,ub}san \
    llvm-devel \
    lsof \
    lz4 \
    man-db \
    man-pages \
    mutrace \
    neovim \
    net-tools \
    nodejs \
    openssh-server \
    perf \
    procps-ng \
    python3-devel \
    python3-neovim \
    python3-pip \
    python3-tkinter \
    redhat-rpm-config \
    ripgrep \
    rsync \
    screen \
    strace \
    sysstat \
    tcpdump \
    time \
    valgrind \
    vim \
    wget \
    which \
    xz

dnf install 'dnf-command(copr)'
dnf copr -y enable @dotnet-sig/dotnet
dnf install -y dotnet-sdk-2.2

# pip2 install neovim
pip3 install psrecord matplotlib

npm install -g \
    dockerfile-language-server-nodejs \
    neovim

# https://github.com/mads-hartmann/bash-language-server/issues/93#issuecomment-476144999
npm install --unsafe-perm -g bash-language-server

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
curl -fsSL -o /usr/local/bin/ctop https://github.com/bcicen/ctop/releases/download/v0.7.3/ctop-0.7.3-linux-amd64
chmod +x /usr/local/bin/ctop

# docker bash completion
curl -fsSL https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker > "$(pkg-config --variable=compatdir bash-completion)"/docker

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
rm -rf /root/.cache/pip
find /var/tmp /tmp -mindepth 1 -delete
