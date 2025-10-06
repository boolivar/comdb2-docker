# syntax=docker/dockerfile:1
FROM ubuntu:latest

ARG DBNAME=default

RUN useradd --no-create-home --user-group comdb2

RUN apt-get update      \
 && apt-get install -y  \
    bison               \
    build-essential     \
    cmake               \
    flex                \
    libevent-dev        \
    liblz4-dev          \
    libprotobuf-c-dev   \
    libreadline-dev     \
    libsqlite3-dev      \
    libssl-dev          \
    libunwind-dev       \
    ncurses-dev         \
    protobuf-c-compiler \
    tcl                 \
    uuid-dev            \
    zlib1g-dev

RUN --mount=type=bind,source=comdb2,target=/comdb2,rw mkdir /comdb2/build \
  && cd /comdb2/build \
  && cmake ..         \
  && make             \
  && make install

ENV PATH=/opt/bb/bin:$PATH DBNAME=$DBNAME

RUN comdb2 --create $DBNAME

COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]

CMD ["$DBNAME"]

EXPOSE 5105 19000

LABEL org.opencontainers.image.title="comdb2"
LABEL org.opencontainers.image.source="https://github.com/boolivar/comdb2-docker"
LABEL org.opencontainers.image.licenses="MIT"