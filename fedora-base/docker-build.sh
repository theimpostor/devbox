#!/usr/bin/env bash

set -euf -o pipefail

dnf update -y

dnf groupinstall -y 'Development Tools'

dnf install -y  \
    bash-completion \
    ccls \
    cmake \
    fd-find \
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

dnf clean all

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

npm cache --force clean
