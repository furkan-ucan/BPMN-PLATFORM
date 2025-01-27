# BPM Platform - Veri Arşivleme ve Temizleme Akışı

Bu diyagram, BPM platformundaki veri arşivleme ve temizleme süreçlerini göstermektedir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef process fill:#f9f,stroke:#333,stroke-width:2px
    classDef storage fill:#bbf,stroke:#333,stroke-width:2px
    classDef policy fill:#bfb,stroke:#333,stroke-width:2px
    classDef monitor fill:#fbb,stroke:#333,stroke-width:2px

    %% Ana Bileşenler
    VeriKaynakları[Veri Kaynakları]
    ArşivPolitikası[Arşiv Politikası]
    TemizlemePolitikası[Temizleme Politikası]
    VeriAnalizi[Veri Analizi]
    ArşivYönetimi[Arşiv Yönetimi]
    TemizlemeYönetimi[Temizleme Yönetimi]
    ArşivDepolama[Arşiv Depolama]
    PerformansİZleme[Performans İzleme]

    %% Alt Bileşenler
    VeriKaynakları --> |Analiz| VeriAnalizi
    VeriAnalizi --> |Politika Kontrolü| ArşivPolitikası
    VeriAnalizi --> |Politika Kontrolü| TemizlemePolitikası
    ArşivPolitikası --> |Uygula| ArşivYönetimi
    TemizlemePolitikası --> |Uygula| TemizlemeYönetimi
    ArşivYönetimi --> |Depola| ArşivDepolama
    TemizlemeYönetimi --> |İzle| PerformansİZleme
    ArşivDepolama --> |İzle| PerformansİZleme

    %% Stil Atamaları
    class VeriKaynakları,VeriAnalizi process
    class ArşivDepolama storage
    class ArşivPolitikası,TemizlemePolitikası policy
    class PerformansİZleme monitor

    %% Notlar
    note1[Otomatik arşivleme ve temizleme]
    note2[Veri sıkıştırma ve şifreleme]
    note3[Performans metrikleri]
```

## Önemli Noktalar

1. Veri Kaynakları
   - İşlem verileri
   - Süreç verileri
   - Sistem logları
   - Kullanıcı verileri

2. Arşiv Politikası
   - Yaş bazlı arşivleme
   - Önem bazlı arşivleme
   - Yasal gereklilikler
   - Saklama süreleri

3. Temizleme Politikası
   - Otomatik temizleme kuralları
   - Manuel temizleme prosedürleri
   - İstisna yönetimi
   - Geri dönüşüm politikaları

4. Performans İzleme
   - Arşivleme metrikleri
   - Temizleme metrikleri
   - Depolama kullanımı
   - Sistem performansı