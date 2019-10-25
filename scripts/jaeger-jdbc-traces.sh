#! /bin/bash
# Given a traceId from Jaeger, This script will fetch that trace
# and spit out det

TRACE_ID=$1
TRACE_SPANS="data/spans-$TRACE_ID.json"
TRACE_QUERIES="data/queries-$TRACE_ID.txt"
TRACE_TABLES="data/tables-$TRACE_ID.txt"


if [ -z $TRACE_ID ]; then
  echo "Missing traceId"
  echo "fetch-trace <traceId>"
  exit 1
fi



curl "http://localhost:16686/api/traces/$TRACE_ID" > $TRACE_SPANS
cat $TRACE_SPANS | jq '.data[0].spans[] | select (.tags[].key=="db.statement") | .tags[] | select(.key=="db.statement") | .value' > $TRACE_QUERIES
cat $TRACE_QUERIES| grep -oE "from[ ]+([a-zA-Z0-9_]*)" | sed s/from//g | sort | uniq -c > $TRACE_TABLES