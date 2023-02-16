terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
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
resource "local_file" "app_yml" {
  content = templatefile("../../ansible/templates/hosts.tmpl",
    {
      dbip = module.db.db_internal_ip
    }
  )
  file_permission = "0644"
  filename = "../../ansible/environments/prod/group_vars/app"
}
resource "local_file" "inventory_tmpl" {
  content = templatefile("../../ansible/templates/inventory.tmpl",
    {
      db = module.db.external_ip_address_db
      app = module.app.external_ip_address_app
    }
  )
  file_permission = "0644"
  filename = "../../ansible/environments/prod/inventory"
}
