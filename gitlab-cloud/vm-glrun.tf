//Создаём вм типа glrun
resource "yandex_compute_instance" "glrun" {
  count       = var.vm.glrun.count
  name        = "${var.vm.glrun.name}${format("%02s", count.index + 1)}"
  hostname    = "${var.vm.glrun.name}${format("%02s", count.index + 1)}"
  platform_id = var.vm.glrun.platform_id
  zone        = "${var.subnet.prefix_name}${var.subnet.zone[count.index]}"
  resources {
    cores         = var.vm.glrun.cores
    memory        = var.vm.glrun.memory
    core_fraction = var.vm.glrun.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.vm.glrun.image_id
      type     = var.vm.glrun.type_disk
      size     = var.vm.glrun.size_disk
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.default[count.index].id
    nat       = true
    //nat_ip_address = yandex_vpc_address.default[count.index].external_ipv4_address.0.address
    nat_ip_address = "158.160.108.48"
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