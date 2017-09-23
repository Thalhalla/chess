.PHONY: run build homedir
all: run

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container

build: builddocker

run: rm rundocker

rundocker: CONFIG
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval CONFIG := $(shell cat CONFIG))
	@docker run --name=$(NAME) \
	-d \
	--cidfile=".chess.CID" \
	-v $(CONFIG):/home/chess/.config \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$(DISPLAY) \
	--device /dev/snd \
	--device /dev/dri \
	--device /dev/bus/usb \
	-t $(TAG) \
	/usr/games/pychess

builddocker:
	$(eval TAG := $(shell cat TAG))
	/usr/bin/time -v docker build -t $(TAG) .

beep:
	@echo "beep"
	@aplay /usr/share/sounds/alsa/Front_Center.wav

kill:
	-@docker kill `cat .chess.CID`

rm-image:
	-@docker rm `cat .chess.CID`
	-@rm .chess.CID

rm: kill rm-image

clean:  rm

logs:
	docker logs  -f `cat .chess.CID`

enter:
	docker exec -i -t `cat .chess.CID` /bin/bash

pull:
	$(eval TAG := $(shell cat TAG))
	docker pull $(TAG)

CONFIG:
	echo '/tmp/config' > CONFIG
	@echo 'To persist `echo /PATH/TO/config > CONFIG`'
