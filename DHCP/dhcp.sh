apt-get update && apt-get upgrade

# Install DHCP server
apt-get install isc-dhcp-server

interface=$(ip route | grep default | awk '{print $5}')
ip_address=$(ip addr show dev $interface | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)

systemctl stop isc-dhcp-server

# Configure DHCP server
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.bak
cat <<EOF > /etc/dhcp/dhcpd.conf
subnet $ip_address netmask 255.255.255.0 {
    range $ip_address 192.168.1.50;
    option subnet-mask 255.255.255.0;
    option routers $ip_address;
    option domain-name-servers 8.8.8.8;
    default-lease-time 600;
    max-lease-time 7200;
}
EOF

# Configure DHCP server interface
cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.bak
cat <<EOF > /etc/default/isc-dhcp-server
INTERFACESv4="$interface"
EOF