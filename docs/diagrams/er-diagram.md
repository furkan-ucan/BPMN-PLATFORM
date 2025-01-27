# BPM Platform - Varlık İlişki Diyagramı

Bu diyagram, BPM Platform'un veritabanı şemasını ve tablolar arası ilişkileri gösterir.

```mermaid
erDiagram
    %% Ana Tablolar
    Users {
        int user_id PK
        string name
        string email
        string password
        int role_id FK
        boolean is_active
        string profile_picture
        string phone_number
        string preferred_language
        datetime created_at
        datetime updated_at
    }

    Roles {
        int role_id PK
        string role_name
        json permissions
        datetime created_at
    }

    Processes {
        int process_id PK
        string name
        string description
        int creator_id FK
        json bpmn_data
        string status
        string version
        string category
        string[] tags
        datetime created_at
        datetime updated_at
    }

    Activities {
        int activity_id PK
        int process_id FK
        string name
        string type
        string status
        int assigned_to FK
        string priority
        datetime due_date
        datetime started_at
        datetime completed_at
    }

    Tasks {
        int task_id PK
        int activity_id FK
        int assigned_to FK
        string status
        datetime due_date
        json reminders
        datetime created_at
        datetime updated_at
    }

    %% Form Yönetimi
    Forms {
        int form_id PK
        int process_id FK
        string name
        json schema
        json validation_rules
        string version
        string status
        datetime created_at
    }

    FormSubmissions {
        int submission_id PK
        int form_id FK
        int task_id FK
        int user_id FK
        json data
        datetime submitted_at
        string status
    }

    %% Doküman Yönetimi
    Documents {
        int document_id PK
        int uploaded_by FK
        string name
        string type
        binary content
        string version
        datetime created_at
    }

    DocumentVersions {
        int version_id PK
        int document_id FK
        int created_by FK
        string version_number
        binary content
        datetime created_at
    }

    %% İş Akışı
    WorkflowHistory {
        int history_id PK
        int process_id FK
        int activity_id FK
        int user_id FK
        string action_taken
        datetime timestamp
        string comments
    }

    %% İzleme ve Raporlama
    Reports {
        int report_id PK
        int process_id FK
        string report_type
        json data
        datetime generated_at
    }

    Notifications {
        int notification_id PK
        int user_id FK
        int process_id FK
        string message
        string type
        boolean is_read
        datetime created_at
    }

    %% SLA Yönetimi
    SLADefinitions {
        int sla_id PK
        string name
        int target_time
        string applicable_to
        int entity_id FK
        datetime created_at
    }

    SLATracking {
        int tracking_id PK
        int sla_id FK
        int entity_id FK
        datetime start_time
        datetime end_time
        string status
    }

    %% API Yönetimi
    APIKeys {
        int api_key_id PK
        int user_id FK
        string api_key
        json permissions
        datetime created_at
        datetime expires_at
    }

    APILogs {
        int log_id PK
        int api_key_id FK
        string endpoint
        string method
        int status_code
        datetime timestamp
    }

    %% Denetim
    AuditLogs {
        int log_id PK
        int user_id FK
        string action
        string entity
        int entity_id FK
        datetime timestamp
        json details
    }

    %% İlişkiler
    Users ||--o{ Processes : "creates"
    Users ||--o{ Activities : "assigned_to"
    Users ||--|| Roles : "has"
    Processes ||--o{ Activities : "contains"
    Activities ||--o{ Tasks : "generates"
    Tasks ||--|| FormSubmissions : "requires"
    Forms ||--o{ FormSubmissions : "has"
    Tasks }o--o{ Documents : "contains"
    Users ||--o{ Documents : "uploads"
    Documents ||--o{ DocumentVersions : "versions"
    Users ||--o{ Notifications : "receives"
    Processes ||--o{ Notifications : "generates"
    SLADefinitions ||--o{ SLATracking : "tracks"
    Activities }o--o{ SLADefinitions : "monitored_by"
    Users ||--o{ APIKeys : "owns"
    APIKeys ||--o{ APILogs : "generates"
    Users ||--o{ AuditLogs : "generates"

    %% BPMN ve Süreç Yönetimi
    BPMNTemplates {
        int template_id PK
        string name
        string description
        text bpmn_xml
        string category
        int created_by FK
        boolean is_public
        string version
        string[] tags
        datetime created_at
        datetime updated_at
    }

    ProcessSimulations {
        int simulation_id PK
        int process_id FK
        string scenario_name
        json input_parameters
        json simulation_results
        int execution_time
        json resource_usage
        json bottlenecks
        datetime created_at
    }

    %% İş Kuralları
    DecisionTables {
        int decision_id PK
        string name
        string description
        int process_id FK
        json rules_definition
        string version
        string status
        datetime created_at
        datetime updated_at
    }

    BusinessPolicies {
        int policy_id PK
        string name
        string description
        string policy_type
        json rules
        json conditions
        json actions
        int priority
        string status
    }

    %% Süreç İzleme
    ProcessKPIs {
        int kpi_id PK
        int process_id FK
        string kpi_name
        float target_value
        float actual_value
        string measurement_period
        string status
        string trend
        json alerts
    }

    ProcessVersionControl {
        int version_id PK
        int process_id FK
        string version_number
        json changes
        int changed_by FK
        string approval_status
        text review_comments
        string deployment_status
        datetime created_at
    }

    %% Test ve Kalite
    ProcessTestCases {
        int test_id PK
        int process_id FK
        string test_name
        json test_scenario
        json expected_results
        json actual_results
        string status
        datetime created_at
        datetime last_run
    }

    ProcessValidations {
        int validation_id PK
        int process_id FK
        string validation_type
        json rules_checked
        json validation_results
        int errors_found
        json warnings
        datetime timestamp
    }

    %% Maliyet ve Kaynak
    ProcessCosts {
        int cost_id PK
        int process_id FK
        string cost_type
        decimal amount
        string currency
        string calculation_basis
        datetime period_start
        datetime period_end
        text notes
    }

    ResourceAllocation {
        int allocation_id PK
        int process_id FK
        string resource_type
        int quantity
        decimal cost_per_unit
        decimal total_cost
        string allocation_period
    }

    %% İlişkiler (Devam)
    Processes ||--o{ BPMNTemplates : "uses"
    Processes ||--o{ ProcessSimulations : "simulates"
    Processes ||--o{ DecisionTables : "implements"
    Processes ||--o{ BusinessPolicies : "follows"
    Processes ||--o{ ProcessKPIs : "measures"
    Processes ||--o{ ProcessVersionControl : "versions"
    Processes ||--o{ ProcessTestCases : "validates"
    Processes ||--o{ ProcessValidations : "checks"
    Processes ||--o{ ProcessCosts : "tracks_costs"
    Processes ||--o{ ResourceAllocation : "allocates"

    %% Yeni Tablolar - Normalizasyon
    RolePermissions {
        int permission_id PK
        int role_id FK
        string permission_name
        string permission_type
        json permission_scope
        datetime created_at
        datetime updated_at
    }

    ProcessTags {
        int tag_id PK
        int process_id FK
        string tag_name
        datetime created_at
    }

    ProcessCategories {
        int category_id PK
        string category_name
        string description
        datetime created_at
    }

    BPMNElements {
        int element_id PK
        int process_id FK
        string element_type
        string element_name
        json properties
        json coordinates
        json incoming_flows
        json outgoing_flows
        datetime created_at
        datetime updated_at
    }

    TestLogs {
        int log_id PK
        int test_id FK
        datetime executed_at
        json test_parameters
        json log_details
        string result
        int execution_time
        string environment
    }

    NotificationTemplates {
        int template_id PK
        string template_name
        string template_type
        text content_template
        json placeholders
        boolean is_active
        datetime created_at
    }

    ResourceTypes {
        int type_id PK
        string type_name
        string description
        json attributes
        boolean is_active
    }

    CostCenters {
        int center_id PK
        string center_name
        string description
        string budget_code
        decimal annual_budget
        datetime fiscal_year_start
        datetime fiscal_year_end
    }

    %% Yeni İlişkiler
    Roles ||--o{ RolePermissions : "has"
    Processes ||--o{ ProcessTags : "tagged_with"
    Processes ||--o{ ProcessCategories : "belongs_to"
    Processes ||--o{ BPMNElements : "contains"
    ProcessTestCases ||--o{ TestLogs : "generates"
    Notifications ||--o{ NotificationTemplates : "uses"
    ResourceAllocation ||--o{ ResourceTypes : "of_type"
    ProcessCosts ||--o{ CostCenters : "allocated_to"

    %% Eksik İlişkiler Eklendi
    FormSubmissions ||--|| WorkflowHistory : "creates_history"
    Notifications ||--|| Tasks : "notifies_about"
    SLADefinitions ||--|| ProcessKPIs : "monitors"
    ResourceAllocation ||--|| ProcessCosts : "calculates"
    Documents ||--|| ProcessVersionControl : "linked_to"
    Notifications ||--|| Reports : "related_to"

    %% GDPR ve Veri Koruma
    DataRetentionPolicies {
        int policy_id PK
        string entity_type
        int retention_period
        string deletion_strategy
        boolean requires_consent
        datetime created_at
        datetime updated_at
    }

    UserDataConsent {
        int consent_id PK
        int user_id FK
        string consent_type
        boolean is_granted
        datetime granted_at
        datetime expires_at
        text consent_details
    }

    %% Performans İzleme
    DatabaseIndexes {
        int index_id PK
        string table_name
        string column_name
        string index_type
        boolean is_unique
        datetime created_at
        json performance_stats
    }

    QueryPerformanceLogs {
        int log_id PK
        string query_hash
        int execution_time
        int rows_affected
        datetime executed_at
        json execution_plan
    }

    %% Yeni İlişkiler - Veri Koruma
    Users ||--o{ UserDataConsent : "provides"
    AuditLogs ||--|| DataRetentionPolicies : "governed_by"
    APILogs ||--|| DataRetentionPolicies : "governed_by"

    %% Süreç Optimizasyonu
    ProcessOptimizationRules {
        int rule_id PK
        int process_id FK
        string rule_type
        json conditions
        json actions
        int priority
        boolean is_active
        datetime created_at
    }

    ProcessMetrics {
        int metric_id PK
        int process_id FK
        string metric_name
        float current_value
        float target_value
        string unit
        datetime measured_at
        json historical_values
    }

    %% İş Kuralları Detayları
    BusinessRuleElements {
        int element_id PK
        int decision_id FK
        string element_type
        json conditions
        json actions
        int sequence
        boolean is_active
    }

    RuleExecutionLogs {
        int log_id PK
        int rule_id FK
        datetime executed_at
        json input_data
        json output_data
        boolean success
        string error_message
    }

    %% Yeni İlişkiler - Optimizasyon
    Processes ||--o{ ProcessOptimizationRules : "optimized_by"
    Processes ||--o{ ProcessMetrics : "measured_by"
    DecisionTables ||--o{ BusinessRuleElements : "composed_of"
    BusinessRuleElements ||--o{ RuleExecutionLogs : "logs"

    %% Genişletilmiş İzin Yönetimi
    PermissionTypes {
        int type_id PK
        string type_name "read|write|execute|admin"
        string description
        string scope "global|process|user_group"
        json scope_constraints
        boolean is_system
        boolean is_active
        datetime created_at
    }

    RolePermissionDetails {
        int detail_id PK
        int permission_id FK
        string action_type
        json constraints
        boolean is_granted
        int priority
        datetime effective_from
        datetime effective_until
        string approval_status
    }

    %% Süreç Metadata ve Etiketleme
    ProcessTagCategories {
        int category_id PK
        string category_name
        string description
        boolean is_system
        int parent_category_id FK
        int display_order
        datetime created_at
    }

    ProcessTagHierarchy {
        int hierarchy_id PK
        int parent_tag_id FK
        int child_tag_id FK
        int level
        datetime created_at
    }

    %% BPMN Element Detayları
    BPMNElementConstraints {
        int constraint_id PK
        int element_id FK
        string constraint_type
        json constraint_rules
        boolean is_required
        string validation_message
        datetime created_at
    }

    BPMNElementRelations {
        int relation_id PK
        int source_element_id FK
        int target_element_id FK
        string relation_type
        json properties
        datetime created_at
    }

    %% Test ve Kalite Yönetimi
    TestDependencies {
        int dependency_id PK
        int test_id FK
        int dependent_test_id FK
        string dependency_type
        boolean is_blocking
        datetime created_at
    }

    TestCoverage {
        int coverage_id PK
        int test_id FK
        string coverage_type
        float coverage_percentage
        json coverage_details
        datetime measured_at
    }

    %% Bildirim Sistemi
    NotificationPriorities {
        int priority_id PK
        string priority_name
        int priority_level
        json delivery_rules
        json retry_policy
        datetime created_at
    }

    NotificationEscalations {
        int escalation_id PK
        int notification_id FK
        int current_level
        datetime next_escalation
        json escalation_history
        boolean is_resolved
    }

    %% Maliyet ve Kaynak İzleme
    ResourceCapacityPlanning {
        int plan_id PK
        int resource_id FK
        string capacity_type
        decimal planned_capacity
        decimal actual_capacity
        datetime period_start
        datetime period_end
    }

    CostAllocationHistory {
        int history_id PK
        int rule_id FK
        decimal allocated_amount
        string allocation_status
        datetime allocated_at
        int approved_by FK
    }

    %% Performans ve İzleme
    MetricThresholds {
        int threshold_id PK
        int metric_id FK
        string threshold_type
        float warning_value
        float critical_value
        json alert_config
        boolean is_active
    }

    PerformanceBaselines {
        int baseline_id PK
        int metric_id FK
        float baseline_value
        datetime baseline_date
        string calculation_method
        json historical_data
    }

    %% Yeni İlişkiler
    ProcessTagCategories ||--o{ ProcessTagCategories : "parent_of"
    ProcessTags ||--o{ ProcessTagHierarchy : "hierarchical_structure"
    BPMNElements ||--o{ BPMNElementConstraints : "constrained_by"
    BPMNElements ||--o{ BPMNElementRelations : "relates_to"
    ProcessTestCases ||--o{ TestDependencies : "depends_on"
    ProcessTestCases ||--o{ TestCoverage : "measures"
    Notifications ||--o{ NotificationPriorities : "prioritized_by"
    Notifications ||--o{ NotificationEscalations : "escalates_to"
    ResourceTypes ||--o{ ResourceCapacityPlanning : "plans"
    CostAllocationRules ||--o{ CostAllocationHistory : "tracks"
    PerformanceMetrics ||--o{ MetricThresholds : "threshold_by"
    PerformanceMetrics ||--o{ PerformanceBaselines : "baselined_by"

    %% Partition ve İndeks Yönetimi
    TablePartitions {
        int partition_id PK
        string table_name
        string partition_key
        string partition_range
        datetime created_at
        datetime retention_end
    }

    IndexUsageStats {
        int stat_id PK
        int index_id FK
        bigint scan_count
        bigint tuple_reads
        float index_size_mb
        datetime collected_at
    }

    %% Yeni İlişkiler - Sistem Yönetimi
    DatabaseIndexes ||--o{ IndexUsageStats : "tracks"
    TablePartitions ||--|| DataRetentionPolicies : "applies"
```

