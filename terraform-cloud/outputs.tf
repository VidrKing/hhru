//Чисто для галочки
output "internal_ip_address_vm_app00" {
  value = yandex_compute_instance.app[0].network_interface.0.ip_address
}

output "internal_ip_address_vm_mon00" {
  value = yandex_compute_instance.mon[0].network_interface.0.ip_address
}

output "internal_ip_address_vm_prom00" {
  value = yandex_compute_instance.prom[0].network_interface.0.ip_address
}

output "external_ip_address_vm_app00" {
  value = yandex_compute_instance.app[0].network_interface.0.nat_ip_address
}

output "external_ip_address_vm_mon00" {
  value = yandex_compute_instance.mon[0].network_interface.0.nat_ip_address
}

output "external_ip_address_vm_prom00" {
  value = yandex_compute_instance.prom[0].network_interface.0.nat_ip_address
}

output "subnet-1" {
  value = yandex_vpc_subnet.default[0].id
}

output "subnet-2" {
  value = yandex_vpc_subnet.default[1].id
}

output "subnet-3" {
  value = yandex_vpc_subnet.default[2].id
}

output "subnet-4" {
  value = yandex_vpc_subnet.default[3].id
}
