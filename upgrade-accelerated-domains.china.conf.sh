#!/bin/sh



wget -c --no-check-certificate https://github.com/felixonmars/dnsmasq-china-list/raw/master/accelerated-domains.china.conf \
     -O /etc/accelerated-domains.china-$(date "+%Y_%m_%d_%H:%M:%S").conf