## SQL Optimizasyon ve Analiz Örnekleri

### 1. İzin ve Rol Analizi
```sql
-- Rol bazlı izin analizi
WITH RECURSIVE permission_hierarchy AS (
    SELECT 
        rp.role_id,
        pt.type_name,
        rpd.is_granted,
        1 as level
    FROM RolePermissions rp
    JOIN PermissionTypes pt ON rp.permission_id = pt.type_id
    JOIN RolePermissionDetails rpd ON rp.permission_id = rpd.permission_id
    WHERE pt.is_system = true
    
    UNION ALL
    
    SELECT 
        ph.role_id,
        pt.type_name,
        rpd.is_granted,
        ph.level + 1
    FROM permission_hierarchy ph
    JOIN RolePermissions rp ON ph.role_id = rp.role_id
    JOIN PermissionTypes pt ON rp.permission_id = pt.type_id
    JOIN RolePermissionDetails rpd ON rp.permission_id = rpd.permission_id
    WHERE ph.level < 3
)
SELECT 
    role_id,
    type_name,
    bool_and(is_granted) as effective_permission,
    max(level) as inheritance_depth
FROM permission_hierarchy
GROUP BY role_id, type_name;
```

### 2. Süreç Performans Analizi
```sql
-- Süreç performans metrikleri
CREATE MATERIALIZED VIEW process_performance_metrics AS
WITH metric_stats AS (
    SELECT 
        pm.process_id,
        pm.metric_name,
        avg(ms.value) as avg_value,
        percentile_cont(0.95) WITHIN GROUP (ORDER BY ms.value) as p95_value,
        min(ms.value) as min_value,
        max(ms.value) as max_value
    FROM ProcessMetrics pm
    JOIN MetricSnapshots ms ON pm.metric_id = ms.metric_id
    WHERE ms.captured_at >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY pm.process_id, pm.metric_name
),
baseline_comparison AS (
    SELECT 
        ms.process_id,
        ms.metric_name,
        ms.avg_value,
        pb.baseline_value,
        ((ms.avg_value - pb.baseline_value) / pb.baseline_value * 100) as performance_change
    FROM metric_stats ms
    JOIN PerformanceBaselines pb ON ms.process_id = pb.metric_id
)
SELECT 
    p.name as process_name,
    bc.metric_name,
    bc.avg_value as current_average,
    bc.baseline_value,
    bc.performance_change,
    CASE 
        WHEN bc.performance_change <= -10 THEN 'Critical'
        WHEN bc.performance_change <= -5 THEN 'Warning'
        WHEN bc.performance_change >= 10 THEN 'Excellent'
        ELSE 'Normal'
    END as status
FROM baseline_comparison bc
JOIN Processes p ON bc.process_id = p.process_id;
```

