FROM alpine:3.9

ADD html /webdemo/html
ADD server.py /webdemo

run apk add --no-cache python

cmd ["python", "/webdemo/server.py"]
