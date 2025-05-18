#!/bin/bash

# wait for system to fully boot
sleep 30

# unblock wireless if blocked
rfkill unblock all

# bring up wireless interface
ip link set wlan0 up

# restart services in correct order
systemctl restart dhcpcd
sleep 5
systemctl restart dnsmasq
systemctl restart hostapd
systemctl restart nginx

# set up iptables rules
iptables -t nat -F PREROUTING
iptables -t nat -A PREROUTING -s 192.168.4.0/24 -p tcp --dport 80 -j DNAT --to-destination 192.168.4.1:80
iptables -t nat -A PREROUTING -s 192.168.4.0/24 -p tcp --dport 443 -j DNAT --to-destination 192.168.4.1:80
netfilter-persistent save

exit 0