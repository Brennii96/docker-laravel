FROM debian:jessie
MAINTAINER Brendan ONeill <mrlegend1235@gmail.com>

# Don't ask questions.
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    curl \
 && curl https://www.dotdeb.org/dotdeb.gpg | apt-key add - && \
    curl -sL https://deb.nodesource.com/setup_7.x | bash - \
 && echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list && \
    echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list && \
    echo 'deb http://repo.mysql.com/apt/debian jessie mysql-8.0' >> /etc/apt/sources.list \
 && apt-get update && apt-get install -y --force-yes \
    php7.2 \
    php7.2-fpm \
    php7.2-common \
    php7.2-mysql \
    php7.2-xml \
    php7.2-mbstring \
    php7.2-opcache \
    php7.2-json \
    php7.2-readline \
    php7.2-sqlite3 \
    php7.2-curl \
    libphp-phpmailer \
    zip \
    git \
    nginx \
    mysql-server \
 && apt-get remove apache2 -y && \
    apt-get autoremove -y && \
    apt-get purge -y \
 && rm -rf /var/lib/apt/lists/* \
    /usr/share/doc/* \
    /usr/share/groff/* \
    /usr/share/info/* \
    /usr/share/linda/* \
    /usr/share/lintian/* \
    /usr/share/locale/* \
    /usr/share/man/* \
    /etc/nginx/sites-available/default \
 && /etc/init.d/mysql start \
 && mysql -e "CREATE DATABASE IF NOT EXISTS docker /*\!40100 DEFAULT CHARACTER SET utf8 */;" && \
    mysql -e "CREATE USER 'docker'@'localhost' IDENTIFIED BY 'docker';" && \
    mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'docker'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;" \
 && sed -ie 's/listen = \/run\/php\/php7\.2-fpm\.sock/listen = \/var\/run\/php7\.2-fpm\.sock/g' /etc/php/7.2/fpm/pool.d/www.conf && \
    sed -ie 's/;cgi\.fix_pathinfo=1/cgi\.fix_pathinfo=0/g' /etc/php/7.0/fpm/php.ini \
 && curl -O https://getcomposer.org/installer \
 && php installer && \
    php composer.phar global require "laravel/installer" && \
    php composer.phar create-project --prefer-dist laravel/laravel laravel \
 && echo 'alias composer="/composer.phar"' >> ~/.bashrc && \
    echo 'alias phpunit="/var/www/vendor/bin/phpunit"' >> ~/.bashrc \
 && . ~/.bashrc

# Configuration files.
COPY root /
RUN chmod +x entrypoint.sh
VOLUME /var/www
WORKDIR /var/www
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
