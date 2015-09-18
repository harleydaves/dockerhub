FROM debian:stable
MAINTAINER David Rubert <david.rubert@gmail.com>

ENV SQUID_CACHE_DIR=/var/spool/squid3

RUN apt-get update -y && apt-get install --no-install-recommends -y -q squid3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sed -i s/'^# access_log daemon:\/var\/log\/squid3\/access.log'/'access_log stdio:\/var\/log\/squid3\/access.log'/ /etc/squid3/squid.conf
RUN sed -i s/'^# cache_log \/var\/log\/squid3\/cache.log'/'cache_log stdio:\/var\/log\/squid3\/cache.log'/ /etc/squid3/squid.conf
RUN sed -i "s/^#acl localnet/acl localnet/" /etc/squid3/squid.conf
RUN sed -i "s/^#http_access allow localnet/http_access allow localnet/" /etc/squid3/squid.conf

# Redirect logs to stdout for the container
RUN ln -sf /dev/stdout /var/log/squid3/access.log
RUN ln -sf /dev/null /var/log/squid3/store.log
RUN ln -sf /dev/stderr /var/log/squid3/cache.log

COPY entrypoint.sh /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
EXPOSE 3128/tcp
VOLUME ["${SQUID_CACHE_DIR}"]
