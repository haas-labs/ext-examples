# Search Contracts by Name/Address

PID=${1:-898}
NAME=${2}
ADDR=${ADDR}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "PID=$PID"
>&2 echo "NAME=$NAME"
>&2 echo "ADDR=$ADDR"

if [ "$ADDR" != "" ]; then
   DATA_JSON="{\"from\":0,\"size\":10,\"trackTotal\":false,\"where\":\"projectId = $PID AND address='${ADDR}' \"}"
elif [ "$NAME" != "" ]; then
   DATA_JSON="{\"from\":0,\"size\":10,\"trackTotal\":false,\"where\":\"projectId = $PID AND name='${NAME}' \"}"
else
   DATA_JSON="{\"from\":0,\"size\":100,\"trackTotal\":false,\"where\":\"projectId = $PID\"}"
fi

#curl -S -s -D /dev/stderr \
curl -i \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/contract/search
