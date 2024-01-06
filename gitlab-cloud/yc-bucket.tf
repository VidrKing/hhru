// Создание бакета с использованием ключа
/* Нормально не работает с Terraform
resource "yandex_storage_bucket" "default" {
  access_key = yandex_iam_service_account_static_access_key.default.access_key
  secret_key = yandex_iam_service_account_static_access_key.default.secret_key
  bucket     = "${var.task_id}-bucket"
  max_size   = var.yc_bucket.max_size
  lifecycle_rule {
    enabled = var.yc_bucket.enabled
    expiration {
      days = var.yc_bucket.days_life
    }
  }
}
*/