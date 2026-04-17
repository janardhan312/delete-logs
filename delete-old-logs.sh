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



SOURCE_DIR=/home/ec2-user/app-logs

if [! -d $SOURCE_DIR]; then 
    echo -e "Error :: $SOURCE_DIR does not exit"
    exit 1
fi

FILE_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -type f -mtime +14)

while IFS= read -r filepath;
do
    echo "Deleting the file: $filepath"
    rm -rf $filepath
    echo "Deleted the file: $filepath"
done <<< $FILE_TO_DELETE