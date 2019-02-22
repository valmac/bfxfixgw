#!/bin/bash

function build(){
  echo "build.."
  echo "GOOS=$GOOS GOARCH=$GOARCH"
  go build 
}

case $1 in
    linux32)
      echo "linux32 build.."
      export GOOS=linux
      export GOARCH=386
      echo "GOOS=$GOOS GOARCH=$GOARCH"
      build
      ;;
    linux64)
      echo "linux64 build.."
      export GOOS=linux
      export GOARCH=amd64      
      echo "GOOS=$GOOS GOARCH=$GOARCH"
      build
      ;;
    win32)
      echo "windows32 build.."
      export GOOS=windows
      export GOARCH=386
      echo "GOOS=$GOOS GOARCH=$GOARCH"
      build
      ;;
    win64)
      echo "windows64 build.."
      export GOOS=windows
      export GOARCH=amd64
      echo "GOOS=$GOOS GOARCH=$GOARCH"
      build
      ;;
    env)
      echo "GOOS=$GOOS GOARCH=$GOARCH"
      ;;
    *)
      echo "Usage: build.sh {linux32|linux64|win32|win64|env}"
      ;;
esac