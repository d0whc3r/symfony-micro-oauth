#!/usr/bin/env bash
case $1 in
  dev|uat|prod)
    export ENV=$1
    ;;
  *|-h|--help)
    echo "[?] Usage: $0 <dev|uat|prod> <dest env file>"
    exit 1
    ;;
esac

file="${ENV}.env"
if [ ! -f "${file}" ]; then
    echo "[!] ERROR file ${file} does not exist"
    exit 1
fi

dest=$2
if [ ! -f "${dest}" ]; then
    echo "[!] ERROR dest file ${dest} does not exist"
    exit 1
fi

export $(cat ./${file})

sed -i "s/API_HOST=.*/API_HOST=${API_HOST}/" ${dest}
sed -i "s/API_PORT=.*/API_PORT=${API_PORT_EXPOSED}/" ${dest}
sed -i "s/API_TOKEN=.*/API_TOKEN=${API_TOKEN}/" ${dest}
