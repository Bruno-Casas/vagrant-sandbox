#!/bin/bash


cat <<EOF > /etc/minio/minio.conf
MINIO_VOLUMES="http://10.0.0.1{1...4}/shared/minio"
# Server user.
# MINIO_ROOT_USER=example-user
# Server password.
# MINIO_ROOT_PASSWORD=example-password
# Use if you want to run Minio on a custom port.
MINIO_OPTS="--address :3000"

EOF

if test ! -f "/volume.img"; then
    dd if=/dev/zero of=/volume.img bs=1M count=512
    mkfs.ext4 /volume.img
fi

if ! grep -q "/shared/minio" "/proc/mounts" ; then
    mount -t auto -o loop /volume.img /shared/minio
fi

chown -R minio:minio /shared/minio

systemctl restart minio

exit 0