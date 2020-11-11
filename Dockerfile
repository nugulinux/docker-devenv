
FROM nugulinux/devenv:core_xenial

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	    clang clang-format clang-tidy \
	    clang-6.0 clang-format-6.0 clang-tidy-6.0 clang-tools-6.0 \
	    cppcheck \
	    ctags \
	    exuberant-ctags \
	    gdb \
	    gstreamer1.0-tools \
	    gstreamer1.0-plugins-bad \
	    gstreamer1.0-plugins-ugly \
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
COPY patches/* /tmp/

# 1. oh-my-zsh, vim vundle
# 2. checkpatch
# 3. clang-6.0 to default
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
