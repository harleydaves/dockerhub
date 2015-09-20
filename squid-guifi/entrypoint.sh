#!/bin/bash

# https://gist.github.com/pkuczynski/8665367
parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

# Parse YAML
eval $(parse_yaml config.yml "config_")

# Disallow access to localnet
sed -i "s/^acl localnet src/#acl localnet src/" /etc/squid3/squid.conf

# Add open ports
for port in $config_ports; do
    sed -i "/^#acl Safe_ports port 80/ a\acl Safe_ports port $port" /etc/squid3/squid.conf
done

# Add open SSL ports
for ssl_port in $config_ssl_ports; do
    sed -i "/^#acl Safe_ports port 80/ a\acl Safe_ports port $ssl_port" /etc/squid3/squid.conf
    sed -i "/^#acl SSL_ports port 443/ a\acl SSL_ports port $ssl_port" /etc/squid3/squid.conf
done

# Disable SSL access if not enabled
if [ -z $config_ssl_ports ]; then
    sed -i "s/^http_access deny CONNECT !SSL_ports/#http_access deny CONNECT !SSL_ports" /etc/squid3/squid.conf
fi

# SquidGuard configuration
if [ $config_squidguard = 'yes' ]; then
    echo url_rewrite_program /usr/bin/squidGuard -c /etc/squid3/squidGuard.conf >> /etc/squid3/squid.conf
    echo redirect_children 4 >> /etc/squid3/squid.conf
fi

# Permissions to STDOUT and STDERR
chown proxy.proxy /dev/stdout
chown proxy.proxy /dev/stderr

/usr/sbin/squid3 -Nd1 -f /etc/squid3/squid.conf
