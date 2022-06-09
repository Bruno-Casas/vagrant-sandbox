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

echo 'minioadmin:minioadmin' > /passwd-s3fs
chmod 600 /passwd-s3fs

if test ! -f "/volume.img"; then
    dd if=/dev/zero of=/volume.img bs=1M count=512
    mkfs.ext4 /volume.img
fi

if ! grep -q "/shared/minio" "/proc/mounts" ; then
    mount -t auto -o loop /volume.img /shared/minio
fi

chown -R minio:minio /shared/minio

systemctl restart minio
systemctl restart docker

while ! nc -z 127.0.0.1 3000; do echo 'Aguardando o servidor de arquivos' && sleep 1; done;

mcli config host add minioserver http://127.0.0.1:3000 minioadmin minioadmin && \
mcli mb minioserver/teste

echo 'Iniciando montagem da pasta compartilhada' 
sudo s3fs teste /mnt -o allow_other,use_path_request_style,nonempty,url=http://127.0.0.1:3000,passwd_file=/passwd-s3fs
sudo docker run \
    -v /mnt:/srv \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -p 8080:80 \
    -d \
    filebrowser/filebrowser:s6
echo 'Tudo pronto para uso!!!'

exit 0
