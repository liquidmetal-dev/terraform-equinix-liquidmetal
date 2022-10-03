#!/bin/bash

wget https://raw.githubusercontent.com/weaveworks-liquidmetal/flintlock/main/hack/scripts/provision.sh
chmod +x provision.sh

CONTAINERD="v1.6.6" ./provision.sh all -y \
  --grpc-address "0.0.0.0:9090" \
  --parent-iface "bond0.$VLAN_ID" \
  --insecure
