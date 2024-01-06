#Created with Terraform
[gl]
%{ for vm in vm_gl ~}
${vm.name}    ansible_host=${vm.network_interface.0.nat_ip_address}
%{ endfor ~}

[glrun]
%{ for vm in vm_glrun ~}
${vm.name}    ansible_host=${vm.network_interface.0.nat_ip_address}
%{ endfor ~}