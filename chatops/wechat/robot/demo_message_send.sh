#!/bin/sh

CHAT_WEBHOOK_URL='https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key'
CHAT_CONTENT_TYPE='Content-Type: application/json'

curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
        "msgtype": "text",
        "text": {
            "content": "hello liumiao"
        }
   }' 2>/dev/null |jq .
