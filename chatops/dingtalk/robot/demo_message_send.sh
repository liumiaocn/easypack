#!/bin/sh

CHAT_WEBHOOK_URL='https://oapi.dingtalk.com/robot/send?access_token'
CHAT_CONTENT_TYPE='Content-Type: application/json'

echo "## demo: text: print hello liumiao"
curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
    "msgtype": "text",
    "text": {
        "content": "[LiuMiaoMsg]: hello liumiao"
    }
   }' 2>/dev/null |jq .

echo "## demo: link type message"
curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
    "msgtype": "link", 
    "link": {
        "text": "这个即将发布的新版本，创始人称它为“红树林”。
而在此之前，每当面临重大升级，产品经理们都会取一个应景的代号，这一次，为什么是“红树林”？ [LiuMiaoMsg]", 
        "title": "时代的火车向前开", 
        "picUrl": "", 
        "messageUrl": "https://liumiaocn.blog.csdn.net/article/details/103750765"
    }
   }' 2>/dev/null |jq .

echo "## demo: markdown type message"
curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
     "msgtype": "markdown",
     "markdown": {
         "title":"杭州天气",
         "text": "#### 杭州天气 \n > 9度，西北风1级，空气良89，相对温度73%\n\n >![screenshot](https://gw.alicdn.com/tfs/TB1ut3xxbsrBKNjSZFpXXcXhFXa-846-786.png)\n >###### 10点20分发布 [天气](https://www.seniverse.com/) [LiuMiaoMsg]\n"
     }
   }' 2>/dev/null |jq .

echo "## demo: actionCard singleTitle"
curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
    "actionCard": {
        "title": "乔布斯 20 年前想打造一间苹果咖啡厅，而它正是 Apple Store 的前身", 
        "text": "![screenshot](@lADOpwk3K80C0M0FoA) 
 ### 乔布斯 20 年前想打造的苹果咖啡厅 
 Apple Store 的设计正从原来满满的科技感走向生活化，而其生活化的走向其实可以追溯到 20 年前苹果一个建立咖啡馆的计划[LiuMiaoMsg]", 
        "hideAvatar": "0", 
        "btnOrientation": "0", 
        "singleTitle" : "阅读全文",
        "singleURL" : "https://www.dingtalk.com/"
    }, 
    "msgtype": "actionCard"
   }' 2>/dev/null |jq .

echo "## demo: actionCard list"
curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
   "actionCard": {
        "title": "乔布斯 20 年前想打造一间苹果咖啡厅，而它正是 Apple Store 的前身", 
        "text": "![screenshot](@lADOpwk3K80C0M0FoA) 
 ### 乔布斯 20 年前想打造的苹果咖啡厅 
 Apple Store 的设计正从原来满满的科技感走向生活化，而其生活化的走向其实可以追溯到 20 年前苹果一个建立咖啡馆的计划[LiuMiaoMsg]", 
        "hideAvatar": "0", 
        "btnOrientation": "0", 
        "btns": [
            {
                "title": "内容不错", 
                "actionURL": "https://www.dingtalk.com/"
            }, 
            {
                "title": "不感兴趣", 
                "actionURL": "https://www.dingtalk.com/"
            }
        ]
    }, 
    "msgtype": "actionCard"
   }' 2>/dev/null |jq .

echo "## demo: freecard type"
curl "${CHAT_WEBHOOK_URL}=${CHAT_WEBHOOK_KEY}" \
   -H "${CHAT_CONTENT_TYPE}" \
   -d '
   {
   "feedCard": {
        "links": [
            {
                "title": "[LiuMiaoMsg]:时代的火车向前开", 
                "messageURL": "https://liumiaocn.blog.csdn.net/article/details/103750765",
                "picURL": "https://www.dingtalk.com/"
            },
            {
                "title": "[LiuMiaoMsg]:时代的火车开不动了", 
                "messageURL": "https://liumiaocn.blog.csdn.net/article/details/103750765",
                "picURL": "https://www.dingtalk.com/"
            }
        ]
    }, 
    "msgtype": "feedCard"
   }' 2>/dev/null |jq .
