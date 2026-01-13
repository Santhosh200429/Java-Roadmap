# REST Controllers: Building Web APIs

## What is a REST API?

**REST** (Representational State Transfer) is a way to build web services using HTTP methods.

- GET: Retrieve data
- POST: Create data
- PUT: Update data
- DELETE: Remove data

## Spring Boot REST Controller

A **@RestController** returns JSON instead of HTML pages.

```java
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/students")
public class StudentController {
    
    @GetMapping
    public List<Student> getAllStudents() {
        // GET /api/students
    }
    
    @GetMapping("/{id}")
    public Student getStudentById(@PathVariable int id) {
        // GET /api/students/1
    }
    
    @PostMapping
    public Student createStudent(@RequestBody Student student) {
        // POST /api/students
    }
    
    @PutMapping("/{id}")
    public Student updateStudent(@PathVariable int id, @RequestBody Student student) {
        // PUT /api/students/1
    }
    
    @DeleteMapping("/{id}")
    public void deleteStudent(@PathVariable int id) {
        // DELETE /api/students/1
    }
}
```

## Annotations Explained

| Annotation | Purpose |
|-----------|---------|
| `@RestController` | Marks class as REST endpoint |
| `@RequestMapping("/path")` | Base path for all methods |
| `@GetMapping` | HTTP GET request |
| `@PostMapping` | HTTP POST request |
| `@PutMapping` | HTTP PUT request |
| `@DeleteMapping` | HTTP DELETE request |
| `@PathVariable` | Get value from URL path |
| `@RequestParam` | Get value from query string |
| `@RequestBody` | Get JSON from request body |

## Complete Student API

### 1. Entity Class

```java
import javax.persistence.*;

@Entity
@Table(name = "students")
public class Student {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    private String name;
    private String email;
    private double gpa;
    
    // Constructors
    public Student() {}
    
    public Student(String name, String email, double gpa) {
        this.name = name;
        this.email = email;
        this.gpa = gpa;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public double getGpa() { return gpa; }
    public void setGpa(double gpa) { this.gpa = gpa; }
}
```

### 2. Repository

```java
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentRepository extends JpaRepository<Student, Integer> {
    // JpaRepository provides: save, findById, findAll, delete, etc.
    Student findByEmail(String email);
}
```

### 3. Service (Business Logic)

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class StudentService {
    
    @Autowired
    private StudentRepository studentRepository;
    
    // Get all students
    public List<Student> getAllStudents() {
        return studentRepository.findAll();
    }
    
    // Get by ID
    public Student getStudentById(int id) {
        return studentRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Student not found"));
    }
    
    // Create
    public Student createStudent(Student student) {
        return studentRepository.save(student);
    }
    
    // Update
    public Student updateStudent(int id, Student studentDetails) {
        Student student = getStudentById(id);
        student.setName(studentDetails.getName());
        student.setEmail(studentDetails.getEmail());
        student.setGpa(studentDetails.getGpa());
        return studentRepository.save(student);
    }
    
    // Delete
    public void deleteStudent(int id) {
        studentRepository.deleteById(id);
    }
}
```

### 4. Controller

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/students")
public class StudentController {
    
    @Autowired
    private StudentService studentService;
    
    // GET /api/students
    @GetMapping
    public List<Student> getAllStudents() {
        return studentService.getAllStudents();
    }
    
    // GET /api/students/1
    @GetMapping("/{id}")
    public Student getStudentById(@PathVariable int id) {
        return studentService.getStudentById(id);
    }
    
    // POST /api/students
    @PostMapping
    public Student createStudent(@RequestBody Student student) {
        return studentService.createStudent(student);
    }
    
    // PUT /api/students/1
    @PutMapping("/{id}")
    public Student updateStudent(
        @PathVariable int id,
        @RequestBody Student student
    ) {
        return studentService.updateStudent(id, student);
    }
    
    // DELETE /api/students/1
    @DeleteMapping("/{id}")
    public void deleteStudent(@PathVariable int id) {
        studentService.deleteStudent(id);
    }
}
```

## Query Parameters

```java
@GetMapping("/search")
public List<Student> searchStudents(
    @RequestParam(required = false) String name,
    @RequestParam(required = false) Double minGpa
) {
    // GET /api/students/search?name=Alice&minGpa=3.5
}
```

## Request/Response Examples

### Get All Students
```bash
curl http://localhost:8080/api/students
```

**Response:**
```json
[
    {
        "id": 1,
        "name": "Alice",
        "email": "alice@email.com",
        "gpa": 3.8
    },
    {
        "id": 2,
        "name": "Bob",
        "email": "bob@email.com",
        "gpa": 3.5
    }
]
```

### Get Single Student
```bash
curl http://localhost:8080/api/students/1
```

**Response:**
```json
{
    "id": 1,
    "name": "Alice",
    "email": "alice@email.com",
    "gpa": 3.8
}
```

### Create Student
```bash
curl -X POST http://localhost:8080/api/students \
  -H "Content-Type: application/json" \
  -d '{"name":"Charlie","email":"charlie@email.com","gpa":3.9}'
```

### Update Student
```bash
curl -X PUT http://localhost:8080/api/students/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Alice Updated","email":"alice.new@email.com","gpa":3.9}'
```

### Delete Student
```bash
curl -X DELETE http://localhost:8080/api/students/1
```

## HTTP Status Codes

Return appropriate status codes:

```java
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@PostMapping
public ResponseEntity<Student> createStudent(@RequestBody Student student) {
    Student created = studentService.createStudent(student);
    return ResponseEntity.status(HttpStatus.CREATED).body(created);
}

@GetMapping("/{id}")
public ResponseEntity<Student> getStudentById(@PathVariable int id) {
    try {
        Student student = studentService.getStudentById(id);
        return ResponseEntity.ok(student);  // 200 OK
    } catch (Exception e) {
        return ResponseEntity.notFound().build();  // 404 Not Found
    }
}
```

## Exception Handling

```java
import org.springframework.web.bind.annotation.*;

@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(
        ResourceNotFoundException ex
    ) {
        ErrorResponse error = new ErrorResponse(
            404,
            ex.getMessage()
        );
        return ResponseEntity.status(404).body(error);
    }
}

class ErrorResponse {
    int status;
    String message;
    
    ErrorResponse(int status, String message) {
        this.status = status;
        this.message = message;
    }
}
```

## Complete Application Configuration

### pom.xml
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
</dependency>
```

### application.properties
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/student_db
spring.datasource.username=root
spring.datasource.password=password
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
server.port=8080
```

### Main Application
```java
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class StudentAPIApplication {
    public static void main(String[] args) {
        SpringApplication.run(StudentAPIApplication.class, args);
    }
}
```

## Testing with Postman

1. **Install Postman**: [postman.com](https://www.postman.com)
2. **Create new request**
3. **Set method**: GET, POST, PUT, DELETE
4. **Set URL**: http://localhost:8080/api/students
5. **Add body** (for POST/PUT):
```json
{
    "name": "Alice",
    "email": "alice@email.com",
    "gpa": 3.8
}
```
6. **Send request**

## Key Takeaways

- âœ… @RestController returns JSON
- âœ… @GetMapping, @PostMapping, @PutMapping, @DeleteMapping for CRUD
- âœ… @PathVariable for URL parameters
- âœ… @RequestBody for JSON input
- âœ… Service layer contains business logic
- âœ… Repository handles database access
- âœ… @Autowired injects dependencies

---

