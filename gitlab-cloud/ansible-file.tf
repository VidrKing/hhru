//Записываем необходимые переменные для Ansible

//Создаётся файл конфигурации ansible.cfg
//УБРАТЬ ХАРДКОД (СНАЧАЛА ДОДЕЛАТЬ РАННЕР)
resource "local_file" "ansible_cfg" {
  content         = <<-EOT
    [defaults]
    #Created with Terraform
    host_key_checking = false
    become = true
    roles_path = ${path.cwd}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_dir_inventory}/${var.dir_file.ansible_dir_roles}
    inventory = ${path.cwd}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_dir_inventory}/${var.dir_file.ansible_file_hosts}
    gitlab_container_external_url: 'http://vidrking.ru:80'
    backet_acc_access_key:  YCAJE6rMQyMN9jyd0p8KjYMhS
    backet_acc_secret_key:  YCNfGxhPIQVIlHYOfUwMTOY41QTX3ZvZijMc09qz
    bucket_name:            Бакета_нет_и_пока_не_будет
    user_name:              ubuntu
  EOT
  filename        = "${path.module}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_file_cfg}"
  file_permission = "0666"
}

//Создаётся файл hosts.cfg
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.ansible_file_hosts_tpl}",
    {
      vm_gl    = yandex_compute_instance.gl.*
      vm_glrun = yandex_compute_instance.glrun.*
    }
  )
  filename        = "${path.module}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_dir_inventory}/${var.dir_file.ansible_file_hosts}"
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
  filename        = "${path.module}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_dir_inventory}/${var.dir_file.ansible_dir_groupvars}/${each.value.name}"
  file_permission = "0666"
}

//Создаётся файл main.yml в дирекории под Ansible в папке inventory/group_vars/all
resource "local_file" "var_for_ansible" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.file_var_for_ansible_tpl}",
    {
      stat_key = yandex_iam_service_account_static_access_key.default
      //bucket_name = yandex_storage_bucket.default.bucket
      bucket_name = "Бакета_нет_и_пока_не_будет"
      user_name   = var.meta_user.name_user
    }
  )
  filename        = "${path.module}/${var.dir_file.ansible_dir}/${var.dir_file.ansible_dir_inventory}/${var.dir_file.ansible_dir_groupvars}/${var.dir_file.ansible_dir_groupvars_all}/${var.dir_file.file_var_for_ansible}"
  file_permission = "0666"
}

//Взято из README.md из директории /gitlab-cloud/ansible
//Terraform в данную директорию при apply добавляет скрипт (backup-gitlab.sh) для бэкапа GitLab.
//Останавливается ВМ, создаётся снимок диска ВМ, затем ВМ снова запускается
resource "local_file" "backup_gitlab_snapshot_sh" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.file_backup_gitlab_snapshot_tpl}",
    {
      vm_gl = yandex_compute_instance.gl.*
    }
  )
  filename        = "${path.module}/${var.dir_file.ansible_dir}/${var.dir_file.file_backup_gitlab_snapshot}"
  file_permission = "0777"
}

//Убрать хардкод в шаблоне
//Создаём плейбук для снапшотов машины с GitLab
resource "local_file" "playbook_snapshot" {
  content = templatefile("${path.module}/${var.dir_file.dir_template}/${var.dir_file.file_playbook_for_ansible_tpl}",
    {
      hosts_gl  = var.vm.gl.name
      become    = "true"
      user_name = var.meta_user.name_user
    }
  )
  filename        = "${path.module}/${var.dir_file.ansible_dir}/${var.dir_file.file_playbook_for_ansible}"
  file_permission = "0777"
}