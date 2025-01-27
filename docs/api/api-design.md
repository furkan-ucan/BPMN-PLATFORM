# BPM Platform - API Tasarım Dokümanı

## 1. API Tasarım Prensipleri

### 1.1 Genel Prensipler
- RESTful mimari prensipleri
- Resource-oriented tasarım
- Tutarlı naming conventions
- HTTP metodlarının doğru kullanımı
- Uygun HTTP status kodları

### 1.2 Versiyonlama
- URI tabanlı versiyonlama: `/api/v1/resource`
- Major version değişiklikleri için yeni endpoint
- Minor version değişiklikleri için geriye uyumluluk
- Version sunset policy

### 1.3 Endpoint Yapısı
- Resource bazlı URL yapısı
- Nested resource yapısı
- Query parameter standartları
- Filtreleme, sıralama ve sayfalama

## 2. API Endpoints

### 2.1 Process Management API
```yaml
/api/v1/processes:
  get:
    description: Süreç listesi
    parameters:
      - name: status
      - name: category
      - name: page
      - name: size
  post:
    description: Yeni süreç oluşturma
    
/api/v1/processes/{processId}:
  get:
    description: Süreç detayı
  put:
    description: Süreç güncelleme
  delete:
    description: Süreç silme

/api/v1/processes/{processId}/activities:
  get:
    description: Süreç aktiviteleri
  post:
    description: Yeni aktivite ekleme
```

### 2.2 Form Management API
```yaml
/api/v1/forms:
  get:
    description: Form şablonları listesi
  post:
    description: Yeni form şablonu oluşturma

/api/v1/forms/{formId}/submissions:
  get:
    description: Form gönderileri
  post:
    description: Yeni form gönderisi
```

### 2.3 User Management API
```yaml
/api/v1/users:
  get:
    description: Kullanıcı listesi
  post:
    description: Yeni kullanıcı oluşturma

/api/v1/users/{userId}/roles:
  get:
    description: Kullanıcı rolleri
  put:
    description: Rol atama
```

## 3. Request/Response Format

### 3.1 Request Format
```json
{
  "data": {
    "type": "resource_type",
    "attributes": {
      "field1": "value1",
      "field2": "value2"
    },
    "relationships": {
      "related_resource": {
        "data": {
          "type": "related_type",
          "id": "related_id"
        }
      }
    }
  }
}
```

### 3.2 Response Format
```json
{
  "data": {
    "type": "resource_type",
    "id": "resource_id",
    "attributes": {
      "field1": "value1",
      "field2": "value2"
    }
  },
  "meta": {
    "page": 1,
    "total": 100
  }
}
```

### 3.3 Error Format
```json
{
  "errors": [
    {
      "status": "400",
      "code": "VALIDATION_ERROR",
      "title": "Validation Error",
      "detail": "Field 'name' is required",
      "source": {
        "pointer": "/data/attributes/name"
      }
    }
  ]
}
```

## 4. Güvenlik

### 4.1 Authentication
- Bearer token authentication
- API key authentication (third-party)
- OAuth2 flow desteği

### 4.2 Rate Limiting
```yaml
headers:
  X-RateLimit-Limit: 1000
  X-RateLimit-Remaining: 999
  X-RateLimit-Reset: 1623456789
```

### 4.3 CORS Policy
```yaml
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Max-Age: 86400
```

## 5. API Performance

### 5.1 Caching
```yaml
headers:
  Cache-Control: public, max-age=31536000
  ETag: "33a64df551425fcc55e4d42a148795d9f25f89d4"
  Last-Modified: Wed, 21 Oct 2015 07:28:00 GMT
```

### 5.2 Compression
```yaml
headers:
  Accept-Encoding: gzip, deflate
  Content-Encoding: gzip
```

### 5.3 Pagination
```yaml
parameters:
  page: 1
  size: 20
  sort: created_at:desc
```

## 6. API Documentation

### 6.1 OpenAPI Specification
- Swagger UI integration
- API documentation auto-generation
- Interactive API testing

### 6.2 Code Examples
```bash
# Example cURL request
curl -X POST \
  https://api.bpmplatform.com/v1/processes \
  -H 'Authorization: Bearer {token}' \
  -H 'Content-Type: application/json' \
  -d '{
    "data": {
      "type": "process",
      "attributes": {
        "name": "New Process",
        "description": "Process description"
      }
    }
  }'
```

## 7. API Monitoring

### 7.1 Metrics
- Request count
- Response time
- Error rate
- Endpoint usage

### 7.2 Logging
- Request/Response logging
- Error logging
- Performance logging
``` 