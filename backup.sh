#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}

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

if [ ! -d $SOURCE_DIR ]; then
    echo -e "$R $SOURCE_DIR does not exist $N"
    exit 1
fi

if [ ! -d $DEST_DIR ]; then
    echo -e "$R $DEST_DIR does not exist $N"
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS)

if [ ! -z "${FILES}" ]; then
  echo "files found: $FILES"
  TIMESTAMP=$(date +%F-%H-%M)
  ZIP_FILE="$DEST_DIR/app-logs-$TIMESTAMP.zip"
  echo "Zip files:: $ZIP_FILE"
  find $SOURCE_DIR -name "*.log" -type f -mtime +$DAYS | zip -@ -j "$ZIP_FILE"

    if [ -f $ZIP_FILE ]
    then 
        echo -e "Archevie ... $G SUCCESS $N"

        while IFS= read -r filepath;
        do
            echo "Deleting the file: $filepath"
            rm -rf $filepath
            echo "Deleted the file: $filepath"
        done <<< $FILES
    else
        echo -e "Archevie ... $G FAILURE $N"
        exit 1
    fi
    
else
  echo -e "No files to do archeive .... $Y Skipping $N"
fi

