apiVersion: ${manifest.apiVersion}
kind: ${manifest.kind}
metadata:
  namespace: ${manifest.metadata.namespace}
  name: ${manifest.metadata.name}
  labels:
%{ for labels in manifest.metadata.labels ~}
    ${labels}
%{ endfor ~}
spec:
  ports:
%{ for ports in manifest.spec.ports ~}
    - port: ${ports.port}
      name: ${ports.name}
      targetPort: ${ports.targetPort}
%{ endfor ~}
  selector:
%{ for labels in manifest.metadata.labels ~}
    ${labels}
%{ endfor ~}
  type: ${manifest.spec.type}