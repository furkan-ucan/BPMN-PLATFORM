# API Önbellek Stratejisi

```mermaid
flowchart TD
    subgraph Cache Strategy
        A[API İsteği] --> B{Önbellekte var mı?}
        B -->|Evet| C[Önbellekten Yanıt]
        B -->|Hayır| D[Backend'den Veri Al]
        D --> E[Önbelleğe Kaydet]
        E --> F[Yanıt Dön]
        C --> F
    end

    subgraph Cache Components
        G[Redis Cache]
        H[CDN Cache]
        I[Browser Cache]
    end

    subgraph Cache Policies
        J[TTL Yönetimi]
        K[Invalidation Rules]
        L[Cache Keys]
    end
```

## Önbellek Katmanları

1. **CDN Önbelleği**
   - Statik içerik
   - API yanıtları
   - TTL: 1-24 saat

2. **Uygulama Önbelleği (Redis)**
   - Sık kullanılan veriler
   - Oturum bilgileri
   - TTL: 5-60 dakika

3. **Tarayıcı Önbelleği**
   - UI bileşenleri
   - API yanıtları
   - TTL: Kaynak bazlı

## Önbellek Stratejileri

- Write-Through Cache
- Cache-Aside
- Read-Through Cache
- Refresh-Ahead Cache

## Önbellek Yönetimi

- Otomatik TTL yönetimi
- Manuel invalidasyon
- Pattern bazlı temizleme
- Versiyonlama