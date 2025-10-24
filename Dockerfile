# syntax=docker/dockerfile:1
ARG UBUNTU_VERSION=24.04

FROM ubuntu:$UBUNTU_VERSION AS build

ARG BUILD_DEPS="\
 bison \
 build-essential \
 cmake \
 file \
 flex \
 git \
 libevent-dev \
 liblz4-dev \
 libprotobuf-c-dev \
 libreadline-dev \
 libsqlite3-dev \
 libssl-dev \
 libunwind-dev \
 ncurses-dev \
 protobuf-c-compiler \
 tcl \
 uuid-dev \
 zlib1g-dev \
"

RUN --mount=source=comdb2,target=/comdb2 \
    apt-get update \
 && apt-get install -y --no-install-recommends $BUILD_DEPS \
 && mkdir /build \
 && cd /build \
 && cmake ../comdb2 \
 && make package

FROM ubuntu:$UBUNTU_VERSION

RUN --mount=source=.dockerenv,target=/.dockerenv \ 
    --mount=from=build,source=/build,target=/comdb2 \
    useradd --system --create-home --user-group comdb2 \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
  adduser \
  /comdb2/comdb2.deb \
 && rm -rf /var/lib/apt/lists/*

USER comdb2

ARG DBNAME=default

ENV PATH=/opt/bb/bin:$PATH DBNAME=$DBNAME 

RUN comdb2 --create $DBNAME

COPY entrypoint.sh .

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 5105 19000

LABEL org.opencontainers.image.title="comdb2"
LABEL org.opencontainers.image.source="https://github.com/boolivar/comdb2-docker"
LABEL org.opencontainers.image.licenses="MIT"
