#!/bin/bash
perm=$(stat -c %a 'var/cache')
if [ "$perm" != "777" ]; then
  echo "[+] Changing permissions..."
  dirs="var/cache/ var/logs/ var/sessions/"
  mkdir -p ${dirs}
  HTTPDUSER=`ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
  if [ `whoami` != ${HTTPDUSER} ]; then
    setfacl -R -m u:"${HTTPDUSER}":rwX -m u:`whoami`:rwX ${dirs} 2>/dev/null
    setfacl -dR -m u:"${HTTPDUSER}":rwX -m u:`whoami`:rwX ${dirs} 2>/dev/null
  fi
  #chmod 777 -R ${dirs} 2>/dev/null
fi
