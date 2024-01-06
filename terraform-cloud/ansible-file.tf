//Записываем необходимые переменные для Ansible

//Создаётся файл конфигурации ansible.cfg
resource "local_file" "ansible_cfg" {
  content         = <<-EOT
    [defaults]
    #Created with Terraform
    host_key_checking = false
    become = true
    roles_path = ${path.cwd}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_dir_inventory}/${var.dir_file.ansible_dir_roles}
    inventory = ${path.cwd}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_dir_inventory}/${var.dir_file.ansible_file_hosts}
  EOT
  filename        = "${var.dir_file.parent_dir}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_file_cfg}"
  file_permission = "0666"
}

//Создаётся файл hosts.cfg
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.ansible_file_hosts_tpl}",
    {
      vm_app  = yandex_compute_instance.app.*
      vm_mon  = yandex_compute_instance.mon.*
      vm_prom = yandex_compute_instance.prom.*
    }
  )
  filename        = "${var.dir_file.parent_dir}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_dir_inventory}/${var.dir_file.ansible_file_hosts}"
  file_permission = "0666"
}

//Создаются файлы, хранящие переменные для Ansible под каждый тип ВМ
resource "local_file" "groupvars_cfg" {
  for_each = var.vm
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.ansible_file_groupvars_tpl}",
    {
      name_user = var.meta_user.name_user
      ssh_path  = "${path.cwd}/${var.dir_file.dir_sshkey}/${var.dir_file.file_sshpriv}"
    }
  )
  filename        = "${var.dir_file.parent_dir}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_dir_inventory}/${var.dir_file.ansible_dir_groupvars}/${each.value.name}"
  file_permission = "0666"
}