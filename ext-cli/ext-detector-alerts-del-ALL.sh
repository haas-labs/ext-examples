CWD=`echo $(dirname $(readlink -f $0))`

CID=${1:-4976}

$CWD/ext-detector-alerts.sh $CID | jq -r .data[].uid | while read -r AID; do
    echo "Delete: $AID"
    $CWD/ext-detector-alerts-del.sh $AID
done
