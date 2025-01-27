# BPM Platform - Bildirim Yönetimi Akışı

Bu diyagram, BPM Platform'un bildirim yönetimi ve dağıtım süreçlerini gösterir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef event fill:#E8EAF6,stroke:#3F51B5,stroke-width:2px
    classDef processing fill:#E3F2FD,stroke:#2196F3,stroke-width:2px
    classDef delivery fill:#E8F5E9,stroke:#4CAF50,stroke-width:2px
    classDef template fill:#FFF3E0,stroke:#FF9800,stroke-width:2px
    classDef tracking fill:#FCE4EC,stroke:#E91E63,stroke-width:2px
    classDef preference fill:#F3E5F5,stroke:#9C27B0,stroke-width:2px

    %% Bildirim Olayları
    subgraph NotificationEvents["Bildirim Olayları"]
        %% Olay Kaynakları
        subgraph EventSources["Olay Kaynakları"]
            SystemEvents[Sistem Olayları]:::event
            ProcessEvents[Süreç Olayları]:::event
            UserEvents[Kullanıcı Olayları]:::event
            IntegrationEvents[Entegrasyon Olayları]:::event
        end

        %% Olay Tipleri
        subgraph EventTypes["Olay Tipleri"]
            Alert[Uyarılar]:::event
            Info[Bilgilendirmeler]:::event
            Action[Aksiyon Gerektiren]:::event
            Reminder[Hatırlatıcılar]:::event
        end
    end

    %% Bildirim İşleme
    subgraph NotificationProcessing["Bildirim İşleme"]
        %% İşleme Bileşenleri
        EventRouter[Olay Yönlendirici]:::processing
        PriorityManager[Öncelik Yöneticisi]:::processing
        ContentEnricher[İçerik Zenginleştirici]:::processing
        RuleEngine[Kural Motoru]:::processing
    end

    %% Bildirim Şablonları
    subgraph NotificationTemplates["Bildirim Şablonları"]
        %% Şablon Yönetimi
        TemplateManager[Şablon Yöneticisi]:::template
        ContentBuilder[İçerik Oluşturucu]:::template
        Localization[Yerelleştirme]:::template
        Personalization[Kişiselleştirme]:::template
    end

    %% Bildirim Dağıtımı
    subgraph NotificationDelivery["Bildirim Dağıtımı"]
        %% Dağıtım Kanalları
        EmailChannel[E-posta]:::delivery
        PushChannel[Push Bildirim]:::delivery
        SMSChannel[SMS]:::delivery
        WebhookChannel[Webhook]:::delivery
    end

    %% Bildirim İzleme
    subgraph NotificationTracking["Bildirim İzleme"]
        %% İzleme Bileşenleri
        DeliveryStatus[İletim Durumu]:::tracking
        ReadStatus[Okunma Durumu]:::tracking
        ActionStatus[Aksiyon Durumu]:::tracking
        Analytics[Analitik]:::tracking
    end

    %% Kullanıcı Tercihleri
    subgraph UserPreferences["Kullanıcı Tercihleri"]
        %% Tercih Yönetimi
        ChannelPrefs[Kanal Tercihleri]:::preference
        FrequencyPrefs[Sıklık Tercihleri]:::preference
        TypePrefs[Tip Tercihleri]:::preference
        TimePrefs[Zaman Tercihleri]:::preference
    end

    %% Bağlantılar - Olaylar
    EventSources --> EventTypes
    SystemEvents --> Alert
    ProcessEvents --> Info
    UserEvents --> Action
    IntegrationEvents --> Reminder

    %% Bağlantılar - İşleme
    EventTypes --> NotificationProcessing
    Alert --> EventRouter
    Info --> PriorityManager
    Action --> ContentEnricher
    Reminder --> RuleEngine

    %% Bağlantılar - Şablonlar
    NotificationProcessing --> NotificationTemplates
    EventRouter --> TemplateManager
    PriorityManager --> ContentBuilder
    ContentEnricher --> Localization
    RuleEngine --> Personalization

    %% Bağlantılar - Dağıtım
    NotificationTemplates --> NotificationDelivery
    TemplateManager --> EmailChannel
    ContentBuilder --> PushChannel
    Localization --> SMSChannel
    Personalization --> WebhookChannel

    %% Bağlantılar - İzleme
    NotificationDelivery --> NotificationTracking
    EmailChannel --> DeliveryStatus
    PushChannel --> ReadStatus
    SMSChannel --> ActionStatus
    WebhookChannel --> Analytics

    %% Bağlantılar - Tercihler
    NotificationTracking --> UserPreferences
    DeliveryStatus --> ChannelPrefs
    ReadStatus --> FrequencyPrefs
    ActionStatus --> TypePrefs
    Analytics --> TimePrefs

    %% Geri Bildirim Döngüleri
    UserPreferences --> NotificationEvents
    ChannelPrefs --> EventSources
    FrequencyPrefs --> NotificationProcessing
    TypePrefs --> NotificationTemplates
    TimePrefs --> NotificationDelivery

    %% Notlar
    note1[Bildirim Olayları]:::note
    note2[Bildirim İşleme]:::note
    note3[Bildirim Şablonları]:::note
    note4[Bildirim Dağıtımı]:::note
    note5[Bildirim İzleme]:::note
    note6[Kullanıcı Tercihleri]:::note

    %% Not Bağlantıları
    NotificationEvents -.-> note1
    NotificationProcessing -.-> note2
    NotificationTemplates -.-> note3
    NotificationDelivery -.-> note4
    NotificationTracking -.-> note5
    UserPreferences -.-> note6

    classDef note fill:#F5F5F5,stroke:#9E9E9E,stroke-width:1px
```

## Diyagram Açıklaması

### Bildirim Olayları
#### Olay Kaynakları
- **Sistem Olayları**: System events
- **Süreç Olayları**: Process events
- **Kullanıcı Olayları**: User events
- **Entegrasyon Olayları**: Integration events

#### Olay Tipleri
- **Uyarılar**: Alerts
- **Bilgilendirmeler**: Info
- **Aksiyon Gerektiren**: Action required
- **Hatırlatıcılar**: Reminders

### Bildirim İşleme
- **Olay Yönlendirici**: Event router
- **Öncelik Yöneticisi**: Priority manager
- **İçerik Zenginleştirici**: Content enricher
- **Kural Motoru**: Rule engine

### Bildirim Şablonları
- **Şablon Yöneticisi**: Template manager
- **İçerik Oluşturucu**: Content builder
- **Yerelleştirme**: Localization
- **Kişiselleştirme**: Personalization

### Bildirim Dağıtımı
- **E-posta**: Email channel
- **Push Bildirim**: Push notification
- **SMS**: SMS channel
- **Webhook**: Webhook channel

### Bildirim İzleme
- **İletim Durumu**: Delivery status
- **Okunma Durumu**: Read status
- **Aksiyon Durumu**: Action status
- **Analitik**: Analytics

### Kullanıcı Tercihleri
- **Kanal Tercihleri**: Channel preferences
- **Sıklık Tercihleri**: Frequency preferences
- **Tip Tercihleri**: Type preferences
- **Zaman Tercihleri**: Time preferences

### Önemli Özellikler
- Bildirim olayları
- Bildirim işleme
- Bildirim şablonları
- Bildirim dağıtımı
- Bildirim izleme
- Kullanıcı tercihleri 