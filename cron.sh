#!/bin/bash
# Crontab
# * * * * * BASEPATH/cron.sh APPNAME DOMAIN LICENSE > /var/log/kstych-cron.log 2>&1

export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

BASEPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

APPNAME=${1:-app}
DOMAIN=${2:-localhost}
LICENSE=${3:-localhost}

COMMAND="podman"
if ! command -v $COMMAND &> /dev/null
then
    COMMAND="docker"
fi


cd $BASEPATH

if ! /usr/bin/screen -list | grep -q $APPNAME; then
  date
  /usr/bin/screen -d -m -S $APPNAME bash -c "cd $BASEPATH;./kstych.sh $LICENSE $DOMAIN"
fi

nowtime=$(date +%k%M)
if [ $nowtime -eq "000" ] ; then

  # restart container if ssl not renewed (expiring in 5 days = 432000 sec)
  if true | openssl s_client -connect $DOMAIN:443 -servername $DOMAIN 2>/dev/null | openssl x509 -noout -checkend 432000; then
    echo "Certificate is not expired"
  else
    echo "Certificate is expired"

    $COMMAND stop kstych-framework
    service $COMMAND restart
  fi

  # update docker image add random delay to prevent all at same time
  CURRENTCOUNT=`podman images | grep "kstych/framework" | wc -l`
  SLEEPSEC=$((10 + RANDOM % 3600))
  echo "waiting for $SLEEPSEC seconds"
  sleep $SLEEPSEC
  $COMMAND pull kstych/framework
  NEWCOUNT=`podman images | grep "kstych/framework" | wc -l`

  # restart if image was updated
  if [[ $CURRENTCOUNT != $NEWCOUNT ]]; then
    echo "New Image Downloaded ($CURRENTCOUNT -> $NEWCOUNT) Restarting Framework"
    $COMMAND stop kstych-framework
  fi

fi
