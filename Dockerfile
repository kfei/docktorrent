FROM ubuntu

MAINTAINER kfei "kfei@kfei.net"

ENV VER_LIBTORRENT 0.13.4
ENV VER_RTORRENT 0.9.4
ENV VER_RUTORRENT 3.6

RUN apt-get update && apt-get install -q -y \
    automake \
    build-essential \
    libc-ares-dev \
    libcppunit-dev \
    libtool \
    libssl-dev \
    libxml2-dev \
    libncurses5-dev \
    nginx \
    php5-cli \
    php5-fpm \
    pkg-config \
    subversion \
    wget

WORKDIR /usr/local/src

# Install cURL
RUN wget http://curl.haxx.se/download/curl-7.39.0.tar.gz && \
    tar xzvfp curl-7.39.0.tar.gz && \
    cd curl-7.39.0 && \
    ./configure --enable-ares --with-gnu-tls --enable-tls-srp --with-zlib --with-ssl && \
    make && \
    make install && \
    cd .. && \
    rm -rf curl-* && \
    ldconfig

# Install xmlrpc-c
RUN svn checkout https://svn.code.sf.net/p/xmlrpc-c/code/stable/ xmlrpc-c && \
    cd xmlrpc-c && \
    ./configure --enable-libxml2-backend --disable-abyss-server --disable-cgi-server && \
    make && \
    make install && \
    cd .. && \
    rm -rf xmlrpc-c && \
    ldconfig

# Install libTorrent
RUN wget http://libtorrent.rakshasa.no/downloads/libtorrent-$VER_LIBTORRENT.tar.gz && \
    tar xzf libtorrent-$VER_LIBTORRENT.tar.gz && \
    cd libtorrent-$VER_LIBTORRENT && \
    ./autogen.sh && \
    ./configure --with-posix-fallocate && \
    make && \
    make install && \
    cd .. && \
    rm -rf libtorrent-* && \
    ldconfig

# Install rTorrent
RUN wget http://libtorrent.rakshasa.no/downloads/rtorrent-$VER_RTORRENT.tar.gz && \
    tar xzf rtorrent-$VER_RTORRENT.tar.gz && \
    cd rtorrent-$VER_RTORRENT && \
    ./autogen.sh && \
    ./configure --with-xmlrpc-c && \
    make && \
    make install && \
    cd .. && \
    rm -rf rtorrent-* && \
    ldconfig

WORKDIR /usr/share/nginx/html

# Install ruTorrent
RUN wget http://dl.bintray.com/novik65/generic/rutorrent-$VER_RUTORRENT.tar.gz && \
    wget http://dl.bintray.com/novik65/generic/plugins-$VER_RUTORRENT.tar.gz && \
    tar xzvpf rutorrent-$VER_RUTORRENT.tar.gz && \
    tar xzvpf plugins-$VER_RUTORRENT.tar.gz -C rutorrent/

ADD config/nginx/default /etc/nginx/sites-available/default
ADD config/rtorrent/.rtorrent.rc /root/.rtorrent.rc
ADD config/rutorrent/config.php /usr/share/nginx/html/rutorrent/conf/config.php

EXPOSE 80 443 9527

VOLUME ["/rtorrent", "/usr/share/nginx/html/rutorrent/share"]
