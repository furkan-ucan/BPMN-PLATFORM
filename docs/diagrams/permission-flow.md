# BPM Platform - Yetkilendirme Akışı

Bu diyagram, BPM Platform'un yetkilendirme ve erişim kontrol süreçlerini gösterir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef role fill:#E8EAF6,stroke:#3F51B5,stroke-width:2px
    classDef permission fill:#E3F2FD,stroke:#2196F3,stroke-width:2px
    classDef access fill:#E8F5E9,stroke:#4CAF50,stroke-width:2px
    classDef policy fill:#FFF3E0,stroke:#FF9800,stroke-width:2px
    classDef audit fill:#FCE4EC,stroke:#E91E63,stroke-width:2px
    classDef cache fill:#F3E5F5,stroke:#9C27B0,stroke-width:2px

    %% Rol Yönetimi
    subgraph RoleManagement["Rol Yönetimi"]
        %% Rol Tanımları
        subgraph RoleDefinitions["Rol Tanımları"]
            SystemRoles[Sistem Rolleri]:::role
            CustomRoles[Özel Roller]:::role
            DynamicRoles[Dinamik Roller]:::role
            TemporaryRoles[Geçici Roller]:::role
        end

        %% Rol Hiyerarşisi
        subgraph RoleHierarchy["Rol Hiyerarşisi"]
            SuperAdmin[Süper Admin]:::role
            Admin[Admin]:::role
            Manager[Yönetici]:::role
            User[Kullanıcı]:::role
        end
    end

    %% İzin Yönetimi
    subgraph PermissionManagement["İzin Yönetimi"]
        %% İzin Tipleri
        subgraph PermissionTypes["İzin Tipleri"]
            CRUDPermissions[CRUD İzinleri]:::permission
            ProcessPermissions[Süreç İzinleri]:::permission
            DataPermissions[Veri İzinleri]:::permission
            APIPermissions[API İzinleri]:::permission
        end

        %% İzin Kapsamları
        subgraph PermissionScopes["İzin Kapsamları"]
            GlobalScope[Global Kapsam]:::permission
            GroupScope[Grup Kapsamı]:::permission
            ProjectScope[Proje Kapsamı]:::permission
            ResourceScope[Kaynak Kapsamı]:::permission
        end
    end

    %% Erişim Kontrol
    subgraph AccessControl["Erişim Kontrol"]
        %% Kontrol Mekanizmaları
        RBAC[Rol Tabanlı Kontrol]:::access
        ABAC[Öznitelik Tabanlı Kontrol]:::access
        DAC[İsteğe Bağlı Kontrol]:::access
        MAC[Zorunlu Kontrol]:::access
    end

    %% Politika Yönetimi
    subgraph PolicyManagement["Politika Yönetimi"]
        %% Politika İşlemleri
        PolicyDefinition[Politika Tanımlama]:::policy
        PolicyValidation[Politika Doğrulama]:::policy
        PolicyEnforcement[Politika Uygulama]:::policy
        PolicyAudit[Politika Denetimi]:::policy
    end

    %% Denetim ve İzleme
    subgraph AuditMonitoring["Denetim ve İzleme"]
        %% Denetim İşlemleri
        AccessLogs[Erişim Logları]:::audit
        PermissionLogs[İzin Logları]:::audit
        PolicyLogs[Politika Logları]:::audit
        ChangeLogs[Değişiklik Logları]:::audit
    end

    %% Önbellek Yönetimi
    subgraph CacheManagement["Önbellek Yönetimi"]
        %% Önbellek İşlemleri
        RoleCache[Rol Önbelleği]:::cache
        PermissionCache[İzin Önbelleği]:::cache
        PolicyCache[Politika Önbelleği]:::cache
        TokenCache[Token Önbelleği]:::cache
    end

    %% Bağlantılar - Rol
    RoleDefinitions --> RoleHierarchy
    SystemRoles --> RBAC
    CustomRoles --> ABAC
    DynamicRoles --> DAC
    TemporaryRoles --> MAC

    %% Bağlantılar - İzin
    PermissionTypes --> PermissionScopes
    CRUDPermissions --> PolicyDefinition
    ProcessPermissions --> PolicyValidation
    DataPermissions --> PolicyEnforcement
    APIPermissions --> PolicyAudit

    %% Bağlantılar - Erişim
    AccessControl --> PolicyManagement
    RBAC --> PolicyDefinition
    ABAC --> PolicyValidation
    DAC --> PolicyEnforcement
    MAC --> PolicyAudit

    %% Bağlantılar - Politika
    PolicyManagement --> AuditMonitoring
    PolicyDefinition --> AccessLogs
    PolicyValidation --> PermissionLogs
    PolicyEnforcement --> PolicyLogs
    PolicyAudit --> ChangeLogs

    %% Bağlantılar - Önbellek
    RoleManagement --> CacheManagement
    PermissionManagement --> CacheManagement
    AccessControl --> CacheManagement
    PolicyManagement --> CacheManagement

    %% Geri Bildirim Döngüleri
    AccessLogs --> RoleManagement
    PermissionLogs --> PermissionManagement
    PolicyLogs --> PolicyManagement
    ChangeLogs --> AccessControl

    %% Notlar
    note1[Rol Bazlı Erişim]:::note
    note2[İzin Yönetimi]:::note
    note3[Politika Kontrolü]:::note
    note4[Denetim İzleme]:::note
    note5[Önbellek Yönetimi]:::note

    %% Not Bağlantıları
    RoleManagement -.-> note1
    PermissionManagement -.-> note2
    PolicyManagement -.-> note3
    AuditMonitoring -.-> note4
    CacheManagement -.-> note5

    classDef note fill:#F5F5F5,stroke:#9E9E9E,stroke-width:1px
