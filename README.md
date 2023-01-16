# timur8298_infra
timur8298 Infra repository
bastion_IP = 51.250.90.207
someinternalhost_IP = 10.128.0.25
#Дополнительное задание
#для подключения по имени, нужно создать файл .ssh/config с содержимым:
Host 10.128.0.*
    ProxyJump appuser@51.250.90.207
Host bastion
     HostName 51.250.90.207
     User appuser
     IdentityFile ~/.ssh/appuser
Host someinternalhost
    ProxyJump appuser@51.250.90.207
     HostName 10.128.0.25
     User appuser
     IdentityFile ~/.ssh/appuser
#дополнительное задание2
#настроил валидный сертификат let's encrypt для https://51.250.90.207.sslip.io/

testapp_IP = 62.84.116.26
testapp_port = 9292

#команда YC CLI исполняется в корне репозитория
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4,nat-address=62.84.116.26 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=./startup.yaml \
  --metadata serial-port-enable=1
