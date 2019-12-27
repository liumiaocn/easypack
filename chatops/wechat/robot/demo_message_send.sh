#!/bin/sh

CHAT_WEBHOOK_URL='https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key'
CHAT_CONTENT_TYPE='Content-Type: application/json'

echo "## demo: text: print hello liumiao"
curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
        "msgtype": "text",
        "text": {
            "content": "hello liumiao"
        }
   }' 2>/dev/null |jq .

echo "## demo: markdown: print markdown type message"
curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
        "msgtype": "markdown",
        "markdown": {
             "content": "实时新增用户反馈<font color=\"warning\">132例</font>，请相关同事注意。\n> 类型:<font color=\"comment\">用户反馈</font>\n> 普通用户反馈:<font color=\"comment\">117例</font>\n> VIP用户反馈:<font color=\"comment\">15例</font>"
        }
   }' 2>/dev/null |jq .

echo "## demo: news: print news type message"
curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
        "msgtype": "news",
        "news": {
           "articles" : [
              {
                  "title" : "中秋节礼品领取",
                  "description" : "今年中秋节公司有豪礼相送",
                  "url" : "https://liumiaocn.blog.csdn.net/article/details/103740661",
                  "picurl" : "http://res.mail.qq.com/node/ww/wwopenmng/images/independent/doc/test_pic_msg1.png"
              }
           ]
        }
   }' 2>/dev/null |jq .