```

## Diyagram Açıklaması

### Rol Yönetimi
#### Rol Tanımları
- **Sistem Rolleri**: Öntanımlı roller
- **Özel Roller**: Kullanıcı tanımlı
- **Dinamik Roller**: Koşula bağlı
- **Geçici Roller**: Süreli roller

#### Rol Hiyerarşisi
- **Süper Admin**: Tam yetki
- **Admin**: Yönetim yetkileri
- **Yönetici**: Süreç yönetimi
- **Kullanıcı**: Temel yetkiler

### İzin Yönetimi
#### İzin Tipleri
- **CRUD İzinleri**: Temel işlemler
- **Süreç İzinleri**: İş süreçleri
- **Veri İzinleri**: Veri erişimi
- **API İzinleri**: API kullanımı

#### İzin Kapsamları
- **Global Kapsam**: Sistem geneli
- **Grup Kapsamı**: Grup bazlı
- **Proje Kapsamı**: Proje bazlı
- **Kaynak Kapsamı**: Kaynak bazlı

### Erişim Kontrol
- **Rol Tabanlı**: RBAC modeli
- **Öznitelik Tabanlı**: ABAC modeli
- **İsteğe Bağlı**: DAC modeli
- **Zorunlu**: MAC modeli

### Politika Yönetimi
- **Politika Tanımlama**: Kural tanımı
- **Politika Doğrulama**: Kural kontrolü
- **Politika Uygulama**: Kural yürütme
- **Politika Denetimi**: Kural denetimi

### Denetim ve İzleme
- **Erişim Logları**: Access logs
- **İzin Logları**: Permission logs
- **Politika Logları**: Policy logs
- **Değişiklik Logları**: Change logs

### Önbellek Yönetimi
- **Rol Önbelleği**: Role cache
- **İzin Önbelleği**: Permission cache
- **Politika Önbelleği**: Policy cache
- **Token Önbelleği**: Token cache

### Önemli Özellikler
- Rol bazlı erişim
- İzin yönetimi
- Politika kontrolü
- Denetim izleme
- Önbellek yönetimi