# Development Environment Setup

## Git Workflow ve Branch Stratejisi

### Branch Yapısı
- `main`: Production ortamı için kararlı sürüm
- `development`: Geliştirme ortamı için ana branch
- `feature/*`: Yeni özellik geliştirmeleri
- `bugfix/*`: Hata düzeltmeleri
- `hotfix/*`: Acil production düzeltmeleri
- `release/*`: Sürüm hazırlıkları

### Branch Kuralları
1. **Feature Development**
   - `development`'dan `feature/[issue-no]-[feature-name]` branch'i açılır
   - Geliştirme tamamlandığında `development`'a PR açılır
   - Code review sonrası merge edilir

2. **Bug Fixes**
   - `development`'dan `bugfix/[issue-no]-[bug-description]` branch'i açılır
   - Fix tamamlandığında `development`'a PR açılır
   - Test sonrası merge edilir

3. **Hotfixes**
   - `main`'den `hotfix/[issue-no]-[description]` branch'i açılır
   - Fix tamamlandığında hem `main` hem `development`'a PR açılır
   - Acil olarak deploy edilir

4. **Releases**
   - `development`'dan `release/v[major].[minor].[patch]` branch'i açılır
   - Test ve son düzeltmeler yapılır
   - `main`'e merge edilir ve tag oluşturulur

### Commit Conventions
- feat: Yeni özellik
- fix: Hata düzeltmesi
- docs: Dokümantasyon değişiklikleri
- style: Kod formatı değişiklikleri
- refactor: Kod refactoring
- test: Test ekleme/düzenleme
- chore: Genel bakım

### PR Süreci
1. PR template kullanılmalı
2. En az 1 reviewer onayı gerekli
3. CI testleri başarılı olmalı
4. Conflict olmamalı
5. Branch güncel olmalı

## IDE Setup

### VS Code
#### Gerekli Extension'lar
- ESLint
- Prettier
- GitLens
- Docker
- Kubernetes
- REST Client
- Thunder Client
- Error Lens
- Auto Import
- Path Intellisense
- Material Icon Theme

#### Workspace Settings
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "typescript.updateImportsOnFileMove.enabled": "always",
  "javascript.updateImportsOnFileMove.enabled": "always"
}
```

### WebStorm (Alternatif)
- Material Theme
- Atom Material Icons
- .env files support
- GitToolBox
- Kubernetes
- Prettier

## Local Development

### Gerekli Araçlar
- Node.js >= 18
- pnpm
- Docker Desktop
- Kubernetes (Docker Desktop ile gelir)
- Git

### Ortam Kurulumu
1. Repository clone'lama:
   ```bash
   git clone https://github.com/furkan-ucan/BPMN-PLATFORM.git
   cd BPMN-PLATFORM
   ```

2. Bağımlılıkları yükleme:
   ```bash
   pnpm install
   ```

3. Environment dosyaları:
   ```bash
   cp .env.example .env
   ```

4. Development sunucusunu başlatma:
   ```bash
   pnpm dev
   ```

### Docker Compose
```yaml
version: '3.8'
services:
  postgres:
    image: postgres:latest
    environment:
      POSTGRES_USER: bpmn
      POSTGRES_PASSWORD: bpmn123
      POSTGRES_DB: bpmn_platform
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:latest
    ports:
      - "6379:6379"

  rabbitmq:
    image: rabbitmq:management
    ports:
      - "5672:5672"
      - "15672:15672"

volumes:
  postgres_data:
```

### Debugging
1. VS Code Debug Configuration
2. Chrome DevTools
3. Backend Debug Port: 9229
4. Frontend Debug Port: 9222

### Testing
1. Unit Tests: `pnpm test`
2. E2E Tests: `pnpm test:e2e`
3. Integration Tests: `pnpm test:integration`

### Linting ve Formatting
1. Lint: `pnpm lint`
2. Format: `pnpm format`
3. Type Check: `pnpm type-check`

## CI/CD Pipeline

### Local Pipeline Test
1. GitHub Actions Local Test:
   ```bash
   act -n
   ```

2. Docker Build Test:
   ```bash
   docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
   ```

## Troubleshooting

### Sık Karşılaşılan Sorunlar
1. Port çakışmaları
2. Node modülleri hataları
3. Docker volume permission sorunları
4. Git conflict çözümleri

### Çözüm Yolları
1. Port kullanımı kontrol: `netstat -ano | findstr :[PORT]`
2. Node modülleri temizleme: `pnpm clean`
3. Docker reset: `docker system prune -a`
4. Git reset: `git reset --hard origin/development` 