# Update geoip.dat
GEOIP_TAG=$(curl --silent "https://api.github.com/repos/v2ray/geoip/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -L -o /root/geoip.dat-$(date "+%Y_%m_%d_%H:%M:%S") "https://github.com/v2ray/geoip/releases/download/${GEOIP_TAG}/geoip.dat"