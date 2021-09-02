
FROM ubuntu:xenial
LABEL maintainer="webispy@gmail.com" \
      version="0.2" \
      description="NUGUSDK for Linux development environment"

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 \
    LANG=$LC_ALL

RUN apt-get update \
	&& apt-get install -y \
	    ca-certificates \
	    language-pack-en \
	    software-properties-common \
	&& locale-gen $LC_ALL \
	&& dpkg-reconfigure locales \
	&& add-apt-repository -y ppa:nugulinux/sdk \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
	    apt-utils \
	    apt-transport-https \
	    build-essential \
	    cmake \
	    curl \
	    dbus \
	    debianutils \
	    debhelper \
	    debootstrap \
	    devscripts \
	    dh-autoreconf dh-systemd \
	    diffstat \
	    dnsutils \
	    elfutils \
	    git \
	    gstreamer1.0-plugins-base \
	    gstreamer1.0-plugins-good \
	    iputils-ping \
	    jq \
	    less \
	    libasound2-dev libasound2-dbg libasound2-plugins \
	    libcurl4-openssl-dev libcurl3-dbg \
	    libdbus-glib-1-dev \
	    libglib2.0-dev libglib2.0-0-dbg \
	    libgstreamer1.0-dev libgstreamer1.0-0-dbg \
	    libgstreamer-plugins-base1.0-dev \
	    libnugu-epd-dev libnugu-epd-dbg \
	    libnugu-kwd-dev libnugu-kwd-dbg \
	    libopus-dev libopus-dbg \
	    libssl-dev libssl1.0.0-dbg \
	    libsqlite3-dev \
	    moreutils \
	    net-tools \
	    patch \
	    pkg-config \
	    portaudio19-dev \
	    pulseaudio \
	    python-dbus \
	    python-flask-restful \
	    python-pip \
	    python-requests-oauthlib \
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
