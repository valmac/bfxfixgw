#!/bin/bash

NAME=bfx-orders-fix42
IMAGE=$NAME:latest
MOUNT_PATH=/path_to_fix_configs


function getID(){
  echo "get id.."
  docker inspect --format="{{.Id}}" $NAME
}
function start(){
  echo "start.."
  docker run -itd --volume $MOUNT_PATH:/fix_settings --name $NAME $IMAGE
}
function stop(){
  echo "stop.."
  docker stop $NAME
}
function rm(){
  echo "remove.."
  docker rm $(getID)
}
function pull(){
  echo "pull.."
  docker pull $IMAGE
}
function logs(){
  echo "logs.."
  docker logs $NAME
}
function inspect(){
  echo "inspect.."
  docker inspect $NAME
}  
case $1 in
  start)
    start
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
    ;;

  *)
    echo "usage: $NAME.sh {start|stop|stop-rm|rm|upgrade|pull|logs|inspect|id|name|image|config}" 
    ;;    
esac
exit 0
