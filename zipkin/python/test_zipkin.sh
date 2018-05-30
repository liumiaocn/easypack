#!/bin/sh

usage(){
  echo "Usage: $0 ACTION"
  echo "       ACTION: start|stop|restart|status"
  echo ""
}

ACTION=$1

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

demo_file_list="A.py B.py C.py D.py E.py"

echo
echo "## Operation: $ACTION"
echo "## ${ACTION} begins ..."
if [ _"stop" = _"$ACTION" ]; then
  echo "## clear zipkin service"
  docker stop zipkin
  docker rm   zipkin

  echo "## before $ACTION action"
  sh $0 status 
  for file in $demo_file_list
  do
    pid=`ps -ef |grep -w python |grep "$file" |awk '{print $2}'`
    if [ _"" != _"$pid" ]; then
      kill -kill $pid
    fi 
  done
  sleep 3
  echo "## after $ACTION action"
  sh $0 status 
  echo "## ${ACTION} begins ..."
elif [ _"start" = _"$ACTION" ]; then
  echo "## start zipkin service"
  docker run --name zipkin -d -p 9411:9411 openzipkin/zipkin 

  echo "## before $ACTION action"
  sh $0 status 
  for file in $demo_file_list
  do
    python "$file" &
  done
  sleep 3
  echo "## after $ACTION action"
  sh $0 status 
elif [ _"status" = _"$ACTION" ]; then
  for file in $demo_file_list
  do
    echo "demo process: $file  "
    ps -ef |grep python |grep "$file" 
  done
elif [ _"restart" = _"$ACTION" ]; then
  sh $0 stop
  sh $0 start
fi
echo "## ${ACTION} ends..."
