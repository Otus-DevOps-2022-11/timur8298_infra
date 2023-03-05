terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
resource "yandex_compute_instance" "app" {
  name = "reddit-app"

  labels = {
    tags = "reddit-app"
  }
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    host        = yandex_compute_instance.app.network_interface[0].nat_ip_address
    user        = "ubuntu"
    agent       = false
    private_key = file(var.private_key_path)
  }
}
resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

resource "yandex_vpc_security_group" "nginx" {
  name        = "app security"
  description = "app security group"
  network_id  = yandex_vpc_network.lab-net.id

  labels = {
    my-label = "my-label-value"
  }

  ingress {
    protocol       = "TCP"
    description    = "rule1 description"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  #  provisioner "file" {
  #    content     = templatefile("${path.module}/files/puma.service.tmpl", { db_ip = var.db_ip })
  #    destination = "/tmp/puma.service"
  #  }

  #  provisioner "remote-exec" {
  #    script = "${path.module}/files/deploy.sh"
  #  }
}
