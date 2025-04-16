#!/bin/sh
set -e


openssl s_client -connect localhost:4432 -tls1_3 -CAfile CA_ecc_cert.pem
