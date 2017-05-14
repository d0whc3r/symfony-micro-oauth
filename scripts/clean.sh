#!/bin/bash
if [ "$1" == "prod" ]; then
  php bin/console cache:warmup
  php bin/console cache:clear
  ../scripts/cleanlog.sh
  ../scripts/cleancache.sh
  php bin/console cache:clear --env=prod
  php bin/console assets:install --env=prod web
else
  php bin/console cache:warmup
  php bin/console cache:clear
  ../scripts/cleanlog.sh
  ../scripts/cleancache.sh
fi
composer dump-autoload --optimize