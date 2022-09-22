#!/bin/sh
#此为官方链接，请保留，方便反馈bug/下载新版
#https://github.com/feng1168/switchRouter
#Version: 1.7

sec_ipv4=192.168.6.2  #旁路由ipv4
sec_ipv6=             #旁路由ipv6

ping -W1 -c1 $sec_ipv4 >/dev/null 2>&1
if [ $? = 0 ]; then
  uci show dhcp.lan.dhcp_option | grep $sec_ipv4
  if [ $? = 0 ]; then
    printf "\033c"
    exit 0
  else
    printf "\033c"
    logger -s "switchRouter is running, switch to $sec_ipv4"
    uci set dhcp.lan.dhcp_option="3,$sec_ipv4"
    dns1=$(ubus call network.interface.wan status | grep -A1 "dns-server" | sed -n 2p | cut -d \" -f 2)
    uci add_list dhcp.lan.dhcp_option="6,$dns1,8.8.4.4"
    if [ -n "$sec_ipv6" ]; then
      uci set dhcp.lan.dns="$sec_ipv6"
      uci set dhcp.lan.ra_default=0
      uci set dhcp.cfg01411c.filter_aaaa=1 >/dev/null 2>&1
      uci set dhcp.cfg02411c.filter_aaaa=1 >/dev/null 2>&1
      /etc/init.d/odhcpd enable
      /etc/init.d/odhcpd stop >/dev/null 2>&1
      /etc/init.d/odhcpd start
    else
      uci set dhcp.cfg01411c.filter_aaaa=1 >/dev/null 2>&1
      uci set dhcp.cfg02411c.filter_aaaa=1 >/dev/null 2>&1
      /etc/init.d/odhcpd disable
      /etc/init.d/odhcpd stop >/dev/null 2>&1
    fi
    uci set mwan3.balanced.last_resort=default >/dev/null 2>&1
    uci commit mwan3 >/dev/null 2>&1
    uci commit dhcp
    /etc/init.d/dnsmasq restart >/dev/null 2>&1
  fi
else
  uci show dhcp.lan.dhcp_option | grep $sec_ipv4
  if [ $? = 1 ]; then
    printf "\033c"
    exit 0
  else
    printf "\033c"
    uci show network.lan.ipaddr | cut -d "'" -f 2
    if [ $? = 0 ]; then
      printf "\033c"
      ipv4=$(uci show network.lan.ipaddr | cut -d "'" -f 2)
    else
      printf "\033c"
      logger -s "switchRouter is running, No detected Router IP"
      exit 0
    fi
    logger -s "switchRouter is running, switch to $ipv4"
    uci set dhcp.lan.dhcp_option=""
    uci set dhcp.lan.dns=""
    uci set dhcp.lan.ra_default=0
    uci set dhcp.cfg01411c.filter_aaaa=0 >/dev/null 2>&1
    uci set dhcp.cfg02411c.filter_aaaa=0 >/dev/null 2>&1
    /etc/init.d/odhcpd enable
    /etc/init.d/odhcpd start
    uci set mwan3.balanced.last_resort=default >/dev/null 2>&1
    uci commit mwan3 >/dev/null 2>&1
    uci commit dhcp
    /etc/init.d/dnsmasq restart >/dev/null 2>&1
  fi
fi