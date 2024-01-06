apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${manifest.metadata_name}
  labels:
    ${manifest.label_key}: ${manifest.label_value}
  namespace: ${manifest.namespace}
spec:
  replicas: ${manifest.spec.replicas}
  selector:
    matchLabels:
      ${manifest.label_key}: ${manifest.label_value}
  template:
    metadata:
      labels:
        ${manifest.label_key}: ${manifest.label_value}
    spec:
      containers:
      - name: ${manifest.spec.template.spec.containers.name}
        image: ${image}
        env:
        - name: DATABASE_URI
          value: "${database_uri}"
        - name: DATABASE_HOSTS
          value: "${database_hosts}"
        ports:
            - containerPort: 443

apiVersion: v1
kind: Service
metadata:
  name: ${manifest.metadata_name}
spec:
  type: NodePort
  selector:
    ${manifest.label_key}: ${manifest.label_value}
  ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
      nodePort: 30081
