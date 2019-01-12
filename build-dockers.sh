#!/bin/bash
NAME=bfx-orders-fix42

function build_orders_fix42(){
  cd dockers/$NAME
  docker build -t $NAME .
  docker image tag $NAME $NAME:latest
  cd ~
}


function build_orders_fix42_no_cache(){

  cd dockers/$NAME
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