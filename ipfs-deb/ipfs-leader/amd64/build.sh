#!/bin/bash

IPFS_VERSION=$1

rm -rf go-ipfs
git clone --depth 1 --branch v$IPFS_VERSION https://github.com/ipfs/go-ipfs.git
make -C go-ipfs build
mkdir -p input
cp go-ipfs/cmd/ipfs/ipfs input/
