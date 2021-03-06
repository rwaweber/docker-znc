# version 1.6.1-2
# docker-version 1.11.1
FROM ubuntu:15.04
MAINTAINER Jim Myhrberg "contact@jimeh.me"

ENV ZNC_VERSION 1.6.1

RUN apt-get update \
    && apt-get install -y sudo wget build-essential libssl-dev libperl-dev \
               pkg-config swig3.0 libicu-dev ca-certificates python python3 \
	       python3-dev python3-pip\
    && pip3 install requests \
    && mkdir -p /src \
    && cd /src \
    && wget "http://znc.in/releases/archive/znc-${ZNC_VERSION}.tar.gz" \
    && tar -zxf "znc-${ZNC_VERSION}.tar.gz" \
    && cd "znc-${ZNC_VERSION}" \
    && ./configure --enable-python --disable-ipv6 \
    && make \
    && make install \
    && rm -rf /src* /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get autoremove -y \
    && apt-get clean \
    && useradd znc

ADD docker-entrypoint.sh /entrypoint.sh
ADD znc.conf.default /znc.conf.default
RUN chmod 644 /znc.conf.default

VOLUME /znc-data

EXPOSE 6667
ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
