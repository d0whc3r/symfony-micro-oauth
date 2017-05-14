#!/bin/bash
if [ "$1" = "y" ]; then
  echo "[+] Fetching..."
  git fetch --all
  echo "[+] Reset to HEAD"
  git reset --hard HEAD
  echo "[+] Pulling..."
  git pull origin $2
else
  echo "[+] Usage: $0 y [branch]"
fi
