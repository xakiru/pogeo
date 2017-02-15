#!/bin/bash
set -e -x

yum install -y openssl-devel

# Compile wheels
for PYBIN in /opt/python/cp3*/bin; do
    "${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done

export CC=clang
export CXX=clang++
# Install packages and test
for PYBIN in /opt/python/cp3*/bin/; do
    "${PYBIN}/pip" install git+https://github.com/Noctem/pogeo.git --no-index -f /io/wheelhouse
done
