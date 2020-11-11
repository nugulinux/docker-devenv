
FROM arm32v7/ubuntu:xenial
LABEL maintainer="webispy@gmail.com" \
      version="0.1" \
      description="development environment for nugulinux"

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 \
    LANG=$LC_ALL

COPY qemu-*-static /usr/bin/

# split the apt-get command to 3 steps because the travis error:
# - "Too many levels of symbolic links"
# all steps will be merged to 1 layer using 'squash' option.

# 1/3
RUN apt-get update && apt-get install -y software-properties-common \
	    ca-certificates language-pack-en \
	    && locale-gen $LC_ALL \
	    && dpkg-reconfigure locales \
	    && add-apt-repository -y ppa:nugulinux/sdk \
	    && apt-get update \
	    && apt-get install -y --no-install-recommends \
	    apt-utils \
	    binfmt-support \
	    build-essential \
	    ca-certificates \
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
	    gdb \
	    gettext \
	    git \
	    gstreamer1.0-tools \
	    gstreamer1.0-plugins-base \
	    gstreamer1.0-plugins-good \
	    gstreamer1.0-plugins-bad \
	    gstreamer1.0-plugins-ugly

# 2/3
RUN apt-get install -y --no-install-recommends \
	    iputils-ping \
	    language-pack-en \
	    less \
	    libasound2-dev libasound2-dbg libasound2-plugins \
	    libconfig-dev libconfig-dbg \
	    libcurl4-openssl-dev libcurl3-dbg \
	    libglib2.0-dev libglib2.0-0-dbg \
	    libgstreamer1.0-dev libgstreamer1.0-0-dbg \
	    libgstreamer-plugins-base1.0-dev \
	    libopus-dev libopus-dbg \
	    libssl-dev libssl1.0.0-dbg \
	    libsqlite3-dev libsqlite3-0-dbg \
	    moreutils \
	    mdbus2 \
	    net-tools \
	    patch \
	    pkg-config \
	    portaudio19-dev

# 3/3
RUN apt-get install -y --no-install-recommends \
	    pulseaudio \
	    qtdeclarative5-dev \
	    sed \
	    sqlite3 \
	    sudo \
	    tig \
	    unzip \
	    vim \
	    wget \
	    xz-utils \
	    zlib1g-dev \
	    && apt-get clean \
	    && rm -rf /var/lib/apt/lists/*

COPY dotfiles/.vimrc dotfiles/.gitconfig dotfiles/.tigrc /root/

# vim vundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
	&& ls -la ~/ \
	&& vim +PluginInstall +qall

ENV SHELL=/bin/bash
COPY startup.sh /usr/bin/
ENTRYPOINT ["/usr/bin/startup.sh"]
CMD ["/bin/bash"]
