# CI/CD Pipelines: Automated Testing & Deployment

## What is CI/CD?

**CI/CD** automates the process of building, testing, and deploying code changes.

**Real-world analogy**: CI/CD is like an assembly line - code changes automatically flow through quality checks and get deployed.

### CI (Continuous Integration)
- Developers push code frequently (multiple times per day)
- Automated tests run immediately
- Build failures caught early
- Team stays in sync

### CD (Continuous Deployment)
- Tested code automatically deployed to production
- No manual deployment steps
- Features reach users faster

## GitHub Actions

### Basic Structure

```yaml
name: Java CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    # Step 1: Checkout code
    - uses: actions/checkout@v3
    
    # Step 2: Setup Java
    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: maven
    
    # Step 3: Build with Maven
    - name: Build with Maven
      run: mvn clean package
    
    # Step 4: Run tests
    - name: Run tests
      run: mvn test
```

### Complete Maven Build Pipeline

```yaml
name: Maven Build & Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        java-version: [ '17', '21' ]  # Test on multiple versions
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK ${{ matrix.java-version }}
      uses: actions/setup-java@v3
      with:
        java-version: ${{ matrix.java-version }}
        distribution: 'temurin'
        cache: maven
    
    - name: Build
      run: mvn clean compile
    
    - name: Run Unit Tests
      run: mvn test
    
    - name: Run Integration Tests
      run: mvn verify
    
    - name: Check Code Quality (SpotBugs)
      run: mvn spotbugs:check
    
    - name: Upload Coverage Reports
      uses: codecov/codecov-action@v3
      if: always()
```

## Database Testing

### CI Pipeline with Database

```yaml
name: Maven with Database

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_DATABASE: testdb
          MYSQL_USER: testuser
          MYSQL_PASSWORD: testpass
          MYSQL_ROOT_PASSWORD: rootpass
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
        ports:
          - 3306:3306
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: maven
    
    - name: Wait for MySQL
      run: |
        until mysqladmin ping -h localhost -u root -prootpass; do
          echo 'waiting for mysql...'
          sleep 1
        done
    
    - name: Run Tests
      run: mvn clean test
      env:
        SPRING_DATASOURCE_URL: jdbc:mysql://localhost:3306/testdb
        SPRING_DATASOURCE_USERNAME: testuser
        SPRING_DATASOURCE_PASSWORD: testpass
```

## Docker Build & Push

### Build and Push Docker Image

```yaml
name: Build and Push Docker Image

on:
  push:
    branches: [ main ]

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: maven
    
    - name: Build JAR
      run: mvn clean package -DskipTests
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2
    
    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
    
    - name: Build and Push
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: |
          ${{ secrets.DOCKER_USERNAME }}/myapp:latest
          ${{ secrets.DOCKER_USERNAME }}/myapp:${{ github.sha }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
```

## Deploy to Cloud

### Deploy to Azure App Service

```yaml
name: Deploy to Azure

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: maven
    
    - name: Build JAR
      run: mvn clean package -DskipTests
    
    - name: Deploy to Azure
      uses: azure/webapps-deploy@v2
      with:
        app-name: my-java-app
        publish-profile: ${{ secrets.AZURE_PUBLISH_PROFILE }}
        package: target/*.jar
```

### Deploy to AWS EC2

```yaml
name: Deploy to AWS

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: maven
    
    - name: Build JAR
      run: mvn clean package -DskipTests
    
    - name: Deploy via SSH
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ${{ secrets.EC2_USER }}
        key: ${{ secrets.EC2_SSH_KEY }}
        script: |
          cd /app
          aws s3 cp s3://mybucket/app.jar ./
          systemctl restart myapp
```

## Complete Real-World Pipeline

```yaml
name: Complete CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: docker.io
  IMAGE_NAME: mycompany/myapp

jobs:
  # Stage 1: Code Quality
  quality:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: maven
    
    - name: SonarQube Analysis
      run: mvn sonar:sonar -Dsonar.projectKey=myapp

  # Stage 2: Build & Test
  build:
    runs-on: ubuntu-latest
    needs: quality
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: maven
    
    - name: Build
      run: mvn clean package -DskipTests
    
    - name: Unit Tests
      run: mvn test
    
    - name: Integration Tests
      run: mvn verify

  # Stage 3: Docker Build
  docker:
    runs-on: ubuntu-latest
    needs: build
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v3
    
    - name: Build & Push Docker
      uses: docker/build-push-action@v4
      with:
        push: true
        tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest

  # Stage 4: Deploy to Staging
  deploy-staging:
    runs-on: ubuntu-latest
    needs: docker
    steps:
    - name: Deploy to Staging
      run: |
        echo "Deploying to staging environment"
        # AWS/Azure deployment commands

  # Stage 5: Integration Tests
  integration-tests:
    runs-on: ubuntu-latest
    needs: deploy-staging
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: maven
    
    - name: Run Integration Tests
      run: mvn test -Dgroups=integration

  # Stage 6: Deploy to Production
  deploy-prod:
    runs-on: ubuntu-latest
    needs: integration-tests
    if: github.ref == 'refs/heads/main'
    environment: production
    steps:
    - name: Deploy to Production
      run: |
        echo "Deploying to production"
        # Production deployment commands
```

## GitLab CI/CD

```yaml
image: maven:3.8-openjdk-17

stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - mvn clean compile
  artifacts:
    paths:
      - target/

test:
  stage: test
  script:
    - mvn test
  coverage: '/Coverage: \d+\.\d+%/'

deploy:
  stage: deploy
  script:
    - mvn clean package
    - docker build -t $CI_REGISTRY_IMAGE:latest .
    - docker push $CI_REGISTRY_IMAGE:latest
  only:
    - main
```

## Common Mistakes

### 1. No Test in Pipeline

```yaml
# âŒ WRONG - skips all tests
- name: Build
  run: mvn clean package -DskipTests

# âœ… RIGHT - run all tests
- name: Build and Test
  run: mvn clean package
```

### 2. Long Build Times

```yaml
# âŒ WRONG - rebuilds every time
- name: Build
  run: mvn clean compile
  run: mvn test

# âœ… RIGHT - use caching
- name: Set up JDK
  uses: actions/setup-java@v3
  with:
    java-version: '17'
    distribution: 'temurin'
    cache: maven  # Cache dependencies
```

### 3. Exposing Secrets

```yaml
# âŒ WRONG - hardcoded secrets
- name: Login
  run: docker login -u myuser -p hardcoded_password

# âœ… RIGHT - use GitHub secrets
- name: Login
  run: docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
```

## Pipeline Best Practices

1. **Fast Feedback** - Tests should complete in <10 minutes
2. **Fail Fast** - Quick checks first (lint, build), then slow (tests)
3. **Parallel Jobs** - Run independent jobs simultaneously
4. **Environment Parity** - Same env as production
5. **Artifact Retention** - Keep builds for quick rollback
6. **Security** - Use secrets for credentials
7. **Notifications** - Alert team on failures

## Key Takeaways

- âœ… CI automatically builds and tests code changes
- âœ… CD automatically deploys tested code
- âœ… GitHub Actions enables CI/CD for free
- âœ… Pipeline stages: Build â†’ Test â†’ Docker â†’ Deploy
- âœ… Use secrets for credentials, never hardcode
- âœ… Cache dependencies to speed up builds
- âœ… Run tests before deployment

---

