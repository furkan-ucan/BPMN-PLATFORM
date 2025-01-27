# BPM Platform - Mikroservisler Arası İletişim Akışı (Geliştirilmiş)

Bu diyagram, BPM Platform'daki mikroservisler arasındaki iletişim akışını ve etkileşimleri gösterir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef service fill:#E8EAF6,stroke:#3F51B5,stroke-width:2px
    classDef gateway fill:#E3F2FD,stroke:#2196F3,stroke-width:2px
    classDef queue fill:#E8F5E9,stroke:#4CAF50,stroke-width:2px
    classDef store fill:#FFF3E0,stroke:#FF9800,stroke-width:2px
    classDef monitor fill:#FCE4EC,stroke:#E91E63,stroke-width:2px
    classDef ai fill:#F3E5F5,stroke:#9C27B0,stroke-width:2px

    %% API Gateway ve Load Balancer
    subgraph Gateway["API Gateway Layer"]
        APIGateway[API Gateway]:::gateway
        LoadBalancer[Load Balancer]:::gateway
        CircuitBreaker[Circuit Breaker]:::gateway
        TrafficManager[Traffic Manager]:::gateway
    end

    %% Temel Mikroservisler
    subgraph CoreServices["Core Microservices"]
        ProcessService[Süreç Servisi]:::service
        TaskService[Görev Servisi]:::service
        FormService[Form Servisi]:::service
        RuleService[Kural Servisi]:::service
        DocumentService[Doküman Servisi]:::service
    end

    %% Destek Mikroservisleri
    subgraph SupportServices["Support Microservices"]
        NotificationService[Bildirim Servisi]:::service
        AuthService[Kimlik Doğrulama Servisi]:::service
        UserService[Kullanıcı Servisi]:::service
        ReportService[Raporlama Servisi]:::service
        AnalyticsService[Analitik Servisi]:::service
    end

    %% AI ve ML Servisleri
    subgraph AIServices["AI & ML Services"]
        PredictiveAnalytics[Öngörülü Analitik]:::ai
        AnomalyDetection[Anomali Tespiti]:::ai
        RecommendationEngine[Öneri Motoru]:::ai
        MLPipeline[ML Pipeline]:::ai
    end

    %% Mesajlaşma ve Event Sistemi
    subgraph MessageSystem["Message System"]
        EventBus[Event Bus]:::queue
        MessageQueue[Message Queue]:::queue
        StreamProcessor[Stream Processor]:::queue
        EventSchema[Event Schema]:::queue
        EventTracer[Event Tracer]:::queue
    end

    %% Veri Depolama
    subgraph DataStores["Data Stores"]
        ProcessDB[(Süreç DB)]:::store
        TaskDB[(Görev DB)]:::store
        DocumentDB[(Doküman DB)]:::store
        AnalyticsDB[(Analitik DB)]:::store
        Cache[(Distributed Cache)]:::store
        CacheManager[Cache Manager]:::store
    end

    %% İzleme ve Logging
    subgraph Monitoring["Monitoring & Logging"]
        MetricsCollector[Metrics Collector]:::monitor
        LogAggregator[Log Aggregator]:::monitor
        HealthChecker[Health Checker]:::monitor
        Tracing[Distributed Tracing]:::monitor
        AlertManager[Alert Manager]:::monitor
    end

    %% Bağlantılar - Gateway ve Servisler
    APIGateway --> TrafficManager
    TrafficManager --> LoadBalancer
    LoadBalancer --> CircuitBreaker
    CircuitBreaker --> CoreServices
    CircuitBreaker --> SupportServices

    %% Core Servis Bağlantıları (Sync)
    ProcessService -->|Sync| TaskService
    ProcessService -->|Sync| FormService
    ProcessService -->|Sync| RuleService
    TaskService -->|Sync| DocumentService

    %% Support Servis Bağlantıları (Mixed)
    NotificationService -->|Async| UserService
    AuthService -->|Sync| UserService
    ReportService -->|Async| AnalyticsService
    AnalyticsService --> PredictiveAnalytics

    %% AI Servis Bağlantıları
    PredictiveAnalytics --> ProcessService
    AnomalyDetection --> HealthChecker
    RecommendationEngine --> NotificationService
    AnalyticsService --> MLPipeline

    %% Event ve Message Bağlantıları
    CoreServices --> EventBus
    SupportServices --> EventBus
    EventBus --> EventSchema
    EventSchema --> StreamProcessor
    StreamProcessor --> MessageQueue
    EventBus --> EventTracer

    %% Veri Depolama Bağlantıları
    ProcessService --> ProcessDB
    TaskService --> TaskDB
    DocumentService --> DocumentDB
    AnalyticsService --> AnalyticsDB
    CoreServices & SupportServices --> CacheManager
    CacheManager --> Cache

    %% Monitoring Bağlantıları
    MetricsCollector --> CoreServices & SupportServices & AIServices
    LogAggregator --> Tracing
    HealthChecker --> CircuitBreaker
    Tracing --> AlertManager
    AlertManager --> NotificationService

    %% Notlar
    note1[Async Event-Driven Communication]:::note
    note2[Sync Direct Communication]:::note
    note3[AI-Enhanced Analytics]:::note
    note4[Dynamic Cache Management]:::note
    note5[Distributed Tracing]:::note

    %% Not Bağlantıları
    MessageSystem -.-> note1
    CoreServices -.-> note2
    AIServices -.-> note3
    CacheManager -.-> note4
    Tracing -.-> note5

    classDef note fill:#F5F5F5,stroke:#9E9E9E,stroke-width:1px
