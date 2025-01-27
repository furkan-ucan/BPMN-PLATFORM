# Development stage
FROM node:18-alpine AS development

# Temel gereksinimler ve build araçları
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    git \
    curl \
    bash

# pnpm kurulumu
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Root package dosyalarını kopyala
COPY package.json pnpm-workspace.yaml ./

# Backend package dosyasını kopyala
COPY backend/package.json ./backend/

# TypeScript ve diğer bağımlılıkları yükle
RUN cd backend && \
    pnpm install && \
    pnpm add -D typescript@latest @types/node@latest && \
    pnpm exec tsc --init

# Kaynak kodları kopyala
COPY backend ./backend/

# tsconfig.json oluştur
COPY backend/tsconfig.json ./backend/

# TypeScript build
RUN cd backend && pnpm exec tsc

# Development için gerekli portları aç
EXPOSE 3001 9229

# Development modunda çalıştır
WORKDIR /app/backend
CMD ["pnpm", "dev"]

# Production stage
FROM node:18-alpine AS production

# Temel gereksinimler
RUN apk add --no-cache \
    python3 \
    make \
    g++

# pnpm kurulumu
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# Root package dosyalarını kopyala
COPY package.json pnpm-workspace.yaml ./

# Backend package dosyasını kopyala
COPY backend/package.json ./backend/

# Sadece production bağımlılıklarını yükle
RUN cd backend && pnpm install --prod

# Build çıktısını development stage'den kopyala
COPY --from=development /app/backend/dist ./backend/dist

# Production için gerekli portları aç
EXPOSE 3001

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3001/health || exit 1

# Production modunda çalıştır
WORKDIR /app/backend
CMD ["node", "dist/main"]