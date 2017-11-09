#! /bin/bash
# set -x
unalias ls

UPLOADS="/uploads/datasets"
IMPORTS="/var/www/importeren/app/storage/exports"

for i in $(ls ${UPLOADS});
 do
    for ii in pits.ndjson relations.ndjson
    do
        j="${UPLOADS}/${i}/${ii}"
        k="${IMPORTS}/${i}/${ii}"
    
        # echo ${j}
        # echo ${k}
    
        # echo "LS: $(ls ${j} ${k})"
    
        if [ -f "${j}" -a -f "${k}" ]
        then
            # echo "${i}/${ii} exists in both dir"
            diff ${j} ${k}
        elif [ -f "${j}" ]
        then
            echo "${i}/${ii} exists only in ${UPLOADS}";
        elif [ -f "${k}" ]
        then
            echo "${i}/${ii} exists only in ${IMPORTS}"
        else
            echo "${i}/${ii} is not in either dir"
        fi
    done
 done

#  set +x
