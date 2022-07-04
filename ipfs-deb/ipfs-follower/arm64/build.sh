#!/bin/bash

IPFS_VERSION=$1
OPENSSL_VERSION=$2
LIBSSL_VERSION=$3

wget http://ports.ubuntu.com/pool/main/o/openssl/libssl${OPENSSL_VERSION}_${LIBSSL_VERSION}_arm64.deb -O libssl.deb
dpkg-deb -xv ./libssl.deb libssl
sudo mkdir -p /usr/lib/aarch64-linux-gnu
sudo cp -rv ./libssl/usr/lib/aarch64-linux-gnu/* /usr/lib/aarch64-linux-gnu/
wget http://ports.ubuntu.com/pool/main/o/openssl/libssl-dev_${LIBSSL_VERSION}_arm64.deb -O libssl-dev.deb
dpkg-deb -xv ./libssl-dev.deb libssl-dev
sudo mkdir -p /usr/include/aarch64-linux-gnu/openssl
sudo cp -v ./libssl-dev/usr/include/aarch64-linux-gnu/openssl/opensslconf.h /usr/include/aarch64-linux-gnu/openssl/opensslconf.h
sudo cp -rv ./libssl-dev/usr/lib/aarch64-linux-gnu/* /usr/lib/aarch64-linux-gnu/
sudo apt-get update
sudo apt-get install -y gcc-aarch64-linux-gnu
rm -rf go-ipfs
git clone --depth 1 --branch v$IPFS_VERSION https://github.com/ipfs/go-ipfs.git
export CC=aarch64-linux-gnu-gcc
make -C go-ipfs build GOOS=linux GOARCH=arm64 GOTAGS=openssl CGO_ENABLED=1
mkdir -p input
cp go-ipfs/cmd/ipfs/ipfs input/
