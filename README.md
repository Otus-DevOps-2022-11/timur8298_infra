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

#HW-07 Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform
Создан образ с приложением: packer build -var-file="./packer/variables.json" ./packer/app.json
Создан образа с базой данных: packer build -var-file="./packer/variables.json" ./packer/db.json
Созданы окружения: prod, stage
Созданы terraform модули: app, db, vpc
Добавлено использование внешнего backend
Добавлен deploy приложения: modules/db/files modules/app/files
Как запустить проект:
запустить terraform apply в папке с окружением prod или stage проекта
перейти по ссылке http://IP:9292, где IP адрес можно взять по итогам команды terraform apply (external_ip_address_app = "84.201.156.36)

#HW-08 Управление конфигурацией. Знакомство с Ansible 
Создан ansible-playbook clone.yml и inventory файл;
На app была применена комманда, которая клонировала репозиторий с github;
Была применена команда удаления репозитория reddit через модуль -m command -a 'rm -rf ~/reddit' 
Выполнен плейбук ansible-playbook clone.yml
Из-за того, что ~/reddit был удален предыдущей командой, при выполнении плейбука он был установлен снова
Дописал main.tf в папке stage, для формирования файла инвентори из выходных переменных результата выполнения terraform apply
resource "local_file" "hosts_cfg" {
  filename = "../../ansible/inventory_tf"
  content = <<EOF
[app]
appserver ansible_host=${module.app.external_ip_address_app}
[db]
dbserver ansible_host=${module.db.external_ip_address_db}

  EOF
}
Изменил настройку инвентори в ansible.cfg на новый файл, который сформирован из терраформа, проверил работу.

#HW-09 Продолжение знакомства с Ansible: templates, handlers, dynamic inventory, vault, tags
Создан плейбук reddit_app.yml и протестирован
Создан плейбук на несколько сценариев reddit_app2.yml
Плейбук разбит на несколько: app.yml, db.yml, deploy.yml и переименовываны старые плейбуки
Модифицированы наши провижионеры в packer, заменой их на ansible и перезапечены образы, указаны новые образы в переменных терраформа.
После модификации провижионеров в packer, вы падало в ошибку. Включил дебаг, после гугления проблемы нашел решение, прописал "use_proxy": false, после заработало.

Задания со **
Для создания динамической инвентаризации, по совету Владимира Дроздецкого, воспользовался terraform template. для чего создал 2 шаблона в папке templates (hosts.tmpl? inventory.tmpl)
После запуска terraform apply, автоматически генерируются файлы app.yml, inventory_tf.
