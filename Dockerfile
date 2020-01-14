FROM alpine:latest as builder

RUN apk add git curl alpine-sdk libressl-dev zlib-dev wget
RUN git clone https://github.com/TelegramMessenger/MTProxy
WORKDIR /MTProxy

RUN wget -c https://raw.githubusercontent.com/ICQFan4ever/MTProxyARMPatch/master/arm.patch
RUN patch -p1 < arm.patch

RUN wget -c https://raw.githubusercontent.com/alexdoesh/mtproxy/master/patches/randr_compat.patch
RUN patch -p0 < randr_compat.patch

RUN apk add linux-headers

RUN export NUMCPUS=$(grep -c '^processor' /proc/cpuinfo)
RUN make -j $NUMCPUS

FROM alpine:latest

RUN apk add libressl-dev zlib-dev

WORKDIR /mtproxy

COPY --from=builder /MTProxy/objs/bin/mtproto-proxy /mtproxy/mtproto-proxy

ADD entry.sh /mtproxy/entry.sh
RUN chmod +x /mtproxy/entry.sh

ENTRYPOINT ["/mtproxy/entry.sh"]
