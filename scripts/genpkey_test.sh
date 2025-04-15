#!/bin/bash
set -e
OPENSSL_CONF=./temp.cnf

tpm2_evictcontrol -C o -P owner123 -c 0x81000008
tpm2_createprimary -C o -P owner123 -g sha256 -G ecc -c primary_sh.ctx
tpm2_evictcontrol -C o -P owner123 -c primary_sh.ctx 0x81000008
openssl genpkey -algorithm RSA -provider tpm2 -pkeyopt bits:2048 -pkeyopt parent:0x81000008 -out rsa2.pem
#openssl genpkey -algorithm RSA -provider tpm2 -pkeyopt bits:2048 -pkeyopt parent-auth:owner123 -out rsa2.pem
openssl pkey -provider tpm2 -provider default -in rsa2.pem -pubout -out rsa2.pub.pem
openssl rsa -pubin -text -in rsa2.pub.pem

#encryt and decrypt
openssl pkeyutl -pubin -inkey rsa2.pub.pem -in input_data.txt -encrypt -out mycipher
xxd mycipher
OPENSSL_CONF=temp.cnf openssl pkeyutl -provider tpm2 -provider default -inkey rsa2.pem -decrypt -in mycipher -out mydecipher

#sign
openssl dgst -sha256 -binary input_data.txt > input_data.hash
openssl pkeyutl -provider tpm2 -provider default -pkeyopt rsa_padding_mode:pss -inkey rsa2.pem -sign -rawin -in input_data.hash -out mysig
xxd mysig

#verify
#openssl pkeyutl -pkeyopt pad-mode:pss -digest sha256 -pubin -inkey rsa2.pub.pem -verify -rawin -in input_data.hash -sigfile mysig

