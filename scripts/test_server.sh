#!/bin/sh
set -e

#~ #when auth value is empty
#~ openssl genpkey -config temp.cnf -pkeyopt parent-auth: -provider tpm2 -algorithm RSA -out tpm_tss_key.pem

#~ #when auth value is set
#~ openssl genpkey -config temp.cnf -pkeyopt parent-auth:owner123 -provider tpm2 -algorithm RSA -out rsa_CA.tss
#~ openssl req -config temp.cnf -provider tpm2  -in rsa_CA.tss -pkeyopt parent-auth:owner123 -new -x509 -days 7300 -sha256   -out CA_rsa_cert.pem -subj '/C=SG/ST=Singapore/L=Singapore/O=Infineon Technologies/OU=DSS/CN=TPMEvalKitCA'

#Generate CA RSA key and Certificate
openssl genpkey -algorithm RSA -out rsa_CA.pem
openssl req -key rsa_CA.pem -new -x509 -days 7300 -sha256   -out CA_rsa_cert.pem -subj '/C=SG/ST=Singapore/L=Singapore/O=Infineon Technologies/OU=DSS/CN=TPMEvalKitCA'

#Generate Server key with TPM
openssl genpkey -config temp.cnf -pkeyopt parent-auth:owner123 -provider tpm2 -algorithm RSA -out rsa_server.tss
openssl req -new -config temp.cnf -provider tpm2 -in rsa_server.tss -pkeyopt parent-auth:owner123 -subj /CN=TPM_UI/O=Infineon/C=SG -out server_rsa.csr

# OPENSSL_CONF=temp.cnf openssl x509 -req -provider tpm2 -provider base -in server_rsa.csr -CA CA_rsa_cert.pem -CAkey rsa_CA.tss -out CAsigned_rsa_cert.crt -days 365 -sha256 -CAcreateserial 

#Generate Server certificate
OPENSSL_CONF=temp.cnf openssl x509 -req -in server_rsa.csr -CA CA_rsa_cert.pem -CAkey rsa_CA.pem -out CAsigned_rsa_cert.crt -days 365 -sha256 -CAcreateserial 
