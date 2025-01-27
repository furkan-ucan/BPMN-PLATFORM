# BPM Platform - Veri Akış Diyagramı

Bu diyagram, BPM Platform'daki veri akışlarını ve sistemler arası ilişkileri gösterir.

```mermaid
flowchart TB
    %% Stil Tanımlamaları
    classDef user fill:#FFE4C4,stroke:#8B4513,stroke-width:2px
    classDef system fill:#87CEEB,stroke:#4682B4,stroke-width:2px
    classDef database fill:#98FB98,stroke:#228B22,stroke-width:2px
    classDef queue fill:#DDA0DD,stroke:#8B008B,stroke-width:2px
    classDef external fill:#F0E68C,stroke:#DAA520,stroke-width:2px
    classDef security fill:#FF6B6B,stroke:#8B0000,stroke-width:2px
    classDef monitoring fill:#98FB98,stroke:#006400,stroke-width:2px

    %% Load Balancer ve Service Discovery
    load_balancer["⚖️ Load Balancer<br/>Nginx/HAProxy"]
    service_discovery["🔍 Service Discovery<br/>Consul"]

    %% Dış Sistemler ve Aktörler
    user["👤 Kullanıcı"]
    external_system["🌐 Harici Sistemler<br/>ERP, CRM, vs."]
    identity_provider["🔐 Kimlik Sağlayıcı<br/>SSO Provider"]

    %% Veri Depolama Sistemleri
    subgraph Storage["Veri Depolama"]
        process_db[("💾 Süreç DB<br/>PostgreSQL")]
        document_db[("📄 Doküman DB<br/>MongoDB")]
        analytics_db[("📊 Analitik DB<br/>ClickHouse")]
        cache_db[("⚡ Önbellek<br/>Redis")]
        object_store[("📦 Nesne Deposu<br/>S3/MinIO")]
    end

    %% Mesajlaşma Sistemleri
    subgraph Messaging["Mesajlaşma Sistemleri"]
        event_bus[["📡 Event Bus<br/>Kafka"]]
        message_queue[["📨 Message Queue<br/>RabbitMQ"]]
        dead_letter_queue[["💀 Dead Letter Queue"]]
    end

    %% Frontend Sistemi
    subgraph Frontend["Frontend Sistemi"]
        web_ui["🖥️ Web UI<br/>Angular"]
        mobile_ui["📱 Mobile UI<br/>React Native"]
        notification_ui["🔔 Notification UI"]
    end

    %% Güvenlik Katmanı
    subgraph Security["Güvenlik Katmanı"]
        waf["🛡️ WAF"]
        encryption_service["🔒 Encryption Service"]
        audit_service["📝 Audit Service"]
        auth_service["🔑 Auth Service<br/>Keycloak"]
        token_service["🎟️ Token Service<br/>JWT"]
    end

    %% İzleme ve Raporlama
    subgraph Monitoring["İzleme ve Raporlama"]
        prometheus["📊 Prometheus"]
        grafana["📈 Grafana"]
        elk_stack["📋 ELK Stack"]
        health_check["💓 Health Check"]
    end

    %% API Gateway ve Rate Limiting
    subgraph APIGateway["API Gateway Katmanı"]
        api_gateway["🌐 API Gateway"]
        rate_limiter["⏱️ Rate Limiter"]
        circuit_breaker["🔌 Circuit Breaker"]
    end

    %% Süreç Yönetim Sistemi
    subgraph Process["Süreç Yönetim Sistemi"]
        bpmn_engine["⚙️ BPMN Engine<br/>Camunda"]
        form_engine["📝 Form Engine"]
        rule_engine["📋 Rule Engine<br/>Drools"]
        process_cache["💨 Process Cache"]
    end

    %% Entegrasyon Sistemi
    subgraph Integration["Entegrasyon Sistemi"]
        integration_service["🔄 Integration Service"]
        data_transformer["🔄 Data Transformer"]
        retry_mechanism["🔁 Retry Mechanism"]
    end

    %% Analitik Sistemi
    subgraph Analytics["Analitik Sistemi"]
        reporting_service["📊 Reporting Service"]
        analytics_service["📈 Analytics Service"]
        ml_service["🤖 ML Service"]
        dashboard_service["📊 Dashboard Service"]
    end

    %% Bildirim Sistemi
    subgraph Notification["Bildirim Sistemi"]
        notification_service["🔔 Notification Service"]
        email_service["📧 Email Service"]
        sms_service["📱 SMS Service"]
        push_service["📲 Push Service"]
    end

    %% Veri Akışları
    user --> load_balancer
    load_balancer --> waf
    waf --> api_gateway

    api_gateway --> rate_limiter
    rate_limiter --> circuit_breaker
    circuit_breaker --> auth_service

    auth_service --> identity_provider
    auth_service --> token_service
    auth_service --> encryption_service

    circuit_breaker --> bpmn_engine
    bpmn_engine --> process_db
    bpmn_engine --> rule_engine
    bpmn_engine --> form_engine
    bpmn_engine --> process_cache

    form_engine --> document_db
    form_engine --> object_store

    rule_engine --> cache_db
    rule_engine --> analytics_db

    integration_service --> external_system
    integration_service --> retry_mechanism
    retry_mechanism --> dead_letter_queue

    %% İzleme ve Log Akışları
    bpmn_engine & form_engine & rule_engine --> prometheus
    prometheus --> grafana
    all_services --> elk_stack
    health_check --> prometheus

    %% Bildirim Akışları
    notification_service --> email_service & sms_service & push_service
    email_service & sms_service & push_service --> message_queue

    %% Analitik Akışları
    analytics_service --> dashboard_service
    ml_service --> analytics_service
    reporting_service --> dashboard_service

    %% Service Discovery
    all_services --> service_discovery

    %% Stil Atamaları
    class user,external_system user
    class process_db,document_db,analytics_db,cache_db,object_store database
    class event_bus,message_queue,dead_letter_queue queue
    class waf,encryption_service,audit_service,auth_service,token_service security
    class prometheus,grafana,elk_stack,health_check monitoring
    class web_ui,mobile_ui,notification_ui,bpmn_engine,form_engine,rule_engine,api_gateway,integration_service,reporting_service,analytics_service,ml_service system

```

