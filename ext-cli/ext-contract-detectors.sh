# TID - alien tenantID only works with Admin JWT
CID=${1:-0}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "CID=$CID"

DATA_JSON="{\"size\":100,\"trackTotal\":false,\"where\":\"contractId = $CID OR contractId = $CID\"}"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/detector/search
