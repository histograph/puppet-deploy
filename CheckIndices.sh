unalias ls
for i in $(ls  /uploads/datasets/)
do
    i=${i%/};
#    echo "EEEE  ${i}"
    # eval "curl localhost:9200/_cat/indices/${i}"
    # echo $j
    if [ "$(curl localhost:9200/_cat/indices/${i} 2>/dev/null| tr -s ' ' | cut -f7 -d' ') " == "0 " ]
    then
        echo "${i} has no docs";
        # rm -rf /uploads/datasets/${i}
    fi
done
