certupstreampath="/etc-letsencrypt/live/$CRYPTDOM"

if [ -d $certupstreampath ] && [ ! -f /etc/freeswitch/workingcerts ]
then
  rm -rf /etc/freeswitch/tls/*
  cp $certupstreampath/* /etc/freeswitch/tls/
  cd /etc/freeswitch/tls
  cat fullchain.pem privkey.pem > all.pem 
  ln -s all.pem tls.pem 
  ln -s all.pem agent.pem 
  ln -s all.pem wss.pem
  ln -s all.pem dtls-srtp.pem
  wget https://ssl-tools.net/certificates/dac9024f54d8f6df94935fb1732638ca6ad77c13.pem
  cat chain.pem dac9024f54d8f6df94935fb1732638ca6ad77c13.pem > cafile.pem
  cd /
  touch /etc/freeswitch/workingcerts
  chown -R freeswitch:freeswitch /etc/freeswitch/tls
  echo "UPDATED CERTS"
else
  echo "CERTS NOT UPDATED"
fi
