
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
|登陆URL	|http://192.168.32.123	|

