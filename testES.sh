MY_INDEX=test
MY_PORT=9780
MY_FILE="bulk.ndjson"

echo "Delete ${MY_INDEX}"
curl -XDELETE localhost:${MY_PORT}/${MY_INDEX}

echo -e "\nCreate mapping"
curl -XPUT "localhost:${MY_PORT}/${MY_INDEX}?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0,
    "refresh_interval": "30s",
    "analysis": {
      "analyzer": {
        "lowercase": {
          "type": "custom",
          "filter": "lowercase",
          "tokenizer":  "keyword"
        }
      }
    }
  },
  "mappings": {
    "_default_": {
      "_all": {
        "enabled": false
      },
      "properties": {
        "geometry": {
          "precision": "10m",
          "tree": "quadtree",
          "type": "geo_shape"
        },
        "uri": {
          "type": "keyword"
        },
        "id": {
          "type": "keyword"
        },
        "type": {
          "type": "keyword"
        },
        "name": {
          "fields": {
            "analyzed": {
              "type": "text"
            },
            "exact": {
              "analyzer": "lowercase",
              "type": "text"
            }
          },
          "type": "text",
          "index": false
        },
        "dataset": {
          "type": "keyword"
        },
        "validSince": {
          "format": "date_optional_time",
          "type": "date"
        },
        "validUntil": {
          "format": "date_optional_time",
          "type": "date"
        }
      }
    }
  }
}
'

# curl 'https://search-histograph-v3mtb6qo4la3qmu76rmoxkkz3i.eu-central-1.es.amazonaws.com/cshapes/_search/?pretty&size=1000' 

# curl 'localhost:9200/${MY_INDEX}/_search/?pretty&size=1000' 

# cat core.log | sed 's/},{"index":{"_index":"cshapes"/}\'$'\n{"index":{"_index":"cshapes"/g' | sed 's/"}},{"id":"/"}}\'$'\n{"id":"/g' | sed "s/cshapes/${MY_INDEX}/g" > bulk.ndjson


echo -e "\nBulk index ${MY_FILE}"
curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:${MY_PORT}/_bulk --data-binary "@${MY_FILE}" &

while :
do
  curl localhost:${MY_PORT}/_cat/indices/${MY_INDEX}
  sleep 30s
done