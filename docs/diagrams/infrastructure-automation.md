# Infrastructure Automation Architecture

```mermaid
graph TB
    subgraph "Infrastructure Automation"
        A[Configuration Management] --> B[Infrastructure as Code]
        B --> C[Resource Provisioning]
        
        subgraph "Automation Tools"
            D[Terraform] 
            E[Ansible]
            F[Jenkins]
            G[GitLab CI]
        end
        
        subgraph "Monitoring & Alerts"
            H[Prometheus]
            I[Grafana]
            J[Alert Manager]
        end
        
        B --> D
        B --> E
        B --> F
        B --> G
        
        C --> H
        C --> I
        H --> J
        
        subgraph "Infrastructure Components"
            K[Compute]
            L[Storage] 
            M[Network]
            N[Security]
        end
        
        C --> K
        C --> L 
        C --> M
        C --> N
    end

classDef primary fill:#e1f5fe,stroke:#01579b
classDef secondary fill:#f3e5f5,stroke:#4a148c
classDef tools fill:#fff3e0,stroke:#e65100

class A,B,C primary
class D,E,F,G tools
class H,I,J secondary