### 3. Kaynak Kullanım Optimizasyonu
```sql
-- Kaynak kullanım ve maliyet analizi
CREATE MATERIALIZED VIEW resource_utilization_analysis AS
WITH resource_usage AS (
    SELECT 
        r.resource_id,
        r.type_name,
        rcp.planned_capacity,
        sum(rul.quantity_used) as total_usage,
        sum(rul.cost_incurred) as total_cost
    FROM ResourceTypes r
    JOIN ResourceCapacityPlanning rcp ON r.type_id = rcp.resource_id
    JOIN ResourceUsageLogs rul ON r.type_id = rul.resource_id
    WHERE rul.usage_start >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY r.resource_id, r.type_name, rcp.planned_capacity
)
SELECT 
    type_name,
    planned_capacity,
    total_usage,
    (total_usage / planned_capacity * 100) as utilization_percentage,
    total_cost,
    CASE 
        WHEN (total_usage / planned_capacity * 100) > 90 THEN 'Over-utilized'
        WHEN (total_usage / planned_capacity * 100) < 30 THEN 'Under-utilized'
        ELSE 'Optimal'
    END as utilization_status
FROM resource_usage;
```

### 4. Test Kapsamı ve Kalite Metrikleri
```sql
-- Test kapsamı ve başarı oranı analizi
CREATE MATERIALIZED VIEW test_quality_metrics AS
WITH test_results AS (
    SELECT 
        ptc.process_id,
        tc.coverage_type,
        tc.coverage_percentage,
        count(tes.step_id) as total_steps,
        sum(CASE WHEN tes.status = 'passed' THEN 1 ELSE 0 END) as passed_steps
    FROM ProcessTestCases ptc
    JOIN TestCoverage tc ON ptc.test_id = tc.test_id
    JOIN TestLogs tl ON ptc.test_id = tl.test_id
    JOIN TestExecutionSteps tes ON tl.log_id = tes.log_id
    WHERE tl.executed_at >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY ptc.process_id, tc.coverage_type, tc.coverage_percentage
)
SELECT 
    p.name as process_name,
    tr.coverage_type,
    tr.coverage_percentage,
    tr.total_steps,
    tr.passed_steps,
    (tr.passed_steps::float / tr.total_steps * 100) as success_rate,
    CASE 
        WHEN tr.coverage_percentage < 80 THEN 'Insufficient Coverage'
        WHEN (tr.passed_steps::float / tr.total_steps * 100) < 90 THEN 'Quality Issues'
        ELSE 'Satisfactory'
    END as quality_status
FROM test_results tr
JOIN Processes p ON tr.process_id = p.process_id;
```

