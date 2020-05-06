
FROM nugulinux/devenv:core_bionic

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	    clang clang-format clang-tidy clang-tools \
	    cppcheck \
	    ctags \
	    exuberant-ctags \
	    gdb \
	    gstreamer1.0-tools \
	    gstreamer1.0-plugins-bad \
	    gstreamer1.0-plugins-ugly \
	    gstreamer1.0-pulseaudio \
	    libqt5webkit5-dev \
	    mdbus2 \
	    qt5-default \
	    tig \
	    unzip \
	    vim \
	    wget \
	    xz-utils \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY dotfiles/.vimrc dotfiles/.zshrc dotfiles/.tigrc /root/
COPY run_codechecker run_codereview.sh /usr/bin/

# 1. oh-my-zsh, vim vundle
# 2. checkpatch
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh --depth 1 \
	&& git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting --depth 1 \
	&& git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth 1 \
	&& ls -la ~/ \
	&& vim +PluginInstall +qall \
	&& mkdir /usr/share/codespell \
	&& wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl -P /usr/bin/ \
	&& wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/spelling.txt -P /usr/bin/ \
	&& chmod +x /usr/bin/checkpatch.pl \
	&& wget https://raw.githubusercontent.com/nugulinux/docker-devenv/master/patches/0001-checkpatch-add-option-for-excluding-directories.patch -P /tmp/ \
	&& wget https://raw.githubusercontent.com/nugulinux/docker-devenv/master/patches/0002-ignore_const_struct_warning.patch -P /tmp/ \
	&& cd /usr/bin \
	&& cat /tmp/0001-checkpatch-add-option-for-excluding-directories.patch | patch \
	&& cat /tmp/0002-ignore_const_struct_warning.patch | patch \
	&& rm /tmp/*.patch \
	&& pip install setuptools \
	&& pip install wheel \
	&& pip install pyyaml

