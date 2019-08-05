FROM node:12-alpine
LABEL maintainer="codesheng <nstop.sheng@gmail.com>"

ENV SS_VER=3.0.8
ENV SS_URL=https://github.com/shadowsocks/shadowsocks-libev/releases/download/v$SS_VER/shadowsocks-libev-$SS_VER.tar.gz

ENV SIMPLE_OBFS_VER=0.0.5

COPY startup.sh /root/startup.sh

RUN set -ex && \
    apk add --no-cache --virtual .build-deps \
                                automake \
                                autoconf \
                                build-base \
                                curl \
                                libev-dev \
                                libtool \
                                linux-headers \
                                libsodium-dev \
                                mbedtls-dev \
                                pcre-dev \
                                c-ares-dev \
                                git \
                                tar \
                                udns-dev && \
    cd /tmp && \
    git clone --depth=1 https://github.com/shadowsocks/simple-obfs.git . && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \
    rm -rf * && \
    curl -sSL $SS_URL | tar xz --strip 1 && \
    ./configure --prefix=/usr --disable-documentation && \
    make install && \    
    cd .. && \
    runDeps="$( \
        scanelf --needed --nobanner /usr/bin/ss-* \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | xargs -r apk info --installed \
            | sort -u \
    )" && \
    apk add --no-cache --virtual .run-deps rng-tools $runDeps && \
    apk del .build-deps && \
    rm -rf /tmp/*  && \
	apk --no-cache add tzdata iproute2  && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&  \
    echo "Asia/Shanghai" > /etc/timezone  &&  \
    npm i -g shadowsocks-manager --unsafe-perm && \
	chmod +x /root/startup.sh

CMD [ "./root/startup.sh" ]
