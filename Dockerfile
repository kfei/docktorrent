FROM debian:jessie

MAINTAINER kfei <kfei@kfei.net>

WORKDIR /usr/local/src

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install --assume-yes \
        ca-certificates \
        curl \
        rtorrent \
        wget \
        apache2-utils \
        nginx \
        php5-cli \
        php5-fpm \
        mediainfo \
        unrar-free \
        unzip

RUN set -x && \
    mkdir --parent /usr/share/nginx/html && \
    cd /usr/share/nginx/html && \
    mkdir rutorrent && \
    curl --location --remote-name https://github.com/Novik/ruTorrent/archive/master.tar.gz && \
    tar --extract --gzip --file master.tar.gz --directory rutorrent --strip-components 1 && \
    rm -rf *.tar.gz

# For ffmpeg, which is required by the ruTorrent screenshots plugin
# This increases ~53 MB of the image size, remove it if you really don't need screenshots
RUN echo "deb http://www.deb-multimedia.org jessie main" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -q -y --force-yes --no-install-recommends \
    deb-multimedia-keyring \
    ffmpeg

# IMPORTANT: Change the default login/password of ruTorrent before build
RUN htpasswd -cb /usr/share/nginx/html/rutorrent/.htpasswd docktorrent p@ssw0rd

# Copy config files
COPY config/nginx/default /etc/nginx/sites-available/default
COPY config/rtorrent/.rtorrent.rc /root/.rtorrent.rc
COPY config/rutorrent/config.php /usr/share/nginx/html/rutorrent/conf/config.php

# Add the s6 binaries fs layer
ADD s6-1.1.3.2-musl-static.tar.xz /

# Service directories and the wrapper script
COPY rootfs /

# Run the wrapper script first
ENTRYPOINT ["/usr/local/bin/docktorrent"]

# Declare ports to expose
EXPOSE 80 9527 45566

# Declare volumes
VOLUME ["/rtorrent", "/var/log"]

# This should be removed in the latest version of Docker
ENV HOME /root
