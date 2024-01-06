apiVersion: ${manifest.apiVersion}
kind: Deployment
metadata:
  name: ${manifest.metadata.name}
  labels:
%{ for labels in manifest.metadata.labels ~}
    ${labels}
%{ endfor ~}
  namespace: ${manifest.metadata.namespace}
spec:
  replicas: ${manifest.spec.replicas}
  selector:
    matchLabels:
%{ for labels in manifest.metadata.labels ~}
    ${labels}
%{ endfor ~}
  template:
    metadata:
      labels:
%{ for labels in manifest.metadata.labels ~}
        ${labels}
%{ endfor ~}
    spec:
      containers:
%{ for containers in manifest.spec.template.spec.containers ~}
        - name: ${containers.name}
          image: ${containers.image}
          ports:
%{ for ports in containers.ports ~}
            - name: ${ports.name}
              containerPort: ${ports.containerPort}
%{ endfor ~}
%{ endfor ~}

---
apiVersion: v1
kind: Service
metadata:
  name: httpbin
spec:
  type: NodePort
  selector:
    app: httpbin
  ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
      nodePort: 30080