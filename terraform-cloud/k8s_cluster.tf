//Создаём в Yandex Cloud кластер Managed Service for Kubernetes
resource "yandex_kubernetes_cluster" "default" {
  name       = var.k8s_cluster.cluster_name
  network_id = yandex_vpc_network.default.id
  master {
    version   = var.k8s_cluster.k8s_version
    public_ip = var.k8s_cluster.public_ip
    zonal {
      zone      = yandex_vpc_subnet.default[0].zone
      subnet_id = yandex_vpc_subnet.default[0].id
    }
  }
  service_account_id      = yandex_iam_service_account.k8s_res.id
  node_service_account_id = yandex_iam_service_account.k8s_puller.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_res,
    yandex_resourcemanager_folder_iam_member.k8s_puller
  ]
}

output "kubeconfig" {
  value = yandex_kubernetes_cluster.default.master[0].external_v4_endpoint
}