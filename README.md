# freeswitch-container

## Concept

This is a freeswitch container for easy localisation. The concept
is to regenerate `vars.xml` at startup, depending on the existence of
a file `localvars` in freeswitchs `/etc/freeswitch` directory.

The Dockerfile contains an environment from which the Values are derived.
This environment provides the defaults and looks like this:

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
    VERTO_BINDLOCAL_PORT='8082' \
    INTERNAL_TLS_ONLY='false'
```

You can overwrite each of the Variables during start of an instance
container of this image.

If you use a persistent volume for `/etc/freeswitch` the `vars.xml`
will only be rewritten at the first start. Either with the defaults,
or, depending on which environment you set, with other values (plus
the defaults for unset values), and the file `/etc/freeswitch/localvars`
will be created. As `localvars` now exists on the persistent volume,
`vars.xml` won't be rewritten anymore, unless you delete `localvars`,
and start a new instance of the image with the same Volume mountet
at `/etc/freeswitch`.

To see how this is implemented look at [localvars.sh](https://github.com/gidmoth/freeswitch-container/blob/main/entrypoint.d/localvars.sh).

## Usage

It is recommended to start instances of this freeswitch image with
hostnetworking, since the minimal config provided is not prepared for
NAT handling, and for performance reasons.

If you want to run a container in a production environment you will
need working TLS, which means certificates acceptet by your clients.
One way to get the certs is letsencrypt, see [here](https://github.com/gidmoth/certbot-scripts)
for an example.

Freeswitch needs the certs in a certain format, for the case of
letsencrypt certs there is a script provided [here](https://github.com/gidmoth/freeswitch-container/blob/main/entrypoint.d/letsencrypt-cert-load.sh).
This is just an example, and the script will not run if you don't provide
the necessary environment or volume mount. Since certificates need renewal
from time to time, the example uses the same "file exists?" logic as
the vars mechanism, combined with a check for the right `CRYPTDOM`
environment.

Example start (you can replace `podman` with `docker`):

```
podman run --name=freeswitch \
  --env CRYPTDOM="example.com" \
  -v freeswitch_etc-freeswitch:/etc/freeswitch \
  -v certbot_etc-letsencrypt:/etc-letsencrypt \
  --network=host \
  --env DOMAIN_NAME="example.com" \
  --env DOMAIN="example.com" \
  gidmoth/freeswitch:latest freeswitch
```
