# TID - alien tenantID only works with Admin JWT
ADDRESS=${1:-0x00000000000000000000000000000000000face1}
NAME=${2:-face1}
CHAIN=${CHAIN:-ethereum_sepolia}
PID=${PID:-898}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "ADDRESS=$ADDRESS"
>&2 echo "NAME=$NAME"
>&2 echo "CHAIN=$CHAIN"
>&2 echo "PID=$PID"

DATA_JSON="{\"address\":\"$ADDRESS\",\"chainUid\":\"$CHAIN\",\"name\":\"$NAME\",\"abi\":null,\"projectId\":$PID,\"addressType\":\"CONTRACT\"}"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/contract
