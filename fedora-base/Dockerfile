FROM rust AS dua-cli

RUN cargo install dua-cli hexyl pastel

FROM fedora:31

COPY --from=dua-cli /usr/local/cargo/bin/dua /usr/bin/dua
COPY --from=dua-cli /usr/local/cargo/bin/hexyl /usr/bin/hexyl
COPY --from=dua-cli /usr/local/cargo/bin/pastel /usr/bin/pastel

COPY docker-build.sh /.

RUN /docker-build.sh

VOLUME /tmp
