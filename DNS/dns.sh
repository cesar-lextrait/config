#!/bin/bash

# Installation de Bind
apt-get update && apt-get upgrade 
apt-get install bind9
apt-get bind9utils

systemctl stop bind9

ip_adress=$(hostname -I | awk '{print $1}')
domain_name="dnsproject.prepa.com"

echo "$ip_adress $domain_name" >> /etc/hosts

cat > /etc/bind/db.$domain_name <<EOF
\$TTL 604800
@ IN SOA $domain_name. root.$domain_name. (
    1 ; Serial
    604800 ; Refresh
    86400 ; Retry
    2419200 ; Expire
    604800 ) ; Negative Cache TTL
;
@ IN NS ns1$domain_name.
@ IN A $ip_adress
ns1 IN A $ip_adress
EOF

echo "zone \"$domain_name\" {
    type master;
    file \"/etc/bind/db.$domain_name\";
};" >> /etc/bind/named.conf.local

systemctl start bind9

ping -c 1 $domain_name