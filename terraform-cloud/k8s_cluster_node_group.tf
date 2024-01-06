//Создаём группу узлов под приложение
resource "yandex_kubernetes_node_group" "app" {
  cluster_id = yandex_kubernetes_cluster.default.id
  name       = var.k8s_cluster.node_group_app_name
  version    = var.k8s_cluster.k8s_version
  labels = {
    "${var.k8s_manifest.deployment_app.label_key}" = "${var.k8s_manifest.deployment_app.label_value}"
  }
  instance_template {
    platform_id = var.vm.app.platform_id
    resources {
      cores         = var.vm.app.cores
      memory        = var.vm.app.memory
      core_fraction = var.vm.app.core_fraction
    }
    boot_disk {
      type = var.vm.app.type_disk
      size = var.vm.app.size_disk
    }
    network_interface {
      subnet_ids = ["${yandex_vpc_subnet.default[0].id}"] //Как-то более интересно выдавать подсеть
      nat        = true
    }
    metadata = {
      //user-data          = local_file.user_data.content
      ssh-keys           = "${var.meta_user.name_user}:${tls_private_key.default.public_key_openssh}"
      serial-port-enable = 1
    }
    scheduling_policy {
      preemptible = true
    }
  }
  scale_policy {
    #auto_scale {
    #  min     = 1
    #  max     = 3
    #  initial = 2
    #}
    fixed_scale {
      size = 1
    }
  }
  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster get-credentials --id=${yandex_kubernetes_cluster.default.id} --external"
  }
}