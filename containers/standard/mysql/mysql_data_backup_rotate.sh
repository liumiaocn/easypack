#!/bin/sh

usage(){
echo "Usage : $0 ACTION SCHEMA [TABLE]"
echo "        ACTION:  backup/restore"
echo "        SCHEMA:  database name"
echo "        [TABLE]: table name"
echo ""
}

ACTION=$1
SCHEMA=$2
TABLE=$3

DATE_TIMESTAMP=`date +%Y%m%d%H%M%S`
BACKUP_DATA_DIR=/var/lib/mysql/backup
BACKUP_FILE_NAME=devops-backup-data-${DATE_TIMESTAMP}.sql
BACKUP_KEEP_DAYS=14
DATABASE_SCHEMA=${SCHEMA}

DATABASE_USER=root
DATABASE_PASSWORD=liumiaocn

if [ _"${DATABASE_USER}" = _"" -o _"${DATABASE_PASSWORD}" = _"" ]; then
  echo "Please make sure that DATABASE_USER and DATABASE_PASSWORD exported in advance"
  exit
fi

# create backup dir when not exist
mkdir -p ${BACKUP_DATA_DIR}

# change dir
cd ${BACKUP_DATA_DIR}

# backup data by using mysqldump
mysqldump -u ${DATABASE_USER} -p${DATABASE_PASSWORD} ${DATABASE_SCHEMA} > ${BACKUP_FILE_NAME}

# gzip file
gzip ${BACKUP_FILE_NAME}

# clear old files before ${BACKUP_KEEP_DAYS} days
find ${BACKUP_DATA_DIR} -mtime +${DAY_ROTATE} -name '*.sql.gz' |xargs rm -f
