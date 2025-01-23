# TID - alien tenantID only works with Admin JWT
ADDR=${1:-anvil:0x4675c7e5baafbffbca748158becba61ef3b0a263}

SERVICE_URI=${AML_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "ADDR=$ADDR"

curl -S -s -D /dev/stderr \
   -X GET \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   $SERVICE_URI/aml/gl/${ADDR}?meta=report

# DoS !
# curl -S -s -D /dev/stderr \
#    -X GET \
#    -H 'Content-Type: application/json' \
#    -H "Authorization: Bearer $ACCESS_TOKEN" \
#    $SERVICE_URI/aml/gl/?${ADDR}meta=report

