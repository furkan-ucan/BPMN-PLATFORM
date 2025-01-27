# BPM Platform API Dokümantasyonu

## İçindekiler
1. [Genel Bilgiler](#genel-bilgiler)
   - [API Versiyonları](#api-versiyonları)
   - [Ortamlar](#ortamlar)
   - [İstek Formatı](#i̇stek-formatı)

2. [Güvenlik](#güvenlik)
   - [Kimlik Doğrulama](#kimlik-doğrulama)
   - [API Anahtarları](#api-anahtarları)
   - [Rate Limiting](#rate-limiting)
   - [IP Kısıtlamaları](#ip-kısıtlamaları)

3. [API Endpoints](#api-endpoints)
   - [Kullanıcı Yönetimi](#kullanıcı-yönetimi)
   - [Süreç Yönetimi](#süreç-yönetimi)
   - [Form Yönetimi](#form-yönetimi)
   - [Görev Yönetimi](#görev-yönetimi)

4. [API Endpoint Detayları](#api-endpoint-detayları)
   - [Endpoint Parametreleri](#endpoint-parametreleri)
   - [Query Parametreleri](#query-parametreleri)
   - [Path Parametreleri](#path-parametreleri)
   - [Request Body Örnekleri](#request-body-örnekleri)

5. [Gelişmiş Güvenlik](#gelişmiş-güvenlik)
   - [CORS Politikaları](#cors-politikaları)
   - [SSL/TLS Gereksinimleri](#ssltls-gereksinimleri)
   - [Token Yönetimi](#token-yönetimi)

6. [WebSocket API](#websocket-api)
   - [Bağlantı](#bağlantı)
   - [Events](#events)
   - [Bildirimler](#bildirimler)

7. [Batch İşlemler](#batch-i̇şlemler)
   - [Toplu Süreç İşlemleri](#toplu-süreç-i̇şlemleri)
   - [Toplu Görev İşlemleri](#toplu-görev-i̇şlemleri)

8. [Webhook Entegrasyonu](#webhook-entegrasyonu)
   - [Webhook Yapılandırma](#webhook-yapılandırma)
   - [Event Formatları](#event-formatları)

9. [Performans Optimizasyonu](#performans-optimizasyonu)
   - [Caching](#caching)
   - [Pagination](#pagination)
   - [Rate Limiting](#rate-limiting-1)
   - [Bulk İşlem En İyi Pratikleri](#bulk-i̇şlem-en-i̇yi-pratikleri)
   - [Rate Limiting Stratejileri](#rate-limiting-stratejileri)

10. [SDK Örnekleri](#sdk-örnekleri)
    - [Python SDK](#python-sdk)
    - [Node.js SDK](#nodejs-sdk)

11. [Gelişmiş Hata Yönetimi](#gelişmiş-hata-yönetimi)
    - [Detaylı Hata Kodları](#detaylı-hata-kodları)
    - [Hata İşleme Örnekleri](#hata-i̇şleme-örnekleri)
    - [Troubleshooting Rehberi](#troubleshooting-rehberi)

12. [Test ve Geliştirme](#test-ve-geliştirme)
    - [Test Ortamı](#test-ortamı)
    - [Postman Koleksiyonu](#postman-koleksiyonu)
    - [Swagger Dokümantasyonu](#swagger-dokümantasyonu)

13. [Performans Testleri](#performans-testleri)
    - [K6 Test Senaryoları](#k6-test-senaryoları)
    - [JMeter Test Planı](#jmeter-test-planı)
    - [APM Entegrasyonu (New Relic)](#apm-entegrasyonu-new-relic)
    - [Datadog APM Entegrasyonu](#datadog-apm-entegrasyonu)

14. [Raporlama ve Analitik](#raporlama-ve-analitik)
    - [Özel Rapor Şablonları](#özel-rapor-şablonları)
    - [KPI ve Performans Ölçümleri](#kpi-ve-performans-ölçümleri)
    - [Görselleştirme Entegrasyonları](#görselleştirme-entegrasyonları)
    - [Özel Analitik Entegrasyonları](#özel-analitik-entegrasyonları)

15. [API Güvenlik Testleri ve Penetrasyon Testleri](#api-güvenlik-testleri-ve-penetrasyon-testleri)
    - [OWASP Güvenlik Testleri](#owasp-güvenlik-testleri)
    - [SQL Injection ve XSS Önlemleri](#sql-injection-ve-xss-önlemleri)
    - [Güvenlik Açığı Tarama Senaryoları](#güvenlik-açığı-tarama-senaryoları)

16. [Felaket Kurtarma ve İş Sürekliliği](#felaket-kurtarma-ve-i̇ş-sürekliliği)
    - [Yedekleme ve Geri Yükleme Prosedürleri](#yedekleme-ve-geri-yükleme-prosedürleri)
    - [Failover Senaryoları](#failover-senaryoları)
    - [Veri Merkezi Geçiş Planları](#veri-merkezi-geçiş-planları)

17. [API Dokümantasyon Versiyonlama](#api-dokümantasyon-versiyonlama)
    - [Dokümantasyon Sürüm Geçmişi](#dokümantasyon-sürüm-geçmişi)
    - [Migration Rehberleri](#migration-rehberleri)

18. [Entegrasyon Senaryoları ve Use-Case'ler](#entegrasyon-senaryoları-ve-use-caseler)
    - [Yaygın Kullanım Senaryoları](#yaygın-kullanım-senaryoları)
    - [Sektör Bazlı Örnekler](#sektör-bazlı-örnekler)
    - [Best Practice Önerileri](#best-practice-önerileri)

19. [Veri Modelleri ve Şemalar](#veri-modelleri-ve-şemalar)
    - [Süreç Modeli](#süreç-modeli)
    - [Görev Modeli](#görev-modeli)

20. [İzleme ve Loglama](#i̇zleme-ve-loglama)
    - [Audit Log](#audit-log)
    - [Metrik Toplama](#metrik-toplama)

21. [Veri Yedekleme ve Geri Yükleme](#veri-yedekleme-ve-geri-yükleme)
    - [Yedekleme](#yedekleme)
    - [Geri Yükleme](#geri-yükleme)

22. [Çoklu Dil Desteği](#çoklu-dil-desteği)
    - [Dil Ayarları](#dil-ayarları)
    - [Çeviri Yönetimi](#çeviri-yönetimi)

23. [API Sürüm Yönetimi](#api-sürüm-yönetimi)
    - [Sürüm Geçişleri](#sürüm-geçişleri)
    - [Breaking Changes](#breaking-changes)

24. [Güvenlik Denetimleri](#güvenlik-denetimleri)
    - [Güvenlik Logları](#güvenlik-logları)
    - [Güvenlik Politikaları](#güvenlik-politikaları)

25. [API Kullanım İstatistikleri](#api-kullanım-i̇statistikleri)
    - [Kullanım Metrikleri](#kullanım-metrikleri)
    - [Raporlama](#raporlama)

## Genel Bilgiler

### API Versiyonları
- Mevcut versiyon: v1
- Semantic versiyonlama (MAJOR.MINOR.PATCH)
- URL tabanlı versiyonlama: `/v1`, `/v2`

### Ortamlar
```plaintext
Production: https://api.bpm-platform.com/v1
Staging: https://api-staging.bpm-platform.com/v1
Development: https://api-dev.bpm-platform.com/v1
```

### İstek Formatı
```http
Content-Type: application/json
Accept: application/json
```

## Güvenlik

### Kimlik Doğrulama
```http
Authorization: Bearer <jwt_token>
```

#### Token Alma
```http
POST /auth/login
{
  "email": "string",
  "password": "string"
}
```

#### Token Yenileme
```http
POST /auth/refresh
Authorization: Bearer <refresh_token>
```

### API Anahtarları
```http
X-Api-Key: <api_key>
X-Timestamp: <unix_timestamp>
X-Signature: <request_signature>
```

### Rate Limiting
```plaintext
Anonim: 100 istek/saat
Authentike: 1000 istek/saat
Bulk: 10 istek/dakika
```

### IP Kısıtlamaları
- Whitelist IP yapılandırması
- IP bazlı rate limiting
- Otomatik IP bloklama

## API Endpoints

### Kullanıcı Yönetimi

#### Kullanıcı Oluşturma
```http
POST /users
{
  "name": "string",
  "email": "string",
  "password": "string",
  "role": "string"
}
```

#### Kullanıcı Listeleme
```http
GET /users?page=1&limit=10&role=admin&status=active
```

### Süreç Yönetimi

#### Süreç Başlatma
```http
POST /processes
{
  "template_id": "string",
  "variables": {
    "key": "value"
  }
}
```

#### Süreç Listeleme
```http
GET /processes?page=1&limit=10&status=active
```

### Form Yönetimi

#### Form Oluşturma
```http
POST /forms
{
  "name": "string",
  "fields": [
    {
      "type": "string",
      "name": "string",
      "required": boolean
    }
  ]
}
```

#### Form Listeleme
```http
GET /forms?page=1&limit=10&process_id=123
```

## WebSocket API

### Bağlantı
```javascript
const ws = new WebSocket('wss://api.bpm-platform.com/v1/ws');
ws.onopen = () => {
  ws.send(JSON.stringify({
    type: 'auth',
    token: '<jwt_token>'
  }));
};
```

### Events
```javascript
// Süreç Güncellemeleri
{
  "type": "process_update",
  "data": {
    "process_id": "string",
    "status": "string"
  }
}

// Görev Bildirimleri
{
  "type": "task_notification",
  "data": {
    "task_id": "string",
    "action": "string"
  }
}
```

## Batch İşlemler

### Toplu Süreç İşlemleri
```http
POST /processes/batch
{
  "processes": [
    {
      "template_id": "string",
      "variables": {}
    }
  ]
}
```

### Toplu Görev İşlemleri
```http
POST /tasks/batch
{
  "tasks": [
    {
      "process_id": "string",
      "assignee": "string"
    }
  ]
}
```

## Webhook Entegrasyonu

### Webhook Yapılandırma
```http
POST /webhooks
{
  "url": "string",
  "events": ["process.completed", "task.assigned"],
  "secret": "string"
}
```

### Event Formatları
```javascript
{
  "event": "string",
  "timestamp": "string",
  "data": {},
  "signature": "string"
}
```

## Performans Optimizasyonu

### Caching
```http
Cache-Control: private, max-age=3600
ETag: "33a64df551425fcc55e4d42a148795d9f25f89d4"
```

### Pagination
```javascript
{
  "items": [],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 100
  }
}
```

### Rate Limiting
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

## SDK Örnekleri

### Python SDK
```python
from bpm_platform import BPMClient

client = BPMClient(
    api_key="your_api_key",
    environment="production"
)

# Süreç başlatma
process = client.processes.create(
    template_id="purchase_request",
    variables={
        "department": "IT",
        "amount": 5000
    }
)

# Görev atama
task = client.tasks.assign(
    task_id=process.tasks[0].id,
    assignee="john.doe@company.com"
)
```

### Node.js SDK
```javascript
const { BPMClient } = require('bpm-platform-sdk');

const client = new BPMClient({
    apiKey: 'your_api_key',
    environment: 'production'
});

// Süreç başlatma
async function startProcess() {
    const process = await client.processes.create({
        templateId: 'purchase_request',
        variables: {
            department: 'IT',
            amount: 5000
        }
    });
    
    // Görev atama
    const task = await client.tasks.assign({
        taskId: process.tasks[0].id,
        assignee: 'john.doe@company.com'
    });
}
```

## Gelişmiş Hata Yönetimi

### Detaylı Hata Kodları
| Kod | Alt Kod | Açıklama | Çözüm Önerisi |
|-----|----------|-----------|----------------|
| 400 | INVALID_INPUT | Geçersiz girdi formatı | Girdi formatını kontrol edin |
| 400 | MISSING_FIELD | Zorunlu alan eksik | Eksik alanları tamamlayın |
| 401 | TOKEN_EXPIRED | Token süresi dolmuş | Token'ı yenileyin |
| 401 | INVALID_TOKEN | Geçersiz token | Yeniden giriş yapın |
| 403 | INSUFFICIENT_PERMISSIONS | Yetersiz yetki | Yetki yükseltme talep edin |
| 404 | RESOURCE_NOT_FOUND | Kaynak bulunamadı | Kaynak ID'sini kontrol edin |
| 409 | DUPLICATE_ENTRY | Mükerrer kayıt | Benzersiz değer kullanın |
| 429 | RATE_LIMIT_EXCEEDED | Limit aşıldı | Bekleme süresi sonrası tekrar deneyin |
| 500 | INTERNAL_ERROR | Sunucu hatası | Destek ekibi ile iletişime geçin |
| 503 | SERVICE_UNAVAILABLE | Servis kullanılamıyor | Sistem durumunu kontrol edin |

### Hata İşleme Örnekleri
```javascript
try {
    const process = await client.processes.create({
        templateId: 'invalid_template'
    });
} catch (error) {
    if (error.code === 'RESOURCE_NOT_FOUND') {
        console.error('Template bulunamadı:', error.details);
        // Template listesini getir
        const templates = await client.templates.list();
    } else if (error.code === 'INVALID_INPUT') {
        console.error('Geçersiz girdi:', error.validation_errors);
        // Validasyon hatalarını düzelt
    } else {
        console.error('Beklenmeyen hata:', error);
        // Hatayı loglama sistemine kaydet
    }
}
```

### Troubleshooting Rehberi
1. **Bağlantı Sorunları**
   - DNS çözümleme kontrolü
   - Proxy yapılandırması
   - SSL sertifika doğrulama

2. **Performans Sorunları**
   - Bağlantı havuzu optimizasyonu
   - Önbellek kullanımı
   - Batch işlem stratejileri

3. **Güvenlik Sorunları**
   - Token yönetimi
   - IP whitelist yapılandırması
   - Rate limit optimizasyonu

4. **Veri Tutarlılığı**
   - İdempotency key kullanımı
   - Retry stratejileri
   - Deadlock yönetimi

## Performans Testleri

### K6 Test Senaryoları
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '2m', target: 100 }, // Yavaş yük artışı
    { duration: '5m', target: 100 }, // Sabit yük
    { duration: '2m', target: 200 }, // Yük artışı
    { duration: '5m', target: 200 }, // Yüksek yük
    { duration: '2m', target: 0 },   // Aşamalı azalma
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // %95 isteklerin 500ms altında olmalı
    http_req_failed: ['rate<0.01'],   // %1'den az hata oranı
  },
};

const BASE_URL = 'https://api.bpm-platform.com/v1';

// Süreç Başlatma Testi
export default function() {
  const payload = JSON.stringify({
    template_id: 'purchase_request',
    variables: {
      department: 'IT',
      amount: 5000
    }
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${__ENV.API_TOKEN}`,
    },
  };

  let response = http.post(`${BASE_URL}/processes`, payload, params);
  
  check(response, {
    'status is 201': (r) => r.status === 201,
    'response time OK': (r) => r.timings.duration < 500,
  });

  sleep(1);
}

### JMeter Test Planı
```xml
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2" properties="5.0">
  <hashTree>
    <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="BPM Platform Test Plan">
      <elementProp name="TestPlan.user_defined_variables" elementType="Arguments">
        <collectionProp name="Arguments.arguments">
          <elementProp name="BASE_URL" elementType="Argument">
            <stringProp name="Argument.name">BASE_URL</stringProp>
            <stringProp name="Argument.value">https://api.bpm-platform.com/v1</stringProp>
          </elementProp>
        </collectionProp>
      </elementProp>
      <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Process Creation Test">
        <stringProp name="ThreadGroup.num_threads">100</stringProp>
        <stringProp name="ThreadGroup.ramp_time">60</stringProp>
        <boolProp name="ThreadGroup.same_user_on_next_iteration">false</boolProp>
      </ThreadGroup>
    </hashTree>
  </hashTree>
</jmeterTestPlan>
```

### APM Entegrasyonu (New Relic)
```javascript
// New Relic APM Konfigürasyonu
const newrelic = require('newrelic');

// API endpoint performans izleme
app.use((req, res, next) => {
  newrelic.setTransactionName(`${req.method} ${req.path}`);
  newrelic.addCustomAttribute('client_id', req.headers['x-client-id']);
  next();
});

// Custom metrik gönderme
newrelic.recordMetric('Custom/Process/CompletionTime', processExecutionTime);
```

### Datadog APM Entegrasyonu
```javascript
const tracer = require('dd-trace').init();

// Trace özelleştirme
tracer.use('express', {
  hooks: {
    request: (span, req, res) => {
      span.setTag('client.id', req.headers['x-client-id']);
    }
  }
});

// Custom metrik gönderme
const StatsD = require('hot-shots');
const dogstatsd = new StatsD();

dogstatsd.gauge('bpm.process.active_count', activeProcessCount);
dogstatsd.histogram('bpm.task.completion_time', taskCompletionTime);
```

## Raporlama ve Analitik

### Özel Rapor Şablonları
```http
POST /reports/custom
{
  "template": "process_performance",
  "parameters": {
    "start_date": "2024-01-01",
    "end_date": "2024-01-31",
    "department": "IT",
    "process_type": "purchase_request",
    "format": "pdf",
    "layout": {
      "orientation": "landscape",
      "page_size": "A4",
      "sections": [
        {
          "type": "chart",
          "chart_type": "line",
          "data_source": "completion_times",
          "title": "Süreç Tamamlanma Süreleri"
        },
        {
          "type": "table",
          "data_source": "task_summary",
          "columns": ["task_name", "avg_duration", "completion_rate"]
        }
      ]
    }
  }
}
```

### KPI ve Performans Ölçümleri
```http
GET /analytics/kpi
{
  "metrics": {
    "process_efficiency": {
      "total_completed": 150,
      "avg_completion_time": "2.5 days",
      "sla_compliance": "95%",
      "bottlenecks": [
        {
          "task": "manager_approval",
          "avg_wait_time": "1.2 days"
        }
      ]
    },
    "resource_utilization": {
      "active_users": 45,
      "task_distribution": {
        "manager_approval": "30%",
        "finance_review": "25%",
        "final_approval": "45%"
      }
    },
    "quality_metrics": {
      "error_rate": "2%",
      "rework_rate": "5%",
      "first_time_right": "93%"
    }
  },
  "trends": {
    "monthly_completion_rate": [
      {
        "month": "2024-01",
        "rate": "94%"
      }
    ],
    "task_completion_times": [
      {
        "task": "manager_approval",
        "trend": [-10, -5, 0, 5, -8]
      }
    ]
  }
}
```

### Görselleştirme Entegrasyonları

#### Grafana Dashboard Konfigürasyonu
```json
{
  "dashboard": {
    "id": null,
    "title": "BPM Platform Metrikleri",
    "tags": ["bpm", "processes", "performance"],
    "timezone": "browser",
    "panels": [
      {
        "title": "Süreç Tamamlanma Süreleri",
        "type": "graph",
        "datasource": "Prometheus",
        "targets": [
          {
            "expr": "rate(process_completion_time_seconds_sum[5m])",
            "legendFormat": "{{process_type}}"
          }
        ]
      },
      {
        "title": "Aktif Süreç Sayısı",
        "type": "stat",
        "datasource": "Prometheus",
        "targets": [
          {
            "expr": "sum(active_processes)"
          }
        ]
      }
    ]
  }
}
```

#### Power BI Rapor Entegrasyonu
```javascript
// Power BI REST API Entegrasyonu
async function updatePowerBIReport() {
  const dataset = {
    process_metrics: await getProcessMetrics(),
    task_metrics: await getTaskMetrics(),
    user_metrics: await getUserMetrics()
  };

  const powerbi = new PowerBIClient(credentials);
  await powerbi.datasets.refreshDataset(workspaceId, datasetId);
}

// Metrik toplama fonksiyonları
async function getProcessMetrics() {
  return {
    completion_times: await db.aggregate([
      {
        $group: {
          _id: "$process_type",
          avg_time: { $avg: "$completion_time" }
        }
      }
    ]),
    volume_by_type: await db.aggregate([
      {
        $group: {
          _id: "$process_type",
          count: { $sum: 1 }
        }
      }
    ])
  };
}
```

### Özel Analitik Entegrasyonları

#### Google Analytics 4 Entegrasyonu
```javascript
// GA4 Event gönderimi
const { measurementId } = require('./config');
const { postToGA4 } = require('./analytics');

async function trackProcessEvent(processData) {
  await postToGA4({
    client_id: processData.userId,
    events: [{
      name: 'process_completed',
      params: {
        process_type: processData.type,
        completion_time: processData.duration,
        department: processData.department
      }
    }]
  });
}
```

#### Özel Metrik Toplayıcı
```javascript
class MetricCollector {
  async collectProcessMetrics(timeRange) {
    const metrics = {
      throughput: await this.calculateThroughput(timeRange),
      performance: await this.calculatePerformanceMetrics(timeRange),
      quality: await this.calculateQualityMetrics(timeRange)
    };

    await this.storeMetrics(metrics);
    await this.generateAlerts(metrics);
    
    return metrics;
  }

  async calculateThroughput(timeRange) {
    return {
      total_processes: await db.count({ 
        completed_at: { 
          $gte: timeRange.start, 
          $lte: timeRange.end 
        }
      }),
      by_type: await db.aggregate([
        {
          $match: {
            completed_at: { 
              $gte: timeRange.start, 
              $lte: timeRange.end 
            }
          }
        },
        {
          $group: {
            _id: "$type",
            count: { $sum: 1 }
          }
        }
      ])
    };
  }
}
```

## API Güvenlik Testleri ve Penetrasyon Testleri

### OWASP Güvenlik Testleri
```javascript
// OWASP ZAP Test Konfigürasyonu
const ZAPClient = require('zaproxy');

const zapOptions = {
  apiKey: 'your-api-key',
  proxy: {
    host: 'localhost',
    port: 8080
  }
};

// Otomatik Güvenlik Taraması
async function runSecurityScan() {
  const zap = new ZAPClient(zapOptions);
  
  // Aktif Tarama
  await zap.spider.scan({
    url: 'https://api.bpm-platform.com',
    maxChildren: 10,
    recurse: true,
    contextName: 'BPM API',
    subtreeOnly: true
  });

  // Güvenlik Açığı Taraması
  const scanId = await zap.ascan.scan({
    url: 'https://api.bpm-platform.com',
    recurse: true,
    inScopeOnly: true,
    scanPolicyName: 'API Security Policy',
    method: 'GET',
    postData: null
  });

  // Sonuçları Al
  const results = await zap.core.alerts({
    baseurl: 'https://api.bpm-platform.com'
  });
}
```

### SQL Injection ve XSS Önlemleri
```javascript
// Input Validasyon Middleware
const validator = require('validator');

function sanitizeInput(req, res, next) {
  // SQL Injection Koruması
  Object.keys(req.body).forEach(key => {
    if (typeof req.body[key] === 'string') {
      req.body[key] = validator.escape(req.body[key]);
    }
  });

  // XSS Koruması
  const xssHeaders = {
    'X-XSS-Protection': '1; mode=block',
    'Content-Security-Policy': "default-src 'self'"
  };
  
  res.set(xssHeaders);
  next();
}
```

### Güvenlik Açığı Tarama Senaryoları
```javascript
// Güvenlik Test Senaryoları
const securityTests = {
  authentication: [
    {
      name: 'Brute Force Koruması',
      test: async () => {
        const attempts = [];
        for (let i = 0; i < 10; i++) {
          attempts.push(
            axios.post('/auth/login', {
              email: 'test@example.com',
              password: 'wrong_password'
            })
          );
        }
        const responses = await Promise.all(attempts);
        return responses[9].status === 429; // Rate limit kontrolü
      }
    }
  ],
  authorization: [
    {
      name: 'Yetki Yükseltme Koruması',
      test: async () => {
        const response = await axios.get('/admin/users', {
          headers: { Authorization: `Bearer ${userToken}` }
        });
        return response.status === 403;
      }
    }
  ]
};
```

## Felaket Kurtarma ve İş Sürekliliği

### Yedekleme ve Geri Yükleme Prosedürleri
```bash
# Otomatik Yedekleme Scripti
#!/bin/bash

# Veritabanı Yedekleme
mongodump --uri="mongodb://localhost:27017/bpm" --out="/backup/$(date +%Y%m%d)"

# Dosya Sistemi Yedekleme
rsync -avz /app/data/ /backup/files/

# Yedekleme Doğrulama
function verify_backup() {
  # MD5 kontrolü
  md5sum /backup/$(date +%Y%m%d)/* > /backup/checksum.md5
  
  # Test Geri Yükleme
  mongorestore --uri="mongodb://localhost:27017/bpm_test" \
    --drop /backup/$(date +%Y%m%d)
}

# AWS S3'e Transfer
aws s3 sync /backup s3://bpm-platform-backup/
```

### Failover Senaryoları
```javascript
// Otomatik Failover Konfigürasyonu
const failoverConfig = {
  primary: {
    host: 'primary-db.bpm-platform.com',
    port: 27017
  },
  secondary: {
    host: 'secondary-db.bpm-platform.com',
    port: 27017
  },
  healthCheck: {
    interval: 5000,
    timeout: 1000,
    retries: 3
  },
  failover: {
    automatic: true,
    maxLatency: 100,
    triggers: ['connection_lost', 'high_latency']
  }
};

// Sağlık Kontrolü
async function checkDatabaseHealth() {
  try {
    await mongoose.connection.db.admin().ping();
    return true;
  } catch (error) {
    await switchToSecondary();
    return false;
  }
}
```

### Veri Merkezi Geçiş Planları
```yaml
# Kubernetes Cluster Geçiş Konfigürasyonu
apiVersion: v1
kind: ConfigMap
metadata:
  name: datacenter-migration-config
data:
  migration-steps:
    - name: "Trafik Yönlendirme"
      actions:
        - update-dns
        - configure-load-balancer
    
    - name: "Veri Senkronizasyonu"
      actions:
        - snapshot-databases
        - replicate-storage
        - verify-consistency

    - name: "Servis Geçişi"
      actions:
        - scale-down-source
        - scale-up-target
        - verify-health
```

## API Dokümantasyon Versiyonlama

### Dokümantasyon Sürüm Geçmişi
```markdown
# Sürüm Geçmişi

## v2.0.0 (2024-01-15)
### Breaking Changes
- `POST /processes` endpoint'i yeni bir request format kullanıyor
- Kimlik doğrulama JWT tabanlı sisteme geçti
- Rate limiting politikası güncellendi

### Yeni Özellikler
- Batch işlem desteği eklendi
- WebSocket API eklendi
- Performans optimizasyonları yapıldı

### Düzeltmeler
- Hata mesajları standardize edildi
- Timeout süreleri optimize edildi
```

### Migration Rehberleri
```javascript
// v1'den v2'ye Geçiş Örneği
const migrationGuide = {
  authentication: {
    v1: {
      // Eski format
      headers: {
        'Api-Key': 'your-api-key'
      }
    },
    v2: {
      // Yeni format
      headers: {
        'Authorization': 'Bearer your-jwt-token'
      }
    }
  },
  processCreation: {
    v1: {
      // Eski format
      body: {
        process_type: 'purchase',
        data: {}
      }
    },
    v2: {
      // Yeni format
      body: {
        template_id: 'purchase_v2',
        variables: {}
      }
    }
  }
};
```

## Entegrasyon Senaryoları ve Use-Case'ler

### Yaygın Kullanım Senaryoları
```javascript
// Satın Alma Süreci Entegrasyonu
async function purchaseProcessExample() {
  // 1. Süreç Başlatma
  const process = await bpmClient.processes.create({
    template_id: 'purchase_request_v2',
    variables: {
      department: 'IT',
      budget_code: 'IT-2024-001',
      items: [
        {
          name: 'Laptop',
          quantity: 5,
          unit_price: 1500
        }
      ]
    }
  });

  // 2. Form Doldurma
  await bpmClient.forms.submit({
    process_id: process.id,
    form_id: 'purchase_details',
    data: {
      supplier: 'Tech Corp',
      delivery_date: '2024-02-01',
      payment_terms: 'net_30'
    }
  });

  // 3. Onay Akışı
  await bpmClient.tasks.complete({
    task_id: process.tasks[0].id,
    action: 'approve',
    comments: 'Bütçe uygun, onaylandı'
  });

  // 4. Bildirim Gönderme
  await bpmClient.notifications.send({
    process_id: process.id,
    template: 'purchase_approved',
    recipients: ['requester', 'finance']
  });
}
```

### Sektör Bazlı Örnekler
```javascript
// Bankacılık Sektörü - Kredi Başvuru Süreci
async function loanApplicationProcess() {
  // 1. Müşteri Kontrolü
  const customerCheck = await bpmClient.services.checkCustomer({
    customer_id: '12345',
    checks: ['credit_score', 'blacklist', 'income']
  });

  // 2. Risk Değerlendirmesi
  const riskAssessment = await bpmClient.services.assessRisk({
    customer_data: customerCheck,
    loan_amount: 100000,
    loan_type: 'mortgage'
  });

  // 3. Otomatik Karar
  if (riskAssessment.score > 700) {
    await bpmClient.processes.autoApprove({
      process_id: 'LOAN-2024-001',
      decision: 'APPROVED',
      terms: {
        interest_rate: 1.5,
        term_months: 120
      }
    });
  }
}

// Üretim Sektörü - Kalite Kontrol Süreci
async function qualityControlProcess() {
  // 1. Üretim Parti Kontrolü
  const batchInspection = await bpmClient.quality.inspectBatch({
    batch_id: 'BATCH-2024-001',
    parameters: ['dimension', 'weight', 'material']
  });

  // 2. Test Sonuçları
  const testResults = await bpmClient.laboratory.runTests({
    batch_id: 'BATCH-2024-001',
    tests: ['durability', 'safety', 'performance']
  });

  // 3. Uygunluk Kararı
  if (batchInspection.passed && testResults.passed) {
    await bpmClient.inventory.approve({
      batch_id: 'BATCH-2024-001',
      certificate_number: 'QC-2024-001'
    });
  }
}
```

### Best Practice Önerileri
```javascript
// 1. İdempotency Uygulaması
const idempotencyKey = uuid();
await bpmClient.processes.create({
  idempotency_key: idempotencyKey,
  template_id: 'purchase_request',
  variables: {}
});

// 2. Batch İşlem Optimizasyonu
const batchSize = 100;
const items = await bpmClient.tasks.batchComplete({
  tasks: taskIds.slice(0, batchSize),
  action: 'approve'
});

// 3. Önbellek Kullanımı
const cache = new NodeCache({ stdTTL: 600 });
const processDetails = await cache.get(
  `process:${processId}`,
  () => bpmClient.processes.get(processId)
);

// 4. Rate Limiting Yönetimi
const rateLimiter = new RateLimiter({
  points: 100,
  duration: 60
});

// 5. Hata İşleme
try {
  await bpmClient.processes.create({});
} catch (error) {
  if (error.code === 'RATE_LIMIT_EXCEEDED') {
    await sleep(error.retryAfter);
    return retry(operation);
  }
  throw error;
}
``` 