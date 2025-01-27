# BPM Platform - Gelişmiş Güvenlik Mimarisi

Bu diyagram, BPM Platform'un geliştirilmiş güvenlik mimarisini ve bileşenler arası güvenlik ilişkilerini gösterir.

```mermaid
flowchart TB
    %% Stil Tanımlamaları
    classDef user fill:#f9f,stroke:#333,stroke-width:2px
    classDef component fill:#lightblue,stroke:#blue,stroke-width:2px
    classDef database fill:#lightgreen,stroke:#green,stroke-width:2px
    classDef package fill:#fff,stroke:#999,stroke-width:1px
    classDef aiEngine fill:#ffe6cc,stroke:#d79b00,stroke-width:2px

    %% Aktörler
    user([Kullanıcı]):::user
    admin([Sistem Yöneticisi]):::user

    %% Dış Güvenlik Katmanı
    subgraph ExternalSecurity[Dış Güvenlik Katmanı]
        direction TB
        subgraph WAF[Web Application Firewall]
            waf_ddos[DDoS Koruması]
            waf_sql[SQL Injection Koruması]
            waf_xss[XSS Koruması]
            waf_rate[Rate Limiting]
            waf_owasp[OWASP Top 10 Koruması]
        end

        subgraph CDN[Content Delivery Network]
            cdn_ssl[SSL/TLS Terminasyonu]
            cdn_ddos[DDoS Mitigasyonu]
            cdn_geo[Coğrafi Erişim Kontrolü]
        end
    end

    %% API Güvenlik Katmanı
    subgraph APISecurity[API Güvenlik Katmanı]
        direction TB
        subgraph Gateway[API Gateway]
            gw_apikey[API Key Doğrulama]
            gw_jwt[JWT Doğrulama]
            gw_rate[Rate Limiting]
            gw_valid[Request Validasyonu]
            gw_conflict[Kimlik Çakışma Yönetimi]
            gw_owasp[OWASP API Security]
        end

        subgraph Auth[Auth Service]
            auth_oauth[OAuth2 Provider]
            auth_token[Token Yönetimi]
            auth_2fa[2FA Yönetimi]
            auth_device[Cihaz Doğrulama]
        end
    end

    %% Kimlik ve Erişim Yönetimi
    subgraph IAM[Kimlik ve Erişim Yönetimi]
        direction TB
        subgraph IDP[Identity Provider]
            idp_sso[SSO Yönetimi]
            idp_user[Kullanıcı Yönetimi]
            idp_role[Rol Yönetimi]
            idp_device[Cihaz Yönetimi]
        end

        subgraph AC[Access Control]
            ac_rbac[RBAC]
            ac_abac[ABAC]
            ac_perm[İzin Yönetimi]
            ac_context[Bağlamsal Erişim]
            ac_behavior[Davranış Tabanlı Erişim]
        end

        idstore[(Identity Store)]
        idstore_user[Kullanıcı Veritabanı]
        idstore_role[Rol Veritabanı]
        idstore_perm[İzin Veritabanı]
        idstore_behavior[Davranış Veritabanı]
    end

    %% Veri Güvenliği
    subgraph DataSecurity[Veri Güvenliği]
        direction TB
        subgraph Encryption[Encryption Service]
            enc_data[Veri Şifreleme]
            enc_key[Anahtar Yönetimi]
            enc_hash[Hash Yönetimi]
            enc_hsm[HSM Entegrasyonu]
        end

        subgraph Vault[HashiCorp Vault]
            vault_secret[Sır Yönetimi]
            vault_cert[Otomatik Sertifika Yönetimi]
            vault_api[API Key Saklama]
            vault_monitor[Erişim İzleme]
        end

        secstore[(Secure Storage)]
        secstore_data[Şifreli Veriler]
        secstore_audit[Audit Logları]
        secstore_backup[Şifreli Yedekler]
    end

    %% Güvenlik İzleme ve AI
    subgraph SecurityMonitoring[Güvenlik İzleme ve AI]
        direction TB
        subgraph SecMon[Security Monitor]
            secmon_threat[Tehdit Tespiti]
            secmon_anomaly[Anomali Tespiti]
            secmon_events[Güvenlik Olayları]
            secmon_sla[SLA İzleme]
        end

        subgraph AIEngine[AI Security Engine]
            ai_behavior[Davranış Analizi]
            ai_predict[Tehdit Tahmini]
            ai_anomaly[Anomali Öğrenme]
            ai_pattern[Saldırı Patern Analizi]
        end
        class AIEngine aiEngine

        subgraph Audit[Audit Service]
            audit_log[Audit Logging]
            audit_analysis[Log Analizi]
            audit_report[Raporlama]
            audit_visual[Görselleştirme]
        end

        subgraph Alert[Alert Manager]
            alert_sla[SLA Alarmları]
            alert_threat[Tehdit Alarmları]
            alert_anomaly[Anomali Alarmları]
            alert_policy[Politika İhlalleri]
        end

        seclogs[(Security Logs)]
        seclogs_sec[Güvenlik Logları]
        seclogs_audit[Audit Trail]
        seclogs_ml[ML Veri Seti]
    end

    %% İlişkiler
    user --> CDN
    CDN --> WAF
    WAF --> Gateway

    Gateway --> Auth
    Gateway --> IDP
    Auth --> IDP
    IDP --> idstore

    Gateway --> AC
    AC --> idstore
    AC --> AIEngine

    Auth --> Vault
    Encryption --> Vault
    Vault --> secstore

    SecMon --> seclogs
    Audit --> seclogs
    AIEngine --> seclogs

    AIEngine --> SecMon
    AIEngine --> Alert
    SecMon --> Alert

    admin --> SecMon
    admin --> Audit
    admin --> Alert

    %% Güvenlik Akışları
    user -.->|HTTPS| CDN
    CDN -.->|SSL/TLS| WAF
    WAF -.->|Filtered Traffic| Gateway
    Gateway -.->|Auth Request| Auth
    Auth -.->|Validate| IDP
    IDP -.->|Query| idstore

    %% AI Akışları
    AIEngine -.->|Davranış Analizi| AC
    AIEngine -.->|Tehdit Tahmini| SecMon
    AIEngine -.->|Anomali Tespiti| Alert

    %% Notlar
    note_waf[Gelişmiş tehdit koruması ve<br/>OWASP uyumluluğu]
    note_auth[Çok faktörlü kimlik doğrulama<br/>ve cihaz yönetimi]
    note_vault[Otomatik sertifika yönetimi<br/>ve erişim izleme]
    note_ai[Yapay zeka destekli<br/>güvenlik analizi]
    note_audit[Görselleştirme ve<br/>detaylı analiz]

    WAF --- note_waf
    Auth --- note_auth
    Vault --- note_vault
    AIEngine --- note_ai
    Audit --- note_audit
```

