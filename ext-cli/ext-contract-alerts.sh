
CID=${1:-3090}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "CID=$CID"

# Calculate timestamps in milliseconds
TS1=$(date +%s%3N)  # Current time in milliseconds
TS0=$(date -d "24 hours ago" +%s%3N)  # 24 hours ago in milliseconds

DATA_JSON="{\"from\":0,\"size\":10,\"trackTotal\":true,\"query\":\"timestamp:[$TS0 TO $TS1]\",\"timeseries\":[{\"from\":$TS0,\"to\":$TS1}],\"sort\":[{\"field\":\"timestamp\",\"order\":\"Desc\"}]}"

>&2 echo "DATA_JSON=$DATA_JSON"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/contract/$CID/alert

