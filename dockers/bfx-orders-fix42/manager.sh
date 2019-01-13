#!/bin/bash

HOST_IP=127.0.0.1
PORT=5002
NAME=bfx-orders-fix42
IMAGE=$NAME:latest
MOUNT_PATH=/path_to_fix_configs


function getID(){  
  docker inspect --format="{{.Id}}" $NAME
}
function start(){
  echo "[start].."
  docker run -itd --volume $MOUNT_PATH:/fix_settings -p $HOST_IP:$PORT:5002 -e DEBUG=1  --name $NAME $IMAGE
}
function run(){
  echo "[run].."
  docker run -it --volume $MOUNT_PATH:/fix_settings -p $HOST_IP:$PORT:5002 -e DEBUG=1  --name $NAME $IMAGE
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
   
  config)
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
    echo "    run        start new container (interactive mode)"
    echo "    stop	 stop runned container if exists"
    echo "    stop-rm    stop and remove runned container if exists"
    echo "    rm	 remove exist container"
    echo "    upgrade    stop remove pull start contaner"
    echo "    pull       pull image"
    echo "    logs       show logs of started container"
    echo "    inspect    inspect to container"
    echo "    id         print id"
    echo "    name       print name"
    echo "    image      print image id"
    echo "    config     print env"
    ;;
  *)
    echo "usage: $NAME.sh {start|run|stop|stop-rm|rm|upgrade|pull|logs|inspect|id|name|image|config}" 
    ;;    
esac
exit 0
