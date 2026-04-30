#!/bin/bash
CWD=`echo $(dirname $(readlink -f $0))`

# Search for All Detectors or Speicif Detector ID (name) and Version

DID=${1}
VERSION=${2}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

if [ "$DID" != "" ]; then
   WHERE_DID=" AND name = '${DID}'"
fi

if [ "$VERSION" != "" ]; then
   WHERE_VERSION=" AND version = '${VERSION}'"
fi

read -r -d '' DATA_JSON << EOM
{
  "size":10000,
  "trackTotalCount":10000,
  "trackTotal":false,
  "where":"status=ACTIVE $WHERE_DID $WHERE_VERSION"
}
EOM

>&2 echo "DATA_JSON=$DATA_JSON"

curl -S -s \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/schema/search

# Print schema IDs and names
# cat schema.json | jq '.data[] | {id:.id,name:.name}'