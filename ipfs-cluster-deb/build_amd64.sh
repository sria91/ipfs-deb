#!/bin/bash

IPFS_CLUSTER_VERSION=$1

rm -rf ipfs-cluster
git clone --depth 1 --branch v$IPFS_CLUSTER_VERSION https://github.com/ipfs/ipfs-cluster.git
make -C ipfs-cluster build
mkdir -p input
cp ipfs-cluster/cmd/ipfs-cluster-service/ipfs-cluster-service input/
cp ipfs-cluster/cmd/ipfs-cluster-ctl/ipfs-cluster-ctl input/
