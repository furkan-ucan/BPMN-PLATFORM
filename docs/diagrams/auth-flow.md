# BPM Platform - Kimlik Doğrulama Akışı

Bu diyagram, BPM Platform'un kimlik doğrulama ve yetkilendirme süreçlerini gösterir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef auth fill:#E8EAF6,stroke:#3F51B5,stroke-width:2px
    classDef validation fill:#E3F2FD,stroke:#2196F3,stroke-width:2px
    classDef security fill:#E8F5E9,stroke:#4CAF50,stroke-width:2px
    classDef session fill:#FFF3E0,stroke:#FF9800,stroke-width:2px
    classDef error fill:#FCE4EC,stroke:#E91E63,stroke-width:2px
    classDef monitoring fill:#F3E5F5,stroke:#9C27B0,stroke-width:2px

    %% Kimlik Doğrulama
    subgraph Authentication["Kimlik Doğrulama"]
        %% Giriş Yöntemleri
        subgraph LoginMethods["Giriş Yöntemleri"]
            LocalLogin[Yerel Giriş]:::auth
            OAuth[OAuth/SSO]:::auth
            LDAP[LDAP/AD]:::auth
            Certificate[Sertifika]:::auth
        end

        %% Doğrulama Kontrolleri
        subgraph ValidationChecks["Doğrulama Kontrolleri"]
            CredentialCheck[Kimlik Kontrolü]:::validation
            MFACheck[2FA/MFA Kontrolü]:::validation
            TokenValidation[Token Doğrulama]:::validation
            SessionCheck[Oturum Kontrolü]:::validation
        end
    end

    %% Güvenlik Kontrolleri
    subgraph SecurityControls["Güvenlik Kontrolleri"]
        %% Güvenlik Mekanizmaları
        BruteForce[Brute Force Koruması]:::security
        RateLimit[Rate Limiting]:::security
        IPControl[IP Kontrolü]:::security
        DeviceCheck[Cihaz Kontrolü]:::security
    end

    %% Oturum Yönetimi
    subgraph SessionManagement["Oturum Yönetimi"]
        %% Oturum İşlemleri
        SessionCreate[Oturum Oluşturma]:::session
        SessionValidate[Oturum Doğrulama]:::session
        SessionRefresh[Oturum Yenileme]:::session
        SessionTerminate[Oturum Sonlandırma]:::session
    end

    %% Hata Yönetimi
    subgraph ErrorHandling["Hata Yönetimi"]
        %% Hata İşlemleri
        AuthError[Kimlik Hatası]:::error
        ValidationError[Doğrulama Hatası]:::error
        SecurityError[Güvenlik İhlali]:::error
        SessionError[Oturum Hatası]:::error
    end

    %% İzleme ve Loglama
    subgraph Monitoring["İzleme ve Loglama"]
        %% İzleme İşlemleri
        AuthLog[Kimlik Logları]:::monitoring
        SecurityLog[Güvenlik Logları]:::monitoring
        ActivityLog[Aktivite Logları]:::monitoring
        AuditLog[Denetim Logları]:::monitoring
    end

    %% Bağlantılar - Kimlik Doğrulama
    LoginMethods --> ValidationChecks
    LocalLogin --> CredentialCheck
    OAuth --> TokenValidation
    LDAP --> CredentialCheck
    Certificate --> TokenValidation

    %% Bağlantılar - Güvenlik
    ValidationChecks --> SecurityControls
    BruteForce --> SessionCreate
    RateLimit --> SessionCreate
    IPControl --> SessionCreate
    DeviceCheck --> SessionCreate

    %% Bağlantılar - Oturum
    SecurityControls --> SessionManagement
    SessionCreate --> SessionValidate
    SessionValidate --> SessionRefresh
    SessionRefresh --> SessionTerminate

    %% Bağlantılar - Hata
    ValidationChecks -->|Hata| ErrorHandling
    SecurityControls -->|İhlal| ErrorHandling
    SessionManagement -->|Hata| ErrorHandling

    %% Bağlantılar - İzleme
    Authentication --> Monitoring
    SecurityControls --> Monitoring
    SessionManagement --> Monitoring
    ErrorHandling --> Monitoring

    %% Geri Bildirim Döngüleri
    AuthLog --> SecurityControls
    SecurityLog --> ValidationChecks
    ActivityLog --> SessionManagement
    AuditLog --> Authentication

    %% Notlar
    note1[Çoklu Faktör Doğrulama]:::note
    note2[Güvenlik Politikaları]:::note
    note3[Oturum Yönetimi]:::note
    note4[Hata İzleme]:::note
    note5[Denetim Kayıtları]:::note

    %% Not Bağlantıları
    ValidationChecks -.-> note1
    SecurityControls -.-> note2
    SessionManagement -.-> note3
    ErrorHandling -.-> note4
    Monitoring -.-> note5

    classDef note fill:#F5F5F5,stroke:#9E9E9E,stroke-width:1px
```

## Diyagram Açıklaması

### Kimlik Doğrulama
#### Giriş Yöntemleri
- **Yerel Giriş**: Kullanıcı/şifre
- **OAuth/SSO**: Tek oturum açma
- **LDAP/AD**: Dizin servisleri
- **Sertifika**: Dijital sertifikalar

#### Doğrulama Kontrolleri
- **Kimlik Kontrolü**: Kullanıcı doğrulama
- **2FA/MFA**: Çoklu faktör
- **Token Doğrulama**: JWT/OAuth token
- **Oturum Kontrolü**: Session kontrol

### Güvenlik Kontrolleri
- **Brute Force Koruması**: Saldırı engelleme
- **Rate Limiting**: İstek sınırlama
- **IP Kontrolü**: IP filtreleme
- **Cihaz Kontrolü**: Cihaz doğrulama

### Oturum Yönetimi
- **Oturum Oluşturma**: Session başlatma
- **Oturum Doğrulama**: Session kontrol
- **Oturum Yenileme**: Token yenileme
- **Oturum Sonlandırma**: Logout işlemi

### Hata Yönetimi
- **Kimlik Hatası**: Auth hataları
- **Doğrulama Hatası**: Validation
- **Güvenlik İhlali**: Security breach
- **Oturum Hatası**: Session error

### İzleme ve Loglama
- **Kimlik Logları**: Auth logları
- **Güvenlik Logları**: Security logs
- **Aktivite Logları**: User activity
- **Denetim Logları**: Audit trail

### Önemli Özellikler
- Çoklu faktör doğrulama
- Güvenlik politikaları
- Oturum yönetimi
- Hata izleme
- Denetim kayıtları