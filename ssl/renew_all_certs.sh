#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

. $DIR/config

echo "renew for domains $DOMAINS"
echo "store challege in $SERVE_DIR"

mkdir -p $SERVE_DIR && $DIR/../letsencrypt/letsencrypt-auto --renew certonly --server $SERVER -a webroot --webroot-path=$SERVE_DIR --agree-tos $DOMAINS

nginx -s reload