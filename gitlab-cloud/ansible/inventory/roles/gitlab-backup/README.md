# GitLab backup

## Настройка бэкапов GitLab 

Бэкапы делаются с определённой частотой через AWS CLI в бакет в Yandex Cloud, где хранятся определённое количество дней (определено на уровне Terraform, где и создаётся бакет) при помощи задачи в Cron