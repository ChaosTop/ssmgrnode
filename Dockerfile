FROM debian:stretch
LABEL maintainer="Codesheng <nstop.sheng@gmail.com>"

COPY startup.sh /root/startup.sh
RUN set -ex \
	&& printf "deb http://deb.debian.org/debian sid main" > /etc/apt/sources.list.d/sid.list \
	&& apt-get update \
	&& export DEBIAN_FRONTEND=noninteractive \
	&& apt-get -t sid install -y --no-install-recommends shadowsocks-libev simple-obfs tzdata iproute2 curl git sudo software-properties-common \
	&& curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs \
	&& npm i -g shadowsocks-manager --unsafe-perm \
    && echo "Asia/Shanghai" > /etc/timezone \
    && rm /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
	&& rm -rf /var/lib/apt/lists/* \
	&& chmod +x /root/startup.sh

CMD [ "./root/startup.sh" ]
