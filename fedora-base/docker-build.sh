#!/usr/bin/env bash

set -euxf -o pipefail

# enable man pages - https://unix.stackexchange.com/a/525250
sed -i -e '/tsflags=nodocs/s/^/#/' /etc/dnf/dnf.conf

dnf update -y

dnf install -y dnf-plugins-core

dnf copr enable -y agriffis/neovim-nightly

dnf update -y

dnf install -y glibc-locale-source

localedef --no-archive -i en_US -f UTF-8 en_US.UTF-8

export LANG=en_US.UTF-8

dnf groupinstall -y 'Development Tools'

dnf install -y  \
    ShellCheck \
    autoconf \
    automake \
    bash-completion \
    bat \
    bear \
    bzip2-devel \
    clang \
    cmake \
    cpio \
    diffutils \
    docker-compose \
    dua-cli \
    exa \
    fd-find \
    file \
    findutils \
    fio \
    gcc-c++ \
    gdb \
    gflags-devel \
    git-delta \
    golang \
    golang-x-tools-gopls \
    hyperfine \
    iproute \
    iptables \
    iputils \
    java-11-openjdk-devel \
    jemalloc-devel \
    jq \
    libzstd-devel \
    lib{a,l,t,ub}san \
    lldb \
    llvm-devel \
    lsof \
    lz4-devel \
    man-db \
    man-pages \
    neovim \
    net-tools \
    nodejs \
    openssh-server \
    parallel \
    perf \
    perl-JSON-PP \
    perl-open \
    procps-ng \
    python-unversioned-command \
    python3-devel \
    python3-neovim \
    python3-pip \
    redhat-rpm-config \
    ripgrep \
    rsync \
    snappy-devel \
    strace \
    sysstat \
    tcpdump \
    time \
    valgrind \
    vim \
    wget \
    which \
    xz \
    zlib-devel

ln -s /usr/share/clang/clang-format-diff.py /usr/bin/.

mkdir /dotnet
curl -fsSL https://download.visualstudio.microsoft.com/download/pr/5797d98a-8faf-472d-925c-931ac542d3c8/e48942da88f4d9d653a7b5c0790e7724/dotnet-sdk-2.1.818-linux-x64.tar.gz | tar xzvfC - /dotnet
ln -s /dotnet/dotnet /usr/bin/.

dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
dnf install -y gh

pip3 install grip

npm install -g \
    bash-language-server \
    dockerfile-language-server-nodejs \
    neovim

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

# starship (package manager version too old)
pushd "$(mktemp -d)"
curl -fsSLO https://starship.rs/install.sh
sh install.sh --yes
popd

# clean up
dnf clean all
npm cache --force clean
rm -rf /root/.cache/pip
find /var/tmp /tmp -mindepth 1 -delete
