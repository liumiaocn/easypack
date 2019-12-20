FROM liumiaocn/android:sdk.26.1.1
COPY Demo/ /data/Demo
RUN /data/Demo/gradlew --version
