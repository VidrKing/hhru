terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  //required_version = ">=0.13.0"

  /* На этой версии terraform Я.Клауд пока не готов поддерживать бэкенд :(
  backend "s3" {
    endpoint   = "https://storage.yandexcloud.net"
    bucket     = "terraform-bucket-deusops"
    region     = "ru-central1"
    key        = "terraform-bucket-deusops/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    //skip_requesting_account_id = true
  }*/
}


locals {
  cloud_id  = file("${path.module}/${var.dir_file.dir_temp}/${var.dir_file.file_cloudid}")
  folder_id = file("${path.module}/${var.dir_file.dir_temp}/${var.dir_file.file_folderid}")
}

provider "yandex" {
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  service_account_key_file = file("${path.module}/${var.dir_file.dir_temp}/${var.dir_file.file_authkey}")
}

//Реализуем сохранение состояния terraform в Yandex Object Storage (бакет)
//нет :)