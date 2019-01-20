#!/bin/bash

APP=fix42-manager
OUT_FILE=$APP.out
PID_FILE=$APP.pid
CFG_DIR=~/go/src/github.com/bitfinexcom/bfxfixgw/conf/prod/service
CFG_FILE="orders_fix42.cfg"


function welcome(){
    echo "====================================="
    echo "   Bitfinex Fix42 GateWay manager"
    echo "====================================="
}
function get_pid(){
  if [ ! -f $PID_FILE ]; then
    echo "ERROR : PID_FILE not found! ($PID_FILE)"
    exit 1
  fi
  PID=`cat $PID_FILE`
}
function do_start(){
    echo "start.."
    export FIX_SETTINGS_DIRECTORY=$CFG_DIR
    ~/go/bin/bfxfixgw -orders -ordcfg $CFG_FILE -rest "https://api.bitfinex.com/v2/" -ws "wss://api.bitfinex.com/ws/2" &
    echo $! > $PID_FILE
    get_pid
    echo "PID = '$PID'"
    exit 0
}
function do_stop(){
    echo "stop.."
    get_pid
    PROCESS_EXISTS=`ps -ax | grep $PID | grep -v grep|wc -l`
    if [ $PROCESS_EXISTS == "0" ]; then
      echo "ERROR : PROCESS NOT FOUND BY PID ($PID)"
      exit 1
    fi

    echo "kill pid: $PID .."
    kill -9 $PID
    echo "remove $PID_FILE .."
    rm $PID_FILE
}
function do_status(){
    echo "status.."
    echo "config:      $CFG_DIR"
    echo "config file: $CFG_FILE"
    echo ""
    echo "grep search process: 'bfxfixgw'.."
    ps aux | grep bfxfixgw
    echo ""
    get_pid
    echo ""
    echo "pidfile:     $PID_FILE"
    echo "pid:         $PID"
}
function do_env(){
    echo "[env].."
    echo "   APP      = $APP"
    echo "   OUT_FILE = $OUT_FILE"
    echo "   PID_FILE = $PID_FILE"
    echo "   CFG_DIR  = $CFG_DIR"
    echo "   CFG_FILE = $CFG_FILE"
}


welcome

case $1 in
  start)
    do_start
    ;;
  stop)
    do_stop
    ;;
  restart)
    do_stop
    do_start
    ;;
  status)
    do_status
    ;;
  env)
    do_env
    ;;
  *)
    echo "Usage:"
    echo "      $APP.sh {start|stop|restart|status|env}"
    ;;
esac