## Diyagram Açıklaması

### Aktörler
- **Kullanıcı**: Sistem kullanıcıları
- **Sistem Yöneticisi**: Güvenlik yönetimi ve izlemeden sorumlu admin

### Güvenlik Katmanları

#### Dış Güvenlik Katmanı
- **WAF**: Gelişmiş web uygulama güvenlik duvarı
  - DDoS koruması
  - SQL Injection koruması
  - XSS koruması
  - Rate limiting
  - OWASP Top 10 koruması
- **CDN**: Gelişmiş içerik dağıtım ağı
  - SSL/TLS terminasyonu
  - DDoS mitigasyonu
  - Coğrafi erişim kontrolü

#### API Güvenlik Katmanı
- **API Gateway**: Gelişmiş API güvenlik kontrolü
  - API Key doğrulama
  - JWT doğrulama
  - Rate limiting
  - Request validasyonu
  - Kimlik çakışma yönetimi
  - OWASP API Security uyumluluğu
- **Auth Service**: Gelişmiş kimlik doğrulama servisi
  - OAuth2 provider
  - Token yönetimi
  - 2FA yönetimi
  - Cihaz doğrulama

#### Kimlik ve Erişim Yönetimi
- **Identity Provider**: Gelişmiş kimlik sağlayıcı
  - SSO yönetimi
  - Kullanıcı yönetimi
  - Rol yönetimi
  - Cihaz yönetimi
- **Access Control**: Gelişmiş erişim kontrolü
  - RBAC (Role-Based Access Control)
  - ABAC (Attribute-Based Access Control)
  - İzin yönetimi
  - Bağlamsal erişim
  - Davranış tabanlı erişim

#### Veri Güvenliği
- **Encryption Service**: Gelişmiş şifreleme servisi
  - Veri şifreleme
  - Anahtar yönetimi
  - Hash yönetimi
  - HSM entegrasyonu
- **Vault**: Gelişmiş güvenli veri depolama
  - Sır yönetimi
  - Otomatik sertifika yönetimi
  - API Key saklama
  - Erişim izleme

#### Güvenlik İzleme ve AI
- **Security Monitor**: Gelişmiş güvenlik izleme
  - Tehdit tespiti
  - Anomali tespiti
  - Güvenlik olayları
  - SLA izleme
- **AI Security Engine**: Yapay zeka güvenlik motoru
  - Davranış analizi
  - Tehdit tahmini
  - Anomali öğrenme
  - Saldırı patern analizi
- **Audit Service**: Gelişmiş denetim servisi
  - Audit logging
  - Log analizi
  - Raporlama
  - Görselleştirme
- **Alert Manager**: Alarm yönetimi
  - SLA alarmları
  - Tehdit alarmları
  - Anomali alarmları
  - Politika ihlalleri

### Güvenlik Akışları
1. Kullanıcı HTTPS üzerinden CDN'e bağlanır
2. CDN SSL/TLS terminasyonu yapar
3. WAF OWASP uyumlu filtreleme yapar
4. API Gateway kimlik doğrulama ve çakışma kontrolü yapar
5. Auth Service çok faktörlü yetkilendirme kontrolü yapar
6. AI Engine davranış analizi ve tehdit tahmini yapar
7. Tüm işlemler görselleştirmeli güvenlik loglarına kaydedilir 