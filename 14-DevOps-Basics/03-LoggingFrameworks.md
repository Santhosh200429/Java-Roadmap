# Logging Frameworks: SLF4J and Logback

## What is Logging?

**Logging** is how applications track what's happening during execution - useful for debugging and monitoring.

**Real-world analogy**: Logging is like a ship's log - records important events throughout operation.

## Why Not System.out.println()?

```java
// [WRONG] BAD - System.out
System.out.println("User logged in: " + username);
System.out.println("Processing payment for: " + amount);

// Problems:
// 1. Can't disable in production (always prints)
// 2. All messages go to console (mixing important and trivial)
// 3. No timestamps or context
// 4. Hard to redirect to file
// 5. Performance impact (always executes)
```

## Logging Frameworks

```
SLF4J (API)
    -"
Logback (Implementation)
    -"
Writes to: File, Console, Email, Database, etc.
```

## Dependencies

Add to `pom.xml`:

```xml
<!-- SLF4J API -->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>2.0.5</version>
</dependency>

<!-- Logback Implementation -->
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.4.6</version>
</dependency>

<!-- Spring Boot includes both by default -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-logging</artifactId>
</dependency>
```

## Basic Usage

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserService {
    
    // Get logger (one per class)
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);
    
    public void loginUser(String username) {
        logger.info("User login attempt: {}", username);
        
        // Process login
        
        logger.info("User {} logged in successfully", username);
    }
    
    public void deleteUser(String userId) {
        logger.warn("Deleting user: {} - This action is permanent", userId);
    }
    
    public void processPayment(double amount) {
        if (amount <= 0) {
            logger.error("Invalid payment amount: {}", amount);
        }
    }
}
```

## Log Levels

```java
logger.trace("Very detailed: method entry");           // TRACE (rarely used)
logger.debug("Debug info: variable value = {}", var);  // DEBUG
logger.info("Application event: User logged in");      // INFO (default)
logger.warn("Something unexpected: out of stock");     // WARN
logger.error("Error occurred: cannot save file");      // ERROR
```

### Setting Level in Code

```java
import org.slf4j.LoggerFactory;
import ch.qos.logback.classic.LoggerContext;
import ch.qos.logback.classic.Logger;

public class LogLevelConfig {
    public static void main(String[] args) {
        // Get Logback logger
        Logger logger = (Logger) LoggerFactory.getLogger("com.myapp");
        
        // Set level to DEBUG
        logger.setLevel(Level.DEBUG);
    }
}
```

## Configuration Files

### application.properties

```properties
# Spring Boot logging
logging.level.root=INFO
logging.level.com.myapp=DEBUG
logging.level.org.springframework=WARN

# File output
logging.file.name=logs/application.log
logging.file.max-size=10MB
logging.file.max-history=10

# Pattern
logging.pattern.console=%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n
```

### logback-spring.xml (Advanced)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    
    <!-- Properties -->
    <property name="LOG_FILE" value="logs/app.log"/>
    <property name="LOG_PATTERN" 
              value="%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"/>
    
    <!-- Console Appender -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>${LOG_PATTERN}</pattern>
        </encoder>
    </appender>
    
    <!-- File Appender -->
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_FILE}</file>
        <encoder>
            <pattern>${LOG_PATTERN}</pattern>
        </encoder>
        
        <!-- Roll files daily or when they reach 10MB -->
        <rollingPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedRollingPolicy">
            <fileNamePattern>logs/app-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <maxFileSize>10MB</maxFileSize>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
    </appender>
    
    <!-- Root Logger -->
    <root level="INFO">
        <appender-ref ref="CONSOLE"/>
        <appender-ref ref="FILE"/>
    </root>
    
    <!-- Application Loggers -->
    <logger name="com.myapp" level="DEBUG"/>
    <logger name="org.springframework" level="WARN"/>
    
</configuration>
```

## Complete Examples

### 1. Service with Logging

```java
@Service
public class StudentService {
    
    private static final Logger logger = LoggerFactory.getLogger(StudentService.class);
    
    @Autowired
    private StudentRepository repository;
    
    public Student createStudent(StudentDTO dto) {
        logger.info("Creating student: {}", dto.getName());
        
        try {
            // Validate
            if (dto.getGpa() < 0 || dto.getGpa() > 4.0) {
                logger.warn("Invalid GPA for student {}: {}", dto.getName(), dto.getGpa());
                throw new IllegalArgumentException("Invalid GPA");
            }
            
            // Create
            Student student = new Student();
            student.setName(dto.getName());
            student.setGpa(dto.getGpa());
            
            Student saved = repository.save(student);
            logger.info("Student created successfully: {} with ID: {}", 
                       dto.getName(), saved.getId());
            
            return saved;
            
        } catch (Exception e) {
            logger.error("Error creating student: {}", dto.getName(), e);
            throw e;
        }
    }
    
    public Student getStudent(Long id) {
        logger.debug("Fetching student with ID: {}", id);
        
        Student student = repository.findById(id)
            .orElse(null);
        
        if (student == null) {
            logger.warn("Student not found: {}", id);
        } else {
            logger.debug("Student found: {}", student.getName());
        }
        
        return student;
    }
}
```

