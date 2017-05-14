#!/usr/bin/env bash
if [ -z "$1" ]; then
    echo "[+] Usage: $0 <environment>"
    exit 0
fi
environment=$1
exfile="./example.env"
envfile="./${environment}.env"
exdata=$(cat ${exfile} | grep -vE "^#" | cut -d"=" -f1 | sort)
data=$(cat ${envfile} | grep -vE "^#" | cut -d"=" -f1 | sort)
diff=$(diff <(printf "%s\n" "${exdata[@]}") <(printf "%s\n" "${data[@]}"))
if [ -z "${diff}" ]; then
    echo "[+] ${envfile} checked"
else
    echo "[-] ERROR ${envfile} have differences, check it with ${exfile}"
    echo ${diff}
    exit 1
fi
