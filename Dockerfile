# Kai Web Application Dockerfile
# Serves the Compose Multiplatform Web build
# Uses Nginx for production-grade serving

# Base image: Alpine with Nginx for lightweight serving
FROM nginx:alpine

# Install Node.js for potential CLI tools if needed
# RUN apk add --no-cache nodejs npm

# Copy the compiled web application
COPY composeApp/build/wasmJsBrowser/wasmJsBrowser/wasmJsBrowser /usr/share/nginx/html

# Copy a custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
