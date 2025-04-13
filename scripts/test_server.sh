#!/bin/sh
set -e

openssl genpkey -config temp.cnf -provider tpm2 -algorithm RSA -out testkey.priv
