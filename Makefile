## For more examples of a Makefile based Docker container deployment see: https://github.com/ypid/docker-makefile

DOCKER_RUN_OPTIONS ?= --env "TZ=Europe/Berlin"

image_bittorrent        ?= kfei/bittorrent

.PHONY: default build build-dev run bittorrent

default: run

build:
	docker build --no-cache=true --tag $(image_bittorrent) .

build-dev:
	docker build --no-cache=false --tag $(image_bittorrent) .

run: bittorrent

bittorrent:
	-@docker rm --force "$@"
	docker run --interactive --tty \
		--name "$@" \
		$(DOCKER_RUN_OPTIONS) \
		--publish 80:80 \
		--publish 45566:45566 \
		--publish 9527:9527/udp \
		--volume /srv/bittorrent:/rtorrent \
		$(image_bittorrent)
