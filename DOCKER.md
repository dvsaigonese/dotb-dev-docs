# Hướng Dẫn Chạy với Docker

Hướng dẫn này mô tả cách chạy DOTB API Documentation bằng Docker và Docker Compose.

## Yêu Cầu

- Docker
- Docker Compose

## Cách Chạy

### 1. Chạy Nhanh (Khuyên dùng)

```bash
chmod +x docker-run.sh
./docker-run.sh
```

### 2. Chạy Thủ Công

```bash
# Build và chạy
docker-compose up --build -d

# Truy cập tại http://localhost:8080
```

### 3. Chạy Từ Docker Image

```bash
# Build image
docker build -t dotb-api-docs .

# Chạy container
docker run -d -p 8080:80 --name dotb-docs dotb-api-docs
```

## Các Lệnh Hữu Ích

```bash
# Xem logs
docker-compose logs -f

# Dừng container
docker-compose down

# Rebuild toàn bộ
docker-compose up --build --force-recreate

# Vào container để debug
docker-compose exec dotb-api-docs sh

# Xóa toàn bộ (container + image)
docker-compose down --rmi all
```

## Cấu Trúc

- **Dockerfile**: Multi-stage build (Node.js → Nginx)
- **docker-compose.yml**: Orchestration với port 8080
- **nginx.conf**: Cấu hình Nginx với gzip và security headers

## Truy Cập

Sau khi chạy thành công, truy cập documentation tại:
**http://localhost:8080**

## Troubleshooting

### Port 8080 đã được sử dụng
```bash
# Thay đổi port trong docker-compose.yml
ports:
  - "3000:80"  # Thay 8080 thành 3000
```

### Build lỗi
```bash
# Xóa cache và rebuild
docker-compose down
docker system prune -f
docker-compose up --build
```

### Không thấy thay đổi
```bash
# Force rebuild
docker-compose up --build --force-recreate
```
