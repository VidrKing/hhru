[app]
%{ for vm in vm_app ~}
${vm.name}    ansible_host=${vm.network_interface.0.nat_ip_address}    
%{ endfor ~}

[mon]
%{ for vm in vm_mon ~}
${vm.name}    ansible_host=${vm.network_interface.0.nat_ip_address}
%{ endfor ~}

[prom]
%{ for vm in vm_prom ~}
${vm.name}    ansible_host=${vm.network_interface.0.nat_ip_address}
%{ endfor ~}