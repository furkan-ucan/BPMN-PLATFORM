# BPM Platform - Veritabanı Şema Dokümantasyonu

## 1. Veritabanı Mimarisi

### 1.1 Veritabanı Seçimi
```yaml
databases:
  operational_db:
    type: "PostgreSQL"
    version: "14.x"
    purpose: "Ana operasyonel veritabanı"
    
  analytics_db:
    type: "ClickHouse"
    version: "22.x"
    purpose: "Analitik ve raporlama veritabanı"
    
  cache_db:
    type: "Redis"
    version: "6.x"
    purpose: "Önbellek ve oturum yönetimi"
```

## 2. Şema Yapısı

### 2.1 Process Management
```sql
CREATE TABLE processes (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    version INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    metadata JSONB
);

CREATE TABLE process_instances (
    id UUID PRIMARY KEY,
    process_id UUID REFERENCES processes(id),
    status VARCHAR(50) NOT NULL,
    variables JSONB,
    started_at TIMESTAMP NOT NULL,
    completed_at TIMESTAMP,
    started_by UUID REFERENCES users(id),
    priority INT DEFAULT 0,
    due_date TIMESTAMP
);

CREATE TABLE tasks (
    id UUID PRIMARY KEY,
    process_instance_id UUID REFERENCES process_instances(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    assignee UUID REFERENCES users(id),
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    due_date TIMESTAMP,
    priority INT DEFAULT 0,
    form_data JSONB
);
```

### 2.2 Form Management
```sql
CREATE TABLE form_definitions (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    version INT NOT NULL,
    schema JSONB NOT NULL,
    validation_rules JSONB,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    created_by UUID REFERENCES users(id),
    status VARCHAR(50) DEFAULT 'active'
);

CREATE TABLE form_submissions (
    id UUID PRIMARY KEY,
    form_definition_id UUID REFERENCES form_definitions(id),
    process_instance_id UUID REFERENCES process_instances(id),
    task_id UUID REFERENCES tasks(id),
    data JSONB NOT NULL,
    submitted_at TIMESTAMP NOT NULL,
    submitted_by UUID REFERENCES users(id),
    status VARCHAR(50) NOT NULL
);
```

### 2.3 User Management
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255),
    status VARCHAR(50) NOT NULL,
    last_login TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    metadata JSONB
);

CREATE TABLE roles (
    id UUID PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    permissions JSONB NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE user_roles (
    user_id UUID REFERENCES users(id),
    role_id UUID REFERENCES roles(id),
    granted_at TIMESTAMP NOT NULL,
    granted_by UUID REFERENCES users(id),
    PRIMARY KEY (user_id, role_id)
);
```

### 2.4 Document Management
```sql
CREATE TABLE documents (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL,
    size BIGINT NOT NULL,
    content_type VARCHAR(100) NOT NULL,
    storage_path VARCHAR(1000) NOT NULL,
    process_instance_id UUID REFERENCES process_instances(id),
    task_id UUID REFERENCES tasks(id),
    uploaded_at TIMESTAMP NOT NULL,
    uploaded_by UUID REFERENCES users(id),
    metadata JSONB
);

CREATE TABLE document_versions (
    id UUID PRIMARY KEY,
    document_id UUID REFERENCES documents(id),
    version INT NOT NULL,
    size BIGINT NOT NULL,
    storage_path VARCHAR(1000) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    created_by UUID REFERENCES users(id),
    comment TEXT,
    UNIQUE (document_id, version)
);
```

## 3. İndeksler ve Performans

### 3.1 İndeks Stratejisi
```sql
-- Process Management İndeksleri
CREATE INDEX idx_processes_status ON processes(status);
CREATE INDEX idx_process_instances_status ON process_instances(status);
CREATE INDEX idx_tasks_assignee_status ON tasks(assignee, status);
CREATE INDEX idx_tasks_due_date ON tasks(due_date) WHERE status = 'active';

-- Form Management İndeksleri
CREATE INDEX idx_form_definitions_version ON form_definitions(version);
CREATE INDEX idx_form_submissions_status ON form_submissions(status);

-- User Management İndeksleri
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_user_roles_user ON user_roles(user_id);

-- Document Management İndeksleri
CREATE INDEX idx_documents_process ON documents(process_instance_id);
CREATE INDEX idx_documents_task ON documents(task_id);
```

### 3.2 Partition Stratejisi
```sql
-- Process Instance Partitioning
CREATE TABLE process_instances_partition OF process_instances
PARTITION BY RANGE (started_at);

CREATE TABLE process_instances_2024_q1 
PARTITION OF process_instances_partition
FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

-- Form Submissions Partitioning
CREATE TABLE form_submissions_partition OF form_submissions
PARTITION BY RANGE (submitted_at);

CREATE TABLE form_submissions_2024_q1
PARTITION OF form_submissions_partition
FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');
```

## 4. Veri Yedekleme ve Arşivleme

### 4.1 Yedekleme Stratejisi
```yaml
backup:
  full_backup:
    frequency: "daily"
    retention: "30 days"
    time: "00:00 UTC"
    
  incremental_backup:
    frequency: "hourly"
    retention: "7 days"
    
  point_in_time_recovery:
    enabled: true
    retention: "7 days"
```

### 4.2 Arşivleme Politikası
```yaml
archival:
  process_instances:
    condition: "completed_at < NOW() - INTERVAL '1 year'"
    target: "data_warehouse"
    retention: "5 years"
    
  form_submissions:
    condition: "submitted_at < NOW() - INTERVAL '1 year'"
    target: "data_warehouse"
    retention: "5 years"
    
  documents:
    condition: "uploaded_at < NOW() - INTERVAL '2 years'"
    target: "cold_storage"
    retention: "7 years"
```

## 5. Veri Güvenliği

### 5.1 Şifreleme
```sql
-- Hassas Veri Şifreleme
CREATE EXTENSION pgcrypto;

-- Kullanıcı Şifreleri için Hash Fonksiyonu
CREATE OR REPLACE FUNCTION hash_password(password TEXT) 
RETURNS TEXT AS $$
BEGIN
    RETURN crypt(password, gen_salt('bf', 8));
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Hassas Veri Şifreleme Fonksiyonu
CREATE OR REPLACE FUNCTION encrypt_sensitive_data(data TEXT, key TEXT) 
RETURNS BYTEA AS $$
BEGIN
    RETURN pgp_sym_encrypt(data, key);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### 5.2 Erişim Kontrolleri
```sql
-- Role-Based Access Control
CREATE ROLE app_readonly;
CREATE ROLE app_writer;
CREATE ROLE app_admin;

-- Readonly Permissions
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_readonly;

-- Writer Permissions
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO app_writer;

-- Admin Permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_admin;
```

## 6. Veritabanı Monitoring

### 6.1 Performans Metrikleri
```yaml
monitoring:
  metrics:
    - name: "connection_count"
      warning_threshold: 80
      critical_threshold: 90
      
    - name: "query_execution_time"
      warning_threshold: "1s"
      critical_threshold: "5s"
      
    - name: "buffer_hit_ratio"
      warning_threshold: 0.8
      critical_threshold: 0.7
      
    - name: "deadlock_count"
      warning_threshold: 5
      critical_threshold: 10
```

### 6.2 Maintenance Planı
```yaml
maintenance:
  vacuum:
    full:
      frequency: "weekly"
      time: "Sunday 01:00 UTC"
    analyze:
      frequency: "daily"
      time: "03:00 UTC"
      
  reindex:
    frequency: "monthly"
    time: "First Sunday 02:00 UTC"
    
  statistics_update:
    frequency: "daily"
    time: "04:00 UTC"
``` 