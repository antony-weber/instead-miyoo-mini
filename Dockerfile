FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      crossbuild-essential-armhf \
      cmake \
      pkg-config \
      zip \
      ca-certificates \
      git \
      libsdl2-dev:armhf \
      libsdl2-ttf-dev:armhf \
      libsdl2-image-dev:armhf \
      libsdl2-mixer-dev:armhf \
      liblua5.1-0-dev:armhf \
      zlib1g-dev:armhf && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
