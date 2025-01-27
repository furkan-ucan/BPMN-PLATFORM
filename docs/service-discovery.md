# BPM Platform - Service Discovery ve Circuit Breaker Dokümanı

## 1. Service Discovery

### 1.1 Consul Configuration
```yaml
consul_config:
  datacenter: "dc1"
  server: true
  bootstrap_expect: 3
  retry_join: ["consul-server-1", "consul-server-2", "consul-server-3"]
  
  services:
    process_service:
      name: "process-service"
  port: 8080
      tags: ["v1", "production"]
      checks:
        - name: "HTTP Health Check"
          http: "http://localhost:8080/health"
          interval: "10s"
          timeout: "5s"
          
    form_service:
      name: "form-service"
      port: 8081
      tags: ["v1", "production"]
      checks:
        - name: "HTTP Health Check"
          http: "http://localhost:8081/health"
          interval: "10s"
          timeout: "5s"
```

### 1.2 Service Registration
```typescript
interface ServiceRegistration {
  id: string;
  name: string;
  tags: string[];
  address: string;
  port: number;
  meta: Record<string, string>;
  checks: HealthCheck[];
}

interface HealthCheck {
  id: string;
  name: string;
  status: 'passing' | 'warning' | 'critical';
  output: string;
  serviceID: string;
  serviceName: string;
}
```

### 1.3 Service Discovery Client
```typescript
class ServiceDiscoveryClient {
  private consul: Consul;
  
  async findService(name: string, tag?: string): Promise<ServiceInstance[]> {
    const result = await this.consul.catalog.service.nodes({
      service: name,
      tag: tag
    });
    
    return result.map(node => ({
      id: node.ServiceID,
      address: node.ServiceAddress,
      port: node.ServicePort,
      tags: node.ServiceTags
    }));
  }
  
  async watchService(name: string, callback: (services: ServiceInstance[]) => void): void {
    const watch = this.consul.watch({
      method: this.consul.health.service,
      options: {
        service: name,
        passing: true
      }
    });
    
    watch.on('change', services => callback(services));
    watch.on('error', err => console.error('Watch error:', err));
  }
}
```

## 2. Circuit Breaker

### 2.1 Resilience4j Configuration
```yaml
resilience4j:
  circuitbreaker:
  instances:
      processService:
        slidingWindowSize: 100
        minimumNumberOfCalls: 10
      failureRateThreshold: 50
        waitDurationInOpenState: 60000
        permittedNumberOfCallsInHalfOpenState: 10
        
      formService:
        slidingWindowSize: 50
        minimumNumberOfCalls: 5
        failureRateThreshold: 40
        waitDurationInOpenState: 30000
        permittedNumberOfCallsInHalfOpenState: 5
```

### 2.2 Circuit Breaker Implementation
```typescript
class CircuitBreaker {
  private state: 'CLOSED' | 'OPEN' | 'HALF_OPEN' = 'CLOSED';
  private failureCount: number = 0;
  private lastFailureTime: number = 0;
  
  constructor(private config: CircuitBreakerConfig) {}
  
  async execute<T>(command: () => Promise<T>): Promise<T> {
    if (this.isOpen()) {
      throw new Error('Circuit breaker is OPEN');
    }
    
    try {
      const result = await command();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }
  
  private isOpen(): boolean {
    if (this.state === 'OPEN') {
      const now = Date.now();
      if (now - this.lastFailureTime >= this.config.waitDurationInOpenState) {
        this.state = 'HALF_OPEN';
        return false;
      }
      return true;
    }
    return false;
  }
  
  private onSuccess(): void {
    if (this.state === 'HALF_OPEN') {
      this.state = 'CLOSED';
      this.failureCount = 0;
    }
  }
  
  private onFailure(): void {
    this.failureCount++;
    if (this.failureCount >= this.config.failureThreshold) {
      this.state = 'OPEN';
      this.lastFailureTime = Date.now();
    }
  }
}
```

