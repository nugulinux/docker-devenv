
FROM ubuntu:focal
LABEL maintainer="webispy@gmail.com" \
      version="0.3" \
      description="Linux development environment for NUGU SDK"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	    ca-certificates \
	    software-properties-common \
	&& add-apt-repository -y ppa:nugulinux/sdk \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
	    build-essential \
	    cmake \
	    curl \
	    dbus \
	    git \
	    libasound2-dev libasound2-plugins \
	    libcurl4-openssl-dev \
	    libdbus-glib-1-dev \
	    libglib2.0-dev \
	    libgstreamer1.0-dev \
	    libgstreamer-plugins-base1.0-dev \
	    libnugu-epd-dev \
	    libnugu-kwd-dev \
	    libopus-dev \
	    libssl-dev \
	    libsqlite3-dev \
	    libpulse-dev \
	    patch \
	    pkg-config \
	    portaudio19-dev \
	    sed \
	    zlib1g-dev \
	    zsh \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY dotfiles/.gitconfig /root/

# dbus-daemon-proxy
RUN chsh -s /bin/zsh root \
	&& cd /tmp \
	&& git clone https://github.com/webispy/dbus-daemon-proxy.git --depth 1 \
	&& cd dbus-daemon-proxy \
	&& make && cp dbus-daemon-proxy /usr/bin/ \
	&& cd .. && rm -rf dbus-daemon-proxy

ENV SHELL=/bin/zsh
COPY startup.sh /usr/bin/
ENTRYPOINT ["/usr/bin/startup.sh"]
CMD ["/bin/zsh"]
