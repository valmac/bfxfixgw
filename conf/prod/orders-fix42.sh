#!/bin/bash

APP=orders-fix42
OUT_FILE=$APP.out
PID_FILE=$APP.pid
CFG_DIR=~/go/src/github.com/bitfinexcom/bfxfixgw/conf/prod/service
CFG_FILE="orders_fix42.cfg"

function welcome(){
    echo "====================================="
    echo "Bitfinex Fix42 ORDERS GateWay manager"
    echo "====================================="
}

function get_pid(){
  if [ ! -f $PID_FILE ]; then
    echo "ERROR : PID_FILE not found! ($PID_FILE)"
    exit 1
  fi  
  PID=`cat $PID_FILE`
}

welcome

case $1 in
  start)
    echo "start.."    
    export FIX_SETTINGS_DIRECTORY=$CFG_DIR
    ~/go/bin/bfxfixgw -orders -ordcfg "orders_fix42.cfg" -rest "https://api.bitfinex.com/v2/" -ws "wss://api.bitfinex.com/ws/2" &       
    echo $! > $PID_FILE
    get_pid
    echo "PID = '$PID'"
    exit 0
    ;;
    
  stop)
    echo "stop.."       
    get_pid
    echo "pid=$PID"
    PROCESS_EXISTS=`ps -ax | grep $PID | grep -v grep|wc -l`
    if [ $PROCESS_EXISTS == "0" ]; then
      echo "ERROR : PROCESS NOT FOUND BY PID ($PID)"
      exit 1
    fi
    
    echo "kill pid: $PID"
    kill -9 $PID
    echo "remove $PID_FILE.."
    rm $PID_FILE 
    ;;

  status)
    echo "status.."
    echo "config:      $CFG_DIR"
    echo "config file: $CFG_FILE"
    get_pid
    echo "pidfile:     $PID_FILE"
    echo "pid:         $PID"
    echo ""
    
    echo "grep search process: 'bfxfixgw'.."
    ps aux | grep bfxfixgw    
    ;;
    
  *)
    
    echo "Usage:"
    echo "      $APP.sh {start|stop|status}"
    ;;
esac
