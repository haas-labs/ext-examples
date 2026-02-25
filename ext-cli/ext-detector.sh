#!/bin/bash
CWD=`echo $(dirname $(readlink -f $0))`

# TID - alient tenantID only works with Admin JWT
DID=${1:-3109}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "DID=$DID"

curl -S -s -D /dev/stderr \
   -X GET \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/detector/${DID}
