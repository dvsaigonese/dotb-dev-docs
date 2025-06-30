# Docker Setup Guide for DOTB API Documentation

This guide describes how to run DOTB API Documentation using Docker and Docker Compose with optimized configurations for minimal image size and better performance.

## Requirements

- Docker
- Docker Compose

## Quick Start

### 1. Quick Run (Recommended)

```bash
chmod +x docker-run.sh
./docker-run.sh
```

### 2. Manual Run

```bash
# Build and run with optimized settings
docker-compose up --build -d

# Access at http://localhost:8081
```

### 3. Run from Docker Image

```bash
# Build optimized image
docker build -t dotb-api-docs .

# Run container with resource limits
docker run -d -p 8080:80 --name dotb-docs \
  --memory=64m --cpus=0.5 \
  dotb-api-docs
```

## Useful Commands

```bash
# View logs
docker-compose logs -f

# Stop container
docker-compose down

# Full rebuild
docker-compose up --build --force-recreate

# Access container for debugging
docker-compose exec dotb-api-docs sh

# Remove everything (containers + images)
docker-compose down --rmi all

# Check resource usage
docker stats dotb-api-documentation

# View image size
docker images dotb-api-docs
```

## Optimization Features

### Image Size Optimization
- **Multi-stage build**: Separate build and runtime stages
- **Alpine Linux**: Minimal base images (Node.js 18-alpine, Nginx 1.25-alpine)
- **Cleanup**: Remove node_modules, npm cache after build
- **Comprehensive .dockerignore**: Exclude unnecessary files

### Performance Optimization
- **Nginx tuning**: Optimized worker processes and buffer sizes
- **Gzip compression**: Enabled for all text-based files
- **Static asset caching**: 1-year cache for assets, 1-hour for JSON
- **Resource limits**: 64MB memory limit, 0.5 CPU limit

### Security Features
- **Security headers**: X-Frame-Options, X-Content-Type-Options, etc.
- **Read-only filesystem**: Container runs in read-only mode
- **No new privileges**: Security option enabled
- **Minimal logging**: Reduced log verbosity for production

## File Structure

- **Dockerfile**: Optimized multi-stage build (Node.js → Nginx)
- **docker-compose.yml**: Container orchestration with resource limits
- **nginx.conf**: Performance-tuned Nginx configuration
- **.dockerignore**: Comprehensive file exclusion list

## Access

After successful startup, access the documentation at:
**http://localhost:8081**

## Apache Proxy Configuration

For production deployment, use the included Apache configuration files:

### Files Included:
- **apache-http.conf**: HTTP (port 80) configuration with HTTPS redirect
- **apache-https.conf**: HTTPS (port 443) configuration with proxy to container

### Setup Instructions:

1. **Copy configuration files to Apache:**
```bash
# Copy to Apache sites-available
sudo cp apache-http.conf /etc/apache2/sites-available/developer.dotb.cloud.conf
sudo cp apache-https.conf /etc/apache2/sites-available/developer.dotb.cloud-ssl.conf
```

2. **Enable required Apache modules:**
```bash
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod headers
sudo a2enmod rewrite
```

3. **Enable sites:**
```bash
sudo a2ensite developer.dotb.cloud.conf
sudo a2ensite developer.dotb.cloud-ssl.conf
```

4. **Add SSL certificates to HTTPS config:**
Edit `apache-https.conf` and uncomment/update SSL certificate paths:
```apache
SSLCertificateFile /path/to/your/certificate.crt
SSLCertificateKeyFile /path/to/your/private.key
SSLCertificateChainFile /path/to/your/ca-bundle.crt
```

5. **Restart Apache:**
```bash
sudo systemctl restart apache2
```

### Access Points:
- **Direct Container**: http://192.168.0.138:8081
- **Via Apache HTTP**: http://developer.dotb.cloud (redirects to HTTPS)
- **Via Apache HTTPS**: https://developer.dotb.cloud

## Performance Metrics

Expected image size: ~25-30MB (vs ~100MB+ unoptimized)
Memory usage: ~32-64MB runtime
CPU usage: Minimal (0.1-0.5 cores)

## Troubleshooting

### Port 8081 already in use
```bash
# Change port in docker-compose.yml
ports:
  - "3000:80"  # Change 8081 to 3000
```

### Build errors
```bash
# Clear cache and rebuild
docker-compose down
docker system prune -f
docker-compose up --build
```

### High memory usage
```bash
# Check resource limits in docker-compose.yml
# Adjust memory limits if needed
deploy:
  resources:
    limits:
      memory: 32M  # Reduce if needed
```

### Container health issues
```bash
# Check health status
docker-compose ps

# View detailed health check logs
docker inspect dotb-api-documentation | grep -A 10 Health
```
