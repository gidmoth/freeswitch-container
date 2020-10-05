FROM debian:10

## Installation
# Some convenience-tools and freeswitch 1.10
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 wget lsb-release ca-certificates gosu locales \
    && wget -O - https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add - \
    && echo "deb http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list \
    && echo "deb-src http://files.freeswitch.org/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    freeswitch \
    freeswitch-mod-commands \
    freeswitch-mod-conference \
    freeswitch-mod-dptools \
    freeswitch-mod-voicemail \
    freeswitch-mod-dialplan-xml \
    freeswitch-mod-loopback \
    freeswitch-mod-sofia \
    freeswitch-mod-local-stream \
    freeswitch-mod-native-file \
    freeswitch-mod-sndfile \
    freeswitch-mod-tone-stream \
    freeswitch-mod-console \
    freeswitch-mod-say-en \
    freeswitch-init \
    freeswitch-lang-en \
    freeswitch-timezones \
    freeswitch-meta-codecs \
    freeswitch-music \
    freeswitch-sounds-en-us-callie \
    freeswitch-mod-event-socket \
    freeswitch-mod-xml-rpc \
    freeswitch-mod-verto \
    freeswitch-mod-rtc \
    freeswitch-conf-minimal \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
#    && rm -rf /etc/freeswitch \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

## copy files/scripts
COPY entrypoint.sh /
COPY entrypoint.d /entrypoint.d/
# set ulimits
COPY build/freeswitch.limits.conf /etc/security/limits.d/
# This may work, if not, try to run with podman as a systemd.service
# and the option:
# `podman run --ulimit=host`
# copy custom config:
COPY etc-freeswitch /etc/freeswitch/

## Environment
ENV LANG en_US.utf8
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Env for freeswitch vars.xml
ENV DEFAULT_PASSWORD='110fcee8-d278-4aac-a16e-898acb394493' \
    SOUND_PREFIX='$${sounds_dir}/en/us/callie' \
    DOMAIN='$${local_ip_v4}' \
    DOMAIN_NAME='$${domain}' \
    GLOBAL_CODEC_PREFS='OPUS,G722,PCMU,PCMA,H264,VP8' \
    OUTBOUND_CODEC_PREFS='OPUS,G722,PCMU,PCMA,H264,VP8' \
    EXTERNAL_RTP_IP='$${local_ip_v4}' \
    EXTERNAL_SIP_IP='$${local_ip_v4}' \
    XML_RPC_PASSWORD='f8c8448b-0c87-4662-ae49-6a4153d87199' \
    INTERNAL_SIP_PORT='5060' \
    EXTERNAL_SIP_PORT='5080' \
    SIP_TLS_VERSION='tlsv1,tlsv1.1,tlsv1.2' \
    INTERNAL_TLS_PORT='3361' \
    INTERNAL_SSL_ENABLE='true' \
    EXTERNAL_TLS_PORT='3381' \
    EXTERNAL_SSL_ENABLE='false' \
    SIP_TLS_CIPHERS='ALL:!ADH:!LOW:!EXP:!MD5:@STRENGTH'
# Cryptdom means "Cryptodomain" -- may be different from domain, since
# you may have wildcard-certs. See entrypoint.d/letsencrypt-cert-load.sh
# for a usage example.
ENV CRYPTDOM example.com

## get the modes an permissions right
RUN chmod +x /entrypoint.sh

## Ports
# Open the container up to the world.
# 8021 fs_cli, 5060 5061 5080 5081 sip and sips, 64535-65535 rtp
EXPOSE 8021/tcp
EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp
EXPOSE 5061/tcp 5061/udp 5081/tcp 5081/udp
EXPOSE 7443/tcp
EXPOSE 5070/udp 5070/tcp
EXPOSE 64535-65535/udp
EXPOSE 16384-32768/udp

## Healthcheck to make sure the service is running
# not sure if this is working flawless with podman or cri-o
# SHELL is not supported for OCI format
#SHELL       ["/bin/bash"]
HEALTHCHECK --interval=15s --timeout=5s \
    CMD  /usr/bin/fs_cli -x status | grep -q ^UP || exit 1


ENTRYPOINT ["/entrypoint.sh"]

CMD ["freeswitch"]
