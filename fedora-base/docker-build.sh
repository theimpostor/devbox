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
    dua-cli \
    fd-find \
    file \
    findutils \
    gcc-c++ \
    gdb \
    golang \
    hyperfine \
    iproute \
    iptables \
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
    perl-open \
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
pushd "$(mktemp -d)"
git clone http://github.com/universal-ctags/ctags.git .
./autogen.sh
./configure
make
make install
popd

# docker bash completion
curl -fsSL https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker > "$(pkg-config --variable=compatdir bash-completion)"/docker

# hexyl
pushd "$(mktemp -d)"
curl -fsSL "$(curl -fsSL "https://api.github.com/repos/sharkdp/hexyl/releases/latest" | jq -r '.assets[].browser_download_url' | grep "x86_64-unknown-linux-gnu.tar.gz$")" | tar xzvf - --strip-components 1
cp -a hexyl /usr/bin/hexyl
popd

# pastel
pushd "$(mktemp -d)"
curl -fsSL "$(curl -fsSL "https://api.github.com/repos/sharkdp/pastel/releases/latest" | jq -r '.assets[].browser_download_url' | grep "x86_64-unknown-linux-gnu.tar.gz$")" | tar xzvf - --strip-components 1
cp -a pastel /usr/bin/pastel
popd

# ctop
curl -fsSLo /usr/bin/ctop "$(curl -fsSL "https://api.github.com/repos/bcicen/ctop/releases/latest" | jq -r '.assets[].browser_download_url' | grep "linux-amd64$")"
chmod +x /usr/bin/ctop

# clean up
dnf clean all
npm cache --force clean
rm -rf /root/.cache/pip
find /var/tmp /tmp -mindepth 1 -delete
