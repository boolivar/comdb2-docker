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
 tcl-dev \
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

COPY LICENSE /licenses/LICENSE
COPY comdb2/LICENSE /licenses/comdb2/LICENSE
COPY comdb2/berkdb/LICENSE /licenses/berkdb/LICENSE
COPY comdb2/crc32c/sb8.h /licenses/crc32c/sb8.h
COPY comdb2/dfp/decNumber/ICU-license.html /licenses/decNumber/ICU-license.html
COPY comdb2/dfp/dfpal/ICU-license.html /licenses/dfpal/ICU-license.html
COPY comdb2/lua/lua.h /licenses/lua/lua.h

LABEL org.opencontainers.image.title="comdb2"
LABEL org.opencontainers.image.description="Docker image for the open-source Comdb2 database. Not endorsed by Bloomberg."
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/boolivar/comdb2-docker"
LABEL org.opencontainers.image.authors="Aleksey Krichevskiy <boolivar@gmail.com>"