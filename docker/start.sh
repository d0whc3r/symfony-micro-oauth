#!/usr/bin/env bash
case $1 in
  dev|uat|prod)
    export ENV=$1
    ;;
  *|-h|--help)
    echo "[?] Usage: $0 <dev|uat|prod> [--init|--update]"
    exit 1
    ;;
esac

file="${ENV}.env"
if [ ! -f "${file}" ]; then
    echo "[!] ERROR file ${file} does not exist"
    ./generateenv.sh ${ENV}
fi
./checkenv.sh ${ENV}
if [ $? -gt 0 ]; then
    exit 1
fi

# Generate symfony secret
var_SYMFONY_SECRET=$(curl -s http://nux.net/secret | grep -i lead | cut -d'>' -f2 | cut -d'<' -f1)
sed -i "s/SYMFONY_SECRET=.*/SYMFONY_SECRET=${var_SYMFONY_SECRET}/" ${file}

# Export all variables in file
export $(cat ./${file})
. ./${file}

# Update nginx config
sed -i "s/listen .*;/listen ${API_PORT};/" nginx/vhost.conf
sed -i "s/server_name .*;/server_name ${API_HOST} ${DOCKER_NGINX};/" nginx/vhost.conf


#envsubst < apache/vhost.tpl.conf > apache/vhost.conf
#envsubst < apache/ports.tpl.conf > apache/ports.conf

envsubst < ../nginx.tpl.Dockerfile > ../nginx.Dockerfile
envsubst < ../docker-compose.tpl.yml > ../docker-compose.yml

docker-compose -f ../docker-compose.yml up -d --build

case $2 in
    --init)
        docker exec -it ${DOCKER_API} bash -c "../scripts/firstinstall.sh --resetdb"
    ;;
    --update)
        docker exec -it ${DOCKER_API} bash -c "../scripts/update.sh"
    ;;
esac