## Veri Akışı ve Bileşen Detayları

### Yük Dengeleme ve Service Discovery
- **Load Balancer**: Nginx/HAProxy ile yük dengeleme
- **Service Discovery**: Consul ile servis keşfi ve yönetimi

### Güvenlik Katmanı
- **WAF**: Web uygulama güvenlik duvarı
- **Encryption Service**: Veri şifreleme servisi
- **Audit Service**: Denetim ve log kayıtları
- **Auth Service**: Kimlik doğrulama ve yetkilendirme
- **Token Service**: JWT token yönetimi

### API Gateway Katmanı
- **Rate Limiter**: API istek sınırlama
  ```json
  {
    "limits": {
      "default": {
        "rate": 100,
        "burst": 50,
        "window": "1m"
      },
      "authenticated": {
        "rate": 1000,
        "burst": 100,
        "window": "1m"
      }
    }
  }
  ```
- **Circuit Breaker**: Devre kesici
  ```json
  {
    "thresholds": {
      "errorRate": "50%",
      "timeout": "5s",
      "resetTimeout": "30s"
    }
  }
  ```

### Veri Depolama
- **PostgreSQL**: Aktif-Pasif Replikasyon
  ```json
  {
    "replication": {
      "mode": "async",
      "nodes": ["master", "slave"],
      "failover": "automatic"
    }
  }
  ```
- **MongoDB**: Sharding ve Replikasyon
  ```json
  {
    "sharding": {
      "enabled": true,
      "shards": 3,
      "replicas": 2
    }
  }
  ```

### Mesajlaşma Sistemleri
- **Kafka**: Event Sourcing ve Stream Processing
  ```json
  {
    "kafka": {
      "partitions": 10,
      "replication": 3,
      "retention": "7d"
    }
  }
  ```
- **RabbitMQ**: Asenkron İşlem Kuyruğu
  ```json
  {
    "queues": {
      "notifications": {
        "type": "direct",
        "durable": true
      },
      "deadLetter": {
        "ttl": "24h",
        "retries": 3
      }
    }
  }
  ```

### İzleme ve Raporlama
- **Prometheus & Grafana**: Metrik Toplama ve Görselleştirme
  ```json
  {
    "metrics": {
      "collection": "15s",
      "retention": "30d",
      "alerts": {
        "cpu": "> 80%",
        "memory": "> 90%",
        "latency": "> 500ms"
      }
    }
  }
  ```
- **ELK Stack**: Log Yönetimi
  ```json
  {
    "logging": {
      "retention": "90d",
      "indices": {
        "application": "daily",
        "security": "hourly"
      }
    }
  }
  ```

### Hata Yönetimi
- **Retry Mechanism**: Yeniden Deneme Stratejisi
  ```json
  {
    "retry": {
      "maxAttempts": 3,
      "backoff": {
        "initial": "1s",
        "multiplier": 2,
        "max": "1m"
      }
    }
  }
  ```
- **Dead Letter Queue**: Başarısız İşlem Yönetimi
  ```json
  {
    "dlq": {
      "retention": "7d",
      "alerts": true,
      "autoRetry": false
    }
  }
  ```

### Ölçeklenebilirlik
- **Auto-scaling**: Kubernetes ile Otomatik Ölçeklendirme
  ```json
  {
    "scaling": {
      "min": 2,
      "max": 10,
      "metrics": {
        "cpu": "70%",
        "memory": "80%"
      }
    }
  }
  ```
- **Cache Strategy**: Önbellekleme Stratejisi
  ```json
  {
    "cache": {
      "rules": {
        "ttl": "15m",
        "strategy": "LRU"
      },
      "sessions": {
        "ttl": "24h",
        "distributed": true
      }
    }
  }
  ``` 