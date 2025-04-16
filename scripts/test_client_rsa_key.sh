#!/bin/sh
set -e


openssl s_client -connect localhost:4433 -tls1_3 -CAfile CA_rsa_cert.pem
