#!/bin/sh

ipt=/usr/bin/iptables

# Flush, ie. delete, rules and userdefined chains.
$ipt -P INPUT DROP
$ipt -P FORWARD DROP
$ipt --flush
$ipt --delete-chain

$ipt -P INPUT DROP
$ipt -P FORWARD DROP
$ipt -P OUTPUT ACCEPT

# Handle the connection state and localhost.
$ipt -A INPUT -i lo -j ACCEPT
$ipt -A OUTPUT -o lo -j ACCEPT
$ipt -A INPUT -m conntrack --ctstate "ESTABLISHED,RELATED" -j ACCEPT
$ipt -A INPUT -m conntrack --ctstate INVALID -j DROP # Also handle bad packets.
$ipt -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
$ipt -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
$ipt -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
$ipt -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT

$ipt -A INPUT -p tcp --dport ssh -j ACCEPT
$ipt -A INPUT -p tcp --dport http -j ACCEPT
$ipt -A INPUT -p tcp --dport https -j ACCEPT
$ipt -A INPUT -p tcp --dport www-http -j ACCEPT
$ipt -A INPUT -p tcp --dport 6697 -j ACCEPT

#iptables-save|tee /etc/iptables/iptables.rules
#systemctl reload iptables
#systemctl status iptables
