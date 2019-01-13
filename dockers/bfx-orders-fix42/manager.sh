#!/bin/bash

HOST_IP=127.0.0.1
PORT=5002
NAME=bfx-orders-fix42
IMAGE=$NAME:latest
FIX_SETTINGS=/fix_settings
FIX_LOGS=/fix_logs


function getID(){  
  docker inspect --format="{{.Id}}" $NAME
}
function start(){
  echo "[start].."
  docker run -itd -v $FIX_SETTINGS:/fix_settings -v $FIX_LOGS:/fix_logs -p $HOST_IP:$PORT:5002 -e DEBUG=1  --name $NAME $IMAGE $NAME $IMAGE
}
function run(){
  echo "[run].."
  docker run -it -v $FIX_SETTINGS:/fix_settings -v $FIX_LOGS:/fix_logs -p $HOST_IP:$PORT:5002 -e DEBUG=1  --name $NAME $IMAGE $IMAGE
}
function stop(){
  echo "[stop].."
  docker stop $NAME
}
function rm(){
  echo "[remove].."
  docker rm $(getID)
}
function pull(){
  echo "[pull].."
  docker pull $IMAGE
}
function logs(){
  echo "[logs].."
  docker logs $NAME
}
function inspect(){
  echo "[inspect].."
  docker inspect $NAME
}
case $1 in
  start)
    start
    ;;
  run)
    run
    ;;
  stop)
    stop
    ;;
  stop-rm)
    stop
    rm
    ;;
  rm)
    rm
    ;;  
  upgrade)
    pull
    stop
    rm
    start
    ;;
  pull)
    pull
    ;;
  logs)
    logs
    ;;    
  inspect)
    inspect
    ;;
  id)
    echo $(getID)
    ;;
  name)
    echo $NAME
    ;;
  image)
    echo $IMAGE
    ;;
  env)
    echo "[env vars].."
    echo "       ID         = $(getID)"
    echo "       NAME       = $NAME"
    echo "       IMAGE      = $IMAGE"
    echo "       MOUNT_PATH = $MOUNT_PATH"
    echo "       HOST_IP    = $HOST_IP"
    echo "       PORT       = $PORT"
    ;;
  help)
    echo "[help] commands:"
    echo "    start      start new container (detached mode)"
    echo "    run        start new container (output to console)"
    echo "    stop       stop runned container"
    echo "    stop-rm    stop and remove runned container"
    echo "    rm         remove exist container"
    echo "    upgrade    pull -> stop -> remove -> start container"
    echo "    pull       pull image"
    echo "    logs       show logs of started container"
    echo "    inspect    inspect to container"
    echo "    id         print id"
    echo "    name       print name"
    echo "    image      print image id"
    echo "    env        print env vars"
    ;;
  *)
    echo "usage: $NAME.sh {start|run|stop|stop-rm|rm|upgrade|pull|logs|inspect|id|name|image|env|help}" 
    ;;    
esac
exit 0
