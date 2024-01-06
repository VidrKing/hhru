#Created with Terraform

#Привет костылю, пока так, в разработке вариант, где вместо Bash скрипта с хардкодом прибегаю к возможностям Terraform и Helm для большей гибкости

# Выдаём роль alb.editor сервисному аккаунту ${service_account_name} для создания балансировщиков
yc resource-manager folder add-access-binding default \
--service-account-name=${service_account_name} \
--role alb.editor

# Выдаём роль vpc.publicAdmin сервисному аккаунту ${service_account_name} для управления внешними адресами
yc resource-manager folder add-access-binding default \
--service-account-name=${service_account_name} \
--role vpc.publicAdmin

# Выдаём роль certificate-manager.certificates.downloader сервисному аккаунту ${service_account_name} certificate-manager.certificates.downloader для скачивания сертификатов из Yandex Certificate Manager
# Пока без сертификатов, так как их неудобно ждать по несколько часов
#yc resource-manager folder add-access-binding default \
#    --service-account-name=${service_account_name} \
#    --role certificate-manager.certificates.downloader

# Выдаём роль compute.viewer сервисному аккаунту ${service_account_name} для добавления нод в балансировщик
yc resource-manager folder add-access-binding default \
    --service-account-name=${service_account_name} \
    --role compute.viewer 

# Подготавливаем файл с данными сервисного аккаунта для запуска helm (да-да, безопасность на нуле в этом костыле, но пока как-то так)
yc iam key create --service-account-name ${service_account_name} --output ${sa_output_file_name}

# Регаемся в helm 
export HELM_EXPERIMENTAL_OCI=1
cat ${sa_output_file_name} | helm registry login cr.yandex --username 'json_key' --password-stdin 

# Скачиваем ingress
helm pull oci://cr.yandex/yc-marketplace/yandex-cloud/yc-alb-ingress/yc-alb-ingress-controller-chart \ 
    --version v0.1.17 \
    --untar \
    --untardir=${k8s_chart_dir}

# Устанавливаем ingress
helm install \
    --create-namespace \
    --namespace ${k8s_ingress_namespace} \
    --set folderId=${folder_id} \
    --set clusterId=${cluster_id} \
    --set-file saKeySecretKey=${sa_output_file_name} \
yc-alb-ingress-controller ./${k8s_chart_dir}/yc-alb-ingress-controller-chart/

# Удаляем данные сервисного аккаунта из локальной машины
rm ${sa_output_file_name}

# Применяем созданный через Terraform манифест ${manifest_httpbin_file}
kubectl apply -f ${manifest_dir}/${manifest_httpbin_file}


# Настраиваем ресурс YC DNS под наш домен
# (заранее купил домен, зарезервировал ip адрес под него и настроил DNS для домена на "ns1.yandexcloud.net" и "ns2.yandexcloud.net")
yc dns zone create \
    --name yc-courses --zone ${domain}. \
    --public-visibility
yc vpc address create --name=infra-alb \
    --labels reserved=true \
    --external-ipv4 zone=${zone}
yc dns zone add-records --name yc-courses \
    --record "*.infra.${domain}. 600 A $(yc vpc address get infra-alb --format json | jq -r .external_ipv4_address.address)"

# Применяем созданный через Terraform манифест ${manifest_ingress_file}
kubectl -n httpbin apply -f ${manifest_dir}/${manifest_ingress_file}