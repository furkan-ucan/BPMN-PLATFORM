# BPM Platform - Arama ve İndeksleme Akışı

Bu diyagram, BPM Platform'un arama ve indeksleme süreçlerini gösterir.

```mermaid
graph TB
    %% Stil Tanımlamaları
    classDef indexing fill:#E8EAF6,stroke:#3F51B5,stroke-width:2px
    classDef search fill:#E3F2FD,stroke:#2196F3,stroke-width:2px
    classDef storage fill:#E8F5E9,stroke:#4CAF50,stroke-width:2px
    classDef query fill:#FFF3E0,stroke:#FF9800,stroke-width:2px
    classDef result fill:#FCE4EC,stroke:#E91E63,stroke-width:2px
    classDef optimization fill:#F3E5F5,stroke:#9C27B0,stroke-width:2px

    %% İndeksleme Süreci
    subgraph IndexingProcess["İndeksleme Süreci"]
        %% Veri Toplama
        subgraph DataCollection["Veri Toplama"]
            DocumentCrawler[Doküman Tarayıcı]:::indexing
            DataExtractor[Veri Çıkarıcı]:::indexing
            MetadataCollector[Metadata Toplayıcı]:::indexing
            ChangeDetector[Değişiklik Algılayıcı]:::indexing
        end

        %% İndeks İşleme
        subgraph IndexProcessing["İndeks İşleme"]
            TextAnalyzer[Metin Analizi]:::indexing
            TokenGenerator[Token Üretici]:::indexing
            StopwordFilter[Stopword Filtresi]:::indexing
            Stemming[Kök Bulma]:::indexing
        end
    end

    %% Arama Motoru
    subgraph SearchEngine["Arama Motoru"]
        %% Arama Bileşenleri
        subgraph SearchComponents["Arama Bileşenleri"]
            QueryParser[Sorgu Ayrıştırıcı]:::search
            QueryExpander[Sorgu Genişletici]:::search
            Searcher[Arayıcı]:::search
            Ranker[Sıralayıcı]:::search
        end

        %% Arama Özellikleri
        subgraph SearchFeatures["Arama Özellikleri"]
            FullText[Tam Metin]:::search
            Faceted[Faset Arama]:::search
            Fuzzy[Bulanık Arama]:::search
            Semantic[Anlamsal Arama]:::search
        end
    end

    %% İndeks Depolama
    subgraph IndexStorage["İndeks Depolama"]
        %% Depolama Bileşenleri
        InvertedIndex[Ters İndeks]:::storage
        DocumentStore[Doküman Deposu]:::storage
        CacheStore[Önbellek Deposu]:::storage
        MetadataStore[Metadata Deposu]:::storage
    end

    %% Sorgu İşleme
    subgraph QueryProcessing["Sorgu İşleme"]
        %% Sorgu İşlemleri
        QueryAnalysis[Sorgu Analizi]:::query
        QueryOptimization[Sorgu Optimizasyonu]:::query
        QueryExecution[Sorgu Yürütme]:::query
        QueryCaching[Sorgu Önbellekleme]:::query
    end

    %% Sonuç İşleme
    subgraph ResultProcessing["Sonuç İşleme"]
        %% Sonuç İşlemleri
        ResultRanking[Sonuç Sıralama]:::result
        ResultFiltering[Sonuç Filtreleme]:::result
        ResultAggregation[Sonuç Birleştirme]:::result
        ResultFormatting[Sonuç Formatlama]:::result
    end

    %% Optimizasyon
    subgraph SearchOptimization["Arama Optimizasyonu"]
        %% Optimizasyon İşlemleri
        IndexOptimizer[İndeks Optimize Edici]:::optimization
        CacheManager[Önbellek Yöneticisi]:::optimization
        PerformanceMonitor[Performans İzleyici]:::optimization
        ResourceManager[Kaynak Yöneticisi]:::optimization
    end

    %% Bağlantılar - İndeksleme
    DataCollection --> IndexProcessing
    DocumentCrawler --> TextAnalyzer
    DataExtractor --> TokenGenerator
    MetadataCollector --> StopwordFilter
    ChangeDetector --> Stemming

    %% Bağlantılar - Arama
    IndexProcessing --> SearchComponents
    TextAnalyzer --> QueryParser
    TokenGenerator --> QueryExpander
    StopwordFilter --> Searcher
    Stemming --> Ranker

    %% Bağlantılar - Depolama
    SearchComponents --> IndexStorage
    QueryParser --> InvertedIndex
    QueryExpander --> DocumentStore
    Searcher --> CacheStore
    Ranker --> MetadataStore

    %% Bağlantılar - Sorgu
    IndexStorage --> QueryProcessing
    InvertedIndex --> QueryAnalysis
    DocumentStore --> QueryOptimization
    CacheStore --> QueryExecution
    MetadataStore --> QueryCaching

    %% Bağlantılar - Sonuç
    QueryProcessing --> ResultProcessing
    QueryAnalysis --> ResultRanking
    QueryOptimization --> ResultFiltering
    QueryExecution --> ResultAggregation
    QueryCaching --> ResultFormatting

    %% Bağlantılar - Optimizasyon
    ResultProcessing --> SearchOptimization
    ResultRanking --> IndexOptimizer
    ResultFiltering --> CacheManager
    ResultAggregation --> PerformanceMonitor
    ResultFormatting --> ResourceManager

    %% Geri Bildirim Döngüleri
    SearchOptimization --> IndexingProcess
    IndexOptimizer --> DataCollection
    CacheManager --> SearchEngine
    PerformanceMonitor --> QueryProcessing
    ResourceManager --> ResultProcessing

    %% Notlar
    note1[İndeksleme Süreci]:::note
    note2[Arama Motoru]:::note
    note3[İndeks Depolama]:::note
    note4[Sorgu İşleme]:::note
    note5[Sonuç İşleme]:::note
    note6[Optimizasyon]:::note

    %% Not Bağlantıları
    IndexingProcess -.-> note1
    SearchEngine -.-> note2
    IndexStorage -.-> note3
    QueryProcessing -.-> note4
    ResultProcessing -.-> note5
    SearchOptimization -.-> note6

    classDef note fill:#F5F5F5,stroke:#9E9E9E,stroke-width:1px
```

