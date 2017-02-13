#docker pull
docker pull liumiaocn/mysql

#docker run with default volume
docker run -d -p 3306:3306 liumiaocn/mysql

#docker run with outside volume
docker volume create --name mysql
docker run -d -p 3306:3306 -v mysql:/var/lib/mysql --name mysql liumiaocn/mysql
