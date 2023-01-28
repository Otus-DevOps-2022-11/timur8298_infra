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

#HW-05 Модели управления инфраструктурой. Подготовка образов с помощью Packer
Создал сервисный аккаунт и создал  service account key file, сконфигурировал билдер.
Добавил провижионер, и скрипты для него.
Проверил образ, установил приложение, проверил его работу.
Параметризировал шаблон Packer.
Для запуска выполнить команду из папки packer репозитория:
packer build -var-file=./packer/variables.json ./packer/ubuntu16.json

Настроил построение  bake-образа, для запуска из папки packer репозитория:
packer build -var-file=./variables.json ./immutable.json

Создал скрипт для автоматического создания ВМ create-reddit-vm.sh

#HW-06 Знакомство с Terraform
Установлен и настроен terraform и провайдер yandex
Создал  инстанс reddit-app и вывод output var
Добавил provisioner для автоматической пост настройки сервиса на инстансе
Добавил vars для параметризации
Настроил HTTP балансировщик
Проблема в резализации reddit-app2, у меня почему-то создавался не параллельно, второму инстансу, а также обьему кода, удобству его понимания
Добавил переменную count кол-во инстансов а также необходимые изменения
