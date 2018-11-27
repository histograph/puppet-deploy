MY_DIR="${HOME}/log"
LOG_DIR="/var/log/nginx"
END=100
DRY_RUN=""
WEB_DIR="/var/www/erfgeo/"

cd ${MY_DIR}

for PRF in $(ls ${LOG_DIR}/ssl-[a-z]*access* | sed 's/\(.*\)\.access\..*/\1/g' | sort -u | tr '\n' ' ')
do
    MY_FILE="${MY_DIR}/$(basename ${PRF}).log"

    > ${MY_FILE}

    if [ -f ${PRF}.access.log ]
    then
        MY_CMD="cat ${PRF}.access.log >> ${MY_FILE}"
        if [ "${DRY_RUN} " = " " ]
        then
            eval ${MY_CMD}
        else
            echo "${MY_CMD}"
        fi
    fi

    for i in $(seq 1 $END)
    do
        CURFILE=${PRF}.access.log.${i}
        echo ${CURFILE}
        if [ -f ${CURFILE}.gz ]
        then
            MY_CMD="gunzip -c ${CURFILE}.gz >> ${MY_FILE}"
            if [ "${DRY_RUN} " = " " ]
            then
                eval ${MY_CMD}
            else
                echo "${MY_CMD}"
            fi
        elif [ -f ${CURFILE} ]
        then
            MY_CMD="cat ${CURFILE} >> ${MY_FILE}"
            if [ "${DRY_RUN} " = " " ]
            then
                eval ${MY_CMD}
            else
                echo "${MY_CMD}"
            fi
        fi

    done

    MY_HTML="$(basename ${MY_FILE}).html"
    goaccess --log-format COMBINED --output ${MY_HTML} ${MY_FILE}
    cp ${MY_HTML} ${WEB_DIR}
    chown www-user:www-data ${WEB_DIR}/${MY_HTML}
    chmod 440 ${WEB_DIR}/${MY_HTML}
done