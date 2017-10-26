FROM debian:jessie
MAINTAINER DracoDragon88

# Install dependencies 
RUN apk --no-cache add curl sqlite unzip git

# Common
ENV FX_VERSION 401-7da138fa4851430482ff2fb4e196b871d5ea3efb
ENV FX_DOWNLOAD_URL https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$FX_VERSION/fx.tar.xz
ENV FX_USER cfx-server
ENV FX_PATH "/home/fx-server"
ENV FX_PATH_DATA "/home/fx-server-data"
ENV FX_ARCHIVE fx.tar.xz

# Container Setup
RUN adduser -D "$FX_USER" && \
	mkdir "$FX_PATH" && \
	mkdir "$FX_PATH_DATA" && \
	cd "$FX_PATH" && \
	cd .. && \
	curl -fsSL "$FX_DOWNLOAD_URL" -o "$FX_ARCHIVE" && \
	
RUN	git clone https://github.com/citizenfx/cfx-server-data.git "$FX_PATH_DATA"
RUN	wget http://file.dracomail.net/fivem/server.cfg -O "$FX_PATH_DATA"/server.cfg
RUN	tar -xvf "$FX_ARCHIVE" -C "$FX_PATH"
RUN	rm "$FX_ARCHIVE"


RUN chmod -R 775 "$FX_PATH"
RUN chmod -R 775 "$FX_PATH_DATA"
WORKDIR "$FX_PATH_DATA"

VOLUME ["$HatH_PATH/cache", "$HatH_PATH/data", "$HatH_PATH/download", "$HatH_PATH/hathdl"]

CMD /home/fx-server/run.sh +exec server.cfg
