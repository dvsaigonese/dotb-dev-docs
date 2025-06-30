# Stage 1: Build documentation
FROM node:18-alpine AS builder

# Set working directory and install dependencies in one layer
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production --no-cache && \
    npm cache clean --force

# Copy source files and build documentation
COPY . .
RUN npx redocly bundle openapi/openapi.yaml -o docs/dist.json && \
    rm -rf node_modules

# Stage 2: Minimal nginx serving
FROM nginx:1.25-alpine

# Remove default nginx files and copy optimized configuration
RUN rm -rf /usr/share/nginx/html/* && \
    rm /etc/nginx/conf.d/default.conf

# Copy built documentation and nginx configuration
COPY --from=builder /app/docs/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/nginx.conf

# Set proper permissions for nginx
RUN chown -R nginx:nginx /usr/share/nginx/html

# Expose port
EXPOSE 80

# Start nginx with optimized settings
CMD ["nginx", "-g", "daemon off;"]
