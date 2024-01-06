variable "task_id" {
  type    = string
  default = "deus230620"
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
    ansible_file_groupvars_tpl      = "groupvars.tpl"
    ansible_dir_roles               = "roles"
    app_dir                         = "app"
    k8s_dir                         = "k8s"
    k8s_chart_dir                   = "charts"
    k8s_manifest_dir                = "manifests"
    k8s_ingress_file                = "ingress.yml"
    k8s_ingress_file_tpl            = "ingress.tpl"
    k8s_deployment_httpbin_file     = "httpbin.yml"
    k8s_deployment_httpbin_file_tpl = "httpbin.tpl"
    k8s_deployment_app_file         = "deployment-app.yml"
    k8s_deployment_app_file_tpl     = "deployment-app.tpl"
    k8s_deployment_app_php_file     = "deployment-app-php.yml"
    k8s_deployment_app_php_file_tpl = "deployment-app-php.tpl"
    k8s_loadbalancer_file           = "load-balancer.yml"
    k8s_loadbalancer_file_tpl       = "load-balancer.tpl"
    k8s_alb_script_file             = "alb-script.sh"
    k8s_alb_script_file_tpl         = "alb-script.tpl"
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

/*Квоты не дают реализовать :(
variable "statpub_ip" {
  type = map(any)
  default = {
    name                = ["statpub-id"]
    deletion_protection = [false]
  }
}
*/

variable "vm" {
  type = map(any)
  default = {
    app = {
      count         = 1
      name          = "app"
      platform_id   = "standard-v3"
      cores         = 4
      memory        = 4
      image_id      = "fd8clogg1kull9084s9o"
      type_disk     = "network-hdd"
      size_disk     = 64
      core_fraction = "20"
    }
    mon = {
      count         = 1
      name          = "mon"
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 2
      image_id      = "fd8clogg1kull9084s9o"
      type_disk     = "network-hdd"
      size_disk     = 64
      core_fraction = "20"
    }
    prom = {
      count         = 1
      name          = "prom"
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 2
      image_id      = "fd8clogg1kull9084s9o"
      type_disk     = "network-hdd"
      size_disk     = 64
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
    k8s_res = {
      name = "k8s-res-service-acc"
      role = "editor"
    }
    k8s_puller = {
      name = "k8s-puller-service-acc"
      role = "container-registry.images.puller"
    }
    ingress_controller = {
      name = "ingress-controller"
    }
  }
}

variable "postgresql" {
  type = map(any)
  default = {
    cluster_name                      = "postgresql-app"
    cluster_env                       = "PRODUCTION"
    cluster_config_version            = 14
    cluster_config_resource_preset    = "b2.medium"
    cluster_config_resource_disk      = "network-hdd"
    cluster_config_resource_disk_size = 10
    //cluster_host_zone = ""      Вытягиваем не отсюда, а из созданного через Terraform ресурса
    //cluster_host_subnet = ""    Вытягиваем не отсюда, а из созданного через Terraform ресурса
    database_name  = "db-app"
    database_owner = "vidrking"
    user_name      = "vidrking"
    user_password  = "password"
  }
}

variable "container_registry" {
  type = map(any)
  default = {
    reg_name = "vidrking-registry"
  }
}

variable "app" {
  type = map(any)
  default = {
    app_name = "app-todolist"
  }
}

variable "app_via_php" {
  type = map(any)
  default = {
    app_name = "app-php"
  }
}

variable "k8s_cluster" {
  type = map(any)
  default = {
    k8s_version         = "1.25"
    public_ip           = true
    cluster_name        = "k8s-vidrking"
    node_group_app_name = "group-app"
  }
}

variable "k8s_manifest" {
  type = any
  default = {
    ingress = {
      domain     = "vidrking.online"
      apiVersion = "networking.k8s.io/v1"
      metadata = {
        name = "alb-demo-tls"
        annotations = {
          //subnets = Берём из создаваемой подсети
          //ipv4 = Есть подготовленный ip на домен vidrking.online
          ipv4       = "158.160.80.72"
          group_name = "infra-ingress"
        }
      }
      spec = {
        rules = {
          host_httpbin_infra_vidrking_online = {
            host = "httpbin.infra.vidrking.online"
            http = {
              paths = {
                prefix = {
                  pathType = "Prefix"
                  backend = {
                    service = {
                      name = "httpbin"
                      port = {
                        number = "80"
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    deployment_httpbin = {
      apiVersion = "apps/v1"
      metadata = {
        name = "httpbin"
        labels = {
          app_label = "app: httpbin"
        }
        namespace = "httpbin"
      }
      spec = {
        replicas = 1
        template = {
          spec = {
            containers = {
              httpbin = {
                name  = "httpbin"
                image = "kong/httpbin"
                ports = {
                  port_80 = {
                    name          = "http"
                    containerPort = "80"
                  }
                }
              }
            }
          }
        }
      }
    }
    deployment_app = {
      label_key     = "app-label"
      metadata_name = "app-todolist"
      label_value   = "app-todolist-label"
      namespace     = "default"
      spec = {
        replicas = 2
        template = {
          spec = {
            containers = {
              name = "app-todolist"
            }
          }
        }
      }
    }
    deployment_app_php = {
      label_key     = "php-label"
      metadata_name = "app-php"
      label_value   = "app-php-label"
      namespace     = "default"
      spec = {
        replicas = 3
        template = {
          spec = {
            containers = {
              name = "app-php"
            }
          }
        }
      }
    }
    loadbalancer = {
      apiVersion = "v1"
      kind       = "Service"
      metadata = {
        namespace = "default"
        name      = "load-balancer"
        labels = {
          app_label = "app-label: app-todolist-label"
          php_label = "php-label: app-php-label"
        }
      }
      spec = {
        ports = {
          port_80 = {
            port       = 80
            name       = "app"
            targetPort = 80
          }
          port_443 = {
            port       = 443
            name       = "php"
            targetPort = 443
          }
        }
        selector = {
          //Берём тег из labels
        }
        type = "LoadBalancer"
      }
    }
    alb_script = {
      sa_output_file_name   = "sa-key.json"
      k8s_ingress_namespace = "yc-alb-ingress"
    }
  }
}