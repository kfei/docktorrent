# docktorrent

Using Docker, rTorrent and ruTorrent to run a full-featured BitTorrent box.

## Quick Start

Build the image yourself:
```bash
git clone https://github.com/kfei/docktorrent
docker build -t docktorrent
```

On a slow machine, the building process can take some time. Just pull a
pre-built image by:
```bash
docker pull kfei/docktorrent
```

Now run the docktorrent container:
```bash
docker run -it \
    -p 80:80 -p 45566:45566 -p 9527:9527/udp \
    -v /data-store:/rtorrent \
    docktorrent
```
Note that the expose ports are required for ruTorrent web interface, rTorrent
listening and the DHT protocol, according to your `.rtorrent.rc`. The
`/data-store` volume is for all downloads, torrents and session data, just make
sure the disk space is enough.

If the container starts without errors, visit `http://127.0.0.1` through any web
browser, log in to with default account: `docktorrent/p@ssw0rd`. Happy seeding!

## Screenshots

![IMAGE](http://i.imgur.com/CHHYIRR.png)
