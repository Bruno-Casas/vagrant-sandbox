#!/bin/bash

dd if=/dev/zero of=/volume.img bs=1M count=512
mkfs.ext4 /volume.img
mount -t auto -o loop /volume.img /shared/minio

rc-service minio restart
rc-service minio status

exit 0