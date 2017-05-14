#!/bin/bash
check_sql() {
  errors=`cat ${tmpsql} | grep -i error | wc -l`
  if [ ${errors} -gt 0 ]; then
    cat ${tmpsql}
    rm -f ${tmpsql}
    exit 1
  fi
}

load_sql() {
  path=$1
  name=$2
  if [ -z "$2" ]; then
    return
  fi
  if [ -d "${path}" ]; then
    x=1
    echo "[?] Loading ${name}..."
    for i in $(find ${path} -name "*.sql" | grep -v exclude); do
      echo "[+] ${x}.- ${i}"
      $COMMAND < ${i} 2> ${tmpsql}
      check_sql
      x=$((${x}+1))
    done
    # echo ""
  fi
}

showhelp() {
  echo "[?] Usage: $0 <options>"
  echo "----------------------------------------------"
  echo "[?] options:"
  echo -e "[+]\t-d/--db: reset database"
  echo -e "[+]\t-u/--users: save users and reinsert (only with --db)"
  echo -e "[+]\t-l/--load: load functions and procedures scripts"
  echo -e "[+]\t-t/--test: inset test data"
  echo -e "[+]\t-h/--help: show this help"
}

sqlpath="sql"
tmpsql=".tmpsql"

mysqlparams="-h ${DOCKER_MYSQL} -P ${SYMFONY_DB_PORT} -u ${DB_USER} -p${DB_PASS}"
COMMAND="mysql ${mysqlparams} -b ${DB_NAME} "

DUMPCOMMAND="mysqldump ${mysqlparams} ${DB_NAME} fos_user "
DUMPFILE="${sqlpath}/users_${ENV}.sql"
TMPDUMP="${sqlpath}/.users_${ENV}.sql"

db=0
users=0
load=0
test=0
params="$(getopt -o hdult -l help,db,users,load,test --name "$0" -- "$@")"
eval set -- "${params}"

while [[ $# -gt 0 ]] ; do
#echo "case $1"
  if [ "$1" != "--" ]; then
      case $1 in
        -d|--db)
          db=1
          ;;
        -u|--users)
          users=1
          ;;
        -l|--load)
          load=1
          ;;
        -t|--test)
          test=1
          ;;
        -h|--help)
          showhelp
          exit 0
          ;;
        *)
          showhelp
          echo ""
          echo "[!] Error: unknown parameter"
          exit 1
          ;;
      esac
  else
    break
  fi
  shift
done

#echo ${db}.${users}.${load}.${test}

if [[ ${db} -eq 0 && ${load} -eq 0 && ${test} -eq 0 ]]; then
    showhelp
    echo "none!"
    exit 0
fi

if [ ${db} -gt 0 ]; then
    if [ ${users} -gt 0 ]; then
        echo "[?] Saving users..."
        touch ${TMPDUMP}
        ${DUMPCOMMAND} > ${TMPDUMP}
        if [ ! -f "${TMPDUMP}" ]; then
            echo "[!] Error saving users"
            exit 1
        fi
        cat ${TMPDUMP} | grep -i "INSERT INTO" > ${DUMPFILE}
        rm -f ${TMPDUMP}
        echo "[-]"
    fi
    echo "[?] Loading DB..."
    ${COMMAND} < "${sqlpath}/database.sql" 2> ${tmpsql}
    check_sql
    load_sql "${sqlpath}/references/" "References"
    if [ ${users} -gt 0 ];then
        echo "[-]"
        echo "[?] Loading Old Users..."
        ${COMMAND} < ${DUMPFILE} 2> ${tmpsql}
        rm -f ${DUMPFILE}
        check_sql
    fi
    echo "[-]"
fi

if [ ${load} -gt 0 ]; then
    load_sql "${sqlpath}/function/" "Functions"
    echo "[-]"
    load_sql "${sqlpath}/procedure/" "Procedures"
fi

if [ ${test} -gt 0 ]; then
    load_sql "${sqlpath}/test/" "Test data"
fi

rm -f ${tmpsql}
exit 0
