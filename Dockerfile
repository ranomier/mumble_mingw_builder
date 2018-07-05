FROM debian:jessie-slim

ENV ARCH="x86-64"
ENV BIN_ARCH="x86_64"
ENV MUMBLE_SOURCE="https://github.com/mumble-voip/mumble.git"
ENV ASIO_SDK_SOURCE="http://www.steinberg.net/sdk_downloads/asiosdk2.3.zip"


RUN touch /usr/local/bin/mumble_compile \
&&  chmod +x /usr/local/bin/mumble_compile \
&&  echo "deb http://pkg.mxe.cc/repos/apt/debian jessie main" > /etc/apt/sources.list.d/mxeapt.list \
&&  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D43A795B73B16ABE9643FE1AFD8FFF16DB45C6AB \
&&  apt-get update \
&&  apt-get install -y\
        mxe-${ARCH}-w64-mingw32.static-qtbase \
        mxe-${ARCH}-w64-mingw32.static-qtsvg \
        mxe-${ARCH}-w64-mingw32.static-qttools \
        mxe-${ARCH}-w64-mingw32.static-qttranslations \
        mxe-${ARCH}-w64-mingw32.static-boost \
        mxe-${ARCH}-w64-mingw32.static-protobuf \
        mxe-${ARCH}-w64-mingw32.static-sqlite \
        mxe-${ARCH}-w64-mingw32.static-flac \
        mxe-${ARCH}-w64-mingw32.static-ogg \
        mxe-${ARCH}-w64-mingw32.static-vorbis \
        mxe-${ARCH}-w64-mingw32.static-libsndfile \
        unzip \
&&  rm -rf /var/lib/apt/lists/* \
&&  echo "###### adding user ######" \
&&  useradd -U -m -d /home/user user

COPY "./mumble_compile" "/usr/local/bin/mumble_compile.temp"
RUN cat "/usr/local/bin/mumble_compile.temp" > "/usr/local/bin/mumble_compile"

USER user

RUN wget "${ASIO_SDK_SOURCE}" -P /home/user/ \
&&  unzip /home/user/asiosdk2.3.zip -d /home/user/ \
&&  rm /home/user/asiosdk2.3.zip

CMD mumble_compile
