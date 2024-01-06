#!/bin/bash

# (важная пометка перед прочтением кода) Только с целью пощупать команду sed я использую её, а не команду grep -e

#Реализуем создание 3 ВМ (просто так)
#Подключаемся к YandexCloud и создаём каталог с сервисным аккаунтом для terraform
#Сохраняем необходимые данные и запускаем terraform



#Переходим в директорию скрипта и создаём необходимую файловую структуру
TERR_DIR=$(dirname $(readlink -f "$0"))
echo $TERR_DIR
NOW_PWD=$(pwd)
cd $TERR_DIR
TEMP_DIR="temporary-file"
mkdir ./$TEMP_DIR
TEMP_DIR="$TERR_DIR/$TEMP_DIR"

TASK_ID="deus$(basename "$(dirname "$(pwd)")")"
yc config profile activate default

#Переходим в заготовленное облако под это задание

CLOUD_NAME=$TASK_ID
CLOUD_ID=$(yc resource-manager cloud get $CLOUD_NAME |
sed '2,$d' |
sed -r 's/.+ //')		
echo $CLOUD_ID
yc config set cloud-id $CLOUD_ID

#Создаём каталог

FOLDER_NAME="$TASK_ID""-folder"
yc resource-manager folder create \
    --name $FOLDER_NAME \
    #--description "Задачник"
FOLDER_ID=$(yc resource-manager folder get $FOLDER_NAME |
sed '2,$d' |
sed -r 's/.+ //')
echo $FOLDER_ID
yc config set folder-id $FOLDER_ID

#Создаём сервисный аккаунт и ключ к нему

SA_NAME="$TASK_ID""-terraform-sa"
yc iam service-account create \
    --name $SA_NAME
SA_ID=$(yc iam service-account get --name $SA_NAME |
sed '2,$d' |
sed -r 's/.+ //')		
echo $SA_ID
yc resource-manager folder add-access-binding $FOLDER_NAME \
    --role admin \
    --subject serviceAccount:$SA_ID
yc iam key create \
    --service-account-name "$TASK_ID""-terraform-sa" \
    -o $TEMP_DIR/authorized_key.json
yc iam access-key create \
    --service-account-name "$TASK_ID""-terraform-sa" \
    > access-key.txt
SECRET_KEY="$(cat ./access-key.txt |
sed -n '/^secret/!d;p' |
sed 's/.*secret: //')"
echo $SECRET_KEY
ACCESS_KEY="$(cat ./access-key.txt |
sed -n '/^  key_id:/!d;p' |
sed 's/.*key_id: //')"
echo $ACCESS_KEY
rm ./access-key.txt

#Создаём отдельные файлы с переменными, нужными в других модулях программы

VAR_FILE="$TEMP_DIR/vars.sh"
touch $VAR_FILE
echo "KEY_PUB=$KEY_PUB" > $VAR_FILE
echo "TERR_DIR=$TERR_DIR" >> $VAR_FILE
echo "TEMP_DIR=$TEMP_DIR" >> $VAR_FILE
echo "NOW_PWD=$NOW_PWD" >> $VAR_FILE
echo "TASK_ID=$TASK_ID" >> $VAR_FILE
echo "CLOUD_NAME=$TASK_ID" >> $VAR_FILE
echo "CLOUD_ID=$CLOUD_ID" >> $VAR_FILE
echo "FOLDER_NAME=$FOLDER_NAME" >> $VAR_FILE
echo "FOLDER_ID=$FOLDER_ID" >> $VAR_FILE
echo "SA_NAME=$SA_NAME" >> $VAR_FILE
echo "SA_ID=$SA_ID" >> $VAR_FILE
#echo -n $SECRET_KEY > ./temporary-file/secret-key.txt
#echo -n $ACCESS_KEY > ./temporary-file/access-key.txt

echo -n $TERR_DIR > $TEMP_DIR/working-directory.txt
echo -n $CLOUD_ID > $TEMP_DIR/cloud-id.txt
echo -n $FOLDER_ID > $TEMP_DIR/folder-id.txt
echo -n $TEMP_DIR/$KEY_FILE > $TEMP_DIR/ssh-key-path.txt

#Настраиваем сервисный профиль yc cli для бакета

#yc config profile delete "$TASK_ID-configprofile"
#yc config profile create "$TASK_ID-configprofile"
#yc config set service-account-key $TEMP_DIR/authorized_key.json
#yc config set cloud-id $CLOUD_ID
#yc config set folder-id $FOLDER_ID
#export YC_TOKEN=$(yc iam create-token)
#export YC_CLOUD_ID=$(yc config get cloud-id)
#export YC_FOLDER_ID=$(yc config get folder-id)
#echo "YC config обновился. Запускаем terraform."


#Запускаем terraform

terraform fmt
terraform init -upgrade -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY" -migrate-state
terraform apply -lock=false



#Возвращаемся в первоначальную директорию
cd $NOW_PWD