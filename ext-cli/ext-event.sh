cid=${1:-7846}
ADDR=${2:-0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266}

EVENT_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

ts=$(date +%s%3N)
eid=$(head -c 16 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 16)
sid=${sid:-ext}
typ=${typ:-nothing}
did=${did}
cat=${cat:-ALERT}
sev=${sev:-0.15}
data=${data:-"data"}

read -d '' DATA_JSON <<EOF
{
  "events": [
    {
      "ts": ${ts},
      "cid": ${cid},
      "did": "${did}",
      "sid": "${sid}",
      "eid": "${eid}",
      "type": "${typ}",
      "category": "${cat}",
      "severity": ${sev},
      "blockchain": {
        "chain_id": "31337",
        "network": "anvil"
      },
      "metadata": {
         "monitored_contract": "${ADDR}",
         "desc": "Description",
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
   $EVENT_URI/event

