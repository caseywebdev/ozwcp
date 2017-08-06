FROM resin/rpi-raspbian:jessie

RUN apt-get update && \
    apt-get install -y curl g++ gcc libgnutls28-dev libgnutlsxx28 libmicrohttpd-dev libudev-dev make && \
    mkdir /open-zwave && \
    curl -fsSL https://api.github.com/repos/OpenZWave/open-zwave/tarball/master | tar xz -C /open-zwave --strip-components 1 && \
    cd /open-zwave && \
    make && \
    mkdir /open-zwave-control-panel && \
    curl -fsSL https://api.github.com/repos/OpenZWave/open-zwave-control-panel/tarball/master | tar xz -C /open-zwave-control-panel --strip-components 1 && \
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
