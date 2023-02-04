#terraform {
#  required_providers {
#    yandex = {
#      source = "yandex-cloud/yandex"
#    }
#  }
#  required_version = ">= 0.13"
#}
provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

module "app" {
  source           = "../modules/app"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  app_disk_image   = var.app_disk_image
  subnet_id        = var.subnet_id
  db_ip            = module.db.db_internal_ip
}

module "db" {
  source           = "../modules/db"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  db_disk_image    = var.db_disk_image
  subnet_id        = var.subnet_id
}
resource "local_file" "hosts_cfg" {
  filename = "../../ansible/inventory_tf"
  content = <<EOF
[app]
appserver ansible_host=${module.app.external_ip_address_app}
[db]
dbserver ansible_host=${module.db.external_ip_address_db}

  EOF
}
#resource "local_file" "hosts_cfg" {
#  content = <<-DOC
#    
#      app: ${var.external_ip_address_app}
#      db: ${var.external_ip_address_db}
#      DOC
#  filename = "hosts"
#}
#resource "local_file" "hosts_cfg" {
#  content = templatefile("hosts.tmpl",
#    {
#      app = module.app.external_ip_address_app
#      db = module.db.external_ip_address_db
#    }
#  )
#  filename = "hosts"
#}
#resource "local_file" "ansible_inventory" {
#  content = templatefile("inventorytest.tmpl",
#    {
#      app_ip = { app_exip = var.yandex_compute_instance.app.network_interface.0.nat_ip_address },
#      db_ip  = { db_exip = var.yandex_compute_instance.db.network_interface.0.nat_ip_address }
#    }
#  )
#  filename = "inventorytest"
#}
#resource "local_file" "ansible_inventory" {
#  content = templatefile("inventorytest.tmpl",
#    {
#      appserver = module.app.external_ip_address_app,
#      dbserver  = module.db.db_internal_ip
#    }
#  )
#  filename = "inventorytest"
#}
