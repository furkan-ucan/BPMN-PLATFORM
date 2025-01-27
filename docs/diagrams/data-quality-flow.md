# BPM Platform - Veri Kalitesi Kontrol Akışı

Bu diyagram, BPM platformundaki veri kalitesi kontrol ve doğrulama süreçlerini göstermektedir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef process fill:#f9f,stroke:#333,stroke-width:2px
    classDef validation fill:#bbf,stroke:#333,stroke-width:2px
    classDef report fill:#bfb,stroke:#333,stroke-width:2px
    classDef action fill:#fbb,stroke:#333,stroke-width:2px

    %% Ana Bileşenler
    VeriGirişi[Veri Girişi]
    KaliteKontrol[Kalite Kontrol]
    DoğrulamaMotoru[Doğrulama Motoru]
    KuralYönetimi[Kural Yönetimi]
    HataYönetimi[Hata Yönetimi]
    RaporlamaAnaliz[Raporlama ve Analiz]
    İyileştirmeAksiyonları[İyileştirme Aksiyonları]
    PerformansMetrikleri[Performans Metrikleri]

    %% Alt Bileşenler
    VeriGirişi --> |Kontrol| KaliteKontrol
    KaliteKontrol --> |Doğrula| DoğrulamaMotoru
    DoğrulamaMotoru --> |Uygula| KuralYönetimi
    DoğrulamaMotoru --> |Tespit| HataYönetimi
    HataYönetimi --> |Raporla| RaporlamaAnaliz
    RaporlamaAnaliz --> |Öner| İyileştirmeAksiyonları
    İyileştirmeAksiyonları --> |İzle| PerformansMetrikleri
    PerformansMetrikleri --> |Güncelle| KuralYönetimi

    %% Stil Atamaları
    class VeriGirişi,KaliteKontrol process
    class DoğrulamaMotoru,KuralYönetimi validation
    class RaporlamaAnaliz,PerformansMetrikleri report
    class HataYönetimi,İyileştirmeAksiyonları action

    %% Notlar
    note1[Otomatik veri doğrulama]
    note2[Kalite metrikleri izleme]
    note3[Sürekli iyileştirme]
```

## Önemli Noktalar

1. Veri Kalite Kontrolleri
   - Format doğrulama
   - Tutarlılık kontrolü
   - Bütünlük kontrolü
   - İş kuralları kontrolü

2. Doğrulama Kuralları
   - Veri tipleri
   - Değer aralıkları
   - Zorunlu alanlar
   - İlişkisel bütünlük

3. Hata Yönetimi
   - Hata tespiti
   - Hata sınıflandırma
   - Düzeltme önerileri
   - İstisna yönetimi

4. Kalite Metrikleri
   - Doğruluk oranı
   - Tutarlılık skoru
   - Hata oranları
   - İyileştirme trendleri