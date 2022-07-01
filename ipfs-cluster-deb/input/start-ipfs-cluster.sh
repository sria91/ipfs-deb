#!/bin/bash

source /etc/ipfs-cluster/env.sh
ipfs-cluster-service daemon --bootstrap $BOOTSTRAP
