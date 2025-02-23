cid=${1:-4976}
# ADDR=${2:-0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266}
MAX=${MAX:-20}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

ts0=$(date -d '10 day ago' +%s%3N) 
ts1=$(date +%s%3N)

read -d '' DATA_JSON <<EOF
{
  "from":0,
  "size":${MAX},
  "query":"(contractId:$cid AND tags:SECURITY) AND timestamp:[$ts0 TO $ts1]",
  "trackTotal":true,
  "sort":[{"field":"timestamp","order":"Desc"}],
  "timeseries":[{"from":$ts0,"to":$ts1}]
}
EOF


>&2 echo "DATA_JSON=$DATA_JSON"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/detector/alert/search

