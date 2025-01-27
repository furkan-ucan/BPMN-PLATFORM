# BPM Platform - Yedekleme ve Geri Yükleme Akışı

Bu diyagram, BPM Platform'un veri yedekleme ve geri yükleme süreçlerini gösterir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef scheduler fill:#E8EAF6,stroke:#3F51B5,stroke-width:2px
    classDef backup fill:#E3F2FD,stroke:#2196F3,stroke-width:2px
    classDef storage fill:#E8F5E9,stroke:#4CAF50,stroke-width:2px
    classDef monitor fill:#FFF3E0,stroke:#FF9800,stroke-width:2px
    classDef restore fill:#FCE4EC,stroke:#E91E63,stroke-width:2px
    classDef validation fill:#F3E5F5,stroke:#9C27B0,stroke-width:2px

    %% Zamanlama ve Tetikleme
    subgraph Scheduling["Zamanlama ve Tetikleme"]
        BackupScheduler[Yedekleme Zamanlayıcı]:::scheduler
        ManualTrigger[Manuel Tetikleme]:::scheduler
        EventTrigger[Olay Tetikleme]:::scheduler
        PreMigrationBackup[Migrasyon Öncesi Yedek]:::scheduler
    end

    %% Yedekleme İşlemleri
    subgraph BackupOps["Yedekleme İşlemleri"]
        %% Veri Kaynakları
        subgraph DataSources["Veri Kaynakları"]
            ProcessDB[Süreç Veritabanı]:::backup
            DocumentStore[Doküman Deposu]:::backup
            ConfigData[Konfigürasyon Verileri]:::backup
            AuditLogs[Denetim Logları]:::backup
        end

        %% Yedekleme Tipleri
        subgraph BackupTypes["Yedekleme Tipleri"]
            FullBackup[Tam Yedekleme]:::backup
            IncrementalBackup[Artımlı Yedekleme]:::backup
            DifferentialBackup[Fark Yedekleme]:::backup
            SnapshotBackup[Anlık Görüntü]:::backup
        end
    end

    %% Depolama Yönetimi
    subgraph Storage["Depolama Yönetimi"]
        %% Depolama Lokasyonları
        LocalStorage[Yerel Depolama]:::storage
        CloudStorage[Bulut Depolama]:::storage
        OffsiteBackup[Uzak Yedekleme]:::storage
        
        %% Yedek Yönetimi
        RetentionManager[Saklama Yöneticisi]:::storage
        CompressionManager[Sıkıştırma Yöneticisi]:::storage
        EncryptionManager[Şifreleme Yöneticisi]:::storage
    end

    %% İzleme ve Doğrulama
    subgraph Monitoring["İzleme ve Doğrulama"]
        BackupMonitor[Yedek İzleyici]:::monitor
        IntegrityChecker[Bütünlük Kontrolü]:::monitor
        ValidationTests[Doğrulama Testleri]:::monitor
        AlertManager[Uyarı Yöneticisi]:::monitor
    end

    %% Geri Yükleme İşlemleri
    subgraph RestoreOps["Geri Yükleme İşlemleri"]
        %% Geri Yükleme Tipleri
        PointInTimeRestore[Zamana Göre Geri Yükleme]:::restore
        FullSystemRestore[Tam Sistem Geri Yükleme]:::restore
        SelectiveRestore[Seçmeli Geri Yükleme]:::restore
        
        %% Doğrulama
        DataValidation[Veri Doğrulama]:::validation
        ConsistencyCheck[Tutarlılık Kontrolü]:::validation
        IntegrityVerification[Bütünlük Doğrulama]:::validation
    end

    %% Bağlantılar - Zamanlama
    Scheduling --> BackupOps
    BackupScheduler --> FullBackup
    ManualTrigger --> BackupTypes
    EventTrigger --> BackupTypes
    PreMigrationBackup --> FullBackup

    %% Bağlantılar - Yedekleme
    DataSources --> BackupTypes
    BackupTypes --> Storage
    
    %% Bağlantılar - Depolama
    FullBackup --> |Encrypt| EncryptionManager
    EncryptionManager --> |Compress| CompressionManager
    CompressionManager --> Storage
    Storage --> RetentionManager

    %% Bağlantılar - İzleme
    BackupOps --> BackupMonitor
    Storage --> IntegrityChecker
    IntegrityChecker --> ValidationTests
    ValidationTests --> AlertManager

    %% Bağlantılar - Geri Yükleme
    Storage --> RestoreOps
    RestoreOps --> DataValidation
    DataValidation --> ConsistencyCheck
    ConsistencyCheck --> IntegrityVerification
    IntegrityVerification --> DataSources

    %% Geri Bildirim Döngüleri
    AlertManager --> BackupScheduler
    ValidationTests --> Storage
    IntegrityVerification --> AlertManager

    %% Notlar
    note1[Automated Scheduling]:::note
    note2[Data Integrity]:::note
    note3[Security & Encryption]:::note
    note4[Validation Process]:::note
    note5[Disaster Recovery]:::note

    %% Not Bağlantıları
    Scheduling -.-> note1
    IntegrityChecker -.-> note2
    EncryptionManager -.-> note3
    ValidationTests -.-> note4
    RestoreOps -.-> note5

    classDef note fill:#F5F5F5,stroke:#9E9E9E,stroke-width:1px
```

## Diyagram Açıklaması

### Zamanlama ve Tetikleme
- **Yedekleme Zamanlayıcı**: Otomatik yedekleme planları
- **Manuel Tetikleme**: Kullanıcı tarafından başlatılan yedeklemeler
- **Olay Tetikleme**: Sistem olaylarına bağlı yedeklemeler
- **Migrasyon Öncesi Yedek**: Sistem güncellemeleri öncesi yedekleme

### Yedekleme İşlemleri
#### Veri Kaynakları
- **Süreç Veritabanı**: BPMN süreç verileri
- **Doküman Deposu**: Form ve doküman verileri
- **Konfigürasyon Verileri**: Sistem ayarları
- **Denetim Logları**: Audit trail verileri

#### Yedekleme Tipleri
- **Tam Yedekleme**: Tüm sistem verisi
- **Artımlı Yedekleme**: Son yedekten sonraki değişiklikler
- **Fark Yedekleme**: İlk tam yedekten sonraki tüm değişiklikler
- **Anlık Görüntü**: Sistem durumunun anlık kopyası

### Depolama Yönetimi
- **Yerel Depolama**: On-premise yedekleme
- **Bulut Depolama**: Cloud backup
- **Uzak Yedekleme**: Off-site backup
- **Saklama Yöneticisi**: Retention policies
- **Sıkıştırma Yöneticisi**: Backup compression
- **Şifreleme Yöneticisi**: Encryption/decryption

### İzleme ve Doğrulama
- **Yedek İzleyici**: Backup monitoring
- **Bütünlük Kontrolü**: Data integrity checks
- **Doğrulama Testleri**: Validation procedures
- **Uyarı Yöneticisi**: Alert management

### Geri Yükleme İşlemleri
#### Geri Yükleme Tipleri
- **Zamana Göre Geri Yükleme**: Point-in-time recovery
- **Tam Sistem Geri Yükleme**: Full system restore
- **Seçmeli Geri Yükleme**: Selective data restore

#### Doğrulama
- **Veri Doğrulama**: Data validation
- **Tutarlılık Kontrolü**: Consistency checks
- **Bütünlük Doğrulama**: Integrity verification

### Önemli Özellikler
- Otomatik zamanlama
- Veri bütünlüğü
- Güvenlik ve şifreleme
- Doğrulama süreci
- Felaket kurtarma
``` 