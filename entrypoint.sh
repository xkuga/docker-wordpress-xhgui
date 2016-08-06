#!/bin/bash

# set wordpress env
sed -i "s/'database_name_here'/'$WORDPRESS_DB_NAME'/g" /wordpress/wp-config.php
sed -i "s/'username_here'/'$WORDPRESS_DB_USER'/g" /wordpress/wp-config.php
sed -i "s/'password_here'/'$WORDPRESS_DB_PASSWORD'/g" /wordpress/wp-config.php
sed -i "s/'localhost'/'$WORDPRESS_DB_HOST'/g" /wordpress/wp-config.php

# set mongo env
sed -i "s/mongodb:\/\/127.0.0.1/$WORDPRESS_MONGO_HOST/g" /xhgui/config/config.default.php

# always profile request
sed -i "s/rand(0, 100) === 42/true/g" /xhgui/config/config.default.php

chmod 777 -R /xhgui/cache

# Go Go GO!
nginx
service php5-fpm start
/bin/bash
