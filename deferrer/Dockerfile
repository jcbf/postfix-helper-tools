FROM ubuntu:16.04
MAINTAINER Jose Borges Ferreira <underspell@gmail.com>
RUN mkdir /usr/local/postfix
WORKDIR /usr/local/postfix

RUN apt-get -q update
RUN apt-get -q -y dist-upgrade
RUN apt-get install -y perl build-essential cpanminus
RUN cpanm Cache::FastMmap::Tie Test::More Test::Script Devel::Cover

COPY ./defer.pl /usr/local/postfix/
CMD  /usr/local/postfix/defer.pl

