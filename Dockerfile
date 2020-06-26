
FROM debian:buster
LABEL maintainer="webispy@gmail.com" \
      version="0.1" \
      description="development environment for nugulinux"

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C \
    LANG=C \
    LANGUAGE=C \
    CROSS_TRIPLE=arm-linux-gnueabihf

ENV AS=${CROSS_TRIPLE}-as \
    AR=${CROSS_TRIPLE}-ar \
    CC=${CROSS_TRIPLE}-gcc \
    CPP=${CROSS_TRIPLE}-cpp \
    CXX=${CROSS_TRIPLE}-g++ \
    LD=${CROSS_TRIPLE}-ld \
    STRIP=${CROSS_TRIPLE}-strip \
    RANLIB=${CROSS_TRIPLE}-ranlib \
    CMAKE_TOOLCHAIN_FILE=/opt/Toolchain.cmake

COPY Toolchain.cmake /opt/

# APT repo priority (apt-cache policy)
# ---------------------------------------------
#  1050 get-edi.github.io    (Cross toolchain) from https://github.com/lueschem/edi-raspbian
#   600 archive.raspbian.org (ARMv6 armhf)
#   500 deb.debian.org       (ARMv7 armhf)
COPY preferences.d/ /etc/apt/preferences.d/

# Original Raspbian os-release file
COPY os-release /usr/lib/

# armhf APT Repository setup
# Change the libudev1 version (remove '+rpi1' tag)
# Fix .bashrc for root
RUN apt-get update && apt-get install -y ca-certificates apt-utils gnupg2 \
    && echo "deb [arch=armhf] http://archive.raspbian.org/raspbian/ buster main contrib non-free rpi" > /etc/apt/sources.list.d/raspbian_buster.list \
    && echo "deb [arch=armhf] http://archive.raspberrypi.org/debian/ buster main" >> /etc/apt/sources.list.d/raspbian_buster.list \
    && echo "deb https://get-edi.github.io/raspbian-cross-compiler/debian buster-raspbian-cross main" > /etc/apt/sources.list.d/raspbian_cross_repo.list \
    && echo "deb http://ppa.launchpad.net/nugulinux/sdk/ubuntu bionic main" > /etc/apt/sources.list.d/nugu.list \
    && echo "deb [trusted=yes] https://nugulinux.github.io/sdk-unstable/ubuntu/ bionic main" > /etc/apt/sources.list.d/nugu-unstable.list \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key A005552923B44442 \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key 9165938D90FDDD2E \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key 5DE933034EEA59C4 \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key 82B129927FA3303E \
    && dpkg --add-architecture armhf \
    && apt-get update \
    && apt-cache policy \
    && apt-get install -y --no-install-recommends \
        cmake \
        git \
        patch \
        pkg-config \
        sed \
        vim \
        wget \
        crossbuild-essential-armhf \
        libc6:armhf \
    && cd /tmp && mkdir patched \
    && apt download libudev1:armhf \
    && dpkg-deb -R libudev*.deb patched \
    && sed -i 's/Version: 241-7~deb10u4+rpi1/Version: 241-7~deb10u4/' patched/DEBIAN/control \
    && dpkg-deb -b patched/ patched.deb \
    && dpkg -i --force-overwrite patched.deb \
    && apt-get install -y \
        libglib2.0-dev:armhf \
        libopus-dev:armhf \
        portaudio19-dev:armhf \
        libssl-dev:armhf \
        libasound2-dev:armhf \
        libgstreamer1.0-dev:armhf \
        libgstreamer-plugins-base1.0-dev:armhf \
        libncursesw5-dev:armhf \
        libnugu-epd-dev:armhf \
        libnugu-kwd-dev:armhf \
        libnugu-dev:armhf \
        wiringpi:armhf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm /root/.bashrc \
    && ln -s /etc/skel/.bashrc /root/ \
    && cd /usr/lib/arm-linux-gnueabihf \
    && mv /usr/lib/libwiringPi* . \
    && rm libwiringPi.so libwiringPiDev.so \
    && ln -s libwiringPi.so.* libwiringPi.so \
    && ln -s libwiringPiDev.so.* libwiringPiDev.so \
    && cd -

CMD ["/bin/bash"]
