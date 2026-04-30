#!/bin/bash
CWD=`echo $(dirname $(readlink -f $0))`

DID=${1}
NAME=${NAME}
STATUS=${STATUS}
MESSAGE=${MESSAGE}
SEV=${SEV}
TYPE=${TYPE}
CONTRACT_ID=${CONTRACT_ID}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "DID=$DID"
>&2 echo "NAME=$NAME"
>&2 echo "MESSAGE=$MESSAGE"
>&2 echo "SEV=$SEV"
>&2 echo "DEST=$DEST"

append_field() {
  local key=$1 val=$2
  [ "$val" == "" ] && return
  [ "$Q" != "" ] && Q="${Q},"
  Q="${Q}\"${key}\": \"${val}\""
}

# {
#   "contractId": "3401",
#   "type": "EVENT_EMITTED",
#   "name": "3333333333333333",
#   "config": { "funcName": "Transfer", "params": [], "txParams": null },
#   "alerts": [
#     {
#       "id": 6510,
#       "createdAt": 1772622691022,
#       "updatedAt": 1772622691022,
#       "status": "ACTIVE",
#       "severity": "INFO",
#       "name": "3333333333333333",
#       "message": "Contract Event emitted",
#       "destinations": [],
#       "actions": []
#     }
#   ]
# }


append_field "name"  "$NAME"
append_field "status" "$STATUS"
append_field "message" "$MESSAGE"
append_field "severity" "$SEV"
append_field "destinations" "$DEST"
append_field "type" "$TYPE"
append_field "contract_id" "$CONTRACT_ID"

read -r -d '' DATA_JSON << EOM
{
  $Q
}
EOM

>&2 echo "DATA_JSON=$DATA_JSON"

curl -S -s -D /dev/stderr \
   -X PUT \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/trigger/${DID}
