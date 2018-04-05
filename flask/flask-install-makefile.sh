#!/bin/bash

SITE_NAME=xss-challenges
PYTHON_LIBRARIES=flask pycrypto

prepare:
	apt-get update
	apt-get install -y nginx-full uwsgi uwsgi-plugin-python python-webob libc6-i386 python-virtualenv python-setuptools python-pip libc6-i386 htop python-dev
	apt-get purge apport apport-symptoms python3-apport
	rm -f /etc/nginx/sites-enabled/default
	rm -f /etc/nginx/sites-available/default

install:
	# uwsgi
	install -m 644 config/${SITE_NAME}.ini /etc/uwsgi/apps-available/${SITE_NAME}.ini
	ln -sf /etc/uwsgi/apps-available/${SITE_NAME}.ini /etc/uwsgi/apps-enabled/${SITE_NAME}.ini
	touch /tmp/${SITE_NAME}.sock
	chown www-data:www-data /tmp/${SITE_NAME}.sock

	# nginx config
	install -m 644 config/${SITE_NAME}.conf /etc/nginx/sites-available/${SITE_NAME}.conf
	ln -sf /etc/nginx/sites-available/${SITE_NAME}.conf /etc/nginx/sites-enabled/${SITE_NAME}.conf
	
	# htdocs
	mkdir -p /var/www/${SITE_NAME}
	cp -rf site/* /var/www/${SITE_NAME}/
	virtualenv /var/www/${SITE_NAME}/.env
	. /var/www/${SITE_NAME}/.env/bin/activate; pip install ${PYTHON_LIBRARIES}; deactivate;
	chown -R www-data:www-data /var/www/${SITE_NAME}/
	find /var/www/${SITE_NAME}/ -type f -exec chmod 640 {} \;
	find /var/www/${SITE_NAME}/ -type d -exec chmod 750 {} \;

.PHONY: all install setup