// Создаём сервисный аккаунт для ВМ проекта
resource "yandex_iam_service_account" "default" {
  name      = var.serv_acc.name_acc_bucket
  folder_id = local.folder_id
}

// Назначаем роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "default" {
  folder_id = local.folder_id
  role      = var.serv_acc.role_bucket
  member    = "serviceAccount:${yandex_iam_service_account.default.id}"
}

// Создаём статический ключ доступа
resource "yandex_iam_service_account_static_access_key" "default" {
  service_account_id = yandex_iam_service_account.default.id
}