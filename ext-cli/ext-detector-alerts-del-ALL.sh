#!/bin/bash
CWD=`echo $(dirname $(readlink -f $0))`

CID=${1}

if [ "$CID" == "" ]; then
   exit 1
fi

export MAX=1000

$CWD/ext-contract-detectors.sh $CID  | jq -r .data[].id | while read -r DID; do

>&2 echo "DID=$DID"
# $CWD/ext-detector-alerts-del.sh $AID

read -r -d '' DATA_JSON << EOM
{
  "query": {
    "query_string": {
      "query": "coid:$CID AND deid:$DID"
    }
  }
}
EOM

curl -S -s -D /dev/stderr \
   -u $ELASTIC_USER:$ELASTIC_PASS \
   -X POST \
   -H 'Content-Type: application/json' \
   --data "$DATA_JSON" \
   $ELASTIC_URI/detector-alert-search,detector-event-search/_delete_by_query

done
