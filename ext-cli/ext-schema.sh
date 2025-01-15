
SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

DATA_JSON="{\"size\":10000,\"trackTotalCount\":10000,\"trackTotal\":false,\"where\":\"status=ACTIVE\"}"

>&2 echo "DATA_JSON=$DATA_JSON"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/schema/search

# Print schema IDs and names
# cat schema.json | jq '.data[] | {id:.id,name:.name}'