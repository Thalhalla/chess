.PHONY: run build homedir
all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container

build: builddocker

run: rm rundocker

rundocker:
	$(eval NAME := $(shell cat NAME))
	@docker run --name=$(NAME) \
	-d \
	--cidfile=".chess.CID" \
	-t $(TAG)

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
