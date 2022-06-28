
FROM nugulinux/devenv:core_jammy

RUN apt-get update \
	&& apt-get update && apt-get install -y --no-install-recommends \
	    apt-utils \
	    automake \
	    clang-format clang-tidy clang-tools \
	    cppcheck \
	    debianutils \
	    debhelper \
	    debootstrap \
	    devscripts \
	    diffstat \
	    dh-autoreconf \
	    dnsutils \
	    elfutils \
	    gdb \
	    gstreamer1.0-tools \
	    gstreamer1.0-plugins-bad \
	    gstreamer1.0-plugins-base \
	    gstreamer1.0-plugins-good \
	    gstreamer1.0-plugins-ugly \
	    gstreamer1.0-pulseaudio \
	    iputils-ping \
	    jq \
	    less \
	    libnugu-epd-dbg \
	    libnugu-kwd-dbg \
	    libreadline-dev \
	    libtinfo5 \
	    libtool \
	    moreutils \
	    net-tools \
	    tig \
	    pulseaudio \
	    python3-dbus \
	    python3-flask-restful \
	    python3-pip \
	    python3-requests-oauthlib \
	    universal-ctags \
	    unzip \
	    valac \
	    vim \
	    wget \
	    xz-utils \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY dotfiles/.vimrc dotfiles/.zshrc dotfiles/.tigrc /root/
COPY run_codechecker run_codereview.sh /usr/bin/
COPY patches/* /tmp/
COPY install_ddebs.sh /usr/bin/

# 1. oh-my-zsh, vim vundle
# 2. checkpatch
# 3. mdbus2
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh --depth 1 \
	&& git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting --depth 1 \
	&& git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth 1 \
	&& ls -la ~/ \
	&& vim +PluginInstall +qall \
	&& mkdir /usr/share/codespell \
	&& wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl -P /usr/bin/ \
	&& wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/spelling.txt -P /usr/bin/ \
	&& chmod +x /usr/bin/checkpatch.pl \
	&& cd /usr/bin \
	&& cat /tmp/0001-checkpatch-add-option-for-excluding-directories.patch | patch \
	&& cat /tmp/0002-ignore_const_struct_warning.patch | patch \
	&& rm /tmp/*.patch \
	&& cd /tmp && git clone https://github.com/webispy/mdbus.git && cd mdbus \
	&& ./autogen.sh --prefix=/usr && make install \
	&& rm -rf /tmp/mdbus
