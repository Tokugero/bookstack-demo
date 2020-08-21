FROM debian:stable-slim

ENV PORT="80"
ENV APP_URL="http://localhost/"

ADD https://github.com/BookStackApp/BookStack/archive/release.zip /bookstack/

ADD https://getcomposer.org/installer /root/composer-setup.php

RUN apt-get update && \
	apt-get install -y \
	unzip \
	php-cli \
	php-mbstring \
	php7.3-curl \
	php7.3-dom \
	php7.3-gd \
	php7.3-mysql \
	php7.3-tidy \
	php7.3-xml \
        php-fpm \
	nginx && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
	
RUN unzip /bookstack/release.zip -d / && \
	rm /bookstack/release.zip && \
	php /root/composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
	mkdir -p /run/php/ && \
	chown -R www-data:www-data /run/php

COPY config/bookstack.env /BookStack-release/.env
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY scripts/run.sh /BookStack-release/run.sh
COPY config/nginx.htpasswd /BookStack-release/.htpasswd

RUN cd /BookStack-release && \
	composer install --no-dev && \
	chown -R www-data:www-data /BookStack-release/ && \
	chmod 600 .htpasswd

WORKDIR /BookStack-release/

ENTRYPOINT ["./run.sh"]
