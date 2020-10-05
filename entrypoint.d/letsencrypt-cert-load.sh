certupstreampath="/etc-letsencrypt/live/$CRYPTDOM"

if [ -d $certupstreampath ] && [ ! -f /etc/freeswitch/workingcerts ]
then
  rm -rf /etc/freeswitch/tls/*
  cp $certupstreampath/* /etc/freeswitch/tls/
  cd /etc/freeswitch/tls
  cat fullchain.pem privkey.pem > wss.pem 
  cat cert.pem privkey.pem > agent.pem 
  cat chain.pem > cafile.pem
  cd /
  touch /etc/freeswitch/workingcerts
  chown -R freeswitch /etc/freeswitch/tls
  echo "UPDATED CERTS"
else
  echo "CERTS NOT UPDATED"
fi