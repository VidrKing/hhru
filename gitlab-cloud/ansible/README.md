# GitLab

Развёртывается самостоятельно через playbook-gitlab.yml.

Создаётся настроенный Docker контейнер с Gitlab, настройка бэкапов присутствует

## Резервное копирование данных GitLab

### *Контейнера*

Настроены volumes для Docker, ничего дополнительно *(вроде)* делать не надо

### *ВМ*

- *(Отключена из-за кривой работы бакетов в YC)*Ansible создаёт задачу в cron бэкапа данных GitLab как в локальную директорию, так и в бакет в облаке

- Terraform в данную директорию (где лежит этот README.md) при apply добавляет скрипт (backup-gitlab-snapshot.sh) для бэкапа GitLab. Останавливается ВМ, создаётся снимок диска ВМ в облаке, затем ВМ снова запускается. Не рекомендуется запускать, так как снапшоты не удаляются через время, а за их хранение надо платить.

НЕТ РЕАЛИЗАЦИИ УДАЛЕНИЯ СКРИНОВ ДИСКА. НАДО СВОИМИ РУЧКАМИ ЧИСТИТЬ ОТ СТАРЫХ

- В РАЗРАБОТКЕ

*Telegram бот высылает архив с данными GitLab (если архив меньше 2Гб)*

## Восстановление данных GitLab

- Автоматическое восстановление в случае создания новой ВМ в активной разработке

- Необходимо загрузить на ВМ архив с файлами и распаковать в директорию с данными GitLab. Или создать новую ВМ на основе снимка диска в консоли Yandex Cloud

# GitLab Runner

НАСТРАИВАЕТСЯ ВРУЧНУЮ.

1 ВМ под два раннера (Проблема с временными ip у ВМ решается; В будущем ограничений по количеству раннеров не будет). Для инициализации необходимо запустить плейбук runner-gitlab.yml (при запуске надо передать через ключ --extra-vars значение *registration token*).