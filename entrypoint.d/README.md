`genericcerts.bash` is a way to get certificates
for local testing of tls.

Adjst the names to your local environment, `$(hostrname -i)`
is just to match the default names in vars.xml.

You will have to: Run the container with `/etc/freeswitch` as
persistent volume.

Run the script. Restart the container with the same persistent
volume.

