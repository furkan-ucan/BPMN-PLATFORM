# BPM Platform - Sistem Mimarisi

Bu diyagram, BPM Platform'un sistem mimarisini ve bileşenler arası ilişkileri gösterir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef user fill:#f9f,stroke:#333,stroke-width:2px
    classDef container fill:#e1f5fe,stroke:#0288d1,stroke-width:2px
    classDef database fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
    classDef external fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    classDef boundary fill:#f5f5f5,stroke:#616161,stroke-width:1px

    %% Kullanıcı
    user[Platform Kullanıcısı]:::user
    
    %% Web ve Mobil Uygulamalar
    subgraph Frontend[Frontend Katmanı]
        direction TB
        web[Web Uygulaması<br/>Angular, TypeScript<br/>JWT Token Yenileme]:::container
        mobile[Mobil Uygulama<br/>React Native<br/>Offline Mode]:::container
        pwa[Progressive Web App<br/>Service Workers]:::container
    end

    %% API Gateway Katmanı
    subgraph Gateway[API Gateway Katmanı]
        direction TB
        api_gateway[API Gateway<br/>Spring Cloud Gateway<br/>Rate Limiting, Load Balancing]:::container
        auth[Auth Service<br/>Keycloak<br/>OAuth 2.0]:::container
        api_docs[API Documentation<br/>OpenAPI/Swagger]:::container
    end

    %% Core Services
    subgraph Core[Core Services]
        direction TB
        process[Process Engine<br/>Camunda, Spring Boot<br/>Auto-scaling]:::container
        form[Form Engine<br/>Spring Boot<br/>Circuit Breaker]:::container
        rule[Rule Engine<br/>Drools, Spring Boot<br/>Auto-scaling]:::container
        document[Document Service<br/>Spring Boot<br/>Retry Mechanism]:::container
    end

    %% Support Services
    subgraph Support[Support Services]
        direction TB
        notification[Notification Service<br/>Spring Boot<br/>Alert Management]:::container
        reporting[Reporting Service<br/>Spring Boot<br/>Data Aggregation]:::container
        audit[Audit Service<br/>Spring Boot<br/>Real-time Analysis]:::container
        integration[Integration Service<br/>Spring Boot<br/>Health Check, Retry]:::container
    end

    %% AI Services
    subgraph AI[AI Services]
        direction TB
        ml[ML Service<br/>Python, TensorFlow<br/>Data Pre-processing]:::container
        nlp[NLP Service<br/>Python, spaCy<br/>Caching Layer]:::container
        prediction[Prediction Service<br/>Python, scikit-learn<br/>Model Optimization]:::container
    end

    %% Monitoring Services
    subgraph Monitor[Monitoring Services]
        direction TB
        monitoring[Monitoring Service<br/>Prometheus, Grafana<br/>Auto-scaling Metrics]:::container
        logging[Logging Service<br/>ELK Stack<br/>Security Analysis]:::container
        tracing[Tracing Service<br/>Jaeger<br/>Performance Tracking]:::container
        alerting[Alert Manager<br/>Prometheus Alertmanager]:::container
    end

    %% Data Layer
    subgraph Data[Data Layer]
        direction TB
        process_db[(Process DB<br/>PostgreSQL<br/>Replica Set)]:::database
        document_db[(Document DB<br/>MongoDB<br/>Sharding)]:::database
        analytics_db[(Analytics DB<br/>ClickHouse<br/>Distributed)]:::database
        cache[(Cache<br/>Redis Cluster)]:::database
        backup[Backup Service<br/>Automated Backup<br/>Disaster Recovery]:::container
    end

    %% Message Layer
    subgraph Message[Message Layer]
        direction TB
        event_bus[Event Bus<br/>Apache Kafka<br/>Topic Prioritization]:::container
        message_queue[Message Queue<br/>RabbitMQ<br/>DLQ, TTL]:::container
        stream_processor[Stream Processor<br/>Kafka Streams]:::container
    end

    %% Security Layer
    subgraph Security[Security Layer]
        direction TB
        waf[WAF<br/>ModSecurity<br/>Real-time Analysis]:::container
        vault[Vault<br/>HashiCorp Vault<br/>Secret Rotation]:::container
        cert[Cert Manager<br/>Let's Encrypt<br/>Auto Renewal]:::container
        ids[IDS/IPS<br/>Security Events]:::container
    end

    %% External Systems
    mail[E-posta Sistemi<br/>SMTP]:::external
    sso[SSO Provider<br/>Kurumsal SSO]:::external
    ext_sys[Harici Sistemler<br/>ERP, CRM, vs.]:::external

    %% İlişkiler
    user --> web & mobile & pwa
    web & mobile & pwa --> waf
    waf --> api_gateway
    
    api_gateway --> auth & api_docs
    auth --> sso
    
    api_gateway --> Core & Support & AI
    
    Core & Support --> Message
    Core & Support & AI --> Data
    
    Monitor --> Core & Support & AI & Security
    alerting --> notification
    
    integration --> ext_sys
    notification --> mail
    
    %% Güvenlik İlişkileri
    Security --> Gateway & Core & Support
    vault --> Core & Support
    cert --> Gateway
    waf --> logging
    ids --> alerting
    
    %% Veri ve Mesaj İlişkileri
    Core --> process_db & document_db
    Support --> analytics_db
    AI --> analytics_db & cache
    backup --> Data
    
    event_bus --> stream_processor
    stream_processor --> Core & Support
    message_queue --> Core & Support

    %% Performans ve İzleme
    cache --> AI & Core
    monitoring --> alerting
    logging --> alerting
```

## Diyagram Açıklaması

### Katmanlar
#### 1. Frontend Katmanı
- **Web Uygulaması**: Angular ve TypeScript ile geliştirilmiş modern web arayüzü
- **Mobil Uygulama**: React Native ile geliştirilmiş iOS ve Android uygulamaları

#### 2. API Gateway Katmanı
- **API Gateway**: Spring Cloud Gateway ile yönlendirme ve yük dengeleme
- **Auth Service**: Keycloak ile kimlik doğrulama ve yetkilendirme
#### 3. Core Services
- **Process Engine**: Camunda tabanlı BPMN süreç yönetimi
- **Form Engine**: Dinamik form yönetimi
- **Rule Engine**: Drools tabanlı iş kuralları motoru
- **Document Service**: Doküman yönetimi
#### 4. Support Services
- **Notification Service**: Bildirim yönetimi
- **Reporting Service**: Raporlama ve analitik
- **Audit Service**: Denetim ve log yönetimi
- **Integration Service**: Harici sistem entegrasyonları
#### 5. AI Services
- **ML Service**: TensorFlow ile makine öğrenmesi
- **NLP Service**: spaCy ile doğal dil işleme
- **Prediction Service**: scikit-learn ile tahminsel analitik
#### 6. Monitoring Services
- **Monitoring Service**: Prometheus ve Grafana ile sistem izleme
- **Logging Service**: ELK Stack ile merkezi log yönetimi
- **Tracing Service**: Jaeger ile distributed tracing
#### 7. Data Layer
- **Process DB**: PostgreSQL ile süreç ve form verileri
- **Document DB**: MongoDB ile doküman verileri
- **Analytics DB**: ClickHouse ile analitik verileri
- **Cache**: Redis ile önbellek verileri
#### 8. Message Layer
- **Event Bus**: Apache Kafka ile event streaming
- **Message Queue**: RabbitMQ ile message queuing
#### 9. Security Layer
- **WAF**: ModSecurity ile web uygulama güvenliği
- **Vault**: HashiCorp Vault ile secrets yönetimi
- **Cert Manager**: Let's Encrypt ile SSL/TLS yönetimi
### Harici Sistemler
- **E-posta Sistemi**: SMTP sunucusu
- **SSO Provider**: 

### Yeni Eklenen Bileşenler ve İyileştirmeler

1. **Yedekleme ve Kurtarma**
   - Backup Service: Otomatik yedekleme ve felaket kurtarma
   - Veritabanı replikasyonu ve sharding
   - Dağıtık veri depolama stratejileri

2. **Servis Dayanıklılığı**
   - Circuit Breaker pattern implementasyonu
   - Retry mekanizmaları
   - Health check servisleri

3. **Performans İyileştirmeleri**
   - Redis cache cluster
   - Veri ön işleme katmanı
   - Auto-scaling yapılandırmaları

4. **Entegrasyon Güvenliği**
   - Health check monitoring
   - Retry politikaları
   - Timeout yapılandırmaları

5. **Ölçeklenebilirlik**
   - Load balancing
   - Horizontal Pod Autoscaling
   - Distributed caching

6. **Güvenlik İzleme**
   - WAF log analizi
   - IDS/IPS entegrasyonu
   - Security event management

7. **Mesajlaşma İyileştirmeleri**
   - Kafka topic önceliklendirme
   - RabbitMQ DLQ
   - Message TTL yapılandırması

8. **API Yönetimi**
   - OpenAPI/Swagger dokümantasyonu
   - Rate limiting
   - API versiyonlama

9. **Hata Yönetimi**
   - Prometheus Alertmanager
   - Log analizi ve alerting
   - Incident response automation

10. **Kullanıcı Deneyimi**
    - JWT token yenileme
    - Offline mode desteği
    - Progressive Web App yapılandırması
``` 