#!/bin/bash
composer install
../scripts/setup.sh
if [ "$1" == "--resetdb" ]; then
    ../scripts/resetdb.sh --test
fi;
../scripts/clean.sh ${DOCKER_ENV}
../scripts/setup.sh
