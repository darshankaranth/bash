#!/bin/bash

DIR=$(pwd)
WORKING_DIR=$DIR/logs/
        if [ -d "$WORKING_DIR" ]; then rm -Rf $WORKING_DIR; fi

function get_logs() {
        file="app_list.txt"
        ID_ARRAY=$(cat $file)
        for ID in ${ID_ARRAY[@]}; do
                mkdir -p logs/${ID}
                LATEST_FILE=$({ID}/tmp/ | sort -k 2 | tail -n 1 )
                if [ -z "${LATEST_FILE}" ] || [ "${LATEST_FILE}" == "null" ]; then
                        echo "Latest log does not exist"
                        echo ${LATEST_FILE}
                        exit 1
                fi
                #echo $LATEST_FILE
                cd logs/${ID}
                cp  $LATEST_FILE $DIR/logs/$ID/ .
                TAR_FILE=$(ls $DIR/logs/${ID}/)
                if [ -z "${TAR_FILE}" ] || [ "${TAR_FILE}" == "null" ]; then
                        echo "Log tar file does not exist"
                        echo ${TAR_FILE}
                exit 1
                fi

                #echo $TAR_FILE
                tar -xf $TAR_FILE
                DIR2=$(ls $DIR/logs/${ID}/$TAR_FILE | sed 's/.......$//')
                echo -e "\n\n"
                echo "Checking appcommits for  $ID"
                cat $DIR2/output.txt | grep -A 30 "Checking appcommits" 2>&1 | tee  ${DIR}/${ID}.txt 
                cd $DIR
                echo "Checking diff for  $ID"
                diff -q --from-file appcommits.txt ${ID}.txt
                diff --from-file appcommits.txt ${ID}.txt

        done
}
### main call ###
get_logs "$@"