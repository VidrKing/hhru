//Создаём реестр под контейнер с приложением
resource "yandex_container_registry" "default" {
  name = var.container_registry.reg_name

}

//Создаём репозиторий с контейнером (НАДО ПОМЕНЯТЬ, ТАК КАК СЕЙЧАС ЕСЛИ ПОДГОТОВИТЬ НОВУЮ ВУРСИЮ DOCKERFILE, ТО TERRAFORM ПЛЕВАЛ
//НА ЭТИ ИЗМЕНЕНИЯ, ТАК КАК РЕПА СОЗДАНА, А ЗНАЧИТ И ПОВТОРЯТЬСЯ НЕ НАДО:( )
resource "yandex_container_repository" "app" {
  name = yandex_container_registry.default.id
  provisioner "local-exec" {
    working_dir = var.dir_file.parent_dir
    command     = "docker build ./${var.dir_file.app_dir} --tag cr.yandex/${yandex_container_registry.default.id}/${var.app.app_name} && docker push cr.yandex/${yandex_container_registry.default.id}/${var.app.app_name}; docker build ./k8s/app-via-php --tag cr.yandex/${yandex_container_registry.default.id}/${var.app_via_php.app_name} && docker push cr.yandex/${yandex_container_registry.default.id}/${var.app_via_php.app_name}"
  }
}