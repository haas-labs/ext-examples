# Extractor API

## Setup

Set environment

```
source ./env.dev
```

Auth JWT should be in file `ACCESS_TOKEN` or in environment variable `ACCESS_TOKEN`.

## Tenant

JWT contains the Tenant which user belongs to and authorized against. Get tenant id (`tid`):

```
cat ACCESS_TOKEN | ./jwt.sh | grep tenantId
```

Save it:
```
TID=`cat ACCESS_TOKEN | ./jwt.sh | grep tenantId | awk -F'"' '{print $4}'`
```


## Project

Tenant contains __Projects__. 

You need to know Project to get Contracts

```
./ext-projects.sh $TID | jq .data[].id
```

E.g. Save first ProjectID:

```
PID=`./ext-projects.sh $TID | jq .data[0].id`
```


## Contracts 

Get all contracts ID for the Specific Project ID

```
./ext-contracts.sh $PID | jq .data[].id
```

E.g. get first Contract:

```
CID=`./ext-contracts.sh $PID | jq .data[0].id`
```

### Detectors

Get all Detectors configured on Contract:

```
./ext-contract-detectors.sh $CID | jq .
```







