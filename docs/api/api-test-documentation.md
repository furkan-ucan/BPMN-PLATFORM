# API Test Dokümantasyonu

## İçindekiler
1. [Temel Sistem Altyapısı Testleri](#temel-sistem-altyapısı-testleri)
2. [BPMN Editor API Testleri](#bpmn-editor-api-testleri)
3. [Form Tasarımcısı API Testleri](#form-tasarımcısı-api-testleri)
4. [Süreç Yönetimi API Testleri](#süreç-yönetimi-api-testleri)
5. [Entegrasyon API Testleri](#entegrasyon-api-testleri)
6. [Raporlama ve Analitik API Testleri](#raporlama-ve-analitik-api-testleri)
7. [Denetim ve Uyumluluk API Testleri](#denetim-ve-uyumluluk-api-testleri)
8. [Destek ve Eğitim API Testleri](#destek-ve-eğitim-api-testleri)
9. [Geliştirme Önerileri ve İleri Seviye Test Senaryoları](#geliştirme-önerileri-ve-ileri-seviye-test-senaryoları)

## Test Ortamı Kurulumu

### Docker Kurulumu
```bash
# Test ortamı Docker container'ı
docker build -t bpm-test-env -f Dockerfile.test .
docker run -d --name bpm-test -p 3000:3000 bpm-test-env
```

### Test Veritabanı Kurulumu
```bash
# MongoDB test veritabanı
docker run -d --name mongodb-test -p 27017:27017 mongo:latest

# Seed data yükleme
npm run db:seed:test
```

### Test Kullanıcıları ve Rolleri

#### Sistem Yönetimi Rolleri
| Rol | Email | Şifre | Yetkiler |
|-----|-------|-------|----------|
| Süper Admin | admin@test.com | test123 | Tüm yetkiler |
| Sistem Yöneticisi | sysadmin@test.com | test123 | Sistem yapılandırma |
| Denetçi | auditor@test.com | test123 | Denetim ve log görüntüleme |

#### Süreç Yönetimi Rolleri
| Rol | Email | Şifre | Yetkiler |
|-----|-------|-------|----------|
| Süreç Sahibi | process.owner@test.com | test123 | Süreç tasarımı ve yönetimi |
| Süreç Sorumlusu | process.manager@test.com | test123 | Süreç izleme ve müdahale |
| Form Tasarımcısı | form.designer@test.com | test123 | Form tasarımı |

### CI/CD Test Konfigürasyonu
```yaml
# .github/workflows/test.yml
name: API Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '16'
      - name: Install dependencies
        run: npm install
      - name: Run tests
        run: npm run test:ci
```

## Performans Test Senaryoları

### Yük Testleri
```javascript
// k6-load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    stages: [
        { duration: '2m', target: 100 }, // Ramp-up
        { duration: '5m', target: 100 }, // Stay at peak
        { duration: '2m', target: 0 }    // Ramp-down
    ],
    thresholds: {
        http_req_duration: ['p(95)<500'], // 95% istekleri 500ms altında
        http_req_failed: ['rate<0.01']    // Hata oranı %1'den az
    }
};

export default function () {
    // Süreç listesi endpoint testi
    const processResponse = http.get('http://test-api/processes', {
        headers: { 'Authorization': `Bearer ${TOKEN}` }
    });
    check(processResponse, {
        'status is 200': (r) => r.status === 200,
        'response time OK': (r) => r.timings.duration < 500
    });
    sleep(1);

    // Form oluşturma endpoint testi
    const formResponse = http.post('http://test-api/forms', {
        name: 'Test Form',
        fields: [{ type: 'text', name: 'field1' }]
    }, {
        headers: { 'Authorization': `Bearer ${TOKEN}` }
    });
    check(formResponse, {
        'status is 201': (r) => r.status === 201,
        'response time OK': (r) => r.timings.duration < 1000
    });
    sleep(1);
}
```

### Stres Testleri
```javascript
// k6-stress-test.js
export const options = {
    scenarios: {
        stress: {
            executor: 'ramping-arrival-rate',
            preAllocatedVUs: 500,
            timeUnit: '1s',
            stages: [
                { duration: '2m', target: 10 },
                { duration: '5m', target: 50 },
                { duration: '2m', target: 100 },
                { duration: '2m', target: 0 }
            ]
        }
    }
};

export default function () {
    // Süreç başlatma stres testi
    const response = http.post('http://test-api/processes/start', {
        template_id: 'template_123',
        variables: { priority: 'high' }
    });
    
    check(response, {
        'status is 201': (r) => r.status === 201,
        'response time OK': (r) => r.timings.duration < 2000
    });
}
```

### Dayanıklılık Testleri
```javascript
// k6-endurance-test.js
export const options = {
    scenarios: {
        endurance: {
            executor: 'constant-vus',
            vus: 50,
            duration: '4h'
        }
    }
};

export default function () {
    // 4 saatlik sürekli yük testi
    const responses = http.batch([
        ['GET', 'http://test-api/processes'],
        ['GET', 'http://test-api/tasks'],
        ['GET', 'http://test-api/forms']
    ]);
    
    responses.forEach((res) => {
        check(res, {
            'status is 200': (r) => r.status === 200,
            'response time OK': (r) => r.timings.duration < 1000
        });
    });
}
```

### Kapasite Testleri
```javascript
// k6-capacity-test.js
export const options = {
    scenarios: {
        capacity: {
            executor: 'ramping-vus',
            startVUs: 0,
            stages: [
                { duration: '5m', target: 100 },
                { duration: '10m', target: 500 },
                { duration: '5m', target: 1000 },
                { duration: '5m', target: 0 }
            ]
        }
    }
};

export default function () {
    // Sistem kapasitesi testi
    const responses = http.batch([
        ['POST', 'http://test-api/processes/start'],
        ['POST', 'http://test-api/tasks'],
        ['GET', 'http://test-api/reports']
    ]);
    
    responses.forEach((res) => {
        check(res, {
            'status is success': (r) => r.status < 400,
            'response time OK': (r) => r.timings.duration < 3000
        });
    });
}
```

## Hata Senaryoları

### API Endpoint Hata Testleri
```javascript
describe('API Endpoint Hata Testleri', () => {
    test('Geçersiz kimlik bilgileri', async () => {
        const response = await api.post('/auth/login', {
            email: 'invalid@test.com',
            password: 'wrong'
        });
        expect(response.status).toBe(401);
        expect(response.data.error).toBe('INVALID_CREDENTIALS');
    });

    test('Eksik parametreler', async () => {
        const response = await api.post('/processes/start', {
            // template_id eksik
            variables: {}
        });
        expect(response.status).toBe(400);
        expect(response.data.error).toBe('MISSING_REQUIRED_FIELD');
    });

    test('Geçersiz format', async () => {
        const response = await api.post('/forms', {
            name: 123, // string olmalı
            fields: 'invalid' // array olmalı
        });
        expect(response.status).toBe(400);
        expect(response.data.error).toBe('INVALID_FORMAT');
    });
});
```

### Ağ Hata Testleri
```javascript
describe('Ağ Hata Testleri', () => {
    test('Bağlantı zaman aşımı', async () => {
        const response = await api.get('/processes', {
            timeout: 1 // 1ms timeout
        }).catch(e => e.response);
        
        expect(response.status).toBe(408);
        expect(response.data.error).toBe('REQUEST_TIMEOUT');
    });

    test('Ağ kesintisi', async () => {
        // Mock network failure
        api.interceptors.request.use(() => {
            throw new Error('Network Error');
        });

        const response = await api.get('/tasks').catch(e => e);
        expect(response.message).toBe('Network Error');
    });
});
```

### Validation Hata Testleri
```javascript
describe('Validation Hata Testleri', () => {
    test('Form validasyon hataları', async () => {
        const response = await api.post('/forms', {
            name: '',
            fields: [
                {
                    type: 'email',
                    name: 'email',
                    validation: {
                        pattern: 'invalid-regex'
                    }
                }
            ]
        });
        
        expect(response.status).toBe(400);
        expect(response.data.errors).toContainEqual({
            field: 'name',
            error: 'REQUIRED_FIELD'
        });
        expect(response.data.errors).toContainEqual({
            field: 'fields[0].validation.pattern',
            error: 'INVALID_REGEX'
        });
    });
});
```

## Güvenlik Test Senaryoları

### OWASP Güvenlik Testleri
```javascript
describe('OWASP Güvenlik Testleri', () => {
    test('SQL Injection Koruması', async () => {
        const response = await api.get('/users', {
            params: {
                search: "'; DROP TABLE users; --"
            }
        });
        expect(response.status).toBe(400);
        expect(response.data.error).toBe('INVALID_INPUT');
    });

    test('XSS Koruması', async () => {
        const response = await api.post('/comments', {
            content: '<script>alert("xss")</script>'
        });
        expect(response.data.content).not.toContain('<script>');
    });

    test('CSRF Koruması', async () => {
        const response = await api.post('/processes', {}, {
            headers: {
                'X-CSRF-Token': 'invalid'
            }
        });
        expect(response.status).toBe(403);
        expect(response.data.error).toBe('INVALID_CSRF_TOKEN');
    });
});
```

## Mock ve Stub Servisleri

### Harici Servis Mockları
```javascript
// mock-services.js
const mockServices = {
    emailService: {
        sendEmail: jest.fn().mockResolvedValue({
            status: 'sent',
            messageId: 'mock_123'
        })
    },
    paymentService: {
        processPayment: jest.fn().mockResolvedValue({
            status: 'success',
            transactionId: 'tx_123'
        })
    },
    notificationService: {
        sendNotification: jest.fn().mockResolvedValue({
            status: 'delivered',
            notificationId: 'notif_123'
        })
    }
};

// Test kullanımı
describe('Harici Servis Entegrasyonları', () => {
    test('E-posta gönderimi', async () => {
        const result = await mockServices.emailService.sendEmail({
            to: 'user@test.com',
            subject: 'Test',
            body: 'Test email'
        });
        
        expect(result.status).toBe('sent');
        expect(mockServices.emailService.sendEmail).toHaveBeenCalled();
    });
});
```

### Test Stubları
```javascript
// test-stubs.js
const testStubs = {
    database: {
        query: jest.fn().mockImplementation((sql, params) => {
            if (sql.includes('SELECT')) {
                return Promise.resolve([{ id: 1, name: 'Test' }]);
            }
            if (sql.includes('INSERT')) {
                return Promise.resolve({ insertId: 1 });
            }
            return Promise.resolve();
        })
    },
    cache: {
        get: jest.fn().mockResolvedValue({ cached: true }),
        set: jest.fn().mockResolvedValue(true),
        del: jest.fn().mockResolvedValue(true)
    }
};

// Test kullanımı
describe('Veritabanı İşlemleri', () => {
    test('Veri sorgulama', async () => {
        const result = await testStubs.database.query(
            'SELECT * FROM users WHERE id = ?',
            [1]
        );
        expect(result[0].name).toBe('Test');
    });
});
```

### Fake Servisler
```javascript
// fake-services.js
class FakeAuthService {
    constructor() {
        this.users = new Map();
    }

    async login(email, password) {
        const user = this.users.get(email);
        if (!user || user.password !== password) {
            throw new Error('Invalid credentials');
        }
        return {
            token: 'fake_token_123',
            user: { id: user.id, email }
        };
    }

    async register(email, password) {
        if (this.users.has(email)) {
            throw new Error('User already exists');
        }
        const id = this.users.size + 1;
        this.users.set(email, { id, password });
        return { id, email };
    }
}

// Test kullanımı
describe('Kimlik Doğrulama', () => {
    let authService;

    beforeEach(() => {
        authService = new FakeAuthService();
    });

    test('Kullanıcı kaydı', async () => {
        const result = await authService.register(
            'test@example.com',
            'password123'
        );
        expect(result.email).toBe('test@example.com');
    });
});
```

## 1. Temel Sistem Altyapısı Testleri
> Referanslar:
> - RFC: RFC-001-TemelSistemAltyapisi.md
> - PRD: Kritik (P0) - MVP Gereksinimleri
> - Diagram: system-architecture.puml

### 1.1 Kimlik Doğrulama Testleri

#### Test Senaryosu: Başarılı Login
```javascript
describe('Kimlik Doğrulama', () => {
    test('Başarılı login işlemi', async () => {
        const response = await api.post('/auth/login', {
            email: 'test@example.com',
            password: 'test123'
        });
        
        expect(response.status).toBe(200);
        expect(response.data).toHaveProperty('token');
        expect(response.data).toHaveProperty('refresh_token');
    });
});

#### Test Senaryosu: Token Yenileme
```javascript
describe('Token İşlemleri', () => {
    test('Refresh token ile yeni token alma', async () => {
        const response = await api.post('/auth/refresh', {
            refresh_token: 'valid_refresh_token'
        });
        
        expect(response.status).toBe(200);
        expect(response.data).toHaveProperty('token');
    });
});

### 1.2 Yetkilendirme Testleri

#### Test Senaryosu: Rol Bazlı Erişim
```javascript
describe('RBAC Testleri', () => {
    test('Admin kullanıcı sistem ayarlarına erişebilmeli', async () => {
        const response = await api.get('/settings/system', {
            headers: { Authorization: `Bearer ${adminToken}` }
        });
        expect(response.status).toBe(200);
    });

    test('Normal kullanıcı sistem ayarlarına erişememeli', async () => {
        const response = await api.get('/settings/system', {
            headers: { Authorization: `Bearer ${userToken}` }
        });
        expect(response.status).toBe(403);
    });
});

## 2. BPMN Editor API Testleri
> Referanslar:
> - RFC: RFC-002-BPMNEditor.md
> - PRD: Süreç Tasarımı ve Modelleme
> - Diagram: process-management-sequence.puml

### 2.1 Süreç Modeli İşlemleri

#### Test Senaryosu: Süreç Modeli Oluşturma
```javascript
describe('Süreç Modeli İşlemleri', () => {
    test('Yeni süreç modeli oluşturma', async () => {
        const model = {
            name: 'Test Süreci',
            description: 'Test süreç açıklaması',
            bpmn_xml: '<xml>...</xml>'
        };
        
        const response = await api.post('/processes/models', model);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('id');
    });
});
```

#### Test Senaryosu: BPMN Validasyon
```javascript
describe('BPMN Validasyon', () => {
    test('Geçerli BPMN XML kontrolü', async () => {
        const response = await api.post('/processes/validate', {
            bpmn_xml: validBpmnXml
        });
        expect(response.status).toBe(200);
        expect(response.data.isValid).toBe(true);
    });

    test('Geçersiz BPMN XML kontrolü', async () => {
        const response = await api.post('/processes/validate', {
            bpmn_xml: invalidBpmnXml
        });
        expect(response.status).toBe(400);
        expect(response.data.errors).toBeArray();
    });
});

## 3. Form Tasarımcısı API Testleri
> Referanslar:
> - RFC: RFC-003-FormTasarimcisi.md
> - PRD: Form Tasarımı ve Yönetimi
> - Diagram: user-operations-sequence.puml

### 3.1 Form Şablonu İşlemleri

#### Test Senaryosu: Form Şablonu Oluşturma
```javascript
describe('Form Şablonu İşlemleri', () => {
    test('Yeni form şablonu oluşturma', async () => {
        const template = {
            name: 'Satın Alma Talebi',
            fields: [
                {
                    type: 'text',
                    name: 'item_name',
                    label: 'Ürün Adı',
                    required: true
                },
                {
                    type: 'number',
                    name: 'quantity',
                    label: 'Miktar',
                    required: true
                }
            ]
        };
        
        const response = await api.post('/forms/templates', template);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('id');
    });
});
```

## 4. Süreç Yönetimi API Testleri
> Referanslar:
> - RFC: RFC-004-SurecYonetimi.md
> - PRD: Süreç Yönetimi ve İzleme
> - Diagram: process-management-sequence.puml

### 4.1 Süreç Yaşam Döngüsü Testleri

#### Test Senaryosu: Süreç Başlatma
```javascript
describe('Süreç Yaşam Döngüsü', () => {
    test('Yeni süreç başlatma', async () => {
        const processData = {
            template_id: 'template_123',
            variables: {
                requestor: 'user_123',
                department: 'IT',
                priority: 'high'
            }
        };
        
        const response = await api.post('/processes/start', processData);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('process_id');
        expect(response.data).toHaveProperty('status', 'ACTIVE');
    });
});
```

#### Test Senaryosu: Süreç Durumu Güncelleme
```javascript
describe('Süreç Durum Yönetimi', () => {
    test('Süreç duraklatma', async () => {
        const response = await api.post('/processes/process_123/suspend', {
            reason: 'Ek bilgi bekleniyor'
        });
        expect(response.status).toBe(200);
        expect(response.data.status).toBe('SUSPENDED');
    });

    test('Süreç devam ettirme', async () => {
        const response = await api.post('/processes/process_123/resume', {
            comment: 'Bilgiler tamamlandı'
        });
        expect(response.status).toBe(200);
        expect(response.data.status).toBe('ACTIVE');
    });
});
```

### 4.2 Görev Yönetimi Testleri

#### Test Senaryosu: Görev Atama ve Güncelleme
```javascript
describe('Görev Yönetimi', () => {
    test('Görevi yeni kullanıcıya atama', async () => {
        const response = await api.post('/tasks/task_123/assign', {
            user_id: 'user_456',
            comment: 'Uzman görüşü gerekiyor'
        });
        expect(response.status).toBe(200);
        expect(response.data.assignee).toBe('user_456');
    });

    test('Görev önceliğini güncelleme', async () => {
        const response = await api.patch('/tasks/task_123', {
            priority: 'HIGH',
            due_date: '2024-01-20T15:00:00Z'
        });
        expect(response.status).toBe(200);
        expect(response.data.priority).toBe('HIGH');
    });
});
```

### 4.3 İş Akışı Testleri

#### Test Senaryosu: Tam Onay Süreci
```javascript
describe('İş Akışı', () => {
    test('Satın alma onay süreci', async () => {
        // Süreci başlat
        const processResponse = await api.post('/processes/start', {
            template_id: 'purchase_approval_template',
            variables: {
                amount: 5000,
                department: 'IT',
                item: 'Laptop'
            }
        });
        expect(processResponse.status).toBe(201);
        const processId = processResponse.data.process_id;

        // İlk onay görevini tamamla
        const firstTaskResponse = await api.post(`/tasks/task_123/complete`, {
            action: 'APPROVE',
            comment: 'Bütçe uygun',
            variables: {
                approved: true,
                approval_date: new Date().toISOString()
            }
        });
        expect(firstTaskResponse.status).toBe(200);

        // Süreç durumunu kontrol et
        const statusResponse = await api.get(`/processes/${processId}`);
        expect(statusResponse.data.status).toBe('COMPLETED');
        expect(statusResponse.data.variables.approved).toBe(true);
    });
});
```

### 4.4 Süreç İzleme Testleri

#### Test Senaryosu: Süreç Metrikleri
```javascript
describe('Süreç İzleme', () => {
    test('Süreç performans metriklerini alma', async () => {
        const response = await api.get('/processes/process_123/metrics');
        expect(response.status).toBe(200);
        expect(response.data).toHaveProperty('duration');
        expect(response.data).toHaveProperty('task_completion_rate');
        expect(response.data).toHaveProperty('bottlenecks');
    });

    test('Süreç tarihçesini görüntüleme', async () => {
        const response = await api.get('/processes/process_123/history');
        expect(response.status).toBe(200);
        expect(response.data.events).toBeArray();
        expect(response.data.events[0]).toHaveProperty('timestamp');
        expect(response.data.events[0]).toHaveProperty('type');
    });
});
```

## 5. Entegrasyon API Testleri
> Referanslar:
> - RFC: RFC-005-EntegrasyonAPI.md
> - PRD: Entegrasyon ve Bağlantılar
> - Diagram: integration-diagram.puml

### 5.1 Harici Sistem Entegrasyonları

#### Test Senaryosu: REST API Entegrasyonu
```javascript
describe('REST API Entegrasyonu', () => {
    test('Harici sistem bağlantı testi', async () => {
        const connection = {
            name: 'ERP Sistemi',
            type: 'REST',
            config: {
                base_url: 'https://erp-test.example.com/api',
                auth_type: 'oauth2',
                client_id: 'test_client',
                client_secret: 'test_secret'
            }
        };
        
        const response = await api.post('/integrations/connections', connection);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('connection_id');
    });

    test('Bağlantı durumu kontrolü', async () => {
        const response = await api.get('/integrations/connections/conn_123/health');
        expect(response.status).toBe(200);
        expect(response.data.status).toBe('HEALTHY');
    });
});
```

### 5.2 Webhook Yönetimi

#### Test Senaryosu: Webhook İşlemleri
```javascript
describe('Webhook Yönetimi', () => {
    test('Yeni webhook kaydı', async () => {
        const webhook = {
            name: 'Süreç Tamamlanma Bildirimi',
            event_type: 'PROCESS_COMPLETED',
            target_url: 'https://notify.example.com/webhook',
            headers: {
                'X-API-Key': 'webhook_secret_key'
            }
        };
        
        const response = await api.post('/integrations/webhooks', webhook);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('webhook_id');
    });

    test('Webhook tetikleme testi', async () => {
        const testEvent = {
            process_id: 'process_123',
            event_type: 'PROCESS_COMPLETED',
            timestamp: new Date().toISOString()
        };
        
        const response = await api.post('/integrations/webhooks/webhook_123/test', testEvent);
        expect(response.status).toBe(200);
        expect(response.data.delivery_status).toBe('SUCCESS');
    });
});
```

### 5.3 Dosya Entegrasyonları

#### Test Senaryosu: Dosya İşlemleri
```javascript
describe('Dosya Entegrasyonları', () => {
    test('Dosya yükleme', async () => {
        const formData = new FormData();
        formData.append('file', new Blob(['test content'], { type: 'text/plain' }));
        formData.append('process_id', 'process_123');
        
        const response = await api.post('/integrations/files/upload', formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        });
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('file_id');
    });

    test('Dosya indirme', async () => {
        const response = await api.get('/integrations/files/file_123/download');
        expect(response.status).toBe(200);
        expect(response.headers['content-type']).toBe('application/octet-stream');
    });
});
```

### 5.4 E-posta Entegrasyonları

#### Test Senaryosu: E-posta Bildirimleri
```javascript
describe('E-posta Entegrasyonları', () => {
    test('E-posta şablonu oluşturma', async () => {
        const template = {
            name: 'Görev Atama Bildirimi',
            subject: 'Yeni Görev: {{task_name}}',
            body: 'Sayın {{user_name}}, size yeni bir görev atanmıştır.',
            variables: ['task_name', 'user_name']
        };
        
        const response = await api.post('/integrations/email/templates', template);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('template_id');
    });

    test('E-posta gönderimi', async () => {
        const email = {
            template_id: 'template_123',
            to: 'user@example.com',
            variables: {
                task_name: 'Döküman İnceleme',
                user_name: 'Ahmet Yılmaz'
            }
        };
        
        const response = await api.post('/integrations/email/send', email);
        expect(response.status).toBe(200);
        expect(response.data.status).toBe('SENT');
    });
});
```

## 6. Raporlama ve Analitik API Testleri
> Referanslar:
> - RFC: RFC-006-RaporlamaAnalitik.md
> - PRD: Raporlama ve Analitik
> - Diagram: data-flow-diagram.puml

### 6.1 Dashboard API Testleri

#### Test Senaryosu: Dashboard Yönetimi
```javascript
describe('Dashboard Yönetimi', () => {
    test('Yeni dashboard oluşturma', async () => {
        const dashboard = {
            name: 'Süreç Performans Dashboardu',
            description: 'Süreç performans metriklerini gösteren dashboard',
            widgets: [
                {
                    type: 'CHART',
                    title: 'Süreç Tamamlanma Süreleri',
                    config: {
                        chart_type: 'LINE',
                        metrics: ['completion_time'],
                        group_by: 'process_type'
                    }
                },
                {
                    type: 'KPI',
                    title: 'Ortalama Tamamlanma Süresi',
                    config: {
                        metric: 'avg_completion_time',
                        format: 'duration'
                    }
                }
            ]
        };
        
        const response = await api.post('/analytics/dashboards', dashboard);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('dashboard_id');
    });

    test('Dashboard verisi alma', async () => {
        const response = await api.get('/analytics/dashboards/dash_123/data', {
            params: {
                start_date: '2024-01-01',
                end_date: '2024-01-31'
            }
        });
        expect(response.status).toBe(200);
        expect(response.data.widgets).toBeArray();
    });
});
```

### 6.2 Rapor API Testleri

#### Test Senaryosu: Rapor Oluşturma ve Çalıştırma
```javascript
describe('Rapor İşlemleri', () => {
    test('Yeni rapor şablonu oluşturma', async () => {
        const report = {
            name: 'Aylık Süreç Performans Raporu',
            description: 'Aylık süreç performans metrikleri',
            query: {
                metrics: ['completion_time', 'task_count', 'error_rate'],
                dimensions: ['process_type', 'department'],
                filters: [
                    {
                        field: 'status',
                        operator: 'IN',
                        values: ['COMPLETED', 'FAILED']
                    }
                ],
                sort: [
                    {
                        field: 'completion_time',
                        direction: 'DESC'
                    }
                ]
            },
            schedule: {
                frequency: 'MONTHLY',
                day: 1,
                time: '00:00'
            }
        };
        
        const response = await api.post('/analytics/reports', report);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('report_id');
    });

    test('Rapor çalıştırma', async () => {
        const response = await api.post('/analytics/reports/report_123/run', {
            parameters: {
                start_date: '2024-01-01',
                end_date: '2024-01-31',
                department: 'IT'
            }
        });
        expect(response.status).toBe(200);
        expect(response.data).toHaveProperty('execution_id');
    });

    test('Rapor sonuçlarını alma', async () => {
        const response = await api.get('/analytics/reports/report_123/executions/exec_123');
        expect(response.status).toBe(200);
        expect(response.data.status).toBe('COMPLETED');
        expect(response.data.results).toBeArray();
    });
});
```

### 6.3 Metrik API Testleri

#### Test Senaryosu: Metrik Sorgulama
```javascript
describe('Metrik Sorgulama', () => {
    test('Süreç metrikleri sorgulama', async () => {
        const response = await api.post('/analytics/metrics/query', {
            metrics: ['avg_completion_time', 'task_completion_rate'],
            dimensions: ['process_type', 'department'],
            filters: [
                {
                    field: 'start_date',
                    operator: 'BETWEEN',
                    values: ['2024-01-01', '2024-01-31']
                }
            ],
            group_by: ['department'],
            order_by: [
                {
                    field: 'avg_completion_time',
                    direction: 'DESC'
                }
            ]
        });
        
        expect(response.status).toBe(200);
        expect(response.data.results).toBeArray();
        expect(response.data.metadata).toHaveProperty('total_count');
    });

    test('Gerçek zamanlı metrikler alma', async () => {
        const response = await api.get('/analytics/metrics/realtime', {
            params: {
                metrics: ['active_processes', 'active_tasks'],
                interval: '5m'
            }
        });
        expect(response.status).toBe(200);
        expect(response.data.metrics).toBeArray();
    });
});
```

## 7. Denetim ve Uyumluluk API Testleri
> Referanslar:
> - RFC: RFC-007-DenetimUyumluluk.md
> - PRD: Denetim ve Uyumluluk
> - Diagram: security-diagram.puml

### 7.1 Denetim Logu Testleri

#### Test Senaryosu: Denetim Kayıtları
```javascript
describe('Denetim Logu', () => {
    test('Denetim kayıtlarını sorgulama', async () => {
        const response = await api.get('/audit/logs', {
            params: {
                start_date: '2024-01-01',
                end_date: '2024-01-31',
                event_type: 'USER_ACTION',
                user_id: 'user_123'
            }
        });
        expect(response.status).toBe(200);
        expect(response.data.logs).toBeArray();
        expect(response.data.metadata).toHaveProperty('total_count');
    });

    test('Detaylı denetim kaydı görüntüleme', async () => {
        const response = await api.get('/audit/logs/log_123');
        expect(response.status).toBe(200);
        expect(response.data).toHaveProperty('event_type');
        expect(response.data).toHaveProperty('user_id');
        expect(response.data).toHaveProperty('action_details');
        expect(response.data).toHaveProperty('timestamp');
    });
});
```

### 7.2 Uyumluluk Raporu Testleri

#### Test Senaryosu: Uyumluluk Raporları
```javascript
describe('Uyumluluk Raporları', () => {
    test('Uyumluluk raporu oluşturma', async () => {
        const report = {
            name: 'KVKK Uyumluluk Raporu',
            type: 'COMPLIANCE_REPORT',
            parameters: {
                regulation: 'KVKK',
                start_date: '2024-01-01',
                end_date: '2024-01-31',
                departments: ['IT', 'HR']
            }
        };
        
        const response = await api.post('/compliance/reports', report);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('report_id');
    });

    test('Uyumluluk raporu sonuçlarını alma', async () => {
        const response = await api.get('/compliance/reports/report_123');
        expect(response.status).toBe(200);
        expect(response.data).toHaveProperty('compliance_score');
        expect(response.data).toHaveProperty('findings');
        expect(response.data).toHaveProperty('recommendations');
    });
});
```

### 7.3 Veri Gizliliği Testleri

#### Test Senaryosu: Veri Maskeleme ve Şifreleme
```javascript
describe('Veri Gizliliği', () => {
    test('Hassas veri maskeleme kuralı oluşturma', async () => {
        const rule = {
            name: 'TC Kimlik Maskeleme',
            field_pattern: 'tc_kimlik_no',
            masking_type: 'PARTIAL',
            masking_config: {
                visible_start: 3,
                visible_end: 3,
                mask_char: '*'
            }
        };
        
        const response = await api.post('/privacy/masking-rules', rule);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('rule_id');
    });

    test('Veri şifreleme politikası oluşturma', async () => {
        const policy = {
            name: 'Kişisel Veri Şifreleme',
            data_type: 'PERSONAL_DATA',
            encryption_method: 'AES_256',
            key_rotation_period: '90d'
        };
        
        const response = await api.post('/privacy/encryption-policies', policy);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('policy_id');
    });
});
```

### 7.4 Güvenlik Politikası Testleri

#### Test Senaryosu: Güvenlik Politikaları
```javascript
describe('Güvenlik Politikaları', () => {
    test('Parola politikası oluşturma', async () => {
        const policy = {
            name: 'Güçlü Parola Politikası',
            rules: {
                min_length: 12,
                require_uppercase: true,
                require_lowercase: true,
                require_numbers: true,
                require_special_chars: true,
                max_age_days: 90,
                prevent_reuse: 5
            }
        };
        
        const response = await api.post('/security/password-policies', policy);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('policy_id');
    });

    test('IP kısıtlama politikası oluşturma', async () => {
        const policy = {
            name: 'IP Kısıtlama',
            rules: {
                allowed_ips: ['192.168.1.0/24', '10.0.0.0/8'],
                blocked_ips: ['1.2.3.4'],
                action: 'BLOCK'
            }
        };
        
        const response = await api.post('/security/ip-restriction-policies', policy);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('policy_id');
    });
});
```

## 8. Destek ve Eğitim API Testleri
> Referanslar:
> - RFC: RFC-008-DestekEgitim.md
> - PRD: Destek ve Eğitim
> - Diagram: support-diagram.puml

### 8.1 Destek API Testleri

#### Test Senaryosu: Destek İşlemleri
```javascript
describe('Destek İşlemleri', () => {
    test('Destek bilet oluşturma', async () => {
        const ticket = {
            title: 'Süreç Hata',
            description: 'Süreç çalışmıyor',
            priority: 'HIGH',
            assignee: 'user_123'
        };
        
        const response = await api.post('/support/tickets', ticket);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('ticket_id');
    });

    test('Destek bilet sorgulama', async () => {
        const response = await api.get('/support/tickets/ticket_123');
        expect(response.status).toBe(200);
        expect(response.data).toHaveProperty('title');
        expect(response.data).toHaveProperty('description');
        expect(response.data).toHaveProperty('priority');
        expect(response.data).toHaveProperty('assignee');
    });
});

### 8.2 Eğitim API Testleri

#### Test Senaryosu: Eğitim İşlemleri
```javascript
describe('Eğitim İşlemleri', () => {
    test('Eğitim kursu oluşturma', async () => {
        const course = {
            name: 'Süreç Yönetimi Eğitimi',
            description: 'Süreç yönetimi ile ilgili eğitim kursu',
            duration: '4 saat',
            instructor: 'Ahmet Yılmaz'
        };
        
        const response = await api.post('/training/courses', course);
        expect(response.status).toBe(201);
        expect(response.data).toHaveProperty('course_id');
    });

    test('Eğitim kursu sorgulama', async () => {
        const response = await api.get('/training/courses/course_123');
        expect(response.status).toBe(200);
        expect(response.data).toHaveProperty('name');
        expect(response.data).toHaveProperty('description');
        expect(response.data).toHaveProperty('duration');
        expect(response.data).toHaveProperty('instructor');
    });
});

## 9. Geliştirme Önerileri ve İleri Seviye Test Senaryoları

### 9.1 Negatif Test Senaryoları

#### Test Senaryosu: Hatalı Girdi Testleri
```javascript
describe('Negatif Test Senaryoları', () => {
    test('Geçersiz JSON formatı', async () => {
        const response = await api.post('/processes', 'invalid-json', {
            headers: { 'Content-Type': 'application/json' }
        });
        expect(response.status).toBe(400);
        expect(response.data.error).toBe('INVALID_JSON_FORMAT');
    });

    test('Çok büyük dosya yükleme', async () => {
        const largeFile = new Blob([new ArrayBuffer(11 * 1024 * 1024)]); // 11MB
        const formData = new FormData();
        formData.append('file', largeFile);
        
        const response = await api.post('/files/upload', formData);
        expect(response.status).toBe(413);
        expect(response.data.error).toBe('FILE_TOO_LARGE');
    });

    test('Rate limit aşımı', async () => {
        const requests = Array(100).fill().map(() => 
            api.get('/processes')
        );
        
        const responses = await Promise.all(requests);
        const lastResponse = responses[responses.length - 1];
        
        expect(lastResponse.status).toBe(429);
        expect(lastResponse.data.error).toBe('RATE_LIMIT_EXCEEDED');
    });
});
```

### 9.2 Gerçek Zamanlı Test Senaryoları

#### Test Senaryosu: WebSocket Bağlantı Testleri
```javascript
describe('Gerçek Zamanlı Testler', () => {
    let wsClient;

    beforeEach(() => {
        wsClient = new WebSocket('ws://localhost:3000');
    });

    afterEach(() => {
        wsClient.close();
    });

    test('Süreç durumu değişikliği bildirimi', (done) => {
        wsClient.onmessage = (message) => {
            const data = JSON.parse(message.data);
            expect(data.type).toBe('PROCESS_STATUS_CHANGED');
            expect(data.process_id).toBeDefined();
            done();
        };

        // Tetikleyici olay
        api.post('/processes/process_123/complete');
    });

    test('Görev atama bildirimi', (done) => {
        wsClient.onmessage = (message) => {
            const data = JSON.parse(message.data);
            expect(data.type).toBe('TASK_ASSIGNED');
            expect(data.assignee).toBe('user_123');
            done();
        };

        // Tetikleyici olay
        api.post('/tasks/task_123/assign', {
            user_id: 'user_123'
        });
    });
});
```

### 9.3 Swagger/Postman Entegrasyonu

#### Swagger Dokümantasyonu
```yaml
openapi: 3.0.0
info:
  title: BPM Platform API
  version: 1.0.0
paths:
  /processes:
    post:
      summary: Yeni süreç başlatma
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ProcessRequest'
      responses:
        '201':
          description: Süreç başarıyla oluşturuldu
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Process'
```

#### Postman Koleksiyonu
```json
{
  "info": {
    "name": "BPM Platform API Tests",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Süreç Testleri",
      "item": [
        {
          "name": "Süreç Oluştur",
          "request": {
            "method": "POST",
            "url": "{{baseUrl}}/processes",
            "body": {
              "mode": "raw",
              "raw": "{\"template_id\": \"template_123\"}"
            }
          }
        }
      ]
    }
  ]
}
```

### 9.4 Veri Tabanlı Test Senaryoları

#### Test Senaryosu: Dinamik Veri Testleri
```javascript
describe('Veri Tabanlı Testler', () => {
    test('Büyük veri seti ile süreç listesi', async () => {
        // Test verisi oluştur
        await generateTestProcesses(1000);
        
        const response = await api.get('/processes', {
            params: {
                page: 1,
                limit: 50,
                sort: 'created_at:desc'
            }
        });
        
        expect(response.status).toBe(200);
        expect(response.data.items).toHaveLength(50);
        expect(response.data.total).toBe(1000);
    });

    test('Veri tutarlılığı kontrolü', async () => {
        const processId = 'process_123';
        
        // Paralel işlemler
        await Promise.all([
            api.post(`/processes/${processId}/tasks`),
            api.patch(`/processes/${processId}`, { status: 'COMPLETED' }),
            api.post(`/processes/${processId}/comments`)
        ]);
        
        // Tutarlılık kontrolü
        const process = await api.get(`/processes/${processId}`);
        expect(process.data.task_count).toBe(1);
        expect(process.data.comment_count).toBe(1);
    });
});
```

### 9.5 Test Sonuçları Raporlama

#### Jest HTML Reporter Konfigürasyonu
```javascript
// jest.config.js
module.exports = {
    reporters: [
        'default',
        [
            './node_modules/jest-html-reporter',
            {
                pageTitle: 'BPM Platform Test Raporu',
                outputPath: './test-reports/index.html',
                includeFailureMsg: true,
                includeSuiteFailure: true
            }
        ]
    ]
};
```

#### K6 Grafana Dashboard
```javascript
// k6-dashboard.js
export const options = {
    ext: {
        loadimpact: {
            projectID: 123456,
            name: "BPM Platform Load Test"
        }
    },
    thresholds: {
        http_req_duration: ['p(95)<500'],
        http_req_failed: ['rate<0.01']
    }
};

export default function () {
    // Test senaryoları
}
```

### 9.6 Sürekli İzleme ve Alarm Testleri

#### Test Senaryosu: Metrik İzleme
```javascript
describe('Sürekli İzleme Testleri', () => {
    test('Yüksek CPU kullanımı alarmı', async () => {
        // CPU yükü simülasyonu
        await simulateHighCPULoad();
        
        const response = await api.get('/monitoring/metrics/cpu');
        expect(response.status).toBe(200);
        expect(response.data.alerts).toContainEqual({
            type: 'HIGH_CPU_USAGE',
            threshold: 80,
            current_value: expect.any(Number),
            status: 'ACTIVE'
        });
    });

    test('Bellek kullanımı izleme', async () => {
        const response = await api.get('/monitoring/metrics/memory');
        expect(response.status).toBe(200);
        expect(response.data).toHaveProperty('used_memory_percentage');
        expect(response.data).toHaveProperty('free_memory_mb');
    });
}); 