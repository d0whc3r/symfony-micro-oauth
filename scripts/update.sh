#!/bin/bash
#../scripts/gitupdate.sh y ${branch}
composer install
../scripts/setup.sh
../scripts/initdb.sh -l
../scripts/clean.sh ${DOCKER_ENV}
../scripts/setup.sh
