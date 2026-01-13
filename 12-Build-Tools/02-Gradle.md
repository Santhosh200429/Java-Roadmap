# Gradle: Alternative Build Tool

## What is Gradle?

**Gradle** is a build automation tool like Maven, but more flexible and faster. It uses a simple script-based approach instead of XML.

**Key difference**: Gradle is easier to read and more powerful than Maven.

## Gradle vs Maven

| Feature | Maven | Gradle |
|---------|-------|--------|
| **Config File** | pom.xml (XML) | build.gradle (Groovy/Kotlin) |
| **Syntax** | Verbose XML | Simple script |
| **Speed** | Slower | Faster (incremental builds) |
| **Customization** | Limited | Highly customizable |
| **Learning Curve** | Moderate | Easy |

## Installing Gradle

### Windows
1. Download from [gradle.org](https://gradle.org/releases/)
2. Extract to folder (e.g., `C:\Gradle`)
3. Add to PATH environment variable
4. Verify: `gradle --version`

### Mac/Linux
```bash
brew install gradle    # Mac
sudo apt install gradle # Linux
gradle --version       # Verify
```

## Project Structure

```
myapp/
â”œâ”€â”€ build.gradle          # Build configuration
â”œâ”€â”€ settings.gradle       # Project settings
â”œâ”€â”€ gradle.properties     # Properties
â”œâ”€â”€ src/
â”‚   â”œâ”€â”€ main/java/        # Source code
â”‚   â””â”€â”€ test/java/        # Test code
â”œâ”€â”€ lib/                  # Dependencies (downloaded)
â””â”€â”€ build/                # Output directory
```

## Basic build.gradle

```gradle
plugins {
    id 'java'
    id 'application'
}

group = 'com.mycompany'
version = '1.0'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    // Testing
    testImplementation 'junit:junit:4.13.2'
    
    // Logging
    implementation 'org.slf4j:slf4j-api:2.0.0'
    implementation 'ch.qos.logback:logback-classic:1.4.0'
    
    // Database
    implementation 'mysql:mysql-connector-java:8.0.33'
}

application {
    mainClass = 'com.mycompany.Main'
}
```

## Dependency Scopes

```gradle
dependencies {
    // Available at compile and runtime
    implementation 'org.json:json:20230227'
    
    // Only for testing
    testImplementation 'junit:junit:4.13.2'
    
    // Compile time only
    compileOnly 'org.projectlombok:lombok:1.18.28'
    
    // Runtime only (not compile time)
    runtimeOnly 'com.mysql:mysql-connector-j:8.0.33'
}
```

## Common Gradle Commands

```bash
# Compile code
gradle compileJava

# Run tests
gradle test

# Build jar
gradle build

# Run application
gradle run

# Clean build directory
gradle clean

# See available tasks
gradle tasks

# Build specific jar
gradle jar

# Show dependencies
gradle dependencies

# Run with refresh
gradle build --refresh-dependencies
```

## Build Gradle for Spring Boot

```gradle
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.0.0'
    id 'io.spring.dependency-management' version '1.1.0'
}

group = 'com.example'
version = '1.0'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    runtimeOnly 'com.mysql:mysql-connector-j:8.0.33'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

tasks.named('test') {
    useJUnitPlatform()
}
```

## Build Gradle for Library

```gradle
plugins {
    id 'java-library'
}

group = 'com.mycompany'
version = '1.0'

repositories {
    mavenCentral()
}

dependencies {
    api 'org.json:json:20230227'           // Export to users
    implementation 'org.slf4j:slf4j-api'   // Internal only
    testImplementation 'junit:junit:4.13.2'
}
```

## Custom Tasks

```gradle
task hello {
    doLast {
        println 'Hello from Gradle!'
    }
}

task printVersion {
    doLast {
        println "Project version: ${version}"
    }
}

task copyResources {
    doLast {
        copy {
            from 'src/main/resources'
            into 'build/resources/main'
        }
    }
}

// Task dependencies
task deploy {
    dependsOn build
    doLast {
        println 'Deploying application...'
    }
}
```

Run with: `gradle hello`

## Multi-Module Project

### settings.gradle
```gradle
rootProject.name = 'student-system'

include 'core'
include 'ui'
include 'api'
```

### Project Structure
```
student-system/
â”œâ”€â”€ settings.gradle
â”œâ”€â”€ core/
â”‚   â””â”€â”€ build.gradle
â”œâ”€â”€ ui/
â”‚   â””â”€â”€ build.gradle
â””â”€â”€ api/
    â””â”€â”€ build.gradle
```

### core/build.gradle
```gradle
plugins {
    id 'java-library'
}

dependencies {
    api 'org.json:json:20230227'
    testImplementation 'junit:junit:4.13.2'
}
```

### api/build.gradle
```gradle
plugins {
    id 'java'
}

dependencies {
    implementation project(':core')
    implementation 'org.springframework.boot:spring-boot-starter-web'
}
```

## Build Properties

### gradle.properties
```properties
org.gradle.java.home=C:\\Program Files\\Java\\jdk-17
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.workers.max=4

# Project properties
app.name=StudentManagement
app.version=1.0
```

Use in build.gradle:
```gradle
version = project.properties['app.version']
```

## Gradle Wrapper

Ensures consistent Gradle version across machines.

```bash
# Generate wrapper
gradle wrapper --gradle-version=8.0

# Use wrapper instead of installed gradle
./gradlew build        # Mac/Linux
gradlew.bat build      # Windows
```

## Complete Example

```gradle
plugins {
    id 'java'
    id 'org.springframework.boot' version '3.0.0'
}

group = 'com.example'
version = '1.0'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    // Spring Boot
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    
    // Database
    runtimeOnly 'com.mysql:mysql-connector-j:8.0.33'
    
    // Utilities
    implementation 'org.json:json:20230227'
    
    // Testing
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
    testImplementation 'junit:junit:4.13.2'
}

tasks.named('test') {
    useJUnitPlatform()
}

task printInfo {
    doLast {
        println "Building ${project.name} v${version}"
        println "Java version: ${sourceCompatibility}"
    }
}
```

## Best Practices

1. **Use Gradle Wrapper**: Consistent version
2. **Explicit Versions**: Don't use `latest`
3. **Separate Dependencies**: Group by purpose
4. **Custom Tasks**: Automate repetitive work
5. **Properties File**: Centralize configuration

## Key Takeaways

- âœ… Gradle simpler than Maven (less XML)
- âœ… `build.gradle` uses Groovy/Kotlin syntax
- âœ… `gradle build` compiles and packages
- âœ… `gradle run` executes application
- âœ… `gradle test` runs tests
- âœ… Dependency scopes: implementation, testImplementation, runtimeOnly
- âœ… Gradle Wrapper ensures consistent version
- âœ… Tasks can depend on other tasks

---

