
![这里写图片描述](http://img.blog.csdn.net/20160804065323615)
#docker pull
docker pull liumiaocn/gitlab

#docker run
>事前准备
```
#mkdir -p /srv/gitlab/config /srv/gitlab/logs /srv/gitlab/data
```
>docker run
```
docker run --detach \
    --hostname host32 \
    --publish 443:443 --publish 80:80 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```

#登陆画面
|登陆URL	|http://192.168.32.32	|

![这里写图片描述](http://img.blog.csdn.net/20160806170902357)
>登陆后画面
![这里写图片描述](http://img.blog.csdn.net/20160806171326062)
#创建Group
![这里写图片描述](http://img.blog.csdn.net/20160806171639360)

>创建后

![这里写图片描述](http://img.blog.csdn.net/20160806171657032)
#创建Project
![这里写图片描述](http://img.blog.csdn.net/20160806173032381)

>创建后

![这里写图片描述](http://img.blog.csdn.net/20160806173231702)

#其他详细请参照：
http://blog.csdn.net/liumiaocn/article/details/52115571
