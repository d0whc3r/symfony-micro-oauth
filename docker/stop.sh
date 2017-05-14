#!/usr/bin/env bash
case $1 in
  dev|uat|prod)
    export ENV=$1
    ;;
  *|-h|--help)
    echo "[?] Usage: $0 <dev|uat|prod> [--remove|--reset [--init|--update]]"
    exit 1
    ;;
esac

file="${ENV}.env"
if [ ! -f "${file}" ]; then
    echo "[!] ERROR file ${file} does not exist"
    exit 1
fi

export $(cat ./${file})

dockers="${DOCKER_API} ${DOCKER_MYSQL} ${DOCKER_NGINX}"
remove() {
  echo "[-] Removing containers"
  docker rm -f ${dockers}
}

echo "[-] Stopping containers"
docker stop ${dockers}
case $2 in
  --remove)
  remove
  ;;
  --reset)
  remove
  ./start.sh ${ENV} ${3}
  ;;
esac
