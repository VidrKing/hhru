//Создаём вм типа gl
resource "yandex_compute_instance" "gl" {
  count       = var.vm.gl.count
  name        = "${var.vm.gl.name}${format("%02s", count.index + 1)}"
  hostname    = "${var.vm.gl.name}${format("%02s", count.index + 1)}"
  platform_id = var.vm.gl.platform_id
  zone        = "${var.subnet.prefix_name}${var.subnet.zone[count.index]}"
  resources {
    cores         = var.vm.gl.cores
    memory        = var.vm.gl.memory
    core_fraction = var.vm.gl.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.vm.gl.image_id
      type     = var.vm.gl.type_disk
      size     = var.vm.gl.size_disk
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default[count.index].id
    nat       = true
    //nat_ip_address = yandex_vpc_address.default[count.index].external_ipv4_address.0.address
    nat_ip_address = "158.160.120.119" //На этой айпишке висит домен vidrking.ru (актуально на момент 11.12.2023)
  }
  metadata = {
    //user-data          = local_file.user_data.content
    serial-port-enable = 1
    ssh-keys           = "${var.meta_user.name_user}:${tls_private_key.default.public_key_openssh}"
  }
  allow_stopping_for_update = true
  scheduling_policy {
    preemptible = true
  }
  service_account_id = yandex_iam_service_account.default.id
}