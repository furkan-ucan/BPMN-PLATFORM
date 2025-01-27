%% Güvenlik Yönetimi Akış Diyagramı
%% Bu diyagram güvenlik yönetim süreçlerini ve bileşenlerini gösterir

graph TB
    %% Stil tanımlamaları
    classDef process fill:#E8EAF6,stroke:#3F51B5,stroke-width:2px
    classDef decision fill:#FFF9C4,stroke:#FFA000,stroke-width:2px
    classDef parallel fill:#E8F5E9,stroke:#4CAF50,stroke-width:2px
    classDef note fill:#F5F5F5,stroke:#9E9E9E,stroke-width:1px
    classDef header fill:#1A237E,stroke:#000,color:#fff

    %% Ana başlık
    Header[Güvenlik Yönetimi Akış Sistemi]:::header

    %% Ana düğümler
    GuvenlikBaslat[Güvenlik Yönetimi Başlatma]:::process
    GuvenlikTipi{Güvenlik Tipi Seçimi}:::decision
    
    subgraph GuvenlikKontrolleri[Önleyici Güvenlik Kontrolleri]
        direction TB
        KimlikDogrulama[Kimlik Doğrulama]:::parallel
        Yetkilendirme[Yetkilendirme]:::parallel
        VeriSifreleme[Veri Şifreleme]:::parallel
        GuvenliIletisim[Güvenli İletişim]:::parallel
    end

    subgraph TehditTespiti[Tehdit Tespit Mekanizmaları]
        direction TB
        AnomaliTespit[Anomali Tespiti]:::parallel
        SaldiriTespit[Saldırı Tespiti]:::parallel
        ZaafiyetTarama[Zaafiyet Tarama]:::parallel
        LogAnaliz[Log Analizi]:::parallel
    end

    subgraph OnlemAlma[Düzeltici Önlemler]
        direction TB
        OtomatikEngelleme[Otomatik Engelleme]:::parallel
        IzolasyonOnlem[İzolasyon]:::parallel
        YedeklemeDonusum[Yedekleme/Dönüşüm]:::parallel
    end

    %% Süreç adımları
    RiskDegerlendirme{Risk Değerlendirme}:::decision
    AlarmOlustur[Alarm Oluştur]:::process
    RaporOlustur[Güvenlik Raporu]:::process
    AksiyonPlan[Aksiyon Planı]:::process
    GuvenlikGuncelle[Güvenlik Güncelleme]:::process
    OlayKayit[Olay Kaydı]:::process

    %% Detaylı notlar
    note1[2FA/MFA Kimlik Doğrulama]:::note
    note2[SIEM Entegrasyonu]:::note
    note3[IDS/IPS Sistemleri]:::note
    note4[Zero Trust Mimarisi]:::note
    note5[Denetim Kayıtları]:::note

    %% Bağlantılar ve akış
    Header --> GuvenlikBaslat
    GuvenlikBaslat --> GuvenlikTipi
    GuvenlikTipi -->|Önleyici Kontroller| GuvenlikKontrolleri
    GuvenlikTipi -->|Tehdit Tespiti| TehditTespiti
    GuvenlikTipi -->|Düzeltici Önlemler| OnlemAlma
    
    GuvenlikKontrolleri --> RiskDegerlendirme
    TehditTespiti --> RiskDegerlendirme
    OnlemAlma --> RiskDegerlendirme
    
    RiskDegerlendirme -->|Yüksek Risk| AlarmOlustur
    AlarmOlustur --> AksiyonPlan
    AksiyonPlan --> GuvenlikGuncelle
    RiskDegerlendirme -->|Normal Risk| RaporOlustur
    RaporOlustur --> OlayKayit
    GuvenlikGuncelle --> OlayKayit

    %% Not bağlantıları ve açıklamalar
    GuvenlikKontrolleri -.->|Kullanılan Yöntem| note1
    TehditTespiti -.->|Entegrasyon| note2
    OnlemAlma -.->|Koruma Sistemleri| note3
    GuvenlikGuncelle -.->|Güvenlik Modeli| note4
    OlayKayit -.->|Kayıt Sistemi| note5