## Diyagram Açıklaması

### İndeksleme Süreci
#### Veri Toplama
- **Doküman Tarayıcı**: Document crawler
- **Veri Çıkarıcı**: Data extractor
- **Metadata Toplayıcı**: Metadata collector
- **Değişiklik Algılayıcı**: Change detector

#### İndeks İşleme
- **Metin Analizi**: Text analysis
- **Token Üretici**: Token generator
- **Stopword Filtresi**: Stopword filter
- **Kök Bulma**: Stemming

### Arama Motoru
#### Arama Bileşenleri
- **Sorgu Ayrıştırıcı**: Query parser
- **Sorgu Genişletici**: Query expander
- **Arayıcı**: Searcher
- **Sıralayıcı**: Ranker

#### Arama Özellikleri
- **Tam Metin**: Full text
- **Faset Arama**: Faceted search
- **Bulanık Arama**: Fuzzy search
- **Anlamsal Arama**: Semantic search

### İndeks Depolama
- **Ters İndeks**: Inverted index
- **Doküman Deposu**: Document store
- **Önbellek Deposu**: Cache store
- **Metadata Deposu**: Metadata store

### Sorgu İşleme
- **Sorgu Analizi**: Query analysis
- **Sorgu Optimizasyonu**: Query optimization
- **Sorgu Yürütme**: Query execution
- **Sorgu Önbellekleme**: Query caching

### Sonuç İşleme
- **Sonuç Sıralama**: Result ranking
- **Sonuç Filtreleme**: Result filtering
- **Sonuç Birleştirme**: Result aggregation
- **Sonuç Formatlama**: Result formatting

### Arama Optimizasyonu
- **İndeks Optimize Edici**: Index optimizer
- **Önbellek Yöneticisi**: Cache manager
- **Performans İzleyici**: Performance monitor
- **Kaynak Yöneticisi**: Resource manager

### Önemli Özellikler
- İndeksleme süreci
- Arama motoru
- İndeks depolama
- Sorgu işleme
- Sonuç işleme
- Arama optimizasyonu 