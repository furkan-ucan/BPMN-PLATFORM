# BPM Platform - Süreç Madenciliği Detay Akışı

Bu diyagram, BPM platformunun süreç madenciliği detay akışını ve analiz süreçlerini göstermektedir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef data fill:#f9f,stroke:#333,stroke-width:2px
    classDef mining fill:#bbf,stroke:#333,stroke-width:2px
    classDef analysis fill:#bfb,stroke:#333,stroke-width:2px
    classDef insight fill:#fbb,stroke:#333,stroke-width:2px

    %% Ana Bileşenler
    VeriToplama[Veri Toplama]
    VeriHazırlama[Veri Hazırlama]
    SüreçKeşif[Süreç Keşfi]
    UygunlukKontrol[Uygunluk Kontrol]
    PerformansAnaliz[Performans Analizi]
    VaryantAnaliz[Varyant Analizi]
    İyileştirmeÖneri[İyileştirme Önerileri]
    RaporlamaGörsel[Raporlama ve Görselleştirme]

    %% Alt Bileşenler
    VeriToplama --> |Hazırlık| VeriHazırlama
    VeriHazırlama --> |Keşif| SüreçKeşif
    SüreçKeşif --> |Kontrol| UygunlukKontrol
    UygunlukKontrol --> |Analiz| PerformansAnaliz
    PerformansAnaliz --> |Varyant| VaryantAnaliz
    VaryantAnaliz --> |Öneri| İyileştirmeÖneri
    İyileştirmeÖneri --> |Raporlama| RaporlamaGörsel
    RaporlamaGörsel --> |Güncelleme| VeriToplama

    %% Stil Atamaları
    class VeriToplama,VeriHazırlama data
    class SüreçKeşif,UygunlukKontrol mining
    class PerformansAnaliz,VaryantAnaliz analysis
    class İyileştirmeÖneri,RaporlamaGörsel insight

    %% Notlar
    note1[Otomatik veri toplama]
    note2[AI destekli analiz]
    note3[Gerçek zamanlı izleme]
```

## Önemli Noktalar

1. Veri Toplama
   - Olay günlükleri
   - Süreç verileri
   - Sistem metrikleri
   - Kullanıcı aktiviteleri

2. Veri Hazırlama
   - Veri temizleme
   - Veri dönüşümü
   - Veri zenginleştirme
   - Veri doğrulama

3. Süreç Keşfi
   - Süreç modeli çıkarma
   - Akış analizi
   - İlişki keşfi
   - Örüntü tanıma

4. Uygunluk Kontrol
   - Model karşılaştırma
   - Sapma analizi
   - Kural kontrolü
   - Uyumluluk denetimi

5. Performans Analizi
   - Süreç metrikleri
   - Darboğaz analizi
   - Kaynak kullanımı
   - Zaman analizi

6. Varyant Analizi
   - Varyant keşfi
   - Varyant karşılaştırma
   - Varyant etkisi
   - Varyant optimizasyonu

7. İyileştirme Önerileri
   - Süreç optimizasyonu
   - Kaynak optimizasyonu
   - Maliyet azaltma
   - Verimlilik artırma

8. Raporlama ve Görselleştirme
   - Süreç haritaları
   - Performans göstergeleri
   - Trend analizleri
   - İnteraktif dashboardlar 