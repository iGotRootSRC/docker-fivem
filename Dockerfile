FROM debian:jessie
MAINTAINER DracoDragon88

ENV MONO_VERSION 5.0.0.100

# Install dependencies 
RUN apt-get update \
  && apt-get install -y apt-utils git-core xz-utils curl \
  && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

RUN echo "deb http://download.mono-project.com/repo/debian jessie/snapshots/$MONO_VERSION main" > /etc/apt/sources.list.d/mono-xamarin.list \
  && apt-get update \
  && apt-get install -y binutils mono-devel ca-certificates-mono fsharp mono-vbnc nuget referenceassemblies-pcl \
  && rm -rf /var/lib/apt/lists/* /tmp/*

# Common
ENV FX_VERSION 495-0959df5797779152d3e9d71951f78240a47f999d
ENV FX_DOWNLOAD_URL https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$FX_VERSION/fx.tar.xz
ENV FX_RESOURCES_URL https://github.com/citizenfx/cfx-server-data.git
ENV FX_PATH "/fivem/fx-server"
ENV FX_PATH_DATA "/fivem/fx-server-data"
ENV FX_ARCHIVE fx.tar.xz
ENV FX_CONFIG https://file.dracomail.net/fivem/server.cfg
ENV FX_PORT 30120

# Container Setup
RUN mkdir /fivem && \
	mkdir "$FX_PATH" && \
	mkdir "$FX_PATH_DATA" && \
	mkdir /opt/cfx-server && \
	cd /fivem && \
	curl -fsSL "$FX_DOWNLOAD_URL" -o "$FX_ARCHIVE" && \
	git clone "$FX_RESOURCES_URL" "$FX_PATH_DATA" && \
	curl -fsSL "$FX_CONFIG" -o "$FX_PATH_DATA"/server.cfg && \
	tar -xvf "$FX_ARCHIVE" -C "$FX_PATH" && \
	rm "$FX_ARCHIVE"

RUN chmod -R 775 "$FX_PATH"
RUN chmod -R 775 "$FX_PATH_DATA"

WORKDIR "$FX_PATH_DATA"

EXPOSE "$FX_PORT"
EXPOSE "$FX_PORT"/udp

CMD /fivem/fx-server/run.sh +exec server.cfg
