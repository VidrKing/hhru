- hosts: ${hosts_gl}
  become: ${become}
  tasks:
    - name: Create backup directory
      file:
        path: ./backup
        state: directory
    - name: add Bash script for backups-via-snapshot
      copy:
        src: ./backup-gitlab-snapshot.sh
        dest: "backup/backup-gitlab.sh"
        mode: "0777"
    - name: set up cron
      cron:
        name: "backup-gl-snapshot"
        job: "sudo /home/ubuntu/backup/backup-gitlab-snapshot.sh > /dev/null"
        minute: "59"
        hour: "*/12"
        user: ${user_name}
    - name: install YC CLI (настраивать профиль не надо, если в Terraform настроили сервисный аккаунт для ВМ)
      shell: "curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash"