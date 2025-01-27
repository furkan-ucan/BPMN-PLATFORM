# BPM Platform - DevOps Playbook

## 1. Altyapı Yönetimi

### 1.1 Kubernetes Cluster Yapılandırması
```yaml
# cluster-config.yaml
apiVersion: v1
kind: Cluster
metadata:
  name: bpm-platform
spec:
  nodes:
    min: 3
    max: 10
  autoscaling:
    enabled: true
    minReplicas: 3
    maxReplicas: 10
```

### 1.2 Namespace Organizasyonu
```yaml
namespaces:
  - bpm-dev
  - bpm-test
  - bpm-staging
  - bpm-prod
  - bpm-monitoring
  - bpm-logging
```

### 1.3 Resource Quotas
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
spec:
  hard:
    requests.cpu: "20"
    requests.memory: 40Gi
    limits.cpu: "40"
    limits.memory: 80Gi
```

## 2. CI/CD Pipeline

### 2.1 GitLab CI/CD Pipeline
```yaml
stages:
  - build
  - test
  - security
  - deploy

variables:
  DOCKER_REGISTRY: registry.bpmplatform.com
  
build:
  stage: build
  script:
    - docker build -t $DOCKER_REGISTRY/$CI_PROJECT_NAME:$CI_COMMIT_SHA .
    - docker push $DOCKER_REGISTRY/$CI_PROJECT_NAME:$CI_COMMIT_SHA

test:
  stage: test
  script:
    - npm install
    - npm run test:unit
    - npm run test:integration

security:
  stage: security
  script:
    - sonar-scanner
    - owasp-dependency-check
    
deploy:
  stage: deploy
  script:
    - kubectl apply -f k8s/
```

### 2.2 Deployment Stratejileri

#### Blue-Green Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bpm-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: bpm
      version: blue
```

#### Canary Deployment
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: bpm-vsvc
spec:
  hosts:
  - bpm.example.com
  http:
  - route:
    - destination:
        host: bpm-stable
      weight: 90
    - destination:
        host: bpm-canary
      weight: 10
```

## 3. Monitoring ve Logging

### 3.1 Prometheus Configuration
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
```

### 3.2 Grafana Dashboards
- Node Metrics
- Pod Metrics
- Application Metrics
- Business Metrics

### 3.3 ELK Stack
```yaml
filebeat.inputs:
- type: container
  paths:
    - /var/log/containers/*.log

output.elasticsearch:
  hosts: ["elasticsearch:9200"]
  index: "bpm-logs-%{+yyyy.MM.dd}"
```

## 4. Backup ve Disaster Recovery

### 4.1 Backup Stratejisi
```bash
#!/bin/bash
# backup-script.sh

# Database backup
pg_dump -h $DB_HOST -U $DB_USER -d $DB_NAME > backup.sql

# Object storage backup
mc mirror minio/bpm-data s3/bpm-backup

# Encrypt and compress
tar -czf backup.tar.gz backup.sql
gpg --encrypt --recipient backup@bpm backup.tar.gz
```

### 4.2 Disaster Recovery Plan
1. Veri Merkezi Kesintisi
2. Veritabanı Corruption
3. Uygulama Hatası
4. Güvenlik İhlali

## 5. Güvenlik

### 5.1 Network Policies
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

### 5.2 Secret Management
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: bpm-secrets
type: Opaque
data:
  db-password: <base64-encoded>
  api-key: <base64-encoded>
```

## 6. Scaling Stratejisi

### 6.1 Horizontal Pod Autoscaling
```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: bpm-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: bpm-app
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

### 6.2 Vertical Pod Autoscaling
```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: bpm-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: Deployment
    name: bpm-app
  updatePolicy:
    updateMode: "Auto"
```

## 7. Service Mesh (Istio)

### 7.1 Traffic Management
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: bpm-destination
spec:
  host: bpm-service
  trafficPolicy:
    loadBalancer:
      simple: ROUND_ROBIN
    connectionPool:
      tcp:
        maxConnections: 100
      http:
        http1MaxPendingRequests: 1024
```

### 7.2 Security Policies
```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: bpm-auth
spec:
  selector:
    matchLabels:
      app: bpm
  rules:
  - from:
    - source:
        principals: ["cluster.local/ns/default/sa/bpm-sa"]
```

## 8. Infrastructure as Code

### 8.1 Terraform Configuration
```hcl
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "bpm" {
  metadata {
    name = "bpm-platform"
  }
}

resource "kubernetes_deployment" "bpm" {
  metadata {
    name = "bpm-app"
    namespace = kubernetes_namespace.bpm.metadata[0].name
  }
  
  spec {
    replicas = 3
    
    selector {
      match_labels = {
        app = "bpm"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "bpm"
        }
      }
      
      spec {
        container {
          image = "bpm:latest"
          name  = "bpm"
          
          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}
```

## 9. Incident Response

### 9.1 Alert Rules
```yaml
groups:
- name: bpm-alerts
  rules:
  - alert: HighErrorRate
    expr: rate(http_requests_total{status=~"5.."}[5m]) > 1
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: High error rate detected
```

### 9.2 Incident Management
1. Tespit
2. Müdahale
3. Analiz
4. Düzeltme
5. Raporlama

## 10. Change Management

### 10.1 Release Process
1. Change Request
2. Impact Analysis
3. Approval
4. Implementation
5. Validation
6. Documentation

### 10.2 Rollback Plan
```bash
#!/bin/bash
# rollback.sh

# Get previous version
PREV_VERSION=$(kubectl get deployment bpm-app -o=jsonpath='{.metadata.annotations.kubernetes\.io/change-cause}')

# Rollback deployment
kubectl rollout undo deployment/bpm-app

# Verify rollback
kubectl rollout status deployment/bpm-app
``` 