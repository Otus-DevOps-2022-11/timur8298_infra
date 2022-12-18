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
