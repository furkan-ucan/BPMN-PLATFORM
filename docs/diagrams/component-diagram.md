# BPM Platform - Bileşen Diyagramı

Bu diyagram, BPM Platform'un ana bileşenlerini ve aralarındaki ilişkileri gösterir.

```mermaid
graph TB
    %% Arayüzler ve API UI
    webUI[("Web UI")]
    mobileUI[("Mobile UI")]
    restAPI[("REST API")]
    graphqlAPI[("GraphQL API")]
    eventBus[("Event Bus")]
    messageQueue[("Message Queue")]
    apiDocs[("API Documentation")]

    %% Frontend Katmanı
    subgraph Frontend["Frontend Layer"]
        subgraph WebApp["Web Application"]
            angularApp["Angular SPA"]
            stateManager["State Management"]
            uiComponents["UI Components"]
            uxModule["UX Module"]
            screenModules["Screen Modules"]
        end
        
        subgraph MobileApp["Mobile Application"]
            reactApp["React Native App"]
            mobileState["Mobile State"]
            nativeUI["Native UI"]
            mobileUX["Mobile UX"]
            offlineSync["Offline Sync"]
        end

        subgraph UXOptimization["UX Optimization"]
            analytics["Usage Analytics"]
            perfMetrics["Performance Metrics"]
            errorTracking["Error Tracking"]
        end
    end

    %% API Gateway Katmanı
    subgraph APIGateway["API Gateway Layer"]
        subgraph Gateway["API Gateway"]
            routeManager["Route Manager"]
            rateLimiter["Rate Limiter"]
            requestValidator["Request Validator"]
            responseCache["Response Cache"]
            ddosProtection["DDoS Protection"]
            fallbackMechanism["Fallback Mechanism"]
        end
        
        subgraph Auth["Auth Service"]
            jwtManager["JWT Manager"]
            oauthHandler["OAuth Handler"]
            permissionManager["Permission Manager"]
            apiKeyManager["API Key Manager"]
        end

        subgraph SecurityPolicies["Security Policies"]
            dataPrivacy["Data Privacy"]
            encryption["Encryption"]
            audit["Audit Logs"]
        end
    end

    %% Core Services Katmanı
    subgraph CoreServices["Core Services Layer"]
        subgraph ProcessEngine["Process Engine"]
            bpmnEngine["BPMN Engine"]
            processManager["Process Manager"]
            taskHandler["Task Handler"]
            processOptimizer["Process Optimizer"]
        end
        
        subgraph FormEngine["Form Engine"]
            formBuilder["Form Builder"]
            formRenderer["Form Renderer"]
            validationEngine["Validation Engine"]
            formVersioning["Form Versioning"]
        end
        
        subgraph RuleEngine["Rule Engine"]
            ruleExecutor["Rule Executor"]
            decisionEngine["Decision Engine"]
            businessRules["Business Rules"]
            ruleOptimizer["Rule Optimizer"]
        end

        subgraph DataFlow["Data Flow Management"]
            dataRouter["Data Router"]
            dataValidator["Data Validator"]
            dataTransformer["Data Transformer"]
        end
    end

    %% Support Services Katmanı
    subgraph SupportServices["Support Services Layer"]
        subgraph DocumentService["Document Service"]
            documentManager["Document Manager"]
            versionControl["Version Control"]
            storageHandler["Storage Handler"]
            documentIndexer["Document Indexer"]
        end
        
        subgraph NotificationService["Notification Service"]
            emailHandler["Email Handler"]
            pushNotifier["Push Notifier"]
            smsGateway["SMS Gateway"]
            notificationRouter["Notification Router"]
            templateEngine["Template Engine"]
        end
        
        subgraph IntegrationService["Integration Service"]
            apiAdapters["API Adapters"]
            dataTransformer["Data Transformer"]
            syncManager["Sync Manager"]
            errorHandler["Error Handler"]
        end

        subgraph ExternalSystems["External Systems"]
            erpConnector["ERP Connector"]
            crmConnector["CRM Connector"]
            legacyConnector["Legacy Connector"]
        end
    end

    %% Monitoring Katmanı
    subgraph Monitoring["Monitoring Layer"]
        subgraph MonitoringService["Monitoring Service"]
            metricsCollector["Metrics Collector"]
            alertManager["Alert Manager"]
            dashboardGenerator["Dashboard Generator"]
            slaMonitor["SLA Monitor"]
        end
        
        subgraph LoggingService["Logging Service"]
            logAggregator["Log Aggregator"]
            logParser["Log Parser"]
            logAnalyzer["Log Analyzer"]
            logArchiver["Log Archiver"]
        end
        
        subgraph TracingService["Tracing Service"]
            traceCollector["Trace Collector"]
            traceAnalyzer["Trace Analyzer"]
            performanceMonitor["Performance Monitor"]
            bottleneckDetector["Bottleneck Detector"]
        end

        subgraph Analytics["Analytics Engine"]
            userMetrics["User Metrics"]
            processMetrics["Process Metrics"]
            systemMetrics["System Metrics"]
        end
    end

    %% AI Services Katmanı
    subgraph AIServices["AI Services Layer"]
        subgraph MLService["ML Service"]
            modelTrainer["Model Trainer"]
            predictionEngine["Prediction Engine"]
            featureExtractor["Feature Extractor"]
            modelOptimizer["Model Optimizer"]
        end
        
        subgraph NLPService["NLP Service"]
            textAnalyzer["Text Analyzer"]
            languageProcessor["Language Processor"]
            sentimentAnalyzer["Sentiment Analyzer"]
            intentRecognizer["Intent Recognizer"]
        end

        subgraph AIOptimization["AI Optimization"]
            processPredictor["Process Predictor"]
            taskAssigner["Task Assigner"]
            anomalyDetector["Anomaly Detector"]
        end
    end

    %% İlişkiler ve Veri Akışı
    webUI --- WebApp
    mobileUI --- MobileApp
    apiDocs --- Gateway

    WebApp -.-> restAPI
    MobileApp -.-> restAPI
    WebApp -.-> graphqlAPI
    MobileApp -.-> graphqlAPI

    restAPI --- Gateway
    graphqlAPI --- Gateway

    Gateway --> Auth
    Gateway --> ProcessEngine
    Gateway --> FormEngine
    Gateway --> RuleEngine

    ProcessEngine --> eventBus
    NotificationService --> messageQueue
    IntegrationService --> eventBus

    ProcessEngine --> FormEngine
    ProcessEngine --> RuleEngine
    FormEngine --> RuleEngine

    DocumentService --> storageHandler
    NotificationService --> emailHandler
    IntegrationService --> apiAdapters

    MonitoringService --> metricsCollector
    LoggingService --> logAggregator
    TracingService --> traceCollector

    MLService --> modelTrainer
    NLPService --> textAnalyzer

    IntegrationService --> ExternalSystems
    ExternalSystems --> dataTransformer

    %% Stil Tanımlamaları
    classDef interface fill:#90EE90,stroke:#006400,stroke-width:2px
    classDef component fill:#ADD8E6,stroke:#00008B,stroke-width:2px
    classDef service fill:#FFB6C1,stroke:#8B0000,stroke-width:2px
    classDef optimization fill:#FFD700,stroke:#B8860B,stroke-width:2px

    class webUI,mobileUI,restAPI,graphqlAPI,eventBus,messageQueue,apiDocs interface
    class WebApp,MobileApp,Gateway,Auth,ProcessEngine,FormEngine,RuleEngine component
    class DocumentService,NotificationService,IntegrationService,MonitoringService,LoggingService,TracingService,MLService,NLPService service
    class UXOptimization,processOptimizer,ruleOptimizer,AIOptimization optimization

```

