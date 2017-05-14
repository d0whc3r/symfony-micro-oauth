#!/bin/bash
host="http://${DOCKER_NGINX}:${API_PORT}"

outfile=".tmpfile.txt"
rm -f ${outfile}
php bin/console doctrine:database:drop --force
php bin/console doctrine:database:create
../scripts/initdb.sh --db --load
cmd="php bin/console appbundle:oauth-server:client:create \
     --redirect-uri=${host} \
     --redirect-uri=http://${API_HOST}:${API_PORT} \
     --redirect-uri=https://${API_HOST}:${API_PORT} \
     --grant-type=authorization_code \
     --grant-type=password \
     --grant-type=refresh_token \
     --grant-type=token \
     --grant-type=client_credentials"
if [ ${DOCKER_ENV} = "dev" ]; then
    cmd="${cmd} \
     --client_id=${CLIENT_ID} \
     --secret_id=${SECRET_ID}"
fi
${cmd} | tee ${outfile}
client=`cat ${outfile} | cut -d' ' -f8 | sed 's/,//g'`
secret=`cat ${outfile} | cut -d' ' -f10`
php bin/console fos:user:create ${ADMIN_NAME} some@email.com ${ADMIN_PASS} --super-admin
#php bin/console fos:user:create ${USER_NAME} some@email.com ${USER_PASS}

if [ "$1" == "--test" ]; then
    ../scripts/initdb.sh --test
fi
rm -f ${outfile}
echo
echo "================================"
echo "SERVER INFORMATION ENV: ${DOCKER_ENV}"
echo "================================"
echo "Client id: ${client}"
echo "Secret: ${secret}"
echo "User: ${ADMIN_NAME}"
echo "Password: ${ADMIN_PASS}"
echo "================================"