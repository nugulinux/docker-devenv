
FROM ubuntu:xenial
LABEL maintainer="webispy@gmail.com" \
      version="0.1" \
      description="development environment for nugulinux"

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 \
    LANG=$LC_ALL

RUN apt-get update && apt-get install -y ca-certificates language-pack-en \
	    && locale-gen $LC_ALL \
	    && dpkg-reconfigure locales \
	    && apt-get install -y --no-install-recommends \
	    apt-utils \
	    binfmt-support \
	    build-essential \
	    ca-certificates \
	    cmake \
	    cppcheck \
	    dbus \
	    debhelper \
	    debootstrap \
	    devscripts \
	    dh-autoreconf dh-systemd \
	    gdb \
	    git \
	    gstreamer1.0-tools \
	    language-pack-en \
	    libasound2-dev libasound2-dbg \
	    libconfig-dev libconfig-dbg \
	    libcurl4-openssl-dev libcurl3-dbg \
	    libglib2.0-dev libglib2.0-0-dbg \
	    libgstreamer1.0-dev libgstreamer1.0-0-dbg \
	    libgstreamer-plugins-base1.0-dev \
	    libssl-dev libssl1.0.0-dbg \
	    libsqlite3-dev libsqlite3-0-dbg \
	    mdbus2 \
	    patch \
	    sed \
	    sqlite3 \
	    vim \
	    wget \
	    && apt-get clean \
	    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
