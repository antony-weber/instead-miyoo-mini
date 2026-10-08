FROM debian:buster

RUN echo "deb http://archive.debian.org/debian buster main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    dpkg --add-architecture armhf && \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      crossbuild-essential-armhf \
      cmake \
      pkg-config \
      zip \
      libsdl2-dev:armhf \
      libsdl2-ttf-dev:armhf \
      libsdl2-image-dev:armhf \
      libsdl2-mixer-dev:armhf \
      liblua5.1-0-dev:armhf \
      zlib1g-dev:armhf && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
