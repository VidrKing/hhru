// Создаём сервисный аккаунт для проекта
resource "yandex_iam_service_account" "k8s_res" {
  name      = var.serv_acc.k8s_res.name
  folder_id = local.folder_id
}

// Назначаем роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "k8s_res" {
  folder_id = local.folder_id
  role      = var.serv_acc.k8s_res.role
  member    = "serviceAccount:${yandex_iam_service_account.k8s_res.id}"
}

// Создаём статический ключ доступа к аккаунту
resource "yandex_iam_service_account_static_access_key" "k8s_res" {
  service_account_id = yandex_iam_service_account.k8s_res.id
}

// Второй аккаунт. Пока только так, идея c for_each тут не прокатила :(

// Создаём сервисный аккаунт для проекта
resource "yandex_iam_service_account" "k8s_puller" {
  name      = var.serv_acc.k8s_puller.name
  folder_id = local.folder_id
}

// Назначаем роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "k8s_puller" {
  folder_id = local.folder_id
  role      = var.serv_acc.k8s_puller.role
  member    = "serviceAccount:${yandex_iam_service_account.k8s_puller.id}"
}

// Создаём статический ключ доступа к аккаунту
resource "yandex_iam_service_account_static_access_key" "k8s_puller" {
  service_account_id = yandex_iam_service_account.k8s_puller.id
}

// Третий аккаунт. Нужен для yc-alb-ingress-controller

// Создаём сервисный аккаунт для ingress (выдадим всю пачку ролей позже)
resource "yandex_iam_service_account" "ingress_controller" {
  name      = var.serv_acc.ingress_controller.name
  folder_id = local.folder_id
}