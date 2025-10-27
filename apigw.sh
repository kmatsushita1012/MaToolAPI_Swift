#!/bin/bash
METHOD=${1:-GET}
RAW_PATH=${2:-/}
BODY=${3:-""}

# pathParameters を自動抽出（簡易版）
PARAM_NAME=$(echo "$RAW_PATH" | grep -o '{[^}]*}' | tr -d '{}')
PARAM_VALUE=$(basename "$RAW_PATH")
if [ -n "$PARAM_NAME" ]; then
    PATH_PARAMS_JSON="{\"$PARAM_NAME\":\"$PARAM_VALUE\"}"
else
    PATH_PARAMS_JSON="{}"
fi

# JSON ペイロード作成
JSON_PAYLOAD=$(jq -n \
  --arg method "$METHOD" \
  --arg rawPath "$RAW_PATH" \
  --arg body "$BODY" \
  --argjson pathParams "$PATH_PARAMS_JSON" \
  '{
    version: "2.0",
    routeKey: ($method + " " + $rawPath),
    rawPath: $rawPath,
    rawQueryString: "",
    headers: {},
    queryStringParameters: {},
    pathParameters: $pathParams,
    body: $body,
    isBase64Encoded: false,
    requestContext: {
      accountId: "123456789012",
      apiId: "local",
      domainName: "localhost",
      domainPrefix: "localhost",
      http: {
        method: $method,
        path: $rawPath,
        protocol: "HTTP/1.1",
        sourceIp: "127.0.0.1",
        userAgent: "curl/7.64.1"
      },
      requestId: "id",
      routeKey: ($method + " " + $rawPath),
      stage: "$default",
      time: "26/Oct/2025:12:00:00 +0000",
      timeEpoch: 1737844800000
    }
  }'
)

# 実行
curl -X POST http://127.0.0.1:7000/invoke \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD"
