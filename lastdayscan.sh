#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
G='\033[0;32m'
B='\033[0;34m'
C='\033[0;36m'

#ulimit -m 10M
PID=$(echo $$)
prlimit --rss=500000 --pid ${PID}
# echo "${PID} pid"
echo "${C}Creating list of files...${NC}"
find / -path /run -prune -o -path /sys -prune -o -path /proc -prune -o -type f -mmin -1440 > templist
sed -i '/sys/d' templist
sed -i '/proc/d' templist
NUMTOSCAN=$(wc -l templist | awk '{print $1}')
echo "${RED}${NUMTOSCAN}${NC} files going to be scanned."
nice -n 19 ionice -c 3 clamscan --exclude-dir="^/sys" --exclude-dir="^/proc" --file-list=templist -rv -l lastscan.log --max-filesize=1M --max-scansize=1M --bytecode-timeout=190000 -o -i
rm -rf templist
echo "${G}Done!${NC}"
# ulimit -m unlimited
