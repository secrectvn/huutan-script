#!/bin/bash
# DIR 
EZ_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EZ_DATA=/root/ezlite
MN_DIR=/root/masternode
# SOURCE 
for assets in $EZ_DIR/assets/*.ezs ; do source $assets; done
