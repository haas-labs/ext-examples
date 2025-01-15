# TID - alient tenantID only works with Admin JWT
TID=${1:-490}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "TID=$TID"


DATA_JSON="{\"from\":0,\"size\":100,\"trackTotal\":false,\"where\":\"auth = $TID\"}"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/contract/search
