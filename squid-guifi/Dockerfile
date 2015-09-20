FROM debian:jessie
MAINTAINER David Rubert <david.rubert@gmail.com>

RUN apt-get update -y && apt-get install --no-install-recommends -y -q squid3 squidguard vim \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Redirect logs for the container
RUN ln -sf /dev/stdout /var/log/squid3/access.log
RUN ln -sf /dev/stderr /var/log/squid3/cache.log

COPY entrypoint.sh /sbin/entrypoint.sh
COPY config.yml /config.yml

ENTRYPOINT ["/sbin/entrypoint.sh"]
EXPOSE 3128/tcp
