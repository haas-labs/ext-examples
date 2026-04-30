#!/bin/bash
CWD=`echo $(dirname $(readlink -f $0))`

# ATTENTION: Supported roles: extractor-event,extractor-service,extractor-admin,admin
# Chain is important to have even if "Entity" is not Contract/Address
# Example:
# ACCESS_TOKEN=`cat ACCESS_TOKEN_DEV_ADMIN` CHAIN=ethereum ./ext-event.sh 25178 "Message"

#CID=${1}
DID=${1}
DESC=${2}
#ADDR=${ADDR:-0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266}
ADDR=${ADDR:-0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266}
CHAIN=${CHAIN}

if [[ "$CHAIN" != "" && "$CHAIN_ID" == "" ]]; then
  case "$CHAIN" in
   "ethereum_sepolia")
      CHAIN_ID="11155111"
      ;;
   "ethereum")
      CHAIN_ID="1"
      ;;
  esac  
fi

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

ts=$(date +%s%3N)
eid=$(head -c 16 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 16)
sid=${sid:-ext:ad}
typ=${typ:-none}
cat=${cat:-ALERT}
sev=${sev:-0.15}
data=${DATA:-"user_data"}

if [ "$ADDR" != "" ]; then
  Q_ADDR="\"monitored_contract\": \"${ADDR}\","
fi

if [ "$CHAIN" != "" ]; then
  Q_CHAIN="\"blockchain\": {\"chain_id\": \"${CHAIN_ID}\",\"network\": \"${CHAIN}\"},"
else
  Q_CHAIN="\"blockchain\": {\"chain_id\": \"\",\"network\": \"\"},"
fi

read -d '' DATA_JSON <<EOF
{
  "events": [
    {
      "ts": ${ts},
      "cid": ${DID},
      "did": "${DID}",
      "sid": "${sid}",
      "eid": "${eid}",
      "type": "${typ}",
      "category": "${cat}",
      "severity": ${sev},
      $Q_CHAIN
      "metadata": {
         ${Q_ADDR}
         "desc": "${DESC}",
         "data": "${data}"
      }
    }
  ]
}
EOF

>&2 echo "DATA_JSON=$DATA_JSON"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/event

