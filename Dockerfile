# Stage 1: Build documentation
FROM node:18-alpine AS builder

# Install dependencies
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Copy source files
COPY . .

# Build documentation following README workflow
RUN npx redocly bundle openapi/openapi.yaml -o docs/dist.json

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built documentation
COPY --from=builder /app/docs/ /usr/share/nginx/html/

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
