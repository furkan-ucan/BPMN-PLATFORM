# BPM Platform - API Versiyon Yönetimi Akışı

Bu diyagram, BPM Platform'un API versiyon yönetimi stratejisini ve süreçlerini gösterir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef gateway fill:#E8EAF6,stroke:#3F51B5,stroke-width:2px
    classDef version fill:#E3F2FD,stroke:#2196F3,stroke-width:2px
    classDef manager fill:#E8F5E9,stroke:#4CAF50,stroke-width:2px
    classDef monitor fill:#FFF3E0,stroke:#FF9800,stroke-width:2px
    classDef docs fill:#FCE4EC,stroke:#E91E63,stroke-width:2px
    classDef client fill:#F3E5F5,stroke:#9C27B0,stroke-width:2px

    %% API Gateway ve Routing
    subgraph Gateway["API Gateway"]
        APIGateway[API Gateway]:::gateway
        VersionRouter[Versiyon Router]:::gateway
        URLParser[URL Parser]:::gateway
        HeaderParser[Header Parser]:::gateway
        QueryParser[Query Parser]:::gateway
    end

    %% Versiyon Yönetimi
    subgraph VersionManagement["Versiyon Yönetimi"]
        VersionManager[Versiyon Yönetici]:::manager
        CompatibilityChecker[Uyumluluk Kontrolcüsü]:::manager
        DeprecationManager[Kullanımdan Kaldırma Yöneticisi]:::manager
        MigrationAssistant[Geçiş Asistanı]:::manager
    end

    %% API Versiyonları
    subgraph Versions["API Versiyonları"]
        V1[API v1]:::version
        V2[API v2]:::version
        V3[API v3 Beta]:::version
        LegacyAPIs[Legacy APIs]:::version
    end

    %% İzleme ve Analiz
    subgraph Monitoring["İzleme ve Analiz"]
        UsageAnalytics[Kullanım Analizi]:::monitor
        VersionMetrics[Versiyon Metrikleri]:::monitor
        DeprecationAlerts[Kullanımdan Kaldırma Uyarıları]:::monitor
        HealthChecks[Sağlık Kontrolleri]:::monitor
    end

    %% Dokümantasyon
    subgraph Documentation["Dokümantasyon"]
        SwaggerDocs[Swagger Docs]:::docs
        ChangeLog[Değişiklik Günlüğü]:::docs
        MigrationGuides[Geçiş Kılavuzları]:::docs
        APISpecs[API Spesifikasyonları]:::docs
    end

    %% API Tüketicileri
    subgraph Clients["API Tüketicileri"]
        MobileApps[Mobil Uygulamalar]:::client
        WebApps[Web Uygulamaları]:::client
        ThirdParty[3. Parti Sistemler]:::client
        LegacyClients[Legacy İstemciler]:::client
    end

    %% Bağlantılar - Gateway
    Clients --> APIGateway
    APIGateway --> VersionRouter
    VersionRouter --> |Parse| URLParser
    VersionRouter --> |Parse| HeaderParser
    VersionRouter --> |Parse| QueryParser

    %% Bağlantılar - Versiyon Yönetimi
    VersionRouter --> VersionManager
    VersionManager --> CompatibilityChecker
    VersionManager --> DeprecationManager
    VersionManager --> MigrationAssistant

    %% Bağlantılar - API Versiyonları
    VersionManager --> V1
    VersionManager --> V2
    VersionManager --> V3
    VersionManager --> LegacyAPIs

    %% Bağlantılar - İzleme
    VersionManager --> UsageAnalytics
    UsageAnalytics --> VersionMetrics
    DeprecationManager --> DeprecationAlerts
    VersionManager --> HealthChecks

    %% Bağlantılar - Dokümantasyon
    VersionManager --> SwaggerDocs
    VersionManager --> ChangeLog
    MigrationAssistant --> MigrationGuides
    VersionManager --> APISpecs

    %% Geri Bildirim Döngüleri
    UsageAnalytics --> DeprecationManager
    HealthChecks --> VersionManager
    DeprecationAlerts --> Clients

    %% Notlar
    note1[Version Negotiation]:::note
    note2[Backward Compatibility]:::note
    note3[Deprecation Strategy]:::note
    note4[Migration Support]:::note
    note5[API Documentation]:::note

    %% Not Bağlantıları
    VersionRouter -.-> note1
    CompatibilityChecker -.-> note2
    DeprecationManager -.-> note3
    MigrationAssistant -.-> note4
    Documentation -.-> note5

    classDef note fill:#F5F5F5,stroke:#9E9E9E,stroke-width:1px
```

## Diyagram Açıklaması

### API Gateway ve Routing
- **API Gateway**: Tüm API isteklerinin giriş noktası
- **Versiyon Router**: İstek yönlendirme ve versiyon tespiti
- **URL/Header/Query Parser**: Versiyon bilgisi çıkarma

### Versiyon Yönetimi
- **Versiyon Yönetici**: API versiyonlarının yaşam döngüsü
- **Uyumluluk Kontrolcüsü**: Geriye dönük uyumluluk kontrolü
- **Kullanımdan Kaldırma Yöneticisi**: Deprecated API yönetimi
- **Geçiş Asistanı**: Versiyon geçiş desteği

### API Versiyonları
- **API v1**: Kararlı sürüm
- **API v2**: Güncel kararlı sürüm
- **API v3 Beta**: Test aşamasındaki sürüm
- **Legacy APIs**: Eski sürümler

### İzleme ve Analiz
- **Kullanım Analizi**: API kullanım istatistikleri
- **Versiyon Metrikleri**: Versiyon bazlı metrikler
- **Kullanımdan Kaldırma Uyarıları**: Deprecated API bildirimleri
- **Sağlık Kontrolleri**: API sağlık durumu

### Dokümantasyon
- **Swagger Docs**: API dokümantasyonu
- **Değişiklik Günlüğü**: Sürüm değişiklikleri
- **Geçiş Kılavuzları**: Versiyon geçiş rehberleri
- **API Spesifikasyonları**: Detaylı API özellikleri

### API Tüketicileri
- **Mobil Uygulamalar**: Mobil istemciler
- **Web Uygulamaları**: Web istemcileri
- **3. Parti Sistemler**: Harici sistemler
- **Legacy İstemciler**: Eski istemciler

### Önemli Özellikler
- Versiyon müzakeresi
- Geriye dönük uyumluluk
- Kullanımdan kaldırma stratejisi
- Geçiş desteği
- API dokümantasyonu
``` 