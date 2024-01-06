apiVersion: ${manifest.apiVersion}
kind: Ingress
metadata:
  name: ${manifest.metadata.name}
  annotations:
    ingress.alb.yc.io/subnets: ${subnet_id}
    ingress.alb.yc.io/external-ipv4-address: ${manifest.metadata.annotations.ipv4}
    ingress.alb.yc.io/group-name: ${manifest.metadata.annotations.group_name}
spec:
  rules:
%{ for rules in manifest.spec.rules ~}
    - host: ${rules.host}
      http:
        paths:
%{ for paths in rules.http.paths ~}
          - pathType: ${paths.pathType}
            path: "/"
            backend:
              service:
                name: ${paths.backend.service.name}
                port:
                  number: ${paths.backend.service.port.number}
%{ endfor ~}
%{ endfor ~}