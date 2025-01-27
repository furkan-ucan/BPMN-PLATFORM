# BPM Platform - Event-Driven Mimari Akışı (Geliştirilmiş)

Bu diyagram, BPM Platform'un event-driven mimarisini ve event akışlarını gösterir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef producer fill:#E8EAF6,stroke:#3F51B5,stroke-width:2px
    classDef consumer fill:#E3F2FD,stroke:#2196F3,stroke-width:2px
    classDef event fill:#E8F5E9,stroke:#4CAF50,stroke-width:2px
    classDef store fill:#FFF3E0,stroke:#FF9800,stroke-width:2px
    classDef processor fill:#FCE4EC,stroke:#E91E63,stroke-width:2px
    classDef security fill:#F3E5F5,stroke:#9C27B0,stroke-width:2px
    classDef monitor fill:#FFEBEE,stroke:#D32F2F,stroke-width:2px

    %% Event Üreticileri
    subgraph Producers["Event Üreticileri"]
        ProcessEngine[Süreç Motoru]:::producer
        TaskManager[Görev Yöneticisi]:::producer
        UserActions[Kullanıcı Aksiyonları]:::producer
        SystemMonitor[Sistem Monitörü]:::producer
        IntegrationPoints[Entegrasyon Noktaları]:::producer
        SecurityEvents[Güvenlik Olayları]:::producer
    end

    %% Event Tipleri ve Sürümleme
    subgraph EventTypes["Event Tipleri"]
        %% İş Süreçleri
        subgraph BusinessEvents["İş Süreçleri"]
            ProcessEvents[Süreç Events v2]:::event
            TaskEvents[Görev Events v2]:::event
            UserEvents[Kullanıcı Events v1]:::event
        end

        %% Sistem Events
        subgraph SystemEvents["Sistem Events"]
            ErrorEvents[Hata Events v1]:::event
            AuditEvents[Denetim Events v2]:::event
            MetricEvents[Metrik Events v1]:::event
        end

        %% Transactional Events
        subgraph TransactionEvents["İşlem Events"]
            SyncEvents[Senkron Events v1]:::event
            AsyncEvents[Asenkron Events v2]:::event
            CompensationEvents[Telafi Events v1]:::event
        end
    end

    %% Event Bus ve Stream Processing
    subgraph EventProcessing["Event İşleme Katmanı"]
        %% Kafka Cluster
        subgraph KafkaCluster["Kafka Cluster"]
            KafkaBroker1[Broker 1]:::processor
            KafkaBroker2[Broker 2]:::processor
            KafkaBroker3[Broker 3]:::processor
            ZooKeeper[ZooKeeper]:::processor
        end

        %% İşleme Birimleri
        subgraph Processors["İşlemciler"]
            RealTimeProcessor[Gerçek Zamanlı İşlemci]:::processor
            BatchProcessor[Toplu İşlemci]:::processor
            StreamProcessor[Stream İşlemci]:::processor
            RetryProcessor[Yeniden Deneme İşlemci]:::processor
        end

        %% Event Yönetimi
        EventRouter[Event Router]:::processor
        EventFilter[Event Filter]:::processor
        EventEnricher[Event Enricher]:::processor
        EventValidator[Event Validator]:::processor
    end

    %% Güvenlik Katmanı
    subgraph Security["Güvenlik"]
        Encryption[Şifreleme]:::security
        Authentication[Kimlik Doğrulama]:::security
        Authorization[Yetkilendirme]:::security
        AuditLog[Denetim Logu]:::security
    end

    %% Event Store ve Cache
    subgraph Storage["Depolama"]
        %% Event Stores
        EventStore[(Event Store)]:::store
        DeadLetterQueue[(Dead Letter Queue)]:::store
        RetryQueue[(Retry Queue)]:::store
        
        %% Caching
        EventCache[(Event Cache)]:::store
        RedisCache[(Redis Cache)]:::store
    end

    %% İzleme ve Analiz
    subgraph Monitoring["İzleme"]
        %% Metrikler
        EventMetrics[Event Metrikleri]:::monitor
        ProcessingMetrics[İşleme Metrikleri]:::monitor
        LatencyMetrics[Gecikme Metrikleri]:::monitor
        
        %% Görselleştirme
        Grafana[Grafana]:::monitor
        Kibana[Kibana]:::monitor
    end

    %% Event Tüketicileri
    subgraph Consumers["Event Tüketicileri"]
        NotificationService[Bildirim Servisi]:::consumer
        AnalyticsEngine[Analitik Motoru]:::consumer
        AuditService[Denetim Servisi]:::consumer
        ReportingService[Raporlama Servisi]:::consumer
        AlertingService[Alarm Servisi]:::consumer
        ReplayService[Replay Servisi]:::consumer
    end

    %% Üretici Bağlantıları
    Producers --> Security
    Security --> EventTypes

    %% Event Processing Bağlantıları
    EventTypes --> KafkaCluster
    KafkaCluster --> Processors
    Processors --> EventRouter
    EventRouter --> EventFilter
    EventFilter --> EventEnricher
    EventEnricher --> EventValidator

    %% Storage Bağlantıları
    EventValidator --> EventStore
    EventStore --> EventCache
    RetryProcessor --> RetryQueue
    RetryQueue --> Processors
    EventValidator --> DeadLetterQueue

    %% Tüketici Bağlantıları
    EventValidator --> Consumers
    Consumers --> Security

    %% İzleme Bağlantıları
    EventProcessing --> Monitoring
    Storage --> Monitoring
    Consumers --> Monitoring

    %% Geri Bildirim Döngüleri
    AlertingService --> SystemMonitor
    AnalyticsEngine --> ProcessEngine
    ReplayService --> EventStore

    %% Notlar
    note1[Event Versioning & Compatibility]:::note
    note2[Load Balanced Processing]:::note
    note3[Security & Encryption]:::note
    note4[Real-time & Batch Processing]:::note
    note5[Event Replay & Recovery]:::note

    %% Not Bağlantıları
    EventTypes -.-> note1
    KafkaCluster -.-> note2
    Security -.-> note3
    Processors -.-> note4
    ReplayService -.-> note5

    classDef note fill:#F5F5F5,stroke:#9E9E9E,stroke-width:1px
