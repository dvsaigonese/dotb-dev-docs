# Apache Proxy Setup Guide for DOTB API Documentation

This guide explains how to configure Apache as a reverse proxy for the DOTB API Documentation Docker container.

## Prerequisites

- Apache2 installed and running
- Docker container running on 192.168.0.138:8081
- SSL certificates for developer.dotb.cloud domain
- Root or sudo access

## Quick Setup

### 1. Install Required Apache Modules

```bash
# Enable necessary modules
sudo a2enmod ssl
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod headers
sudo a2enmod rewrite
sudo a2enmod deflate
```

### 2. Copy Configuration Files

```bash
# Copy the provided configuration files
sudo cp apache-http.conf /etc/apache2/sites-available/developer.dotb.cloud.conf
sudo cp apache-https.conf /etc/apache2/sites-available/developer.dotb.cloud-ssl.conf

# Copy security configuration to conf-available
sudo cp apache-security.conf /etc/apache2/conf-available/dotb-security.conf

# Enable security configuration
sudo a2enconf dotb-security
```

### 3. Configure SSL Certificates

Edit the HTTPS configuration file:

```bash
sudo nano /etc/apache2/sites-available/developer.dotb.cloud-ssl.conf
```

Uncomment and update these lines with your SSL certificate paths:
```apache
SSLCertificateFile /path/to/your/certificate.crt
SSLCertificateKeyFile /path/to/your/private.key
SSLCertificateChainFile /path/to/your/ca-bundle.crt
```

### 4. Enable Sites

```bash
# Enable both HTTP and HTTPS sites
sudo a2ensite developer.dotb.cloud.conf
sudo a2ensite developer.dotb.cloud-ssl.conf

# Disable default site (optional)
sudo a2dissite 000-default
```

### 5. Test Configuration

```bash
# Test Apache configuration
sudo apache2ctl configtest

# If OK, restart Apache
sudo systemctl restart apache2
```

## Configuration Details

### HTTP Configuration (Port 80)
- **Purpose**: Redirects all HTTP traffic to HTTPS
- **File**: `apache-http.conf`
- **Behavior**: 301 redirect to https://developer.dotb.cloud

### HTTPS Configuration (Port 443)
- **Purpose**: Proxies requests to Docker container
- **File**: `apache-https.conf`
- **Target**: http://192.168.0.138:8081
- **Features**:
  - SSL termination
  - Security headers
  - Compression enabled
  - WebSocket support
  - Detailed logging

## Access Points

After successful configuration:

| Method | URL | Description |
|--------|-----|-------------|
| Direct | http://192.168.0.138:8081 | Direct container access |
| HTTP | http://developer.dotb.cloud | Redirects to HTTPS |
| HTTPS | https://developer.dotb.cloud | Production access via Apache |

## Security Features

### Implemented Security Headers:
- `X-Frame-Options: SAMEORIGIN`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Strict-Transport-Security: max-age=31536000; includeSubDomains`

### Additional Security:
- Server tokens disabled
- SSL-only access (HTTP redirects)
- Compression for better performance

## Troubleshooting

### Apache won't start after configuration
```bash
# Check configuration syntax
sudo apache2ctl configtest

# Check Apache error logs
sudo tail -f /var/log/apache2/error.log
```

### ServerTokens configuration error
If you see error: "ServerTokens cannot occur within VirtualHost section"

```bash
# This error is fixed by using the separate security configuration
# Make sure apache-security.conf is enabled:
sudo a2enconf dotb-security

# Test configuration
sudo apache2ctl configtest

# Restart Apache
sudo systemctl restart apache2
```

### 502 Bad Gateway error
```bash
# Check if Docker container is running
docker ps | grep dotb-api-documentation

# Verify container is accessible
curl http://192.168.0.138:8081

# Check Apache proxy error logs
sudo tail -f /var/log/apache2/developer.dotb.cloud_ssl_error.log
```

### SSL certificate issues
```bash
# Test SSL certificate
openssl s_client -connect developer.dotb.cloud:443

# Check certificate expiration
openssl x509 -in /path/to/certificate.crt -text -noout
```

### Port conflicts
```bash
# Check what's using ports 80/443
sudo netstat -tlnp | grep ':80\|:443'

# Stop conflicting services if needed
sudo systemctl stop nginx  # If nginx is running
```

## Monitoring

### Log Files
- **HTTP Access**: `/var/log/apache2/developer.dotb.cloud_access.log`
- **HTTP Error**: `/var/log/apache2/developer.dotb.cloud_error.log`
- **HTTPS Access**: `/var/log/apache2/developer.dotb.cloud_ssl_access.log`
- **HTTPS Error**: `/var/log/apache2/developer.dotb.cloud_ssl_error.log`

### Monitor Traffic
```bash
# Real-time access log monitoring
sudo tail -f /var/log/apache2/developer.dotb.cloud_ssl_access.log

# Check Apache status
sudo systemctl status apache2

# Monitor proxy backend
curl -I http://192.168.0.138:8081
```

## Maintenance

### Restart Services
```bash
# Restart Apache only
sudo systemctl restart apache2

# Restart Docker container
docker-compose restart dotb-api-docs

# Restart both
sudo systemctl restart apache2 && docker-compose restart dotb-api-docs
```

### Update SSL Certificates
```bash
# After updating certificate files
sudo systemctl reload apache2
```

### Configuration Changes
```bash
# After modifying config files
sudo apache2ctl configtest
sudo systemctl reload apache2
```
