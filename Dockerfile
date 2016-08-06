FROM ubuntu:14.04

WORKDIR /

# drop this if u r not in China :)
RUN printf 'deb http://cn.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse\ndeb http://cn.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse\ndeb http://cn.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse\ndeb http://cn.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse\ndeb http://cn.archive.ubuntu.com/ubuntu/ trusty-proposed main restricted universe multiverse\ndeb-src http://cn.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse\ndeb-src http://cn.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse\ndeb-src http://cn.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse\ndeb-src http://cn.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse\ndeb-src http://cn.archive.ubuntu.com/ubuntu/ trusty-proposed main restricted universe multiverse\ndeb http://archive.canonical.com/ubuntu/ trusty partner\n' > /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    make \
    curl \
    wget \
    git \
    nginx \
    php-pear \
    php5-dev \
    php5-fpm \
    php5-cli \
    php5-mysql \
    php5-mcrypt \
    libpcre3-dev \
    libcurl4-openssl-dev \
    vim

# install wordpress
RUN wget https://wordpress.org/wordpress-4.5.tar.gz
RUN tar zxvf wordpress-4.5.tar.gz
RUN cp /wordpress/wp-config-sample.php /wordpress/wp-config.php

# install xhprof
RUN pecl install xhprof-beta
RUN echo 'extension=xhprof.so' > /etc/php5/mods-available/xhprof.ini
RUN php5enmod xhprof

# install mongo extension
RUN pecl install mongo
RUN echo 'extension=mongo.so' > /etc/php5/mods-available/mongo.ini
RUN php5enmod mongo

# enable mcrypt extension
RUN php5enmod mcrypt

# install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# drop this if u r not in China :)
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

# install xhgui and dependencies
RUN wget https://github.com/perftools/xhgui/archive/v0.4.0.tar.gz
RUN tar zxvf v0.4.0.tar.gz && mv /xhgui-0.4.0 /xhgui
RUN cd xhgui && composer install

ADD ./nginx-conf /etc/nginx/conf.d
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

