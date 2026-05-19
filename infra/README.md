# Kai Web App Deployment Strategy

## Overview

This repository contains the infrastructure and deployment configuration for the Kai web app (Compose Multiplatform WASM build).

## Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      PORTAINER ENVIRONMENT                  │
│                                                               │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                  Kai Web Container                       │ │
│  │  ┌─────────────────────────────────────────────────────┐ │ │
│  │  │  Nginx (alpine) - Port 3000                        │ │ │
│  │  │  - Serves WASM build                                │ │ │
│  │  │  - SPA routing support                              │ │ │
│  │  │  - Gzip compression                                 │ │ │
│  │  │  - Caching for static assets                        │ │ │
│  │  │  - Health checks                                    │ │ │
│  │  └─────────────────────────────────────────────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## File Structure

```
Kai/
├── Dockerfile                          # Multi-stage build for WASM + Nginx
├── docker-compose.yml                  # Portainer deployment config
├── infra/
│   ├── nginx/
│   │   └── nginx.conf                  # Nginx configuration
│   └── README.md                       # This file
├── composeApp/                         # Compose Multiplatform source
├── .github/
│   └── workflows/                      # CI/CD pipelines
└── ...
```

## Deployment Steps

### 1. Build the Application

**Option A: Local Build**
```bash
# Build WASM
./gradlew :composeApp:wasmJsBrowser

# Test locally
./gradlew :composeApp:runWasmJsBrowser
```

**Option B: Docker Build**
```bash
# Build Docker image
docker build -t gitlogos/kai-web:latest .

# Verify build
docker run -d -p 3000:3000 gitlogos/kai-web:latest
```

### 2. Deploy to Portainer

**Using docker-compose.yml:**
```bash
# Build and start
docker-compose up -d

# Check health
docker-compose ps
docker inspect kai-web | grep "Health"

# View logs
docker-compose logs -f
```

**In Portainer UI:**
1. Go to **Environments** → Select your environment
2. Click **Stacks** → **Create stack**
3. Name: `kai-web`
4. Image: `gitlogos/kai-web:latest`
5. Ports: `3000:3000`
6. Click **Deploy**

### 3. Monitoring

**Health Check:**
- Nginx healthcheck runs every 30 seconds
- First 60 seconds are start period (not counted as failure)
- 3 consecutive failures = container restart

**Logs:**
```bash
# View nginx logs
docker-compose logs kai-web

# Real-time logs
docker-compose logs -f kai-web
```

## Nginx Configuration

### SPA Routing
```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```
All routes redirect to `index.html` for client-side routing (Compose Multiplatform).

### Caching Strategy
- **Static assets** (WASM, JS, CSS, images): 1 year cache
- **Temporary files**: 1 day cache
- **Gzip**: Enabled for text-based resources

### Security Headers
```nginx
add_header X-Frame-Options SAMEORIGIN;
add_header X-Content-Type-Options nosniff;
add_header X-XSS-Protection "1; mode=block";
```

## Performance Optimizations

| Feature | Benefit |
|---------|---------|
| Multi-stage build | Smaller image (~50MB) |
| Gzip compression | 60-80% smaller payloads |
| Aggressive caching | Faster repeat visits |
| SPA routing | No server redirects for navigation |
| Health checks | Auto-recovery from failures |

## Scaling Strategy

### Horizontal Scaling (Future)
```yaml
services:
  kai-web:
    replicas: 3  # Load balancer needed
    healthcheck: ...
```

### Load Balancer (Nginx)
```bash
# Deploy Nginx load balancer
docker run -d -p 80:80 -p 443:443 nginx:alpine
```

## Rollback Strategy

```bash
# Rollback to previous version
docker-compose down
docker-compose up -d --build
```

## Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs kai-web

# Restart container
docker-compose restart kai-web

# Inspect health
docker inspect kai-web | grep -A 20 "State"
```

### High memory usage
```bash
# Check memory
docker stats kai-web

# Increase memory limit in docker-compose.yml
mem_limit: 512m
```

## API Endpoints (Optional)

If Kai has backend API calls, enable the API location:
```nginx
location /api/ {
    proxy_pass http://localhost:8080;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

## Maintenance

### Update Image
```bash
# Pull latest image
docker-compose pull
docker-compose up -d

# Verify deployment
docker-compose ps
```

### Backup
```bash
# Export current state
docker-compose config > kai-compose.yml.backup

# Restore
docker-compose config < kai-compose.yml.backup
```

## License

Same as the main repository.
