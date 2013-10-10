#!/bin/sh
# Basic web browsing and crawling, video streaming,
# ssh both ways and IRC with authentication on Freenode.
#
# TODO:
#       check rest of the icmp stuff.
#       ssh autoblock with hitcount ?
#
# Mind you, the actual iptables setup I use differs somewhat ;)

ipt=/usr/bin/iptables

# Flush, ie. delete, rules and userdefined chains.
$ipt -F
$ipt -X

$ipt -P INPUT DROP
$ipt -P OUTPUT DROP
$ipt -P FORWARD DROP # Not really necessary for us. Maybe.

# Handle the connection state and loopback.
$ipt -A INPUT -i lo -j ACCEPT
$ipt -A OUTPUT -o lo -j ACCEPT  # Perhaps loopback output not needed ?
$ipt -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
$ipt -A INPUT -p icmp --icmp-type 8 -m conntrack --ctstate NEW -j ACCEPT # allow ping
# Be these good for me ?
#iptables -A INPUT -p icmp –icmp-type destination-unreachable -j ACCEPT
#iptables -A INPUT -p icmp –icmp-type time-exceeded -j ACCEPT
#iptables -A INPUT -p icmp –icmp-type echo-request -j ACCEPT
#iptables -A INPUT -p icmp –icmp-type echo-reply -j ACCEPT
# Also handle bad packets.
$ipt -A INPUT -m conntrack --ctstate INVALID -j DROP

$ipt -A INPUT -p tcp -m conntrack --ctstate NEW -m tcp --dport ssh -j ACCEPT

$ipt -A OUTPUT -p tcp --dport http -j ACCEPT
$ipt -A OUTPUT -p tcp --dport 53 -j ACCEPT # DNS
$ipt -A OUTPUT -p udp --dport 53 -j ACCEPT
$ipt -A OUTPUT -p tcp --dport https -j ACCEPT
$ipt -A OUTPUT -p udp --dport https -j ACCEPT
$ipt -A OUTPUT -p tcp --dport www-http -j ACCEPT
$ipt -A OUTPUT -p tcp --sport ssh -j ACCEPT
$ipt -A OUTPUT -p tcp --dport 6697 -j ACCEPT # SSL/TLS on Freenode!