### 2.3 Retry Strategy
```typescript
interface RetryConfig {
  maxAttempts: number;
  backoffPeriod: number;
  maxBackoffPeriod: number;
  backoffMultiplier: number;
}

class RetryStrategy {
  constructor(private config: RetryConfig) {}
  
  async execute<T>(command: () => Promise<T>): Promise<T> {
    let attempts = 0;
    let lastError: Error;
    
    while (attempts < this.config.maxAttempts) {
      try {
        return await command();
      } catch (error) {
        lastError = error;
        attempts++;
        
        if (attempts === this.config.maxAttempts) {
          throw error;
        }
        
        await this.delay(this.getBackoffTime(attempts));
      }
    }
    
    throw lastError;
  }
  
  private getBackoffTime(attempt: number): number {
    const backoff = this.config.backoffPeriod * Math.pow(this.config.backoffMultiplier, attempt - 1);
    return Math.min(backoff, this.config.maxBackoffPeriod);
  }
  
  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

## 3. Fallback Mekanizması

### 3.1 Fallback Configuration
```typescript
interface FallbackConfig {
  defaultResponse: unknown;
  cacheTimeout: number;
  shouldCache: boolean;
}

class FallbackMechanism<T> {
  private cache: Map<string, CacheEntry<T>> = new Map();
  
  constructor(private config: FallbackConfig) {}
  
  async execute(
    key: string,
    command: () => Promise<T>,
    fallback: () => Promise<T>
  ): Promise<T> {
    try {
      const result = await command();
      if (this.config.shouldCache) {
        this.cache.set(key, {
          data: result,
          timestamp: Date.now()
        });
      }
      return result;
    } catch (error) {
      const cachedValue = this.cache.get(key);
      if (cachedValue && !this.isCacheExpired(cachedValue)) {
        return cachedValue.data;
      }
      return fallback();
    }
  }
  
  private isCacheExpired(entry: CacheEntry<T>): boolean {
    return Date.now() - entry.timestamp > this.config.cacheTimeout;
  }
}
```

## 4. Health Check

### 4.1 Health Check Implementation
```typescript
interface HealthStatus {
  status: 'UP' | 'DOWN' | 'UNKNOWN';
  details: Record<string, unknown>;
  timestamp: number;
}

class HealthCheck {
  private checks: Map<string, () => Promise<HealthStatus>> = new Map();
  
  registerCheck(name: string, check: () => Promise<HealthStatus>): void {
    this.checks.set(name, check);
  }
  
  async performHealthCheck(): Promise<HealthStatus> {
    const results = new Map<string, HealthStatus>();
    
    for (const [name, check] of this.checks) {
      try {
        results.set(name, await check());
      } catch (error) {
        results.set(name, {
          status: 'DOWN',
          details: { error: error.message },
          timestamp: Date.now()
        });
      }
    }
    
    return {
      status: this.aggregateStatus(results),
      details: Object.fromEntries(results),
      timestamp: Date.now()
    };
  }
  
  private aggregateStatus(results: Map<string, HealthStatus>): 'UP' | 'DOWN' | 'UNKNOWN' {
    let hasUnknown = false;
    
    for (const status of results.values()) {
      if (status.status === 'DOWN') {
        return 'DOWN';
      }
      if (status.status === 'UNKNOWN') {
        hasUnknown = true;
      }
    }
    
    return hasUnknown ? 'UNKNOWN' : 'UP';
  }
}
```

## 5. Load Balancing

### 5.1 Load Balancer Configuration
```yaml
load_balancer:
  algorithm: "round_robin"  # round_robin, least_connections, random
  health_check:
    interval: "10s"
    timeout: "5s"
    healthy_threshold: 2
    unhealthy_threshold: 3
    
  sticky_sessions:
    enabled: true
    cookie_name: "SERVERID"
    
  backends:
    - name: "process-service-1"
      weight: 100
      max_connections: 1000
      
    - name: "process-service-2"
      weight: 100
      max_connections: 1000
```

### 5.2 Load Balancer Implementation
```typescript
class LoadBalancer {
  private currentIndex = 0;
  private servers: Server[] = [];
  
  addServer(server: Server): void {
    this.servers.push(server);
  }
  
  removeServer(serverId: string): void {
    this.servers = this.servers.filter(s => s.id !== serverId);
  }
  
  getNextServer(): Server {
    if (this.servers.length === 0) {
      throw new Error('No servers available');
    }
    
    const server = this.servers[this.currentIndex];
    this.currentIndex = (this.currentIndex + 1) % this.servers.length;
    
    return server;
  }
  
  updateServerHealth(serverId: string, isHealthy: boolean): void {
    const server = this.servers.find(s => s.id === serverId);
    if (server) {
      server.healthy = isHealthy;
    }
  }
}
```