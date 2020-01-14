#!/bin/sh
echo "Creating shared configuration folder"
mkdir -p ./shared-config

echo "Obtaining a secret for telegram servers"
curl -s https://core.telegram.org/getProxySecret -o ./shared-config/proxy-secret

echo "Pulling current telegram configuration"
curl -s https://core.telegram.org/getProxyConfig -o ./shared-config/proxy-multi.conf

echo "Starting basic configuration. You can edit it manually later in file './config/conf.env'"
read -p "Generate proxy secret? [Y/n] " gen_secr
case $gen_secr in
    [Nn]* ) SECRET=
        ;;
    * ) SECRET=$(head -c 16 /dev/urandom | xxd -ps)
        ;;
esac

read -p "Number of slave workers [2]: " slaves
if [-z "$slaves"]
then
    SLAVES_QTY=2
fi

echo "Creating local config folder"
mkdir -p ./config

echo "Creating ENV file in config folder"
echo "SECRET=$SECRET" >> ./config/conf.env
echo "# VERBOSE=true" >> ./config/conf.env
echo "# IPV6=" >> ./config/conf.env
echo "# MAX_SPEC_CONN=" >> ./config/conf.env
echo "DOMAIN=google.com" >> ./config/conf.env
echo "# HTTP_PORTS=" >> ./config/conf.env
echo "SLAVES=$SLAVES" >> ./config/conf.env
echo "PROXY_TAG=" >> ./config/conf.env
echo "# PING_INTERVAL=" >> ./config/conf.env
echo "# WINDOW_CLAMP=" >> ./config/conf.env
echo "# BACKLOG=" >> ./config/conf.env
echo "# CONNECTIONS=" >> ./config/conf.env
echo "# MSG_BUF_SIZE=" >> ./config/conf.env
echo "# CPU_THREADS=" >> ./config/conf.env
echo "# IO_THREADS=" >> ./config/conf.env
echo "# ALLOW_SKIP_DH=" >> ./config/conf.env
echo "FORCE_DH=true" >> ./config/conf.env
echo "# MAX_ACCEPT_RATE=" >> ./config/conf.env
echo "# MAX_ACCEPT_DH_RATE=" >> ./config/conf.env
echo "# MULTITHEAD=" >> ./config/conf.env
echo "# TCP_CPU_THREADS=" >> ./config/conf.env
echo "# TCP_IO_THREADS=" >> ./config/conf.env
echo "NAT_INFO=" >> ./config/conf.env
echo "# ADDRESS=" >> ./config/conf.env
echo "HTTP_STATS=true" >> ./config/conf.env

echo "Done."
