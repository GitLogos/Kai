FROM alpine:3.21

# Install Java 17 and Gradle
RUN apk add --no-cache \
    openjdk17-jre \
    gradle

# Copy application
WORKDIR /app
COPY . .

# Build WASM production target
RUN ./gradlew :composeApp:wasmJsBrowserProductionRun --no-daemon

# Production stage - Nginx serving WASM
FROM nginx:alpine
COPY --from=0 /app/build/wasmJsBrowser/wasmJsBrowser/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]