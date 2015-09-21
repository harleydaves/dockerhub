FROM debian:jessie
MAINTAINER David Rubert <david.rubert@gmail.com>

RUN apt-get update -y && apt-get install --no-install-recommends -y -q squid3 squidguard vim \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /config

COPY entrypoint.sh /sbin/entrypoint.sh
COPY squid.conf.template /config/squid.conf.template

ENTRYPOINT ["/sbin/entrypoint.sh"]
EXPOSE 3128/tcp
