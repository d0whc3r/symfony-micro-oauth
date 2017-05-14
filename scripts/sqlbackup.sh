#!/usr/bin/env bash
case $1 in
  dev|uat|prod)
    export ENV=$1
    ;;
  *|-h|--help)
    echo "[?] Usage: $0 <dev|uat|prod>"
    exit 1
    ;;
esac

file="${ENV}.env"
if [ ! -f "${file}" ]; then
    echo "[!] ERROR file ${file} does not exist"
    exit 1
fi
export $(cat ./${file})

sqlfolder="../sqlbackups"
mkdir -p ${sqlfolder}
today=$(date +%Y%m%d)
filename="${DOCKER_MYSQL}_backup_${today}.sql"
echo "[?] Executing mysqldump"
docker exec -e fname=${filename} ${DOCKER_MYSQL} bash -c 'mysqldump -u ${DB_USER} -p${DB_PASS} -d ${DB_NAME} > /tmp/${fname}' || exit 1
echo "[?] Executing docker cp"
dest="${sqlfolder}/${filename}"
docker cp ${DOCKER_MYSQL}:/tmp/${filename} ${dest} || exit 1
echo "[?] Logging action in README.md"
readme="${sqlfolder}/README.md"
filesize=$(stat --printf="%s" ${dest})
echo "| $(date +"__%Y-%m-%d__ | _%H:%M:%S_") | __${filename}__ | ${filesize} |" >> ${readme}
cd ${sqlfolder}
echo "[?] commiting changes in `pwd`"
git add .
git commit -m "update backup script with log"
git push
