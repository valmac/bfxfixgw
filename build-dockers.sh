#!/bin/bash

function build_orders_fix42(){
  NAME=bfx-fix42-ord
  cd dockers/orders-fix42
  docker build -t $NAME .
  docker image tag $NAME $NAME:latest
  cd ~
}


function build_orders_fix42_no_cache(){
  NAME=bfx-fix42-ord
  cd dockers/orders-fix42
  docker build --no-cache -t $NAME .
  docker image tag $NAME $NAME:latest
  cd ~
}
case $1 in

  orders)
    build_orders_fix42
    ;;
    
  orders-nocache)
    build_orders_fix42_no_cache
    ;;
  
    
  *)
    echo "Usage: build-dockers.sh {orders|orders-nocache}"
    ;;
esac