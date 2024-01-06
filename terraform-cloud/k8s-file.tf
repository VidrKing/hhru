//Создаём скрипт alb-script.sh для запуска балансировщика и тестового приложения через скрипт-костыль
resource "local_file" "alb_script_sh" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.k8s_alb_script_file_tpl}",
    {
      service_account_name  = yandex_iam_service_account.ingress_controller.name
      sa_output_file_name   = var.k8s_manifest.alb_script.sa_output_file_name
      folder_id             = local.folder_id
      cluster_id            = yandex_kubernetes_cluster.default.id
      cluster_node_id       = yandex_kubernetes_node_group.app.id // Чтобы скрипт создавался только после полного создания кластера Куба
      k8s_ingress_namespace = var.k8s_manifest.alb_script.k8s_ingress_namespace
      k8s_chart_dir         = var.dir_file.k8s_chart_dir
      manifest_dir          = "${var.dir_file.parent_dir}/${var.dir_file.k8s_dir}/${var.dir_file.k8s_manifest_dir}"
      manifest_httpbin_file = "${var.dir_file.k8s_deployment_httpbin_file}"
      manifest_ingress_file = "${var.dir_file.k8s_ingress_file}"
      domain                = var.k8s_manifest.ingress.domain
      zone                  = yandex_vpc_subnet.default[0].zone
    }
  )
  filename        = "${var.dir_file.parent_dir}/${var.dir_file.k8s_dir}/${var.dir_file.k8s_alb_script_file}"
  file_permission = "0666"
  provisioner "local-exec" {
    working_dir = "${var.dir_file.parent_dir}/${var.dir_file.k8s_dir}/${var.dir_file.k8s_alb_script_file}"
    command     = "chmod +x ./${var.dir_file.k8s_alb_script_file} && ./${var.dir_file.k8s_alb_script_file}"
  }
}

//Создаём манифест ingress под кластер
resource "local_file" "ingress" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.k8s_ingress_file_tpl}",
    {
      manifest  = var.k8s_manifest.ingress
      subnet_id = yandex_vpc_subnet.default[0].id

    }
  )
  filename        = "${var.dir_file.parent_dir}/${var.dir_file.k8s_dir}/${var.dir_file.k8s_manifest_dir}/${var.dir_file.k8s_ingress_file}"
  file_permission = "0666"

}

//Создаём манифест httpbin с тестовым приложением под кластер
resource "local_file" "httpbin" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.k8s_deployment_httpbin_file_tpl}",
    {
      manifest = var.k8s_manifest.deployment_httpbin
    }
  )
  filename        = "${var.dir_file.parent_dir}/${var.dir_file.k8s_dir}/${var.dir_file.k8s_manifest_dir}/${var.dir_file.k8s_deployment_httpbin_file}"
  file_permission = "0666"

}

//Создаём манифест Deployment под app
resource "local_file" "deployment_app" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.k8s_deployment_app_file_tpl}",
    {
      manifest       = var.k8s_manifest.deployment_app
      image          = "cr.yandex/${yandex_container_registry.default.id}/${var.app.app_name}"
      database_uri   = "postgresql://${tolist(yandex_mdb_postgresql_cluster.default.user.*.name)[0]}:${tolist(yandex_mdb_postgresql_cluster.default.user.*.password)[0]}@:1/${tolist(yandex_mdb_postgresql_cluster.default.database.*.name)[0]}"
      database_hosts = "${tolist(yandex_mdb_postgresql_cluster.default.host.*.fqdn)[0]}"
    }
  )
  filename        = "${var.dir_file.parent_dir}/${var.dir_file.k8s_dir}/${var.dir_file.k8s_manifest_dir}/${var.dir_file.k8s_deployment_app_file}"
  file_permission = "0666"
}

//Создаём манифест Deployment под app-via-php
resource "local_file" "deployment_app_php" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.k8s_deployment_app_php_file_tpl}",
    {
      manifest = var.k8s_manifest.deployment_app_php
      image    = "cr.yandex/${yandex_container_registry.default.id}/${var.app_via_php.app_name}"
    }
  )
  filename        = "${var.dir_file.parent_dir}/${var.dir_file.k8s_dir}/${var.dir_file.k8s_manifest_dir}/${var.dir_file.k8s_deployment_app_php_file}"
  file_permission = "0666"
}

//Создаём манифест LoadBalancer под кластер
resource "local_file" "loadbalancer_yml" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.k8s_loadbalancer_file_tpl}",
    {
      manifest = var.k8s_manifest.loadbalancer
    }
  )
  filename        = "${var.dir_file.parent_dir}/${var.dir_file.k8s_dir}/${var.dir_file.k8s_manifest_dir}/${var.dir_file.k8s_loadbalancer_file}"
  file_permission = "0666"

}