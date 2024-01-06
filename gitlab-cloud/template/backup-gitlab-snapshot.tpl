#Created with Terraform

#НЕТ РЕАЛИЗАЦИИ УДАЛЕНИЯ СКРИНОВ ДИСКА. НАДО СВОИМИ РУЧКАМИ ЧИСТИТЬ ОТ СТАРЫХ

#ЗАПУСКАТЬ НА ЛЮБОЙ МАШИНЕ, КРОМЕ ТЕХ, ЧТО ТУТ УКАЗАНЫ. ИЛИ НАДО УБИРАТЬ КУСОК, ГДЕ ОСТАНАВЛИВАЕТСЯ ВМ, С КОТОРОЙ ЗАПУСКАЕТСЯ КОД

#Скрипт останавливает ВМ с GitLab, делает скрин диска и обратно запускает ВМ
#Можно добавить в Cron и делать бэкап диска в по заданным в Cron правилам
#Также можно ручками настроить скрины диска в консоли Yandex Cloud, но там (вроде как) нельзя заставить останавливаться ВМ

#Переходим в директорию скрипта

TERR_DIR=$(dirname $(readlink -f "$0"))
echo $TERR_DIR
NOW_PWD=$(pwd)
cd $TERR_DIR

%{ for vm in vm_gl ~}
#Останавливаем ВМ ${vm.name} (не останавливаем, ведь этот скрипт запускается на указаной вм (тупанул))

VM_NAME=${vm.name}
yc compute instance stop $VM_NAME

#Создаём скрин диска ВМ ${vm.name}
DISK_ID="$(yc compute instance get ${vm.name} |
grep 'disk_id:' |
awk '{print $2}')"
yc compute snapshot create \
  --name "snapshot-${vm.name}--$(date +%d-%m-%G--%H-%M)" \
  --disk-id $DISK_ID

#Запускаем обратно ВМ ${vm.name} (не запускаем, ведь этот скрипт запускается на указаной вм (тупанул))

yc compute instance start ${vm.name}

%{ endfor ~}
#Возвращаемся в первоначальную директорию

cd $NOW_PWD