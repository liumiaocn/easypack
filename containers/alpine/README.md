#Sonarqube
## With Default H2 Database
```
docker run --rm --name sonarqube \
    -p 9000:9000 -p 9092:9092 \
    liumiaocn/sonarqube:5.6.5
```
## With Mysql Database
```
docker run --rm --name sonarqube \
    -p 9000:9000 -p 9092:9092 \
    -e SONARQUBE_JDBC_USERNAME=sonar \
    -e SONARQUBE_JDBC_PASSWORD=sonar \
    -e SONARQUBE_JDBC_URL=jdbc:mysql://localhost/sonar \
    liumiaocn/sonarqube:5.6.5
```
