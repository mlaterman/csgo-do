#!/usr/bin/bash -e

pushd terraform/csgo
HOST=$(terraform output server_ip)
DOMAIN=$(terraform output domain)
popd

echo "[csgo]"         > hosts
echo $HOST            >> hosts
echo ""               >> hosts
echo "[csgo:vars]"    >> hosts
echo "domain=$DOMAIN" >> hosts
