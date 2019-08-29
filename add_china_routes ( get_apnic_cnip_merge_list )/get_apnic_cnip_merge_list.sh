#!/bin/sh

wget -c -O- 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > \
          ./china_ip_list.txt
		  
		  
./CIDR.sh < china_ip_list.txt > cnip-merge.txt

echo create china_routes hash:net family inet hashsize 2048 maxelem 9999 >> ipset-save-china-router.list

 while read ip;do
		
	echo add china_routes "$ip" >> ipset-save-china-router.list
		
 done  < cnip-merge.txt
