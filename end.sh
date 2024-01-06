#!/bin/bash



#Переходим в директорию скрипта

TERR_DIR=$(dirname $(readlink -f "$0"))
echo $TERR_DIR
NOW_PWD=$(pwd)
cd $TERR_DIR

#Сворачиваем созданную инфраструктуру

chmod +x ./gitlab-cloud/end-terraform.sh
./gitlab-cloud/end-terraform.sh

chmod +x ./terraform-cloud/end-terraform.sh
./terraform-cloud/end-terraform.sh

#Возвращаемся в первоначальную директорию
cd $NOW_PWD