//Создаём ssh ключ и на всякий случай сохраняем файлами, чтобы ручками можно было воспользоваться в любой момент, чтобы провалиться в машину
resource "tls_private_key" "default" {
  algorithm = var.ssh_key.algorithm
}

resource "local_file" "ssh_key_pub" {
  filename        = "${path.module}/${var.dir_file.dir_sshkey}/${var.dir_file.file_sshpub}"
  content         = <<-EOT
    ${tls_private_key.default.public_key_openssh}
  EOT
  file_permission = "0400"
}

resource "local_file" "ssh_key_priv" {
  filename        = "${path.module}/${var.dir_file.dir_sshkey}/${var.dir_file.file_sshpriv}"
  content         = <<-EOT
    ${tls_private_key.default.private_key_openssh}
  EOT 
  file_permission = "0400"
}