## Bileşen Açıklamaları ve Kullanım Senaryoları

### Frontend Layer
- **Web Application**: Angular tabanlı web uygulaması
  - Angular SPA: Single Page Application
  - State Management: Redux pattern ile durum yönetimi
  - UI Components: Yeniden kullanılabilir UI bileşenleri
  - UX Module: Kullanıcı deneyimi optimizasyonu
  - Screen Modules: 
    - Process Designer
    - Task Management
    - Form Builder
    - Analytics Dashboard

- **Mobile Application**: React Native tabanlı mobil uygulama
  - React Native App: Cross-platform mobil uygulama
  - Mobile State: Mobil-specific durum yönetimi
  - Native UI: Platform-specific UI bileşenleri
  - Mobile UX: Mobil kullanıcı deneyimi
  - Offline Sync: Çevrimdışı çalışma desteği

### API Gateway Layer
- **API Gateway**: API yönetimi ve güvenlik
  - Route Manager: API rotalarının yönetimi
  - Rate Limiter: 
    ```json
    {
      "maxRequests": 100,
      "window": "1 minute",
      "byIP": true
    }
    ```
  - DDoS Protection: Distributed Denial of Service koruması
  - Fallback Mechanism: Hata durumunda yedek sistemler

- **Security Policies**: Güvenlik politikaları
  - Data Privacy: KVKK ve GDPR uyumluluğu
  - Encryption: End-to-end şifreleme
  - Audit: Güvenlik denetim logları

