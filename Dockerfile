FROM ubuntu:xenial
MAINTAINER Josh Cox <josh 'at' webhosting coop>

ENV LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8 \
  DEBIAN_FRONTEND=noninteractive \
  CHESS_UPDATED=20170708

COPY sources.list /etc/apt/sources.list.d/thalhalla.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F24AEA9FB05498B7 && \
useradd chess && \
mkdir -p /home/chess && \
chown -R chess:chess /home/chess && \
dpkg --add-architecture i386 && \
apt-get -yqq update && \
apt-get install -yqq locales && \
dpkg-reconfigure --frontend=noninteractive locales && \
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
locale-gen && \
apt-get install -yqq \
pychess \
stockfish \
crafty \
crafty-books-medium && \
rm -rf /var/lib/apt/lists/*

# End non-interactive apt
ENV DEBIAN_FRONTEND=interactive

USER chess
WORKDIR /home/chess/

CMD ["/usr/game/pychess"]
