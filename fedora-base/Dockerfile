FROM fedora:33

COPY docker-build.sh /.

RUN /docker-build.sh

ENV DOTNET_ROOT=/dotnet

ENV LANG=en_US.UTF-8

VOLUME /tmp
