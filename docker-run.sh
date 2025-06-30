#!/bin/bash

echo "🚀 Starting build and run DOTB API Documentation..."

# Build and run container
docker-compose up --build -d

echo "✅ Documentation has been started!"
echo "🌐 Access at: http://localhost:8081"
echo ""
echo "📋 Useful commands:"
echo "  - View logs: docker-compose logs -f"
echo "  - Stop container: docker-compose down"
echo "  - Rebuild: docker-compose up --build"
