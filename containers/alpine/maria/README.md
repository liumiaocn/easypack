#MariaDB Version: 10.1.21

#docker pull
docker pull liumiaocn/maria

#docker run with default volume
docker run -d -p 3306:3306 liumiaocn/maria

#docker run with outside volume
docker volume create --name mysql 
docker run -d -p 3306:3306 -v mysql:/var/lib/mysql --name maria liumiaocn/maria
