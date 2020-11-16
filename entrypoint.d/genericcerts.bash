# Run me manualy to get certs for local testing
  rm -rf /etc/freeswitch/tls/*
  gentls_cert setup -cn $(hostname -i) -alt DNS:$(hostname -i) -org freeswitch.org
  gentls_cert create_server -cn $(hostname -i) -alt DNS:$(hostname -i) -org freeswitch.org
  cd /etc/freeswitch/tls
  ln -s agent.pem tls.pem 
  ln -s agent.pem agent.pem 
  ln -s agent.pem wss.pem
  ln -s agent.pem dtls-srtp.pem
  touch /etc/freeswitch/workingcerts
  chown -R freeswitch /etc/freeswitch/tls
