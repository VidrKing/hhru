//Создаём вм типа mon
resource "yandex_compute_instance" "mon" {
  count       = var.vm.mon.count
  name        = "${var.vm.mon.name}${format("%02s", count.index + 1)}"
  hostname    = "${var.vm.mon.name}${format("%02s", count.index + 1)}"
  platform_id = var.vm.mon.platform_id
  zone        = "${var.subnet.prefix_name}${var.subnet.zone[count.index]}"
  resources {
    cores         = var.vm.mon.cores
    memory        = var.vm.mon.memory
    core_fraction = var.vm.mon.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.vm.mon.image_id
      type     = var.vm.mon.type_disk
      size     = var.vm.mon.size_disk
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default[count.index].id
    nat       = true
    //nat_ip_address = yandex_vpc_address.default[count.index].external_ipv4_address.0.address
  }
  metadata = {
    //user-data          = local_file.user_data.content
    ssh-keys           = "${var.meta_user.name_user}:${tls_private_key.default.public_key_openssh}"
    serial-port-enable = 1
  }
  allow_stopping_for_update = true
  scheduling_policy {
    preemptible = true
  }
  //service_account_id = yandex_iam_service_account.default.id
}