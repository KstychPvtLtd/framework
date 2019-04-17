#!/bin/bash

ARG1=${1:-localhost}
ARG2=${2:-localhost}
ARG3=${3:-localhost}
ARG4=${4:-127.0.0.1}

APIKEY=`cat /dev/urandom |head -c 32 | base64`

if [[ "$(docker images -q kstych/framework 2> /dev/null)" == "" ]]; then
  if [ -f framework.tar ]; then
    echo "Importing framework.tar"
    docker load -i framework.tar
  else
    docker pull kstych/framework
  fi
fi

mkdir -p kstych/custom
mkdir -p kstych/var/lib/mysql
mkdir -p kstych/etc/letsencrypt
chmod -R 777 kstych

echo "/app" > kstych/custom/.gitignore

if [ ! -f kstych/custom/.env ]; then

  echo "APP_ENV=local
  APP_DEBUG=false
  APP_KEY=base64:$APIKEY

  APP_URL=http://$ARG2
  APP_NAME=Kstych

  APP_ADMIN_DEBUG=true
  app_title=Framework
  app_ip=$ARG4
  app_masterpassword=yb9738z

  asterisk_domain=$ARG3
  asterisk_slaves=$ARG4:20000:21000:1:5
  asterisk_manager=$ARG4
  asterisk_extensions=\"31332,_62XXXX!\"
  domain_alisas=

  LOG_CHANNEL=stack

  APP_Multiple_Logins=yes
  kDialer_keeplocalconf=0

  DB_CONNECTION=mysql
  DB_HOST=localhost
  DB_PORT=3306
  DB_DATABASE=kstych_test
  DB_USERNAME=root
  DB_PASSWORD=yb9738z

  BROADCAST_DRIVER=log
  CACHE_DRIVER=database
  SESSION_DRIVER=database
  SESSION_LIFETIME=43200
  QUEUE_CONNECTION=database

  MAIL_DRIVER=log
  MAIL_HOST=email-smtp.us-east-1.amazonaws.com
  MAIL_PORT=587
  MAIL_USERNAME=
  MAIL_PASSWORD=
  MAIL_FROM_ADDRESS=siddharth@kstych.com
  MAIL_FROM_NAME=KstychFramework
  app_developer=siddharth@kstych.com

  AWS_ACCESS_KEY_ID=
  AWS_SECRET_ACCESS_KEY=
  AWS_DEFAULT_REGION=us-east-1
  AWS_BUCKET=kstych-test
  AWS_URL=

  FILESYSTEM_DRIVER=local
  FILESYSTEM_CLOUD=s3
  " > kstych/custom/.env

fi


echo "Running Framework Image"
docker run -it -v `pwd`/kstych/var/lib/mysql:/var/lib/mysql -v `pwd`/kstych/custom:/home/Kstych/Framework/custom -v `pwd`/kstych/etc/letsencrypt:/etc/letsencrypt -p 80:80 -p 4443:443 -p 8089:8089 -p 8088:8088 -e KSTYCH_LICENSE="$ARG1" -e KSTYCH_DOMAIN="$ARG2" kstych/framework
