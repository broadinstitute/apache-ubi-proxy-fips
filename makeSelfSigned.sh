#!/bin/bash

SSLCERT="/etc/pki/tls/certs/localhost.crt"
SSLKEY="/etc/pki/tls/private/localhost.key"

openssl genrsa 2048 > ${SSLKEY} 2> /dev/null

FQDN=`hostname`
cat << EOF | openssl req -new -key ${SSLKEY} \
         -x509 -sha256 -days 365 -set_serial $RANDOM -extensions v3_req \
         -out ${SSLCERT} 2>/dev/null
--
SomeState
SomeCity
SomeOrganization
SomeOrganizationalUnit
${FQDN}
root@${FQDN}
EOF
