FROM debian:testing
MAINTAINER David Rubert <david.rubert@gmail.com>

ENV SQUID_CACHE_DIR=/var/spool/squid

RUN apt-get update -y && apt-get install --no-install-recommends -y -q squid \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN sed -i s/'^# access_log daemon:\/var\/log\/squid/access.log squid'/'access_log syslog squid'/ /etc/squid/squid.conf

# Redirect logs to stdout for the container
RUN ln -sf /dev/stdout /var/log/squid/access.log
RUN ln -sf /dev/stdout /var/log/squid/store.log
RUN ln -sf /dev/stdout /var/log/squid/cache.log

ENTRYPOINT ["/usr/sbin/squid", "-Nd1", "-f",  "/etc/squid/squid.conf"]
EXPOSE 3128/tcp
VOLUME ["${SQUID_CACHE_DIR}"]
