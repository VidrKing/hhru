# 230620


### Для понимания

- Является копией ветви dev моего учебного проекта/песочницы. Актуально на момент 06.01.2024

- *Важно понимать, что проект создавался с принципом, что всё созданное должно сворачиваться парой команд минут за 5, а создаваться самостоятельно всё при помощи нескольких команд и нескольких предварительно совершённых действий минут за 15, так как в облаках время - деньги + удобнее было управлять создаваемыми в песочнице реурсами*

# Документация к проекту
- Во вложенных папках можно найти более подробную документацию

## Стек локальных программ

- Bash (выводится из стека)
- YC CLI
- Terraform
- Ansible
- Docker
- K8s
- Helm

## Стек используемых программ

- GitLab
- Bash (выводится из стека в пользу Terraform)
- YC CLI
- Terraform (в планах попробовать заменить на Terragrant)
- Ansible
- Docker
- K8s
- Helm
- PostgreSQL

## GitLab

*На данный момент находится в стадии разработки. Реализовано самостоятельное разворачивание GitLab + 2 раннера (Bash и Docker; но устанавливать на ВМ раннеры надо отдельно - ручками, запустив нужный плейбук с нужной переменной ручками). На данный момент возможны проблемы с диском ВМ типа gl, когда к нему стучиться раннер. Проблема решается только перезапуском ВМ, самостоятельно не проходит*

Разворачивается отдельно от основной инфраструктуры, чтобы взаимодействовать с ней независимо от того, запущена ли основная инфраструктура в облаке. Всё необходимое лежит в директории *gitlab-cloud*

Более подробная документация лежит в этой директории

*БАКЕТ ОЧЕНЬ КРИВОЙ, РЕКОМЕНДУЕТСЯ СОЗДАВАТЬ ТОЛЬКО ПРИ НЕОБХОДИМОСТИ. А ТАК ЛУЧШЕ УДАЛИТЬ БЭКАПЫ В БАКЕТ. БАКЕТ УДАЛЯЕТСЯ ТОЛЬКО ЕСЛИ ПУСТОЙ. ЕСЛИ БАКЕТ ЕСТЬ, ТО TERRAFORM ВЫДАЁТ ОШИБКУ ПРИ APPLY. TERRAFORM НАЧИНАЕТ ДУМАТЬ ПРИ СОЗДАНИИ И УДАЛЕНИИ ИНФРАСТРУКТУРЫ МИНУТ ПО 5 ВМЕСТО СЕКУНД 10*

## CI/CD

Стоят чисто заглушки, которые вытягиваются из другого проекта (то есть, если пересоздать ВМ с GitLab, то надо продублировать там проект с необходимым именем с файлами пайплайна)

## CI/CD (через раннеры в GitLab)

Пока стоят заглушки, так как для реализации нужно состояние Terraform сохранять в облаке, а бэкенд через Yandex Cloud сейчас не работает в Terraform + в целом бакеты Yandex Cloud криво работают с Terraform.

*В ближайшее время попытаюсь придумать, как ещё в облаке можно сохранять состояние инфраструктуры*

## Основная часть проекта

- На данный момент реализовано автоматическая развёртка ingress от *Yandex Cloud* и приложения (не моё приложение, для меня это black box) httpbin на основе образа kong/httpbin. По итогу создания инфраструктуры, при отсутствии изменений в файлах переменных, будет доступен сайт httpbin по домену httpbin.infra.vidrking.online (пока нет подключения сертификатов для https, только http, только хардкор).

- Есть Helm чарт в директории k8s/charts/Helm(myhello), который создаёт в отдельном namespace поды с простенькой http страницей (отсутствует реализация самостоятельного развёртывания чарта)

- В активной разработке находится развёртывание сайта, на котором будет todolist (не моё приложение, для меня это black box). На данный момент создаётся необходимая база PostgreSQL для приложения и заготовки для создания в будущем всего необходимого для развёртывания приложения в k8s кластере.

- Также в активной разработке находится развёртывание php страницы, которая будет разворачиваться в кластере. Это будет нестандартный способ посмотреть ip-адрес контейнера (рандомного контейнера, если несколько реплик) при помощи браузера.

- Кластер также самостоятельно создаётся в облаке, а данные про кластер при terraform apply записываются в конфигурацию локального кубера. *Развёртывание приложения через модуль Helm через Terraform находится в разработке. Пока не реализовано из-за возникнувших проблем с приложением из-за, ориентировочно, несостыковки версии кубера, под который писалось приложение, и версии кубера в создаваемом кластере (ориентировочно, придётся поменять приложение, чтобы их решить)*.

Ещё создаются 3 ВМ в *Yandex Cloud* через *Terraform* и подготовлены все необходимые данные о созданных ВМ для *Ansible*. Они были нужны для ранних версий проекта Код этой реализации лежит в директории *terraform-cloud*, а информация для *Ansible* сохраняется в директории *ansible*. Папка *ansible* добавлена в .gitignore из-за отсутствия чего-либо важного в ней


## P.s.
Более подробную документацию про реализацию можно найти в этих папках в README.md и в комментариях в коде