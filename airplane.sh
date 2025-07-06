#!/bin/sh

ifdown 4g
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
/etc/init.d/firewall reload
sleep 1
ifup 4g
sleep 1
/etc/init.d/dnsmasq reload
