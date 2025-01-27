# BPM Platform - Entegrasyon Detayları Dokümanı

## 1. Harici Sistem Entegrasyonları

### 1.1 ERP Entegrasyonu
```yaml
erp_integration:
  type: "SAP"
  connection:
    protocol: "RFC"
    host: "sap.example.com"
    port: 3300
    auth:
      type: "basic"
      credentials:
        client: "100"
        username: "BPMUSER"
        password: "encrypted"

  endpoints:
    - name: "material_master"
      function: "BAPI_MATERIAL_GET_ALL"
      mapping:
        input:
          MATERIAL_NUMBER: "item_code"
        output:
          MATERIAL_GENERAL_DATA: "item_details"
          
    - name: "purchase_order"
      function: "BAPI_PO_CREATE1"
      mapping:
        input:
          PO_HEADER: "header"
          PO_ITEMS: "items"
        output:
          PO_NUMBER: "po_number"
```

### 1.2 CRM Entegrasyonu
```typescript
interface CRMConfig {
  baseUrl: string;
  apiKey: string;
  webhookUrl: string;
  endpoints: {
    customers: string;
    opportunities: string;
    activities: string;
  };
  mapping: {
    customer: CustomerMapping;
    opportunity: OpportunityMapping;
  };
}

interface CustomerMapping {
  id: string;
  name: string;
  email: string;
  phone: string;
  customFields: Record<string, string>;
}
```

### 1.3 Document Management System
```yaml
dms_integration:
  provider: "SharePoint"
  connection:
    type: "oauth2"
    tenant_id: "your_tenant_id"
    client_id: "your_client_id"
    client_secret: "encrypted"
    scope: ["Files.ReadWrite.All"]
    
  document_types:
    - name: "invoice"
      path: "/Invoices/{year}/{month}"
      metadata:
        - invoice_number
        - vendor_id
        - amount
        
    - name: "contract"
      path: "/Contracts/{type}/{year}"
      metadata:
        - contract_number
        - party_name
        - expiry_date
```

## 2. Event Bus Konfigürasyonu

### 2.1 Kafka Topics
```yaml
kafka_config:
  bootstrap_servers:
    - "kafka-1:9092"
    - "kafka-2:9092"
    - "kafka-3:9092"
    
  topics:
    process_events:
      partitions: 6
      replication_factor: 3
      retention_ms: 604800000  # 7 days
      
    user_events:
      partitions: 3
      replication_factor: 3
      retention_ms: 2592000000  # 30 days
      
  consumer_groups:
    process_handler:
      group_id: "process-handler"
      auto_offset_reset: "earliest"
      
    notification_handler:
      group_id: "notification-handler"
      auto_offset_reset: "latest"
```

### 2.2 Event Schemas
```json
{
  "ProcessStartedEvent": {
    "type": "object",
    "required": ["process_id", "user_id", "timestamp"],
    "properties": {
      "process_id": {
        "type": "string",
        "format": "uuid"
      },
      "user_id": {
        "type": "string"
      },
      "timestamp": {
        "type": "string",
        "format": "date-time"
      },
      "data": {
        "type": "object"
      }
    }
  }
}
```

## 3. Message Queue Yapılandırması

### 3.1 RabbitMQ Configuration
```yaml
rabbitmq_config:
  connection:
    hosts: ["rabbitmq-1", "rabbitmq-2"]
    port: 5672
    virtual_host: "bpm"
    
  exchanges:
    process_exchange:
      type: "topic"
      durable: true
      
    notification_exchange:
      type: "fanout"
      durable: true
      
  queues:
    process_tasks:
      durable: true
      arguments:
        x-message-ttl: 86400000  # 24 hours
        x-dead-letter-exchange: "dlx"
        
    notifications:
      durable: true
      arguments:
        x-message-ttl: 3600000  # 1 hour
```

### 3.2 Dead Letter Queue
```yaml
dlq_config:
  exchange:
    name: "dlx"
    type: "direct"
    
  queues:
    failed_tasks:
      binding_key: "process_tasks"
      
    failed_notifications:
      binding_key: "notifications"
      
  retry_policy:
    max_retries: 3
    initial_interval: 1000
    multiplier: 2
    max_interval: 10000
```

## 4. Webhook Yönetimi

### 4.1 Webhook Configuration
```typescript
interface WebhookConfig {
  endpoint: string;
  events: string[];
  secret: string;
  retryPolicy: {
    maxRetries: number;
    backoffMultiplier: number;
  };
  timeout: number;
}

interface WebhookPayload {
  event: string;
  timestamp: string;
  data: unknown;
  signature: string;
}
```

### 4.2 Webhook Security
```typescript
const generateSignature = (payload: string, secret: string): string => {
  const hmac = crypto.createHmac('sha256', secret);
  return hmac.update(payload).digest('hex');
};

const verifyWebhook = (
  payload: string,
  signature: string,
  secret: string
): boolean => {
  const expectedSignature = generateSignature(payload, secret);
  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(expectedSignature)
  );
};
```

## 5. API Gateway Entegrasyonu

### 5.1 Route Configuration
```yaml
routes:
  process_api:
    path: "/api/v1/processes"
    service: "process-service"
    strip_prefix: true
    timeout: 30s
    retry:
      attempts: 3
      perTryTimeout: 10s
      
  form_api:
    path: "/api/v1/forms"
    service: "form-service"
    strip_prefix: true
    timeout: 20s
    cors:
      allowed_origins: ["*"]
      allowed_methods: ["GET", "POST", "PUT", "DELETE"]
```

### 5.2 Rate Limiting
```yaml
rate_limit:
  global:
    requests_per_second: 1000
    burst: 2000
    
  per_client:
    requests_per_minute: 100
    burst: 200
    
  paths:
    "/api/v1/processes":
      requests_per_minute: 50
      burst: 100
```

## 6. Monitoring ve Alerting

### 6.1 Integration Metrics
```yaml
metrics:
  integration_health:
    type: "gauge"
    labels: ["integration_name", "status"]
    
  request_duration:
    type: "histogram"
    buckets: [0.1, 0.5, 1, 2, 5]
    labels: ["integration_name", "endpoint"]
    
  error_count:
    type: "counter"
    labels: ["integration_name", "error_type"]
```

### 6.2 Alert Rules
```yaml
alerts:
  integration_down:
    condition: "integration_health == 0"
    duration: "5m"
    severity: "critical"
    
  high_error_rate:
    condition: "rate(error_count[5m]) > 10"
    duration: "5m"
    severity: "warning"
    
  slow_response:
    condition: "histogram_quantile(0.95, request_duration) > 2"
    duration: "10m"
    severity: "warning"
```