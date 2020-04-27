FROM rust AS dua-cli

RUN cargo install dua-cli hexyl hyperfine pastel

FROM fedora:32

COPY docker-build.sh /.

RUN /docker-build.sh

COPY --from=dua-cli /usr/local/cargo/bin/dua /usr/bin/dua
COPY --from=dua-cli /usr/local/cargo/bin/hexyl /usr/bin/hexyl
COPY --from=dua-cli /usr/local/cargo/bin/pastel /usr/bin/pastel
COPY --from=dua-cli /usr/local/cargo/bin/hyperfine /usr/bin/hyperfine

VOLUME /tmp
