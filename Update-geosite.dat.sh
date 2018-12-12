# Update geosite.dat

GEOIP_TAG=$(curl --silent "https://api.github.com/repos/v2ray/domain-list-community/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -L -o release/config/geosite.dat "https://github.com/v2ray/domain-list-community/releases/download/${GEOIP_TAG}/dlc.dat"
