#!/bin/bash
if [ -z "$1" ]; then
  docker ps
  echo ""
  echo "[?] Usage: $0 <container-name>"
  exit 1
fi
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
