# docktorrent

Using [Docker](https://www.docker.com/),
[rTorrent](http://rakshasa.github.io/rtorrent/) and
[ruTorrent](https://github.com/Novik/ruTorrent) to run a full-featured
BitTorrent box.

## Highlights

  - Newest version of rTorrent and ruTorrent, with support of DHT and
    asynchronous DNS which will result in a more responsive rTorrent.
  - Enable all useful ruTorrent plugins by default.
  - All-in-one Docker container, build once and run everywhere.
  - rTorrent will automatic restarts on crash.
  - With a working configuration by default, give it a quick try and tune the
    configs later.

## Quick Start

Clone this repository and build the image yourself:
```bash
git clone https://github.com/kfei/docktorrent
cd docktorrent
docker build -t docktorrent .
```

On a slow machine, the building process may take some time. You can just pull
a pre-built image:
```bash
docker pull kfei/docktorrent
```

Now run the docktorrent container:
```bash
docker run -it \
    -p 80:80 -p 45566:45566 -p 9527:9527/udp \
    --dns 8.8.8.8 \
    -v /data-store:/rtorrent \
    docktorrent
```
Note that:
  - The exposed ports are required for ruTorrent web interface, rTorrent
    listening and the DHT protocol according to your `.rtorrent.rc`.
  - The `--dns 8.8.8.8` argument is optional but recommended. It seems like the
    current version of rTorrent still has some [DNS
    issues](https://github.com/rakshasa/rtorrent/issues/180), using Google's
    DNS may help.
  - The `/data-store` volume is for all downloads, torrents and session data,
    just make sure the disk space is enough.

If the container starts without errors, visit `http://127.0.0.1` through any web
browser, log in to with the default account: `docktorrent/p@ssw0rd`.

Happy seeding!

## Requirement

All you need is to have Docker installed on your system. Check [Docker
Documentation](https://docs.docker.com/installation/) for installation guide on
your OS platform.

## Screenshots

![IMAGE](http://i.imgur.com/CHHYIRR.png)
