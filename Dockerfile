# Dockerfile per deployment web Kai (Compose Multiplatform WASM)

# Build stage - Build WASM
FROM node:22-alpine AS builder

# Install Gradle per build Kotlin Multiplatform
RUN apk add --no-cache unzip && \
    wget -q https://services.gradle.org/distributions/gradle-8.11.1-bin.zip && \
    unzip -q gradle-8.11.1-bin.zip && \
    mv gradle-8.11.1 /opt/gradle && \
    rm -rf /opt/gradle-bin.zip

# Set working directory
WORKDIR /build

# Copy Gradle wrapper files
COPY gradle.* ./
COPY gradlew ./
RUN chmod +x gradlew

# Copy project source
COPY composeApp ./composeApp

# Build WASM target (wasmJsBrowser)
RUN ./gradlew :composeApp:wasmJsBrowser --no-daemon

# Production stage - Nginx serving WASM
FROM nginx:alpine

# Set working directory
WORKDIR /app

# Copy built WASM files from builder stage
COPY --from=builder /build/composeApp/build/wasmJsBrowser/wasmJsBrowser/wasmJsBrowser /usr/share/nginx/html

# Copy custom Nginx configuration
COPY --from=builder /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=60s \
    CMD wget --quiet --spider http://localhost:3000/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
