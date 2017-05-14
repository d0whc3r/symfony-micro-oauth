#!/usr/bin/env bash
if [ -z "$1" ]; then
    echo "[+] Usage: $0 <environment> [environment_to_copy]"
    exit 0
fi
environment=$1
exfile="./example.env"
if [[ $2 && -f "$2".env ]]; then
    exfile="$2".env
fi
envfile="./${environment}.env"
data=$(cat ${exfile} | grep -vE "^#")

for d in ${data}; do
    key=$(echo ${d} | cut -d'=' -f1)
    value=$(echo ${d} | cut -d'=' -f2)
    if [ "${key}" == "DOCKER_ENV" ]; then
        value=${environment}
    else
        printf "[+] ${key} (${value}): "
        read v
        if [ ! -z "${v}" ]; then
            value="${v}"
        fi
    fi
    echo "${key}=${value}" >> ${envfile}
done
echo "[+] ${envfile} generated"
