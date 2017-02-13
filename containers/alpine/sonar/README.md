# easypack
##让Linux下没有难装的流行开源软件
##Make popular OSS easily installed in linux

#Sonarqube
## With Default H2 Database
```
docker run --rm --name sonarqube \
    -p 9000:9000 -p 9092:9092 \
    liumiaocn/sonarqube:5.6.5
```
## With Mariadb or Mysql Database
```
docker run --rm --name sonarqube \
    -p 9000:9000 -p 9092:9092 \
    -e SONARQUBE_JDBC_USERNAME=sonar \
    -e SONARQUBE_JDBC_PASSWORD=sonar \
    -e SONARQUBE_JDBC_URL=jdbc:mysql://localhost/sonar \
    liumiaocn/sonarqube:5.6.5
```

## Setting Mariadb or Mysql
```
DROP DATABASE if exists sonar;
CREATE DATABASE sonar CHARACTER SET utf8 COLLATE utf8_general_ci;
DROP USER sonar;
CREATE USER 'sonar' IDENTIFIED BY 'sonar';
GRANT ALL ON sonar.* TO 'sonar'@'%' IDENTIFIED BY 'sonar';
GRANT ALL ON sonar.* TO 'sonar'@'localhost' IDENTIFIED BY 'sonar';
FLUSH PRIVILEGES;
```
