MY_INDEX=test
MY_PORT=9780
MY_FILE="bulk.ndjson"
PRECISION="10m"
ERROR_PCT="0"
MY_HOST=localhost
MY_VERSION=NEW

if [ "${1} " != " " ]
then
  MY_FILE="${1}"
fi

if [ "${2} " != " " ]
then
  PRECISION="${2}"
fi

if [ "${3} " != " " ]
then
  ERROR_PCT="${3}"
fi


echo -e "\n\nDelete ${MY_INDEX}"
curl -XDELETE ${MY_HOST}:${MY_PORT}/${MY_INDEX}

echo -e "\n\nCreate mapping"
if [ "$MY_VERSION " == "OLD " ]
then
curl -XPUT "${MY_HOST}:${MY_PORT}/${MY_INDEX}?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
      "number_of_shards": 5,
      "number_of_replicas": 0,
      "analysis": {
        "analyzer": {
          "lowercase": {
            "type": "custom",
            "filter": " lowercase",
            "tokenizer":  "keyword"
          }
        }
      }
    },
    "mappings": {
      "_default_": {
        "properties": {
          "geometry": {
            "precision": "10m",
            "tree": "quadtree",
            "type": "geo_shape"
          },
          "uri": {
            "index": "not_analyzed",
            "type": "string"
          },
          "id": {
            "index": "not_analyzed",
            "store": true,
            "type": "string"
          },
          "type": {
            "index": "not_analyzed",
            "type": "string"
          },
          "name": {
            "fields": {
              "analyzed": {
                "index": "analyzed",
                "store": true,
                "type": "string"
              },
              "exact": {
                "analyzer": "lowercase",
                "store": true,
                "type": "string"
              }
            },
            "type": "string"
          },
          "dataset": {
            "index": "not_analyzed",
            "type": "string"
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
else
curl -XPUT "${MY_HOST}:${MY_PORT}/${MY_INDEX}?pretty" -H 'Content-Type: application/json' -d'
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
          "precision": '"\"${PRECISION}\""',
          "distance_error_pct": '"${ERROR_PCT}"',
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

fi

# curl 'https://search-histograph-v3mtb6qo4la3qmu76rmoxkkz3i.eu-central-1.es.amazonaws.com/cshapes/_search/?pretty&size=1000' 

# curl '${MY_HOST}:9200/${MY_INDEX}/_search/?pretty&size=1000' 

# cat core.log | sed 's/},{"index":{"_index":"cshapes"/}\'$'\n{"index":{"_index":"cshapes"/g' | sed 's/"}},{"id":"/"}}\'$'\n{"id":"/g' | sed "s/cshapes/${MY_INDEX}/g" > bulk.ndjson


echo -e "\n\nBulk index ${MY_FILE}"
time curl -s -H "Content-Type: application/x-ndjson" -XPOST ${MY_HOST}:${MY_PORT}/_bulk --data-binary "@${MY_FILE}" &

while :
sleep 10s
do
  curl -XGET "http://${MY_HOST}:${MY_PORT}/_cat/indices/${MY_INDEX}"
  curl -XGET "http://${MY_HOST}:${MY_PORT}/_tasks?actions=indices:data/write/bulk*&detailed&pretty"
  
  if curl -XGET "http://${MY_HOST}:${MY_PORT}/_tasks?actions=indices:data/write/bulk*&detailed&pretty" 2>&1| grep '"nodes" : { }' >/dev/null
  then
    break;
  fi
done