#!/bin/bash
set -e -x

yum install -y python-hashlib
curl https://copr.fedorainfracloud.org/coprs/mlampe/llvm_381_el5/repo/epel-5/mlampe-llvm_381_el5-epel-5.repo -o /etc/yum.repos.d/mlampe-llvm_381_el5-epel-5.repo
yum update -y
yum install -y openssl-devel
yum install -y clang

export CC=clang
export CXX=clang++
#ln -sf /usr/bin/clang-3.8 /usr/bin/gcc

# Compile wheels
for PYBIN in /opt/python/cp3*/bin; do
    "${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/cp3*/bin/; do
    "${PYBIN}/pip" install pogeo --no-index -f /io/wheelhouse
done
