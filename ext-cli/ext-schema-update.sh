#!/bin/bash
CWD=`echo $(dirname $(readlink -f $0))`

# Update Detector Configuration (schema + metadata), Version and Status by DetectorID (name)/version
# ATTENTION: Configuration Schema changes for the same version are not allowed. New version must be used

DID=${1:-DetectorTest}
VERSION=${2:-0.0.1}
STATUS=${STATUS:-ACTIVE}
DATA=${DATA:-detector.json}

SERVICE_URI=${SERVICE_URI:-https://localhost:8080/api/v1}
ACCESS_TOKEN=${ACCESS_TOKEN-`cat ACCESS_TOKEN`}

>&2 echo "DATA=$DATA"

# Read from file if provided
if [ "$DATA" != "" ]; then
   DATA_JSON=`cat $DATA`
   # Replace variable placeholders with actual values
   DATA_JSON=$(echo "$DATA_JSON" | sed "s/\${DID}/$DID/g" | sed "s/\${VERSION}/$VERSION/g" | sed "s/\${STATUS}/$STATUS/g")
else
  DATA_JSON=`test_data()`
fi

function test_data() {
if [ "$DATA_JSON" == "" ]; then
  read -r -d '' DATA_JSON << EOM
  {
  "name": "${DID}",
  "title": "Test",
  "description": "Detector for Tests",
  "author": "Hacken",
  "icon": "https://cdn-icons-png.flaticon.com/512/3536/3536964.png",
  "faq": [
    {
      "name": "How does it work",
      "value": "Track news from different feeds"
    },
    {
      "name": "Score",
      "value": "Condition to filter Alerts score. \n"
    },
    {
      "name": "Type",
      "value": "Type of news:\n- `rss`\n- `reddit`"
    },
    {
      "name": "Feed",
      "value": "Feeds URI\n\nMulitple URI's can be specified with comma separation. If `type` is not specified, feed can be prefixed with type (`rss://`. `reddit://`)\n"
    },
    {
      "name": "Filter",
      "value": "Content Processor (currently `regexp` filter)"
    },
    {
      "name": "Max",
      "value": "Max number of entries per Feed"
    },
    {
      "name": "Track Error",
      "value": "Track Errors\n\nMuliple tags can be specified comma-separated (e.g. `sanctions, exploit`)\n\nNegative condition can be specified by prefixing tag with exclamation mark (e.g. `! sanctions`)\n\n__Tags__:\n\n`cybercrime` - OFAC or othe cybercrime activity\n\n`sanctions` - OFAC or other sanctioned entites\n\n`sanctions_exposure` - Indirect exposure to sanctioned entities\n\n`suspicious` - Suspcious activity\n\n`exploit` - Activity in Exploit case\n"
    }
  ],
  "version": "${VERSION}",
  "status": "${STATUS}",
  "tags": [
    "SECURITY",
    "COMPLIANCE",
    "beta",
    "FINANCIAL"
  ],
  "networkTags": [
    "evm",
    "bitcoin"
  ],
  "schema": {
    "type": "object",
    "title": "Schema",
    "required": [
      "feeds",
      "cron"
    ],
    "properties": {
      "max": {
        "type": "number",
        "title": "Max",
        "default": 10,
        "description": "Max news"
      },
      "cron": {
        "type": "string",
        "title": "Cron",
        "default": "10 min",
        "description": "Cron Interval"
      },
      "desc": {
        "type": "string",
        "title": "Description",
        "default": "New post: {title}{err}",
        "description": "Description Template"
      },
      "type": {
        "type": "string",
        "title": "Feed type",
        "default": "rss",
        "description": "Feed Type"
      },
      "feeds": {
        "type": "string",
        "title": "Feeds",
        "default": "https://cointelegraph.com/rss",
        "description": "Feeds URI"
      },
      "score": {
        "type": "string",
        "title": "Score condition",
        "default": ">= 0.0",
        "description": "Track Address score condition"
      },
      "filter": {
        "type": "string",
        "title": "Content Processor",
        "default": "",
        "description": "Content Processor"
      },
      "severity": {
        "type": "number",
        "title": "Severity",
        "default": -1,
        "description": "Severity"
      },
      "track_err": {
        "type": "boolean",
        "title": "Track Errors",
        "default": true,
        "description": "Track Errors as Alerts"
      },
      "err_always": {
        "type": "boolean",
        "title": "Track Error (always)",
        "default": true,
        "description": "Always Alert on Error"
      }
    }
  },
  "uiSchema": {
    "ui:order": [
      "cron",
      "desc",
      "feeds",
      "type",
      "max",
      "score",
      "filter",
      "track_err",
      "err_always",
      "severity"
    ]
  }
}
EOM
fi
}

>&2 echo "DID=$DID"
>&2 echo "VERSION=$VERSION"
>&2 echo "STATUS=$STATUS"
>&2 echo "DATA_JSON=$DATA_JSON"

curl -S -s -D /dev/stderr \
   -X POST \
   -H 'Content-Type: application/json' \
   -H "Authorization: Bearer $ACCESS_TOKEN" \
   --data "$DATA_JSON" \
   $SERVICE_URI/schema

