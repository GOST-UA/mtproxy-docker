#!/bin/sh

# --ipv6/-6                               enables ipv6 TCP/UDP support
# --max-special-connections/-C <arg>      sets maximal number of accepted client connections per worker
# --domain/-D <arg>                       adds allowed domain for TLS-transport mode, disables other transports; can be specified more than once
# --http-ports/-H <arg>                   comma-separated list of client (HTTP) ports to listen
# --slaves/-M <arg>                       spawn several slave workers; not recommended for TLS-transport mode for better replay protection
# --proxy-tag/-P <arg>                    16-byte proxy tag in hex mode to be passed along with all forwarded queries
# --mtproto-secret/-S <arg>               16-byte secret in hex mode
# --ping-interval/-T <arg>                sets ping interval in second for local TCP connections (default 5.000)
# --window-clamp/-W <arg>                 sets window clamp for client TCP connections
# --backlog/-b <arg>                      sets backlog size
# --connections/-c <arg>                  sets maximal connections number
# --daemonize/-d {arg}                    changes between daemonize/not daemonize mode
# --help/-h                               prints help and exits
# --log/-l <arg>                          sets log file name
# --port/-p <arg>                         <port> or <sport>:<eport> sets listening port number or port range
# --user/-u <arg>                         sets user name to make setuid
# --verbosity/-v {arg}                    sets or increases verbosity level
# --aes-pwd <arg>                         sets custom secret.conf file
# --nice <arg>                            sets niceness
# --msg-buffers-size <arg>                sets maximal buffers size (default 268435456)
# --disable-tcp                           do not open listening tcp socket
# --crc32c                                Try to use crc32c instead of crc32 in tcp rpc
# --cpu-threads <arg>                     Number of CPU threads (1-64, default 8)
# --io-threads <arg>                      Number of I/O threads (1-64, default 16)
# --allow-skip-dh                         Allow skipping DH during RPC handshake
# --force-dh                              Force using DH for all outbound RPC connections
# --max-accept-rate <arg>                 max number of connections per second that is allowed to accept
# --max-dh-accept-rate <arg>              max number of DH connections per second that is allowed to accept
# --multithread {arg}                     run in multithread mode
# --tcp-cpu-threads <arg>                 number of tcp-cpu threads
# --tcp-iothreads <arg>                   number of tcp-io threads
# --nat-info <arg>                        <local-addr>:<global-addr>      sets network address translation for RPC protocol handshake
# --address <arg>                         tries to bind socket only to specified address
# --http-stats                            allow http server to answer on stats queries

LOCAL_IP=$(hostname -i)

ARGS="-u nobody -p 8888 -H 443 --aes-pwd /mtproxy/config/proxy-secret /mtproxy/config/proxy-multi.conf"
  [ "${SECRET}" != "" ]               && ARGS="${ARGS} -S ${SECRET}"
  [ "${VERBOSE}" == "true" ]          && ARGS="${ARGS} --verbosity"
  [ "${IPV6}" == "true" ]             && ARGS="${ARGS} --ipv6"
  [ "${MAX_SPEC_CONN}" != "" ]        && ARGS="${ARGS} -C ${MAX_SPEC_CONN}"
  [ "${DOMAIN}" != "" ]               && ARGS="${ARGS} -D ${DOMAIN}"
  [ "${HTTP_PORTS}" != "" ]           && ARGS="${ARGS} -H ${HTTP_PORTS}"
  [ "${SLAVES}" != "" ]               && ARGS="${ARGS} -M ${SLAVES:-1}"
  [ "${PROXY_TAG}" != "" ]            && ARGS="${ARGS} -P ${PROXY_TAG}"
  [ "${PING_INTERVAL}" != "" ]        && ARGS="${ARGS} -T ${PING_INTERVAL}"
  [ "${WINDOW_CLAMP}" != "" ]         && ARGS="${ARGS} -W ${WINDOW_CLAMP}"
  [ "${BACKLOG}" != "" ]              && ARGS="${ARGS} -b ${BACKLOG}"
  [ "${CONNECTIONS}" != "" ]          && ARGS="${ARGS} -c ${CONNECTIONS}"
  [ "${MSG_BUF_SIZE}" != "" ]         && ARGS="${ARGS} --msg-buffers-size ${MSG_BUF_SIZE}"
  [ "${CPU_THREADS}" != "" ]          && ARGS="${ARGS} --cpu-threads ${CPU_THREADS}"
  [ "${IO_THREADS}" != "" ]           && ARGS="${ARGS} --io-threads ${IO_THREADS}"
  [ "${ALLOW_SKIP_DH}" == "true" ]    && ARGS="${ARGS} --allow-skip-dh"
  [ "${FORCE_DH}" == "true" ]         && ARGS="${ARGS} --force-dh"
  [ "${MAX_ACCEPT_RATE}" != "" ]      && ARGS="${ARGS} --max-accept-rate ${MAX_ACCEPT_RATE}"
  [ "${MAX_ACCEPT_DH_RATE}" != "" ]   && ARGS="${ARGS} --max-dh-accept-rate ${MAX_ACCEPT_DH_RATE}"
  [ "${MULTITHEAD}" != "" ]           && ARGS="${ARGS} --multithread ${MULTITHEAD}"
  [ "${TCP_CPU_THREADS}" != "" ]      && ARGS="${ARGS} --tcp-cpu-threads ${TCP_CPU_THREADS}"
  [ "${TCP_IO_THREADS}" != "" ]       && ARGS="${ARGS} --tcp-iothreads ${TCP_IO_THREADS}"
  [ "${NAT_INFO}" != "" ]             && ARGS="${ARGS} --nat-info $LOCAL_IP:${NAT_INFO}"
  [ "${ADDRESS}" != "" ]              && ARGS="${ARGS} --address ${ADDRESS}"
  [ "${HTTP_STATS}" == "true" ]       && ARGS="${ARGS} --http-stats"

exec /mtproxy/mtproto-proxy ${ARGS}
