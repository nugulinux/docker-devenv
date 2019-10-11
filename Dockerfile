
FROM ubuntu:xenial
LABEL maintainer="webispy@gmail.com" \
      version="0.1" \
      description="development environment for nugulinux"

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 \
    LANG=$LC_ALL \
    PATH=$PATH:/usr/local/go/bin

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
	    cppcheck \
	    clang clang-format clang-tidy \
	    clang-6.0 clang-format-6.0 clang-tidy-6.0 clang-tools-6.0 \
	    ctags \
	    curl \
	    dbus \
	    debianutils \
	    debhelper \
	    debootstrap \
	    devscripts \
	    dh-autoreconf dh-systemd \
	    diffstat \
	    dnsutils \
	    exuberant-ctags \
	    elfutils \
	    gdb \
	    gettext \
	    git \
	    global \
	    gstreamer1.0-tools \
	    gstreamer1.0-plugins-base \
	    gstreamer1.0-plugins-good \
	    gstreamer1.0-plugins-bad \
	    gstreamer1.0-plugins-ugly \
	    iputils-ping \
	    language-pack-en \
	    less \
	    libasound2-dev libasound2-dbg libasound2-plugins \
	    libconfig-dev libconfig-dbg \
	    libcurl4-openssl-dev libcurl3-dbg \
	    libglib2.0-dev libglib2.0-0-dbg \
	    libgrpc++-dev \
	    libgstreamer1.0-dev libgstreamer1.0-0-dbg \
	    libgstreamer-plugins-base1.0-dev \
	    libopus-dev libopus-dbg \
	    libprotobuf-dev \
	    libssl-dev libssl1.0.0-dbg \
	    libsqlite3-dev libsqlite3-0-dbg \
		libqt5webkit5-dev \
	    man \
	    minicom \
	    moreutils \
	    mdbus2 \
	    net-tools \
	    patch \
	    pkg-config \
	    portaudio19-dev \
	    protobuf-compiler \
	    protobuf-compiler-grpc \
	    pulseaudio \
	    python-dbus \
	    python-pip \
	    qemu-user-static \
		qt5-default \
	    sbuild \
	    schroot \
	    sed \
	    sqlite3 \
	    sudo \
	    tig \
	    unzip \
	    vim \
	    wget \
	    xz-utils \
	    zlib1g-dev \
	    zsh \
	    && apt-get clean \
	    && rm -rf /var/lib/apt/lists/*

COPY dotfiles/.vimrc dotfiles/.zshrc dotfiles/.gitconfig dotfiles/.tigrc /root/

# 1. gerrit-check
# - fix flake8 python version issue
# - add cppcheck option (--enable=all, --quiet)
# - remove Code-Review: -1
# RUN pip install --trusted-host pypi.python.org --upgrade pip==9.0.3 \
#	&& pip install --trusted-host pypi.python.org gerrit-check \
# 2. oh-my-zsh, vim vundle
# 3. checkpatch
#    - https://raw.githubusercontent.com/01org/zephyr/master/scripts/checkpatch.pl
# 4. clang-6.0 to default
RUN pip install setuptools \
	&& pip install wheel \
	&& pip install gerrit-check \
	&& sed -i 's/from flake8.engine/from flake8.api.legacy/' /usr/local/lib/python2.7/dist-packages/gerritcheck/check.py \
	&& sed -i 's/"--quiet"/"--quiet", "--enable=all"/' /usr/local/lib/python2.7/dist-packages/gerritcheck/check.py \
	&& sed -i 's/review\["labels"\] = {"Code-Review": -1}/ /' /usr/local/lib/python2.7/dist-packages/gerritcheck/check.py \
	&& touch /usr/local/lib/python2.7/dist-packages/gerritcheck/check.py \
	&& chsh -s /bin/zsh root \
	&& git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
	&& git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
	&& git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
	&& ls -la ~/ \
	&& vim +PluginInstall +qall \
	&& mkdir /usr/share/codespell \
	&& wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl -P /usr/bin/ \
	&& wget --no-check-certificate https://raw.githubusercontent.com/torvalds/linux/master/scripts/spelling.txt -P /usr/bin/ \
	&& wget --no-check-certificate https://raw.githubusercontent.com/nfs-ganesha/ci-tests/master/checkpatch/checkpatch-to-gerrit-json.py -P /usr/bin/ \
	&& chmod +x /usr/bin/checkpatch.pl \
	&& chmod +x /usr/bin/checkpatch-to-gerrit-json.py \
	&& wget https://raw.githubusercontent.com/nugulinux/docker-devenv/master/patches/0001-checkpatch-add-option-for-excluding-directories.patch -P /tmp/ \
	&& wget https://raw.githubusercontent.com/nugulinux/docker-devenv/master/patches/0002-ignore_const_struct_warning.patch -P /tmp/ \
	&& wget https://raw.githubusercontent.com/nugulinux/docker-devenv/master/patches/0003-gerrit_checkpatch.patch -P /tmp/ \
	&& cd /usr/bin \
	&& cat /tmp/0001-checkpatch-add-option-for-excluding-directories.patch | patch \
	&& cat /tmp/0002-ignore_const_struct_warning.patch | patch \
	&& cat /tmp/0003-gerrit_checkpatch.patch | patch \
	&& rm /tmp/*.patch \
	&& update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-format-diff clang-format-diff /usr/bin/clang-format-diff-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-tidy-diff.py clang-tidy-diff.py /usr/bin/clang-tidy-diff-6.0.py 1000 \
	&& update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-check clang-check /usr/bin/clang-check-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-query clang-query /usr/bin/clang-query-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-refactor clang-refactor /usr/bin/clang-refactor-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-rename clang-rename /usr/bin/clang-rename-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-apply-replacements clang-apply-replacements /usr/bin/clang-apply-replacements-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-change-namespace clang-change-namespace /usr/bin/clang-change-namespace-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-cl clang-cl /usr/bin/clang-cl-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-func-mapping clang-func-mapping /usr/bin/clang-func-mapping-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-import-test clang-import-test /usr/bin/clang-import-test-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-include-fixer clang-include-fixer /usr/bin/clang-include-fixer-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-offload-bundler clang-offload-bundler /usr/bin/clang-offload-bundler-6.0 1000 \
	&& update-alternatives --install /usr/bin/clang-reorder-fields clang-reorder-fields /usr/bin/clang-reorder-fields-6.0 1000 \
	&& update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-6.0 1000

ENV SHELL=/bin/zsh
COPY startup.sh run_checkpatch.sh run_cppcheck.sh /usr/bin/
ENTRYPOINT ["/usr/bin/startup.sh"]
CMD ["/bin/zsh"]
