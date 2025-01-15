# TID - alient tenantID only works with Admin JWT
CID=${1:-3109}
NAME=${2:-AML-Monitoring}
SCHEMA_ID=${SCHEMA_ID:-234}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "ADDRESS=$ADDRESS"
>&2 echo "NAME=$NAME"
>&2 echo "SCHEMA_ID=$SCHEMA_ID"

CONFIG_JSON="\"tokens\":[{\"threshold\": \"1%\",\"token\": \"0xdad95f9091655b646eda06d76ba7b498a6233f76\"}]"

DATA_JSON="{\"config\":{\"tags\":\"\",\"severity\":-1},\"source\":\"ATTACK_DETECTOR\",\"destinations\":[],\"name\":\"${NAME}\",\"status\":\"ACTIVE\",\"tags\":[\"COMPLIANCE\"],\"schemaId\":$SCHEMA_ID,\"contractId\":$CID}"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/detector
