#!/bin/bash
set -e
export TON_NODE_IP=$(curl -s https://ipinfo.io/ip)
source .env
docker compose build ton-api
NODE_API_KEY=$(docker run --rm -v $API_CONF_VOLUME:/conf -v $NODE_STATE_VOLUME:/liteserver ton-api -c "python /conf/generate-api-key.py")
sed -i "s~NODEAPIKEY~$NODE_API_KEY~g" ${API_CONF_VOLUME}/${API_NETWORK}-config-${API_MODE}.json

cp ${API_CONF_VOLUME}/${API_NETWORK}-config-${API_MODE}.json .