#!/bin/bash
set -x -e

yum update -y
yum -y groupinstall 'Development Tools'
yum install -y curl git irb python-setuptools ruby

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
export PATH="$HOME/.linuxbrew/bin:$PATH"

brew install gcc@5
export CC=g++-5
export CXX=g++-5

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
