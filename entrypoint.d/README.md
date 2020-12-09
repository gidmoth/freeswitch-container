`genericcerts.bash` is a way to get certificates
for local testing of tls. It is interactive so you'll
have to run it in a shell in the container.

What forms of the certs freeswitch needs for all the
picky SIP-Clients out there is hard to tell, but it should become
clear from the [freeswitch-docs for tls](https://freeswitch.org/confluence/display/FREESWITCH/SIP+TLS).

`letsencrypt-cert-load.sh` in this folder is a script which will
be run by the entypoint depending on the environment you run this
Image with. It's meant for the case of certificates and key from
letsencrypt, assumes the default-letsencrypt-folder (`/etc/letsencrypt`)
mountet under `/etc-letsencrypt` and brings in the certs and key from
there if the environment-vars `CRYPTDOM` and `CAPEM_URL` are set correctly,
and the file /etc/freeswitch/workincerts does not exist. The `CAPEM_URL`
is not needed for some Clients, freeswitch does fine with the chain only,
or no `cafile.pem` at all. But some clients seem to need it. Simply adjust
the script to your environment.

The `CAPEM_URL` should point to a copy of the cacert your chain.pem is
connectet to. The default-value points to a public copy of the cacert
my letsencrypt-cahin.pem was pointing to. To find out for your chain.pem
run the following command:

`openssl x509 -in chain.pem -noout -issuer`

Then search for the cafile named in the output, e.g. "DST Root CA X3",
and set `CAPEM_URL` to a link to this file.

