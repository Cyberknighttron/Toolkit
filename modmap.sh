#!/bin/bash

file="$1"
ext="${file##*.}"

case "$ext" in
  py)  bash Modules/modmap-python.sh "$file" ;;
  java) bash Modules/modmap-java.sh "$file" ;;
  cpp) bash Modules/modmap-cpp.sh "$file" ;;
  c)   bash Modules/modmap-c.sh "$file" ;;
  js)  bash Modules/modmap-js.sh "$file" ;;
  sh)  bash Modules/modmap-sh.sh "$file" ;;
  *)
    echo "❌ Unsupported file extension: .$ext"
    exit 1
    ;;
esac

