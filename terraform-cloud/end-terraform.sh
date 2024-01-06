#!/bin/bash
#Удаляем всю инфраструктуру в YandexCloud и чистим персональные данные в локальной директории
TERR_DIR=$(dirname $(readlink -f "$0"))
cd $TERR_DIR
source ./temporary-file/vars.sh

#Инициализируем процесс удаления инфраструктуры от terraform

terraform destroy -lock=false

#Удаляем сервисный аккаунт и файлы с данными из локальной директории

echo "Удалить другие созданные файлы/ресурсы (написать '1', чтобы удалить)?"
read DEL_TEMP
if [ "$DEL_TEMP" -eq 1 ]; then
    rm -r $TEMP_DIR
    yc iam service-account delete $SA_NAME
    yc iam access-key delete
    rm ~/.kube/config
fi

#Удаляем каталог

#yc resource-manager folder delete $FOLDER_NAME --async #удаление отложено на 7 дней, можно руками в YaCloud отменить отложенное удаление



cd $NOW_PWD