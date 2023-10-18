#!/bin/bash
set -euo pipefail

get_rand(){
    cat /dev/urandom | tr -dc '1234567890-=_+~!@#%^$*(){}[];:,.<>?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | head -c 64 ; echo;
}

customize_wp_config() {
    local c="/srv/www/wordpress/wp-config.php"

    for k in AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT;
    do
        r=$(get_rand)
        echo "Set $k to $r"
        set -x
        sed -i -E -e "s/'$k',[^\)]+/'$k', '$r'/" "$c";
        set +x
    done

    echo "Set wp-config DB parameters"
    sed -i -e 's/database_name_here/wordpress/' "$c"
    sed -i -e 's/username_here/wordpress/' "$c"
    sed -i -e 's/password_here/password/' "$c"
}

echo "Ensure packages are installed and up to date"

## ensure updated cache
apt-get update

# install all the packages
apt-get install -y \
    curl \
    unzip \
    mariadb-server \
    apache2 \
    libapache2-mod-php8.1 \
    php8.1 \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-xml \
    php8.1-xmlrpc \
    php8.1-readline \
    php8.1-mysql \
    php8.1-soap \
    php8.1-intl \
    php8.1-zip \
    composer \
    git-core

echo "Enable apache rewrite module"
a2enmod rewrite

echo "Set php config"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/apache2/php.ini
sed -i "s/disable_functions = .*/disable_functions = /" /etc/php/8.1/cli/php.ini


echo "Restart database"
service mariadb restart

echo "Get latest wordpress"
curl https://wordpress.org/latest.zip -o /tmp/latest.zip

echo "Prepare DB"
mariadb <<EOF
CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER IF NOT EXISTS 'wordpress'@'localhost' IDENTIFIED BY 'password';
GRANT ALL ON wordpress.* TO 'wordpress'@'localhost';
FLUSH PRIVILEGES;
EOF

mkdir -p /srv/www/

echo "Prepare apache config"
cat > /etc/apache2/sites-available/wordpress.conf <<EOF

<VirtualHost *:80>
        DocumentRoot /srv/www/wordpress
        <Directory /srv/www/wordpress/>
            AllowOverride All
            Require all granted
        </Directory>
        ServerAdmin webmaster@localhost

        ErrorLog /var/log/apache2/error.log
        CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF

echo "Test apache config and enable things if everything is ok"
# test apache config
apache2ctl configtest
if [ $? == 0 ];
then
    a2dissite 000-default
    a2ensite wordpress
    service apache2 restart
else
    echo Apache2 Config is broken!;
    exit 1;
fi

echo "Prepare WP files"
cd /srv/www/
unzip -o /tmp/latest.zip

cd wordpress
touch .htaccess
mkdir -p wp-contest/upgrade

cp -f wp-config-sample.php wp-config.php

echo "Customize WP config"
customize_wp_config

echo "Ensure correct owner and mode"
chown -R www-data:www-data .
chmod -R o-rwx .
