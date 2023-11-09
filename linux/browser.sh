#! /bin/bash

# detect if parameter is a path to a file in the WSL filesystem
# if so, open this file in the default Windows browser

browser=/mnt/c/Program\ Files\ \(x86\)/Microsoft/Edge/Application/msedge.exe

if [[ -f $1 ]]; then
  "$browser" $(wslpath -w $1)
else
  "$browser" $1
fi
