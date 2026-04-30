#!/bin/bash
CWD=`echo $(dirname $(readlink -f $0))`

DID=${1}
NAME=${NAME}
STATUS=${STATUS}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "DID=$DID"
>&2 echo "NAME=$NAME"

append_field() {
  local key=$1 val=$2
  [ "$val" == "" ] && return
  [ "$Q" != "" ] && Q="${Q},\n"
  Q="${Q}\"${key}\": \"${val}\""
}

append_field "name"   "$NAME"
append_field "status" "$STATUS"

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
   $SERVICE_URI/detector/${DID}
