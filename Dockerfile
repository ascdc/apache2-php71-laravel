FROM ubuntu:trusty
MAINTAINER ASCDC <asdc.sinica@gmail.com>

ADD run.sh /run.sh
ADD locale.gen /etc/locale.gen
ADD locale-archive /usr/lib/locale/locale-archive

RUN chmod +x /*.sh && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive && \
	apt-get -y install locales software-properties-common python-software-properties wget curl vim git && \
	echo "cd /var/www/html" >> /root/.profile && \
	echo "alias ll='ls -al'" >> /root/.profile && \
	echo "export LANG=zh_TW.UTF-8" >> /root/.profile && \ 
	echo "export LANGUAGE=zh_TW" >> /root/.profile && \
	echo "export LC_ALL=zh_TW.UTF-8" >> /root/.profile && \
	echo "export PATH=$PATH:/root/.composer/vendor/bin" >> /root/.profile && \
	echo "export NVM_DIR=/root/.nvm" >> /root/.profile && \
	echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"" >> /root/.profile && \
	locale-gen zh_TW.UTF-8 && \
	dpkg-reconfigure locales && \
	export LANG=zh_TW.UTF-8 && \
	add-apt-repository -y ppa:ondrej/php && \
	add-apt-repository -y ppa:ondrej/apache2
	
RUN DEBIAN_FRONTEND=noninteractive && apt-get update && \
	apt-get -y upgrade && \
	apt-get install -y ^apache2$ ^php7\.1$ ^php7\.1-common$ ^php7\.1-json$ ^php7\.1-opcache$ ^php7\.1-zip$ ^php7\.1-mysql$ ^php7\.1-phpdbg$ ^php7\.1-gd$ ^php7\.1-imap$ ^php7\.1-ldap$ ^php7\.1-pgsql$ ^php7\.1-pspell$ ^php7\.1-recode$ ^php7\.1-tidy$ ^php7\.1-intl$ ^php7\.1-curl$ ^php7\.1-mcrypt$ ^php7\.1-xmlrpc$ ^php7\.1-imagick$ ^php7\.1-xsl$ ^php7\.1-bz2$ ^php7\.1-mbstring$ pkg-config libmagickwand-dev imagemagick build-essential libsasl2-dev libpcre3-dev && \
	ln -s ../mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load && \
	wget -qO /usr/local/bin/composer https://getcomposer.org/composer.phar && \
	chmod 755 /usr/local/bin/composer && \
	export PATH=$PATH:/root/.composer/vendor/bin && \
	composer global require "laravel/installer" && \
	mkdir /var/www/html/public && \
	mv /var/www/html/*.html /var/www/html/public && \
	sed -i "s/DocumentRoot.*/DocumentRoot \/var\/www\/html\/public/g" /etc/apache2/sites-available/000-default.conf && \
	sed -i "s/<\/VirtualHost>/\t<Directory \"\/var\/www\/html\/public\">\n\t\tAllowOverride All\n\t<\/Directory>\n<\/VirtualHost>/g" /etc/apache2/sites-available/000-default.conf && \
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash && \
	export NVM_DIR="/root/.nvm" && \
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
	nvm install v6.9.2 && \
	nvm use v6.9.2
	
ENV LANG zh_TW.UTF-8  
ENV LANGUAGE zh_TW
ENV LC_ALL zh_TW.UTF-8	
ENV NVM_DIR /root/.nvm
	
EXPOSE 80
WORKDIR /var/www/html
ENTRYPOINT ["/run.sh"]