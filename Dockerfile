FROM resin/rpi-raspbian:jessie

RUN apt-get update && \
    apt-get install -y curl g++ gcc libgnutls28-dev libgnutlsxx28 libudev-dev make && \
    mkdir /usr/local/src/libmicrohttpd /open-zwave /open-zwave-control-panel && \
    curl -fsSL ftp://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-latest.tar.gz | tar xz -C /usr/local/src/libmicrohttpd --strip-components 1 && \
    curl -fsSL https://api.github.com/repos/OpenZWave/open-zwave/tarball/master | tar xz -C /open-zwave --strip-components 1 && \
    curl -fsSL https://api.github.com/repos/OpenZWave/open-zwave-control-panel/tarball/master | tar xz -C /open-zwave-control-panel --strip-components 1 && \
    cd /usr/local/src/libmicrohttpd && \
    ./configure && \
    make && \
    make install && \
    cd /open-zwave && \
    make && \
    cd /open-zwave-control-panel && \
    sed -i \
      -e 's/LIBUSB :=/#LIBUSB :=/' \
      -e 's/LIBS :=/#LIBS :=/' \
      -e 's/##LIBUSB :=/LIBUSB :=/' \
      -e 's/##LIBS :=/LIBS :=/' \
      Makefile && \
    make && \
    ln -s /open-zwave/config && \
    ln -s /open-zwave-control-panel/ozwcp /usr/local/bin/

EXPOSE 8090

RUN ["ozwcp"]
