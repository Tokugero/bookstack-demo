#!/bin/bash

sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/nginx.conf;
sed -i -e 's,APPURL,'${APP_URL}',g' /BookStack-release/.env;

cd /BookStack-release/ && \
	echo yes | php artisan key:generate && \
	echo yes | php artisan migrate

cat /etc/passwd

php-fpm7.3 & \
	nginx -g 'daemon off;'
