#!/bin/bash
CWD=`echo $(dirname $(readlink -f $0))`

# TID - alient tenantID only works with Admin JWT
CID=${1:-3109}
#TAGS=${TAGS:-COMPLIANCE}
TAGS=${2:-}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

if [ "$TAGS" != "" ]; then
  Q_TAGS=" and tags='${TAGS}'"
fi


>&2 echo "CID=$CID"

DATA_JSON="{\"where\":\"contractId = $CID${Q_TAGS}\",\"trackTotal\":false,\"from\":0,\"size\":10,\"sort\":[{\"field\":\"createdAt\",\"order\":\"Desc\"}]}"

>&2 echo "DATA_JSON=$DATA_JSON"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/detector/search
