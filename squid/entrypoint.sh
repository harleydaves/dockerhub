#!/bin/bash

# Permissions to STDOUT and STDERR
chown proxy.proxy /dev/stdout
chown proxy.proxy /dev/stderr

/usr/sbin/squid3 -Nd1 -f /etc/squid3/squid.conf
