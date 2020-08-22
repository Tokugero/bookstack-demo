#!/bin/bash

sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/nginx.conf
sed -i -e 's,APPURL,'${APP_URL}',g' /BookStack-release/.env
sed -i -e 's,listen = /run/php/php7.3-fpm.sock,listen = 127.0.0.1:9000,g' /etc/php/7.3/fpm/pool.d/www.conf
sed -i -e 's,pid = /run/php/php7.3-fpm.pid,pid = php7.3-fpm.pid,g' /etc/php/7.3/fpm/php-fpm.conf

cd /BookStack-release/ && \
	echo yes | php artisan key:generate && \
	echo yes | php artisan migrate

cd /home/ && ls -alh

php-fpm7.3 & \
	nginx -g 'daemon off;'
