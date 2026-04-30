#!/bin/bash
CWD=`echo $(dirname $(readlink -f $0))`

# Disable Detector by DetectorID (name) and Version

DID=${1:-DetectorTest}
VERSION=${2:-0.0.1}
STATUS=${3:-DISABLED}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "DID=$DID"
>&2 echo "VERSION=$VERSION"
>&2 echo "STATUS=$STATUS"

DATA_JSON=`${CWD}/ext-schema-search.sh $DID $VERSION`
# Replace variable placeholders with actual values
# Replace version and status attributes (even if they don't have placeholders)
DATA_JSON=$(echo "$DATA_JSON" | sed "s/\"version\":[[:space:]]*\"[^\"]*\"/\"version\": \"$VERSION\"/g")
DATA_JSON=$(echo "$DATA_JSON" | sed "s/\"status\":[[:space:]]*\"[^\"]*\"/\"status\": \"$STATUS\"/g")

echo $DATA_JSON

exit 0

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/schema

