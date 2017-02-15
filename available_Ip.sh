#!/bin/bash
IPaddr=192.168.120.
IPFILE=./arping.txt
UPIPaddr=./ipup.txt
DOWNIPaddr=./ipdown.txt
>$IPFILE
touch $DOWNIPaddr
touch $UPIPaddr
touch $IPFILE
for IP in {1..254}
do
echo $IPaddr$IP
arping -I em1 -c 1 $IPaddr$IP >>$IPFILE
done
echo UPIPADDR
echo " 
IPADDR            MAC ";  cat $IPFILE  |grep reply |awk '{print $4"    "$5}' |awk -F"[" '{print $1" "$2}' | awk -F"]" '{print $1"  "$2}' | column -t >$UPIPaddr
echo DOWNIPADDR
IPTMP=./ip.txt
IPTMP2=./ip2.txt
grep -v ^'[S|R]' $IPFILE |awk -FARPING '{print $2}'|awk -Ffrom '{print $1}' |column -t >$IPTMP
grep -v ^'[S|R]' $IPFILE |awk -F"Unicast reply from" '{print $2}'|awk '{print $1}'|uniq -c |awk '{print $2}' |uniq -c |awk '{print $2}'|column -t >$IPTMP2
cat $IPTMP $IPTMP2 |sort -t "." -k4,4n |uniq -u  >$DOWNIPaddr
VL=`wc -l $UPIPaddr |awk '{print $1}'`
VL2=`wc -l $DOWNIPaddr |awk '{print $1}'`
cat $UPIPaddr
echo 目前有$VL台主机为活动状态
cat $DOWNIPaddr |paste -s
echo 目前有$VL2个可用IP地址
