# freeswitch-container

## Concept

This is a freeswitch container for easy localisation. The concept
is to regenerate `vars.xml` at startup, depending on the existence of
a file `localvars` in freeswitchs `/etc/freeswitch` directory.

The Dockerfile contains an environment from which the Values are derived.
This environment provides th defaults and looks like this:

```
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
    SIP_TLS_CIPHERS='ALL:!ADH:!LOW:!EXP:!MD5:@STRENGTH' \
    VERTO_BINDLOCAL_PORT='8082'
```

You can overwrite each of the Variables during start of an instance
of this image.

If you use a persistent volume for `/etc/freeswitch` the `vars.xml`
will only be rewritten if you delete the file `/etc/freeswitch/localvars`.

To see how this is implemented look at [localvars.sh](entrypoint.d/localvars.sh).

## Usage

Todo
