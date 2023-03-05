output "gitlab_ip" {
  value = yandex_compute_instance.gitlab-ci.network_interface.0.nat_ip_address
}
