# BPM Platform - Sistem Sağlığı İzleme ve Alarm

Bu diyagram, BPM platformunun sistem sağlığı izleme ve alarm süreçlerini göstermektedir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef monitor fill:#f9f,stroke:#333,stroke-width:2px
    classDef alert fill:#bbf,stroke:#333,stroke-width:2px
    classDef action fill:#bfb,stroke:#333,stroke-width:2px
    classDef report fill:#fbb,stroke:#333,stroke-width:2px

    %% Ana Bileşenler
    Sistemİzleme[Sistem İzleme]
    AlarmYönetimi[Alarm Yönetimi]
    OtomatikAksiyon[Otomatik Aksiyon]
    RaporlamaAnaliz[Raporlama ve Analiz]
    SağlıkKontrol[Sağlık Kontrol]
    MetrikToplama[Metrik Toplama]
    AlarmKoşulları[Alarm Koşulları]
    BildirimYönetimi[Bildirim Yönetimi]

    %% Alt Bileşenler
    Sistemİzleme --> |Metrik| MetrikToplama
    MetrikToplama --> |Kontrol| SağlıkKontrol
    SağlıkKontrol --> |Koşul| AlarmKoşulları
    AlarmKoşulları --> |Alarm| AlarmYönetimi
    AlarmYönetimi --> |Aksiyon| OtomatikAksiyon
    OtomatikAksiyon --> |Bildirim| BildirimYönetimi
    BildirimYönetimi --> |Rapor| RaporlamaAnaliz
    RaporlamaAnaliz --> |İzleme| Sistemİzleme

    %% Stil Atamaları
    class Sistemİzleme,MetrikToplama monitor
    class AlarmYönetimi,AlarmKoşulları alert
    class OtomatikAksiyon,BildirimYönetimi action
    class RaporlamaAnaliz,SağlıkKontrol report

    %% Notlar
    note1[7/24 izleme]
    note2[Akıllı alarm yönetimi]
    note3[Otomatik düzeltme]
```

## Önemli Noktalar

1. Sistem İzleme
   - Kaynak kullanımı
   - Performans metrikleri
   - Servis durumları
   - Sistem logları

2. Metrik Toplama
   - CPU kullanımı
   - Bellek kullanımı
   - Disk kullanımı
   - Ağ trafiği

3. Sağlık Kontrol
   - Servis sağlığı
   - Veritabanı sağlığı
   - API sağlığı
   - Bağlantı sağlığı

4. Alarm Koşulları
   - Eşik değerleri
   - Alarm kuralları
   - Öncelik seviyeleri
   - Koşul grupları

5. Alarm Yönetimi
   - Alarm tetikleme
   - Alarm filtreleme
   - Alarm birleştirme
   - Alarm doğrulama

6. Otomatik Aksiyon
   - Otomatik düzeltme
   - Kaynak yönetimi
   - Servis yeniden başlatma
   - Yük dengeleme

7. Bildirim Yönetimi
   - Bildirim kanalları
   - Bildirim şablonları
   - Bildirim öncelikleri
   - Bildirim grupları

8. Raporlama ve Analiz
   - Sağlık raporları
   - Performans raporları
   - Trend analizleri
   - İyileştirme önerileri 