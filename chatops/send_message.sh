#!/bin/sh

usage(){
	echo "usage: $0 TYPE TITLE CONTENT [URL]"
	echo "       TYPE: wechat|dingtalk"
}

TYPE="$1"
TITLE="$2"
CONTENT="$3"
URL="$4"

CHAT_CONTENT_TYPE='Content-Type: application/json'
DEFAULT_PIC_URL="https://img-blog.csdnimg.cn/20191227152859635.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9saXVtaWFvY24uYmxvZy5jc2RuLm5ldA==,size_16,color_FFFFFF,t_70"
DINGTALK_DEFAULT_WORDS=" [LiuMiaoMsg]"
if [ $# -lt 3 ]; then
  usage
  exit 1
fi

if [ _"${TYPE}" = _"wechat" ]; then
  CHAT_WEBHOOK_URL='https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key'
elif [ _"${TYPE}" = _"dingtalk" ]; then
  CHAT_WEBHOOK_URL='https://oapi.dingtalk.com/robot/send?access_token'
else
  usage
  exit 1
fi

if [ _"${CHAT_WEBHOOK_KEY}" = _"" ]; then
  echo "please make sure CHAT_WEBHOOK_KEY has been exported as environment variable"
  usage
  exit 1
fi

if [ _"${URL}" = _"" ]; then
  URL="https://liumiaocn.blog.csdn.net/article/details/103740661"
fi

echo "## send message for : ${TYPE}"
if [ _"${TYPE}" = _"wechat" ]; then
  curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
        "msgtype": "news",
        "news": {
           "articles" : [
              {
                  "title" : "'"${TITLE}"'",
                  "description" : "'"${CONTENT}"'",
                  "url" : "'"${URL}"'",
                  "picurl" : "'"${DEFAULT_PIC_URL}"'"
              }
           ]
        }
   }'
elif [ _"${TYPE}" = _"dingtalk" ]; then
  curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
    "msgtype": "link", 
    "link": {
        "text": "'"${CONTENT}${DINGTALK_DEFAULT_WORDS}"'", 
        "title": "'"${TITLE}"'", 
        "picUrl": "'"${DEFAULT_PIC_URL}"'", 
        "messageUrl": "'"${URL}"'"
    }
   }'
else
  usage
  exit 1
fi
