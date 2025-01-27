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

# Frontend package dosyasını kopyala
COPY frontend/package.json ./frontend/

# TypeScript ve diğer bağımlılıkları yükle
RUN cd frontend && \
    pnpm install && \
    pnpm add -D typescript@latest && \
    pnpm add -D @types/node@latest

# Kaynak kodları kopyala
COPY frontend ./frontend/

# Development için gerekli portları aç
EXPOSE 3000

# Development modunda çalıştır
WORKDIR /app/frontend
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

# Frontend package dosyasını kopyala
COPY frontend/package.json ./frontend/

# Sadece production bağımlılıkları yükle ve build
RUN cd frontend && \
    pnpm install --prod && \
    pnpm build

# Build çıktısını nginx'e kopyala
FROM nginx:alpine

# Nginx yapılandırması
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf

# Build çıktısını kopyala
COPY --from=production /app/frontend/dist /usr/share/nginx/html

# Port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1 