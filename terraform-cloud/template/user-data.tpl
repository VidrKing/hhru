#cloud-config
users:
  - name: ${name_user}
    groups: ${groups}
    shell: ${shell}
    sudo: ${sudo}
    ssh-authorized-keys:
      - ${ssh_key}