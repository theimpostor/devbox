#!/usr/bin/env bash

set -euxf -o pipefail

# enable man pages - https://unix.stackexchange.com/a/525250
sed -i -e '/tsflags=nodocs/s/^/#/' /etc/dnf/dnf.conf

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
    ccls \
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
    mutrace \
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

dnf install 'dnf-command(copr)'
dnf copr -y enable @dotnet-sig/dotnet
dnf install -y dotnet-sdk-2.2

dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
dnf install -y gh

# TODO: broken w/fedora 33
# # pip2 install neovim
# pip3 install psrecord matplotlib

pip3 install grip

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

# glow
pushd "$(mktemp -d)"
curl -fsSLO "$(curl -fsSL "https://api.github.com/repos/charmbracelet/glow/releases/latest" | jq -r '.assets[].browser_download_url' | grep "linux_amd64.rpm")"
rpm -U glow*linux_amd64.rpm
popd

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
