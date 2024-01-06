#!/bin/bash



#Переходим в директорию скрипта

TERR_DIR=$(dirname $(readlink -f "$0"))
echo $TERR_DIR
NOW_PWD=$(pwd)
cd $TERR_DIR

#Запускает в нужном порядке основные скрипты

chmod +x ./gitlab-cloud/start-terraform.sh
./gitlab-cloud/start-terraform.sh

chmod +x ./terraform-cloud/start-terraform.sh
./terraform-cloud/start-terraform.sh

#Возвращаемся в первоначальную директорию
cd $NOW_PWD