//Создаём базу данных PostgreSQL (через сервис Yandex Cloud) под приложение 
resource "yandex_mdb_postgresql_cluster" "default" {
  name        = var.postgresql.cluster_name
  environment = var.postgresql.cluster_env
  network_id  = yandex_vpc_network.default.id
  config {
    version = var.postgresql.cluster_config_version
    resources {
      resource_preset_id = var.postgresql.cluster_config_resource_preset
      disk_type_id       = var.postgresql.cluster_config_resource_disk
      disk_size          = var.postgresql.cluster_config_resource_disk_size
    }
  }
  host {
    zone      = yandex_vpc_subnet.default[0].zone
    subnet_id = yandex_vpc_subnet.default[0].id
  }
  database {
    name  = var.postgresql.database_name
    owner = var.postgresql.database_owner
  }

  user {
    name     = var.postgresql.user_name
    password = var.postgresql.user_password
    permission {
      database_name = var.postgresql.database_name
    }
  }
}

/* Да-да, так рекомендуется, а database и user это не модная тема, но в таком случае пользователя надо ручками создавать, что бред
(или в документации к провайдеру что-то забыли написать)
resource "yandex_mdb_postgresql_database" "default" {
  cluster_id = yandex_mdb_postgresql_cluster.default.id
  name       = var.postgresql.database_name
  owner      = var.postgresql.database_owner
}

resource "yandex_mdb_postgresql_user" "default" {
  cluster_id = yandex_mdb_postgresql_cluster.default.id
  name       = var.postgresql.user_name
  password   = var.postgresql.user_password
  login      = true
  permission {
    database_name = yandex_mdb_postgresql_database.default.name
  }
}
*/