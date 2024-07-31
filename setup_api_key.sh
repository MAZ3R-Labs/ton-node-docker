#!/bin/bash
set -e
export TON_NODE_IP=$(curl -s https://ipinfo.io/ip)

ip2dec () {
    local a b c d ip=$@
    IFS=. read -r a b c d <<< "$ip"
    printf '%d\n' "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))"
}

source .env
docker compose build ton-api
NODE_API_KEY=$(docker run --rm -v $API_CONF_VOLUME:/conf -v $NODE_STATE_VOLUME:/liteserver ton-api -c "python /conf/generate-api-key.py")
IP_DEC=$(ip2dec ${TON_NODE_IP})
cp ${API_CONF_VOLUME}/${API_NETWORK}-config-${API_MODE}.json .
sed -i "s~NODEAPIKEY~$NODE_API_KEY~g" ./${API_NETWORK}-config-${API_MODE}.json
sed -i "s~2886860802~$IP_DEC~g" ./${API_NETWORK}-config-${API_MODE}.json
