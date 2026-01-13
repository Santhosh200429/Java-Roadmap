# Docker: Containerizing Java Applications

## What is Docker?

**Docker** packages your entire application (code, dependencies, JVM) into a **container** - a lightweight, portable, isolated environment.

**Real-world analogy**: Docker is like a shipping container. Your application and all its requirements are packed into one container, so it runs the same everywhere.

## Why Docker?

- **Consistency**: Works same on laptop, testing, production
- **Isolation**: Application doesn't interfere with system
- **Easy deployment**: Ship container to any server
- **Lightweight**: Uses less resources than virtual machines
- **Scalability**: Run multiple containers easily

## Docker Basics

### Images vs Containers

- **Image**: Blueprint (like a cookie cutter)
- **Container**: Running instance (like a baked cookie)

```
Docker Image â†’ Docker Container
(Template)    (Running Instance)
```

## Installing Docker

### Windows/Mac
1. Download [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Install and run

### Linux
```bash
sudo apt-get install docker.io
```

Verify:
```bash
docker --version
```

## Creating a Dockerfile

A **Dockerfile** is instructions to build a Docker image.

```dockerfile
# Start from official Java image
FROM openjdk:17-jdk-slim

# Set working directory in container
WORKDIR /app

# Copy jar file
COPY target/myapp.jar app.jar

# Expose port
EXPOSE 8080

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Multi-Stage Build (Smaller image)

```dockerfile
# Stage 1: Build
FROM maven:3.8.1-openjdk-17 AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

## Building Image

```bash
# Build image
docker build -t myapp:1.0 .

# List images
docker images

# Remove image
docker rmi myapp:1.0
```

## Running Container

```bash
# Basic run
docker run -d -p 8080:8080 myapp:1.0

# With environment variables
docker run -d \
  -p 8080:8080 \
  -e DB_HOST=localhost \
  -e DB_PORT=3306 \
  myapp:1.0

# With volume (persistent storage)
docker run -d \
  -p 8080:8080 \
  -v /app/logs:/logs \
  myapp:1.0

# Interactive (see logs)
docker run -it -p 8080:8080 myapp:1.0
```

### Common Commands

```bash
# List running containers
docker ps

# List all containers
docker ps -a

# View logs
docker logs container_id

# Stop container
docker stop container_id

# Start container
docker start container_id

# Remove container
docker rm container_id

# Execute command in container
docker exec -it container_id bash
```

## Complete Example: Spring Boot App

### Dockerfile

```dockerfile
FROM maven:3.8.1-openjdk-17 AS builder
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
```

### Build and Run

```bash
# Build jar first
mvn clean package

# Build Docker image
docker build -t studentapp:1.0 .

# Run container
docker run -d \
  --name student-app \
  -p 8080:8080 \
  studentapp:1.0

# Check logs
docker logs student-app

# Test API
curl http://localhost:8080/api/students
```

## Docker Compose (Multiple Containers)

**docker-compose.yml**: Define multiple services

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      DB_HOST: db
      DB_PORT: 3306
      DB_NAME: student_db
      DB_USER: root
      DB_PASSWORD: password
    depends_on:
      - db

  db:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: student_db
    volumes:
      - db-data:/var/lib/mysql

volumes:
  db-data:
```

### Run with Compose

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# View running services
docker-compose ps
```

## Best Practices

### 1. Minimal Base Image
```dockerfile
# âŒ Large
FROM openjdk:17

# Smaller
FROM openjdk:17-jdk-slim
```

### 2. Multi-Stage Builds
```dockerfile
# Reduces image size by separating build from runtime
FROM maven:3.8 AS builder
RUN mvn clean package

FROM openjdk:17-slim
COPY --from=builder /build/target/*.jar app.jar
```

### 3. Cache Layers
```dockerfile
# Dependencies cached separately
FROM maven:3.8
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package
```

### 4. Security
```dockerfile
# Run as non-root user
FROM openjdk:17-slim
RUN useradd -m appuser
USER appuser
```

## Common Issues

### Port Already in Use
```bash
# Find process using port
lsof -i :8080

# Use different port
docker run -p 8081:8080 myapp
```

### Container Exits Immediately
```bash
# Check logs
docker logs container_id

# Run interactively to debug
docker run -it myapp /bin/bash
```

## Key Takeaways

- Docker packages application + dependencies
- Dockerfile defines build instructions
- Image is template, container is instance
- `docker build` creates image
- `docker run` starts container
- Multi-stage builds reduce image size
- Docker Compose manages multiple containers

---


