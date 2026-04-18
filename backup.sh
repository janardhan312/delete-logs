#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOG_FILE
echo "scrip executed time : $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]; then
    echo "Error:: kindly run with the root user"
    exit 1
fi 


USAGE(){
    echo -e "$R USAGE:: sudo sh backup.sh <SOURCE_DIR> <DEST_DIR> <DAYS>[optional, default 14 days] $N"

}

if [ $# -lt 2 ]; then
    USAGE
fi
