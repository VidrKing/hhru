variable "task_id" {
  type    = string
  default = "deus230620-git"
}

variable "dir_file" {
  type = map(any)
  default = {
    parent_dir                      = ".."
    dir_template                    = "template"
    dir_temp                        = "temporary-file"
    file_authkey                    = "authorized_key.json"
    file_cloudid                    = "cloud-id.txt"
    file_folderid                   = "folder-id.txt"
    dir_sshkey                      = "ssh-key"
    file_sshpub                     = "yc.pub"
    file_sshpriv                    = "yc"
    file_userdata                   = "user-data.yaml"
    file_userdata_tpl               = "user-data.tpl"
    ansible_file_hosts              = "hosts.cfg"
    ansible_file_hosts_tpl          = "hosts.tpl"
    ansible_dir                     = "ansible"
    ansible_file_cfg                = "ansible.cfg"
    ansible_dir_inventory           = "inventory"
    ansible_dir_groupvars           = "group_vars"
    ansible_dir_groupvars_all       = "all"
    ansible_file_groupvars_tpl      = "groupvars.tpl"
    ansible_dir_roles               = "roles"
    file_backup_gitlab_snapshot     = "backup-gitlab-snapshot.sh"
    file_backup_gitlab_snapshot_tpl = "backup-gitlab-snapshot.tpl"
    file_var_for_ansible            = "main.yml"
    file_var_for_ansible_tpl        = "var-for-ansible.tpl"
    file_playbook_for_ansible       = "backup-snapshot(not_recommended).yml"
    file_playbook_for_ansible_tpl   = "playbook-snapshot.tpl"
  }
}

variable "bucket" {
  type = map(any)
  default = {
    endpoint = "storage.yandexcloud.net"
    name     = "terraform-bucket-deusops"
    region   = "ru-central1"
    key      = "terraform-bucket-deusops/terraform.tfstate"
  }
}

variable "sa_auth_key" {
  type = map(any)
  default = {
    key_algorithm = "RSA_2048"
  }
}

variable "subnet" {
  type = any
  default = {
    prefix_name = "ru-central1-"
    count       = 4
    zone        = ["a", "b", "c", "d"]
    cidr        = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24", "192.168.4.0/24"]
  }
}

variable "statpub_ip" {
  type = map(any)
  default = {
    name                = "gitlab-statpub-id"
    deletion_protection = false
  }
}

variable "vm" {
  type = map(any)
  default = {
    gl = {
      count         = 1
      name          = "gl"
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 4
      image_id      = "fd8aeg00ca1t9obj3irl"
      type_disk     = "network-hdd"
      size_disk     = 30
      core_fraction = "50"
    }
    glrun = {
      count         = 1
      name          = "glrun"
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 2
      image_id      = "fd8aeg00ca1t9obj3irl"
      type_disk     = "network-hdd"
      size_disk     = 25
      core_fraction = "20"
    }
  }
}

variable "ssh_key" {
  type = map(any)
  default = {
    algorithm = "RSA"
  }

}

variable "meta_user" {
  type = map(any)
  default = {
    name_user = "ubuntu"
    groups    = "sudo"
    shell     = "/bin/bash"
    sudo      = "'ALL=(ALL) NOPASSWD:ALL'"
  }
}

variable "serv_acc" {
  type = map(any)
  default = {
    name_acc_bucket = "bucket-service-acc"
    role_bucket     = "storage.editor"
  }
}

variable "yc_bucket" {
  type = any
  default = {
    //Имя задаётся автоматически из id проекта; Имя бакета должно быть уникальным
    max_size  = 5368709120
    enabled   = true
    days_life = 7
  }
}