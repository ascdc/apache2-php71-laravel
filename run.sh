#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime

export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
export PATH=$PATH:/root/.composer/vendor/bin

find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type d -exec chmod ug+s {} \;
find /var/www/html -type f -exec chmod 644 {} \;
chown -R root:www-data /var/www/html
chmod -R 775 /var/www/html/storage
chmod -R 775 /var/www/html/bootstrap/cache/

service apache2 start

/bin/bash

