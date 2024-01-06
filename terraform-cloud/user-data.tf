//Создаём файл с данными для создаваемого пользователя.
//Не используем пока, так как часто возникают проблемы, проще через другой ключ создавать основого пользователя ВМ
resource "local_file" "user_data" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.file_userdata_tpl}",
    {
      name_user = var.meta_user.name_user
      groups    = var.meta_user.groups
      shell     = var.meta_user.shell
      sudo      = var.meta_user.sudo
      ssh_key   = "${tls_private_key.default.public_key_openssh}"
    }
  )
  filename        = "${path.module}/${var.dir_file.dir_temp}/${var.dir_file.file_userdata}"
  file_permission = "0444"
}