```

## Diyagram Açıklaması

### Gateway Katmanı
- **API Gateway**: Dış dünya ile iletişim noktası
- **Traffic Manager**: Trafik yönetimi ve yönlendirme
- **Load Balancer**: Akıllı yük dengeleme
- **Circuit Breaker**: Hata toleransı ve izolasyon

### Core Mikroservisler (Sync İletişim)
- **Süreç Servisi**: BPMN süreç yönetimi
- **Görev Servisi**: Task yönetimi
- **Form Servisi**: Dinamik form yönetimi
- **Kural Servisi**: İş kuralları yönetimi
- **Doküman Servisi**: Doküman işlemleri

### Destek Mikroservisleri (Mixed İletişim)
- **Bildirim Servisi**: Akıllı bildirim yönetimi
- **Kimlik Doğrulama**: Auth işlemleri
- **Kullanıcı Servisi**: Kullanıcı yönetimi
- **Raporlama**: Gelişmiş raporlama
- **Analitik**: AI destekli analiz

### AI ve ML Servisleri
- **Öngörülü Analitik**: Performans tahminleri
- **Anomali Tespiti**: Anormal durum tespiti
- **Öneri Motoru**: Akıllı öneriler
- **ML Pipeline**: Model eğitimi ve deployment

### Mesajlaşma Sistemi
- **Event Bus**: Merkezi event yönetimi
- **Event Schema**: Event yapı tanımları
- **Message Queue**: Async mesajlaşma
- **Stream Processor**: Real-time işleme
- **Event Tracer**: Event izleme

### Veri Depolama
- **Distributed Cache**: Dağıtık önbellek
- **Cache Manager**: TTL ve politika yönetimi
- **Process DB**: Süreç verileri
- **Task DB**: Task verileri
- **Analytics DB**: Analiz verileri

### İzleme ve Logging
- **Distributed Tracing**: End-to-end izleme
- **Metrics Collector**: Metrik toplama
- **Log Aggregator**: Merkezi loglama
- **Health Checker**: Sağlık kontrolü
- **Alert Manager**: Alarm yönetimi

### Önemli Özellikler
- Async/Sync iletişim dengesi
- AI destekli analitik ve öneriler
- Dinamik cache yönetimi
- Distributed tracing
- Event schema yönetimi 