#!/bin/sh

#ifdown 4g
ifdown 4g
killall quectel-cm 2>/dev/null
killall 4gstat.sh 2>/dev/null
killall 4gup.sh 2>/dev/null
rm -rf /var/run/${IFACE}/running
rm -rf /var/run/${IFACE}/netreg
rm -rf /var/run/${IFACE}/simcheck
rm -rf /var/run/${IFACE}/getsim
rm -rf /var/run/${IFACE}/getimei
rm -rf /var/run/${IFACE}/geticcid
rm -rf /var/run/${IFACE}/getregsta
rm -rf /var/run/${IFACE}/retry
rm -rf /var/run/${IFACE}/ignore_data
sleep 1
echo -e "AT+CFUN=0\r" > "/dev/ttyUSB2"
sleep 1
echo -e "AT+CFUN=1\r" > "/dev/ttyUSB2"
sleep 1
echo -e "AT+CGREG?\r" > "/dev/ttyUSB2"
sleep 1
echo -e "AT+CGREG?\r" > "/dev/ttyUSB2"
sleep 1
echo -e "AT+CSQ\r" > "/dev/ttyUSB2"
sleep 1
echo -e "AT+COPS?\r" > "/dev/ttyUSB2"
sleep 1
echo -e "AT+QNWINFO\r" > "/dev/ttyUSB2"
sleep 1
echo -e "AT+QNETDEVCTL=1,1,1\r" > "/dev/ttyUSB2"
sleep 1
echo -e "AT+QNETDEVCTL?\r" > "/dev/ttyUSB2"
sleep 1
echo -e "AT+CGPADDR=1\r" > "/dev/ttyUSB2"
sleep 1
echo -e "AT+QCFG="nwscanmode",0\r" > "/dev/ttyUSB2"
sleep 1
#/etc/init.d/firewall reload
#sleep 1
ifup 4g
#sleep 1
#/etc/init.d/dnsmasq reload
