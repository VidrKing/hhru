//Чисто для галочки
output "internal_ip_address_vm_gl01" {
  value = yandex_compute_instance.gl[0].network_interface.0.ip_address
}

output "external_ip_address_vm_gl01" {
  value = yandex_compute_instance.gl[0].network_interface.0.nat_ip_address
}

output "subnet-git-a" {
  value = yandex_vpc_subnet.default[0].id
}
