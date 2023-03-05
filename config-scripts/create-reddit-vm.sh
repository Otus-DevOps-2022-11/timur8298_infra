#!/bin/bash
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk name=disk1,size=10,image-id=fd8qt19q9bt62n1ne8co \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4,nat-address=62.84.116.26 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/.ssh/appuser.pub
