
FROM nugulinux/devenv:core_bionic

RUN apt-get update \
	&& apt-get update && apt-get install -y --no-install-recommends \
	    apt-utils \
	    clang-format clang-tidy clang-tools \
	    cppcheck \
	    ctags \
	    debianutils \
	    debhelper \
	    debootstrap \
	    devscripts \
	    diffstat \
	    dh-autoreconf dh-systemd \
	    dnsutils \
	    elfutils \
	    exuberant-ctags \
	    gdb \
	    gstreamer1.0-tools \
	    gstreamer1.0-plugins-bad \
	    gstreamer1.0-plugins-base \
	    gstreamer1.0-plugins-good \
	    gstreamer1.0-plugins-ugly \
	    gstreamer1.0-pulseaudio \
	    iputils-ping \
	    jq \
		rapidjson-dev \
	    less \
	    libnugu-epd-dbg \
	    libnugu-kwd-dbg \
	    mdbus2 \
	    moreutils \
	    net-tools \
	    tig \
	    pulseaudio \
	    python3-dbus \
	    python3-flask-restful \
	    python3-pip \
	    python3-requests-oauthlib \
	    unzip \
	    vim \
	    wget \
	    xz-utils \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY dotfiles/.vimrc dotfiles/.zshrc dotfiles/.tigrc /root/
COPY run_codechecker run_codereview.sh /usr/bin/
COPY patches/* /tmp/
COPY install_ddebs.sh /usr/bin/

# 1. oh-my-zsh, vim-plug
# 2. checkpatch
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh --depth 1 \
	&& git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting --depth 1 \
	&& curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
	&& ls -la ~/ \
	&& vim +PlugInstall +qall \
	&& mkdir /usr/share/codespell \
	&& wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl -P /usr/bin/ \
	&& wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/spelling.txt -P /usr/bin/ \
	&& chmod +x /usr/bin/checkpatch.pl \
	&& cd /usr/bin \
	&& cat /tmp/0001-checkpatch-add-option-for-excluding-directories.patch | patch \
	&& cat /tmp/0002-ignore_const_struct_warning.patch | patch \
	&& rm /tmp/*.patch \
	&& pip3 install setuptools \
	&& pip3 install wheel \
	&& pip3 install pyyaml

