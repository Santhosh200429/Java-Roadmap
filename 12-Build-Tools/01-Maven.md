# Maven: Build Automation and Dependency Management

## What is Maven?

**Maven** is a build automation tool that:
- Downloads and manages project dependencies
- Compiles, tests, and packages code
- Standardizes project structure
- Makes projects shareable and reproducible

## Project Structure

Maven follows a standard structure:

```
myproject/
├── pom.xml              ← Project configuration
├── src/
│   ├── main/
│   │   ├── java/       ← Source code
│   │   └── resources/  ← Configuration files
│   └── test/
│       ├── java/       ← Test code
│       └── resources/  ← Test configuration
└── target/             ← Compiled output
```

## pom.xml File

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>
    <modelVersion>4.0.0</modelVersion>
    
    <!-- Project Information -->
    <groupId>com.example</groupId>
    <artifactId>myapp</artifactId>
    <version>1.0-SNAPSHOT</version>
    <name>My Application</name>
    
    <!-- Java Version -->
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>
    
    <!-- Dependencies -->
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
        
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.33</version>
        </dependency>
    </dependencies>
    
    <!-- Build -->
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.10.1</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

## Common Maven Commands

```bash
# Compile project
mvn compile

# Run tests
mvn test

# Build JAR file
mvn package

# Clean target directory
mvn clean

# Install to local repository
mvn install

# All-in-one: clean, compile, test, package
mvn clean package

# Run Spring Boot application
mvn spring-boot:run

# Generate project documentation
mvn site
```

## Adding Dependencies

### From Maven Central Repository

1. Go to https://mvnrepository.com/
2. Search for library (e.g., "json")
3. Copy dependency snippet to pom.xml
4. Maven automatically downloads it

**Example: Adding JSON library**

```xml
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.10.1</version>
</dependency>
```

After adding, Maven downloads to `.m2/repository` folder.

## Dependency Scopes

Control when dependencies are needed:

```xml
<!-- compile: needed for compilation and runtime (default) -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
    <scope>compile</scope>
</dependency>

<!-- provided: needed for compilation, not runtime -->
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>servlet-api</artifactId>
    <version>2.5</version>
    <scope>provided</scope>
</dependency>

<!-- test: only for testing -->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
    <scope>test</scope>
</dependency>

<!-- runtime: needed at runtime, not compilation -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.6.0</version>
    <scope>runtime</scope>
</dependency>
```

## Maven Lifecycle

Maven has built-in phases:

```
validate → compile → test → package → install → deploy
```

When you run `mvn package`, all previous phases run automatically.

## Real Example: Complete pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.mycompany</groupId>
    <artifactId>StudentManagement</artifactId>
    <version>1.0.0</version>
    <name>Student Management System</name>
    
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    
    <dependencies>
        <!-- Database -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.33</version>
        </dependency>
        
        <!-- JSON Processing -->
        <dependency>
            <groupId>com.google.code.gson</groupId>
            <artifactId>gson</artifactId>
            <version>2.10.1</version>
        </dependency>
        
        <!-- Testing -->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.10.1</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

## Maven vs Gradle

| Feature | Maven | Gradle |
|---|---|---|
| Configuration | XML (verbose) | Groovy/Kotlin (concise) |
| Build Speed | Slower | Faster (incremental) |
| Learning Curve | Steeper | Gentler |
| Usage | Very common | Growing |

Both accomplish the same goal - choose based on preference.

## Troubleshooting

### "Can't find dependencies"

Solution:
```bash
# Update dependencies
mvn clean install

# Check pom.xml syntax
```

### "Build fails on different machine"

Maven ensures consistency - same pom.xml, same result everywhere.

## Key Takeaways

- ✅ Maven automates building and testing
- ✅ pom.xml defines project configuration
- ✅ Dependencies downloaded from Maven Central
- ✅ Standard project structure
- ✅ Lifecycle: compile → test → package → deploy
- ✅ Scope controls when dependencies are used
- ✅ mvn commands: clean, compile, test, package, install

---

**Maven is essential for professional Java development.**
