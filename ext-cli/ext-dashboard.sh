
PID=${1:-898}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "PID=$PID"

# Calculate timestamps in milliseconds
TS1=$(date +%s%3N)  # Current time in milliseconds
TS0=$(date -d "24 hours ago" +%s%3N)  # 24 hours ago in milliseconds

DATA_JSON="{\"from\":$TS0,\"to\":$TS1,\"interval\":\"1d\",\"timezone\":\"Europe/Kiev\",\"id\":$PID}"

>&2 echo "DATA_JSON=$DATA_JSON"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/project/${PID}/dashboard

