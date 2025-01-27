# Process Mining Detail Flow

```mermaid
graph TD
    %% Main Process Mining Flow
    Start[Start] --> Extract[Extract Event Logs]
    Extract --> Clean[Clean & Preprocess Data]
    Clean --> Discover[Process Discovery]
    
    %% Process Discovery Branch
    Discover --> ModelGen[Generate Process Model]
    Discover --> Variants[Identify Process Variants]
    
    %% Analysis Branch
    ModelGen --> Analyze[Process Analysis]
    Analyze --> Conformance[Conformance Checking]
    Analyze --> Performance[Performance Analysis]
    
    %% Enhancement Branch
    Performance --> Enhance[Process Enhancement]
    Conformance --> Enhance
    Enhance --> Optimize[Optimization Recommendations]
    
    %% Monitoring & Feedback Loop
    Optimize --> Monitor[Continuous Monitoring]
    Monitor --> Extract
    
    %% Subprocesses
    subgraph Data Preparation
        Extract
        Clean
    end
    
    subgraph Analysis Phase
        Discover
        ModelGen
        Variants
        Analyze
        Conformance
        Performance
    end
    
    subgraph Improvement Phase
        Enhance
        Optimize
        Monitor
    end
    
    %% Notes and Annotations
    classDef default fill:#f9f9f9,stroke:#333,stroke-width:2px;
    classDef subprocess fill:#e1f3d8,stroke:#82c91e,stroke-width:2px;
    class Extract,Clean subprocess;