#!/bin/bash
# chmod 755 client-x.sh

PROTOCOL=http

if [ -z "$API_HOST" ]; then
  API_HOST=localhost
fi
if [ -z "$API_PORT" ]; then
  API_PORT=3000
fi

while true
  do sleep 1

  RES=$(curl -s -w "\n%{http_code}" ${PROTOCOL}://${API_HOST}:${API_PORT}/path-01)
  HTTP_STATUS_CODE=$(tail -n1 <<< "$RES")  # get the last line
  BODY=$(sed '$ d' <<< "$RES")             # get all but the last line which contains the status code
  if [ "$HTTP_STATUS_CODE" == "200" ]; then
    MSG=$(jq '.message + " | " + .internalInfo.serviceName + " (" + .internalInfo.version + ") | " + .internalInfo.hostname.fromOS' <<< "$BODY")
    MSG=$(tr -d "\"" <<< "$MSG")
  fi
  if [ "$HTTP_STATUS_CODE" != "200" ]; then
    MSG=$HTTP_STATUS_CODE
  fi
  echo "[INFO] get /path-01 | ${MSG}"

done
