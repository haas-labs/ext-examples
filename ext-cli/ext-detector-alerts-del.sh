AID=${1:-10646:fccb963a-104c-4086-946c-d5bec35d68be}

# ADDR=${2:-0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

curl -S -s -D /dev/stderr \
   -X DELETE \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/admin/alert/$AID

