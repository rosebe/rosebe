#!/bin/sh
curl -L -H "Cache-Control: no-cache" -O https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt

echo create china_routes hash:net family inet hashsize 2048 maxelem 9999 >> ipset-save-china-router.list

 while read ip;do
		
	echo add china_routes "$ip" >> ipset-save-china-router.list
		
 done  < china_ip_list.txt
