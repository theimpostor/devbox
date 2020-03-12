FROM rust AS dua-cli

RUN cargo install dua-cli


FROM fedora:31

COPY --from=dua-cli /usr/local/cargo/bin/dua /usr/bin/dua

COPY docker-build.sh /.

RUN /docker-build.sh

VOLUME /tmp
