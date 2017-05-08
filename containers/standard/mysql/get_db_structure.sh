#!/bin/sh
usage(){
  echo "sh $0 DBNAME USERNAME USERPASS"
  echo ""
}

DATABASE_NAME="$1"
USERNAME="$2"
USERPASS="$3"

if [ $# -ne 3 ]; then
  usage
  exit 1
fi

TABLE_LIST=`mysql -u${USERNAME} -p${USERPASS} -e "use ${DATABASE_NAME}; show tables" |grep -v Tables_in_ 2>/dev/null`
for table in $TABLE_LIST
do
  echo "$table"
  mysql -u${USERNAME} -p${USERPASS} -e "use ${DATABASE_NAME}; desc $table" 2>/dev/null
  echo
done
