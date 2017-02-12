#!/bin/sh
set -e

case "$1" in
	rails|rake)
		if [ ! -f './config/database.yml' ]; then
			if [ "$MYSQL_PORT_3306_TCP" ]; then
				adapter='mysql2'
				host='mysql'
				port="${MYSQL_PORT_3306_TCP_PORT:-3306}"
				username="${MYSQL_ENV_MYSQL_USER:-root}"
				password="${MYSQL_ENV_MYSQL_PASSWORD:-$MYSQL_ENV_MYSQL_ROOT_PASSWORD}"
				database="${MYSQL_ENV_MYSQL_DATABASE:-${MYSQL_ENV_MYSQL_USER:-redmine}}"
				encoding=
			else
				echo >&2 'warning: missing MYSQL_PORT_3306_TCP environment variables'
				echo >&2 '  Did you forget to --link some_mysql_container:mysql?'
				echo >&2
				echo >&2 '*** Using sqlite3 as fallback. ***'

				adapter='sqlite3'
				host='localhost'
				username='redmine'
				database='sqlite/redmine.db'
				encoding=utf8

				mkdir -p "$(dirname "$database")"
				chown -R redmine:redmine "$(dirname "$database")"
			fi

			cat > './config/database.yml' <<-YML
				$RAILS_ENV:
				  adapter: $adapter
				  database: $database
				  host: $host
				  username: $username
				  password: "$password"
				  encoding: $encoding
				  port: $port
			YML
		fi

		if [ ! -f './config/configuration.yml' ]; then
			if [ "$REDMINE_GOOGLE_USER" ]; then
				username="${REDMINE_GOOGLE_USER}"
				password="${REDMINE_GOOGLE_PASSWORD}"

				if [ "$REDMINE_GOOGLEAPPS_DOMAIN" ]; then
					domain="${REDMINE_GOOGLEAPPS_DOMAIN}"
				else
					domain="smtp.gmail.com"
				fi

				cat > './config/configuration.yml' <<-YML
				$RAILS_ENV:
					  email_delivery:
					    delivery_method: :smtp
					    smtp_settings:
					      enable_starttls_auto: true
					      address: "smtp.gmail.com"
					      port: 587
					      domain: "$domain"
					      authentication: :plain
					      user_name: "$username"
					      password: "$password"
				YML
			fi
		fi

		# ensure the right database adapter is active in the Gemfile.lock
		bundle install --without development test

		if [ ! -s config/secrets.yml ]; then
			if [ "$REDMINE_SECRET_KEY_BASE" ]; then
				cat > 'config/secrets.yml' <<-YML
					$RAILS_ENV:
					  secret_key_base: "$REDMINE_SECRET_KEY_BASE"
				YML
			elif [ ! -f /usr/src/redmine/config/initializers/secret_token.rb ]; then
				rake generate_secret_token
			fi
		fi
		if [ "$1" != 'rake' -a -z "$REDMINE_NO_DB_MIGRATE" ]; then
			gosu redmine rake db:migrate
		fi

		chown -R redmine:redmine files log public/plugin_assets

		# remove PID file to enable restarting the container
		rm -f /usr/src/redmine/tmp/pids/server.pid

		set -- gosu redmine "$@"
		;;
esac

exec "$@"