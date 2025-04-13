#!/bin/sh
set -e

#~ #when auth value is empty
#~ openssl genpkey -config temp.cnf -pkeyopt parent-auth: -provider tpm2 -algorithm RSA -out tpm_tss_key.pem

#when auth value is set
openssl genpkey -config temp.cnf -pkeyopt parent-auth:owner123 -provider tpm2 -algorithm RSA -out tpm_tss_key.pem


openssl req -config temp.cnf -provider tpm2  -in tpm_tss_key.pem -pkeyopt parent-auth:owner123 -new -x509 -days 7300 -sha256   -out CA_rsa_cert.pem -subj '/C=SG/ST=Singapore/L=Singapore/O=Infineon Technologies/OU=DSS/CN=TPMEvalKitCA'
