FROM alpine:3.10.2
ENV NODE_VERSION 8.6.0

RUN apk add --no-cache curl gcc g++ python make linux-headers \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure  \
    && make         \
    && make install \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" 

CMD [ "node" ]