```

## Diyagram Açıklaması

### Event Üreticileri
- **Süreç Motoru**: BPMN süreç eventleri
- **Görev Yöneticisi**: Task eventleri
- **Kullanıcı Aksiyonları**: Kullanıcı eventleri
- **Sistem Monitörü**: Sistem eventleri
- **Entegrasyon Noktaları**: Dış sistem eventleri
- **Güvenlik Olayları**: Güvenlik eventleri

### Event Tipleri ve Sürümleme
#### İş Süreçleri
- **Süreç Events v2**: Süreç yaşam döngüsü
- **Görev Events v2**: Task yönetimi
- **Kullanıcı Events v1**: Kullanıcı etkileşimleri

#### Sistem Events
- **Hata Events v1**: Sistem hataları
- **Denetim Events v2**: Audit logging
- **Metrik Events v1**: Performans metrikleri

#### İşlem Events
- **Senkron Events v1**: Anlık işlemler
- **Asenkron Events v2**: Gecikmeli işlemler
- **Telafi Events v1**: Compensation events

### Event İşleme Katmanı
#### Kafka Cluster
- **Broker 1/2/3**: Dağıtık event yönetimi
- **ZooKeeper**: Cluster koordinasyonu

#### İşlemciler
- **Gerçek Zamanlı İşlemci**: Anlık işlemler
- **Toplu İşlemci**: Batch processing
- **Stream İşlemci**: Stream processing
- **Yeniden Deneme İşlemci**: Retry mekanizması

### Güvenlik
- **Şifreleme**: Event encryption
- **Kimlik Doğrulama**: Producer/Consumer auth
- **Yetkilendirme**: RBAC/ABAC
- **Denetim Logu**: Security audit

### Depolama
- **Event Store**: Event veritabanı
- **Dead Letter Queue**: Başarısız eventler
- **Retry Queue**: Yeniden deneme kuyruğu
- **Event Cache**: Önbellek
- **Redis Cache**: Dağıtık önbellek

### İzleme
- **Event Metrikleri**: Event istatistikleri
- **İşleme Metrikleri**: Processing metrics
- **Gecikme Metrikleri**: Latency tracking
- **Grafana/Kibana**: Görselleştirme

### Event Tüketicileri
- **Bildirim Servisi**: Notification handling
- **Analitik Motoru**: Event analizi
- **Denetim Servisi**: Audit logging
- **Raporlama Servisi**: Reporting
- **Alarm Servisi**: Alerting
- **Replay Servisi**: Event replay

### Önemli Özellikler
- Event sürümleme ve geriye uyumluluk
- Yük dengelemeli işleme
- Güvenlik ve şifreleme
- Gerçek zamanlı ve toplu işleme
- Event replay ve kurtarma 