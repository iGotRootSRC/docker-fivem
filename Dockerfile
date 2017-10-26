FROM debian:jessie
MAINTAINER DracoDragon88

# Install dependencies 
RUN apt-get update && apt-get -y install git-core && apt-get -y install wget && apt-get -y install xz-utils

# Common
ENV FX_VERSION 401-7da138fa4851430482ff2fb4e196b871d5ea3efb
ENV FX_DOWNLOAD_URL https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$FX_VERSION/fx.tar.xz
ENV FX_PATH "/fivem/fx-server"
ENV FX_PATH_DATA "/fivem/fx-server-data"
ENV FX_ARCHIVE fx.tar.xz

# Container Setup
RUN mkdir /fivem && \
	mkdir "$FX_PATH" && \
	mkdir "$FX_PATH_DATA" && \
	cd /fivem && \
	wget "$FX_DOWNLOAD_URL" && \
	git clone https://github.com/citizenfx/cfx-server-data.git "$FX_PATH_DATA" && \
	wget https://file.dracomail.net/fivem/server.cfg -O "$FX_PATH_DATA"/server.cfg && \
	tar -xvf "$FX_ARCHIVE" -C "$FX_PATH" && \
	rm "$FX_ARCHIVE"

RUN chmod -R 775 "$FX_PATH"
RUN chmod -R 775 "$FX_PATH_DATA"

WORKDIR "$FX_PATH_DATA"

EXPOSE 30120
EXPOSE 30120/udp

CMD /fivem/fx-server/run.sh +exec server.cfg
