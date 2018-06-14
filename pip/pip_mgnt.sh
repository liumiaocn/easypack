#!/bin/sh

usage(){
  echo "Usage: $0 ACTION MODULE"
  echo "       ACTION: install|uninstall|show|check"
  echo "       MODULE: module name, eg: pip|tensorflow|numpy|matplotlib"
  echo ""
}

ACTION="$1"
MODULE="$2"

if [ $# -ne 2 ]; then
  echo "## parameters not enough"
  usage
  exit 1
fi

date

#check action type
if [ _"$ACTION" != _"install" -a \
     _"$ACTION" != _"uninstall" -a \
     _"$ACTION" != _"show" -a \
     _"$ACTION" != _"check" ]; then
  echo "## ACTION type not correct"
  usage
  exit
fi

echo "## Begin to [$ACTION] module [$MODULE]"
if [ _"$MODULE" = _"pip" ]; then
  echo "## download pip install script"
  curl "https://bootstrap.pypa.io/get-pip.py" -o /tmp/get-pip.py
  echo "## begin install pip"
  python /tmp/get-pip.py
  echo
  echo "## confirm version:"
  pip --version
else
  pip $ACTION $MODULE
  echo "## confirm module detail"
fi

echo "## End to install module [$MODULE]"
date
