#!/bin/sh

if [ "$1" = "mysqld" ]; then
    if [ ! -d /var/lib/mysql/mysql ]; then
        echo 'Initializing database'
        mysql_install_db --user=mysql --rpm > /dev/null
        echo 'Database initialized'

        # Start MySQL
        "$@" --skip-networking &
        mysql_pid="$!"

        # Wait for MySQL to start
        for i in {30..0}; do
            if "/usr/bin/mysql --protocol=socket --user root -e 'SELECT 1'" &> /dev/null; then
                break
            fi
            echo 'MySQL init process in progress...'
            sleep 1
        done
        if [ "$i" = 0 ]; then
            echo >&2 'MySQL init process failed.'
            exit 1
        fi

        echo "Creating new user"
        /usr/bin/mysql --protocol=socket --user root << EOSQL
            SET @@SESSION.SQL_LOG_BIN=0;
            CREATE USER 'root'@'%';
            GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
            DROP DATABASE IF EXISTS test;
            FLUSH PRIVILEGES;
EOSQL

        # Stop MySQL
        if ! kill -s TERM "$mysql_pid" || ! wait "$mysql_pid"; then
            echo >&2 'MySQL init process failed.'
            exit 1
        fi

        echo
        echo 'MySQL init process done. Ready for start up.'
        echo
    fi
fi

exec "$@"