### 2. Controller with Logging

```java
@RestController
@RequestMapping("/api/students")
public class StudentController {
    
    private static final Logger logger = LoggerFactory.getLogger(StudentController.class);
    
    @Autowired
    private StudentService service;
    
    @GetMapping
    public ResponseEntity<?> getAll() {
        logger.info("GET /api/students - Fetching all students");
        try {
            List<Student> students = service.getAll();
            logger.info("Retrieved {} students", students.size());
            return ResponseEntity.ok(students);
        } catch (Exception e) {
            logger.error("Error fetching students", e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @PostMapping
    public ResponseEntity<?> create(@RequestBody StudentDTO dto) {
        logger.info("POST /api/students - Creating student: {}", dto.getName());
        try {
            Student student = service.createStudent(dto);
            logger.info("Student created: ID={}", student.getId());
            return ResponseEntity.status(201).body(student);
        } catch (IllegalArgumentException e) {
            logger.warn("Validation error: {}", e.getMessage());
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            logger.error("Unexpected error creating student", e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        logger.info("DELETE /api/students/{} - Deleting student", id);
        try {
            service.deleteStudent(id);
            logger.info("Student {} deleted successfully", id);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            logger.error("Error deleting student: {}", id, e);
            return ResponseEntity.internalServerError().build();
        }
    }
}
```

### 3. Utility Class with Debug Logging

```java
public class DataProcessor {
    
    private static final Logger logger = LoggerFactory.getLogger(DataProcessor.class);
    
    public List<String> processData(List<String> input) {
        logger.info("Processing {} data items", input.size());
        
        List<String> result = new ArrayList<>();
        
        for (int i = 0; i < input.size(); i++) {
            String item = input.get(i);
            logger.debug("Processing item {}: {}", i, item);
            
            String processed = item.toUpperCase();
            result.add(processed);
            
            logger.trace("Item {} processed to: {}", i, processed);
        }
        
        logger.info("Processing completed. Results: {}", result.size());
        return result;
    }
}
```

## Structured Logging

Log with context:

```java
public class RequestHandler {
    
    private static final Logger logger = LoggerFactory.getLogger(RequestHandler.class);
    
    public void handleRequest(String requestId, String userId) {
        // Add MDC (Mapped Diagnostic Context)
        MDC.put("requestId", requestId);
        MDC.put("userId", userId);
        
        try {
            logger.info("Processing request");  // Will include requestId and userId
            
            // Do work
            
            logger.info("Request completed");
        } finally {
            MDC.clear();  // Clean up
        }
    }
}

// Configure logback to use MDC:
// <pattern>%d [%X{requestId}] [%X{userId}] %msg%n</pattern>
```

## Common Mistakes

### 1. String Concatenation in Logging

```java
// [WRONG] WRONG - creates string even if DEBUG disabled
logger.debug("User: " + user + ", Amount: " + amount);

// RIGHT - string created only if level enabled
logger.debug("User: {}, Amount: {}", user, amount);
```

### 2. Logging Passwords/Sensitive Data

```java
// [WRONG] WRONG - logs password
logger.info("User login: username={}, password={}", username, password);

// RIGHT - don't log sensitive data
logger.info("User login attempt: username={}", username);
```

### 3. Not Logging Exceptions

```java
// [WRONG] WRONG - exception lost
try {
    doSomething();
} catch (Exception e) {
    logger.error("Error");  // No exception details!
}

// RIGHT - include exception
try {
    doSomething();
} catch (Exception e) {
    logger.error("Error occurred", e);  // Includes stack trace
}
```

## Performance Tips

```java
// Lazy evaluation - only creates message if enabled
logger.debug("Processing {} items", expensiveCalculation());

// [WRONG] Eager - always calculates even if not logged
if (logger.isDebugEnabled()) {
    logger.debug("Processing {} items", expensiveCalculation());
}
```

## Key Takeaways

- Use SLF4J API with Logback implementation
- One logger per class: `LoggerFactory.getLogger(ClassName.class)`
- Log levels: TRACE < DEBUG < INFO < WARN < ERROR
- Use placeholders: `logger.info("Message: {}", var)`
- Configure via properties or XML files
- Never log passwords or sensitive data
- Always include exceptions: `logger.error("Message", exception)`
- Use file rolling to manage log size
- Set appropriate levels (DEBUG for dev, INFO for prod)

---


