#!/bin/bash
set -e

build_all () {
  docker compose build ton-node
}

add_node_assets () {
  mkdir -p $NODE_STATE_VOLUME
  cp -a config/node-assets/. $NODE_STATE_VOLUME
}

deploy_node () {
  docker compose up -d ton-node
  sleep 5
}
export TON_NODE_IP=$(curl -s https://ipinfo.io/ip)
source .env
build_all
add_node_assets
deploy_node