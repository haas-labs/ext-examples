#!/bin/bash
CWD=`echo $(dirname $(readlink -f $0))`

# Delete Detector schema by Schema ID

SCHEMA_ID=${1}

>&2 echo "DID=$DID"

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

curl -S -s -D /dev/stderr \
   -X DELETE \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/schema/${SCHEMA_ID}
