# TID - alien tenantID only works with Admin JWT
ADDR=${1:-anvil:0x4675c7e5baafbffbca748158becba61ef3b0a263}
META=${2:-uncached}

SERVICE_URI=${AML_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}
OID=${OID:-addr}

>&2 echo "ADDR=$ADDR"
>&2 echo "META=$META"
>&2 echo "OID=$OID"

curl -S -s -D /dev/stderr \
   -X GET \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   $SERVICE_URI/aml/${OID}/${ADDR}?meta=${META}
