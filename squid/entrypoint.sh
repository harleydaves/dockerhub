#!/bin/bash

# Permissions to STDOUT
chmod 666 /proc/self/fd/1

# Permissions to STDERR
chmod 666 /proc/self/fd/2

/usr/sbin/squid3 -Nd1 -f /etc/squid3/squid.conf
