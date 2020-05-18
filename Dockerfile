FROM scratch
LABEL maintainer="webispy@gmail.com" \
      version="0.1" \
      description="development environment for nugulinux"

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C \
    LANG=C \
    LANGUAGE=C \
    SHELL=/bin/bash

COPY --from=nugulinux/buildenv:buster_rpi  /var/lib/schroot/chroots/buster-rpi-armhf/ .
COPY qemu-*-static /usr/bin/

RUN apt-get update && apt-get install -y locales \
	    && apt-get install -y --no-install-recommends \
	    software-properties-common \
	    ca-certificates \
	    binfmt-support \
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
	    gdb \
	    git \
	    iputils-ping \
	    less \
	    moreutils \
	    mdbus2 \
	    net-tools \
	    patch \
	    pkg-config \
	    tig \
	    unzip \
	    vim \
	    wget \
	    xz-utils \
	    && echo "deb http://ppa.launchpad.net/nugulinux/sdk/ubuntu bionic main" > /etc/apt/sources.list.d/nugu.list \
	    && echo "deb [trusted=yes] https://nugulinux.github.io/sdk-unstable/ubuntu/ bionic main" > /etc/apt/sources.list.d/nugu-unstable.list \
	    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key 5DE933034EEA59C4 \
	    && apt-get update && apt-get install -y libnugu-dev libnugu libnugu-plugins-default libnugu-examples \
	    && apt-get clean \
	    && rm -rf /var/lib/apt/lists/*

COPY dotfiles/.vimrc dotfiles/.gitconfig dotfiles/.tigrc /root/

# vim vundle
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
	&& ls -la ~/ \
	&& vim +PluginInstall +qall

# fix root .bashrc
RUN rm /root/.bashrc && ln -s /etc/skel/.bashrc /root/

COPY startup.sh run_checkpatch.sh run_cppcheck.sh /usr/bin/
ENTRYPOINT ["/usr/bin/startup.sh"]
CMD ["/bin/bash"]
