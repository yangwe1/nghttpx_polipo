FROM phusion/baseimage:0.10.2
MAINTAINER weiyang512@gmail.com

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list &&\
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list &&\
    apt-get update && apt update -yqq && apt install -yqq nghttp2 polipo && apt clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY polipo.conf /etc/polipo/polipo.conf
RUN ip route show | awk '/default/ {print $3}' > /etc/container_environment/ADDR &&\
    echo 1080 > /etc/container_environment/SS_PORT
RUN mkdir -p /etc/service/polipo && \
    printf "#!/bin/sh\n\nexec /usr/bin/polipo -c /etc/polipo/polipo.conf socksParentProxy=\"\$ADDR:\$SS_PORT\"\n" > /etc/service/polipo/run &&\
    chmod +x /etc/service/polipo/run && mkdir -p /etc/service/nghttpx/ &&\
    printf "#!/bin/sh\n\nexec /usr/sbin/nghttpx -s -f'*,9699' -b127.0.0.1,3128 /certs/\$KEY /certs/\$CERT\n" > /etc/service/nghttpx/run &&\
    chmod +x /etc/service/nghttpx/run

EXPOSE 9699
