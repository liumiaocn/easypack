# easypack
##让Linux下没有难装的流行开源软件
##Make popular OSS easily installed in linux


![这里写图片描述](http://img.blog.csdn.net/20160804065323615)
#docker pull
docker pull liumiaocn/gitlab

#docker run
```
docker run --detach \
    --publish 443:443 --publish 80:80 \  
    liumiaocn/gitlab:latest
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

>邮箱设定参照
```
gitlab_rails['gitlab_email_from'] = 'xxxxxxxx@163.com'
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.163.com"
gitlab_rails['smtp_port'] = 25
gitlab_rails['smtp_user_name'] = "xxxxxxxx@163.com"
gitlab_rails['smtp_password'] = "xxxxxx"
gitlab_rails['smtp_domain'] = "163.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = false
gitlab_rails['smtp_openssl_verify_mode'] = 'peer' 
user['git_user_email'] = "xxxxxxxx@163.com"
```

#其他详细请参照：
http://blog.csdn.net/liumiaocn/article/details/52115571
