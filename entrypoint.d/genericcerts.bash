#!/bin/bash

# Run me manualy to get certs for local testing
rm -rf /etc/freeswitch/tls
mkdir /etc/freeswitch/tls
openssl req -x509 -nodes -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365
cat key.pem cert.pem > /etc/freeswitch/tls/wss.pem
cat key.pem cert.pem > /etc/freeswitch/tls/tls.pem
cat key.pem cert.pem > /etc/freeswitch/tls/dtls-srtp.pem
cp cert.pem /etc/freeswitch/tls/cafile.pem
chown -R freeswitch:freeswitch /etc/freeswitch/tls