### Core Services Layer
- **Process Engine**: BPMN tabanlı süreç yönetimi
  - BPMN Engine: Süreç motoru
  - Process Manager: Süreç yaşam döngüsü yönetimi
  - Task Handler: Görev yönetimi
  - Process Optimizer: Süreç optimizasyonu

- **Form Engine**: Dinamik form yönetimi
  - Form Builder: Sürükle-bırak form tasarımı
  - Form Renderer: Dinamik form görüntüleme
  - Validation Engine: Form doğrulama
  - Form Versioning: Form versiyon kontrolü

### Support Services Layer
- **Notification Service**: Bildirim yönetimi
  ```json
  {
    "notification": {
      "types": ["email", "push", "sms"],
      "templates": {
        "taskAssignment": {
          "priority": "high",
          "channels": ["email", "push"]
        },
        "deadlineWarning": {
          "priority": "critical",
          "channels": ["sms", "push"]
        }
      }
    }
  }
  ```

- **Integration Service**: Sistem entegrasyonları
  ```json
  {
    "integration": {
      "erp": {
        "type": "SAP",
        "sync": "bidirectional",
        "interval": "realtime"
      },
      "crm": {
        "type": "Salesforce",
        "sync": "pull",
        "interval": "15min"
      }
    }
  }
  ```

### Monitoring Layer
- **Monitoring Service**: Sistem izleme
  ```json
  {
    "metrics": {
      "performance": ["responseTime", "throughput"],
      "business": ["processCompletionRate", "taskDuration"],
      "system": ["cpuUsage", "memoryUsage"]
    },
    "alerts": {
      "thresholds": {
        "responseTime": "500ms",
        "errorRate": "1%"
      }
    }
  }
  ```

### AI Services Layer
- **ML Service**: Makine öğrenmesi servisleri
  ```json
  {
    "mlService": {
      "predictions": {
        "processCompletion": {
          "algorithm": "randomForest",
          "accuracy": "85%"
        },
        "taskAssignment": {
          "algorithm": "neuralNetwork",
          "accuracy": "90%"
        }
      }
    }
  }
  ```

- **NLP Service**: Doğal dil işleme servisleri
  ```json
  {
    "nlpService": {
      "textAnalysis": {
        "languages": ["tr", "en"],
        "features": ["sentiment", "intent", "entity"]
      }
    }
  }
  ```

## API Dokümantasyonu
```json
{
  "apiDocs": {
    "swagger": "/api/docs/swagger",
    "postman": "/api/docs/postman",
    "graphql": "/api/docs/graphql",
    "features": {
      "interactive": true,
      "examples": true,
      "authentication": true
    }
  }
}
``` 