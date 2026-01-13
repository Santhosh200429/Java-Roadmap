# Annotations: Metadata for Code

## What are Annotations?

**Annotations** are metadata (information about code) that provide information about the code but don't directly affect code execution.

**Symbol**: `@AnnotationName`

**Real-world analogy**: Annotations are like labels on files - they don't change file content but provide extra information.

## Built-in Annotations

### @Override
Indicates a method overrides parent method. Compiler checks this.

```java
class Animal {
    public void sound() {
        System.out.println("Some sound");
    }
}

class Dog extends Animal {
    @Override
    public void sound() {  // Overriding parent method
        System.out.println("Woof");
    }
}

// If you misspell method name:
class Cat extends Animal {
    @Override
    public void Sound() {  // âŒ ERROR: method not found in parent
        System.out.println("Meow");
    }
}
```

### @Deprecated
Marks method/class as outdated. Not recommended to use.

```java
public class OldAPI {
    
    @Deprecated
    public void oldMethod() {
        System.out.println("Old way");
    }
    
    public void newMethod() {
        System.out.println("New way");
    }
}

// Usage generates warning
OldAPI api = new OldAPI();
api.oldMethod();  // âš ï¸ Warning: oldMethod is deprecated
api.newMethod();  // OK
```

### @Deprecated with Message (Java 9+)
```java
@Deprecated(since = "2.0", forRemoval = true, 
    message = "Use newMethod() instead")
public void oldMethod() {
    // Don't use this
}
```

### @SuppressWarnings
Tells compiler to ignore specific warnings.

```java
@SuppressWarnings("deprecation")
public void useDeprecated() {
    api.oldMethod();  // No warning
}

// Multiple warnings
@SuppressWarnings({"deprecation", "unchecked"})
public void multiWarnings() {
    // Code
}
```

### @FunctionalInterface
Marks interface as functional (single abstract method).

```java
@FunctionalInterface
public interface Calculator {
    int calculate(int a, int b);
}

// Compiler error if multiple abstract methods
@FunctionalInterface
public interface BadInterface {
    void method1();
    void method2();  // âŒ ERROR: more than one abstract method
}
```

### @SafeVarargs
Indicates variadic method/constructor is safe.

```java
@SafeVarargs
public static <T> void printArray(T... items) {
    for (T item : items) {
        System.out.println(item);
    }
}
```

## Annotation Parameters

```java
// No parameters
@Override
public void method() { }

// With parameters
@Deprecated(since = "1.5")
public void oldMethod() { }

// Multiple values
@SuppressWarnings({"unchecked", "deprecation"})
public void method() { }
```

## Spring Boot Annotations

### @Component
Marks class as Spring component (bean).

```java
@Component
public class MyService {
    public void doSomething() {
        System.out.println("Doing something");
    }
}
```

### @Service
Service component (business logic).

```java
@Service
public class StudentService {
    // Business logic
}
```

### @Repository
Repository component (data access).

```java
@Repository
public interface StudentRepository extends JpaRepository<Student, Integer> {
    // Data access methods
}
```

### @Autowired
Auto-inject dependencies.

```java
@Service
public class StudentService {
    
    @Autowired
    private StudentRepository repo;  // Automatically injected
    
    public List<Student> getAllStudents() {
        return repo.findAll();
    }
}
```

### @RestController
REST endpoint controller.

```java
@RestController
@RequestMapping("/api/students")
public class StudentController {
    // REST methods
}
```

### @RequestMapping / @GetMapping / @PostMapping
Map HTTP requests.

```java
@RestController
@RequestMapping("/api/students")
public class StudentController {
    
    @GetMapping
    public List<Student> getAll() { }
    
    @GetMapping("/{id}")
    public Student getById(@PathVariable int id) { }
    
    @PostMapping
    public Student create(@RequestBody Student s) { }
    
    @PutMapping("/{id}")
    public Student update(@PathVariable int id, @RequestBody Student s) { }
    
    @DeleteMapping("/{id}")
    public void delete(@PathVariable int id) { }
}
```

### @PathVariable
Extract value from URL path.

```java
@GetMapping("/students/{id}")
public Student getStudent(@PathVariable int id) {
    // id from URL: /students/123 â†’ id = 123
}

// Multiple path variables
@GetMapping("/courses/{courseId}/students/{studentId}")
public Student getStudent(
    @PathVariable int courseId,
    @PathVariable int studentId
) { }
```

### @RequestParam
Extract query parameters.

```java
@GetMapping("/search")
public List<Student> search(
    @RequestParam String name,
    @RequestParam(required = false) Double minGpa
) {
    // GET /search?name=Alice&minGpa=3.5
}
```

### @RequestBody
Get JSON from request body.

```java
@PostMapping
public Student create(@RequestBody Student student) {
    // student is parsed from JSON
}
```

### @Entity, @Table, @Column
JPA/Hibernate annotations.

```java
@Entity
@Table(name = "students")
public class Student {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    @Column(name = "student_name", length = 100)
    private String name;
    
    @Column(unique = true)
    private String email;
}
```

## Creating Custom Annotations

```java
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)  // Available at runtime
@Target(ElementType.METHOD)           // Can be used on methods
public @interface MyAnnotation {
    String value();
    int priority() default 0;
}

// Usage
public class MyClass {
    
    @MyAnnotation(value = "Important", priority = 1)
    public void importantMethod() {
        // Code
    }
}
```

### Annotation Parameters

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD, ElementType.CLASS})
public @interface Author {
    String name();
    String date() default "Unknown";
    String[] contributors() default {};
}

// Usage
@Author(
    name = "Alice",
    date = "2024-01-01",
    contributors = {"Bob", "Charlie"}
)
public class Calculator {
    // Code
}
```

## Common Annotation Targets

```java
@Target({
    ElementType.TYPE,              // Class
    ElementType.METHOD,            // Method
    ElementType.FIELD,             // Field
    ElementType.PARAMETER,         // Parameter
    ElementType.CONSTRUCTOR,       // Constructor
    ElementType.LOCAL_VARIABLE     // Local variable
})
public @interface MultiTarget {
}
```

## Validation Annotations

```java
import javax.validation.constraints.*;

public class User {
    
    @NotNull(message = "Name cannot be null")
    private String name;
    
    @Email(message = "Invalid email")
    private String email;
    
    @Min(value = 18, message = "Age must be >= 18")
    @Max(value = 100, message = "Age must be <= 100")
    private int age;
    
    @Pattern(regexp = "\\d{10}", message = "Phone must be 10 digits")
    private String phone;
    
    @Size(min = 3, max = 20, message = "Password 3-20 characters")
    private String password;
}

// Usage in controller
@PostMapping
public void createUser(@Valid @RequestBody User user) {
    // Validation happens automatically
}
```

## Practical Example: Custom Logging Annotation

```java
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface LogExecution {
    String value() default "Method executed";
}

// Using with reflection (advanced)
public class MethodInvoker {
    public static void invokeMethod(Object obj, String methodName) 
        throws Exception {
        
        Method method = obj.getClass().getMethod(methodName);
        
        if (method.isAnnotationPresent(LogExecution.class)) {
            LogExecution log = method.getAnnotation(LogExecution.class);
            System.out.println("Executing: " + log.value());
        }
        
        method.invoke(obj);
    }
}

// Implementation
public class Calculator {
    
    @LogExecution("Adding two numbers")
    public int add(int a, int b) {
        return a + b;
    }
    
    @LogExecution("Multiplying numbers")
    public int multiply(int a, int b) {
        return a * b;
    }
}
```

## Complete Example: REST API Annotations

```java
@RestController
@RequestMapping("/api/students")
public class StudentController {
    
    @Autowired
    private StudentService studentService;
    
    @GetMapping
    public ResponseEntity<List<Student>> getAllStudents() {
        return ResponseEntity.ok(studentService.getAllStudents());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Student> getStudent(@PathVariable int id) {
        Student student = studentService.getStudentById(id);
        return ResponseEntity.ok(student);
    }
    
    @PostMapping
    public ResponseEntity<Student> createStudent(
        @Valid @RequestBody Student student
    ) {
        Student created = studentService.createStudent(student);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Student> updateStudent(
        @PathVariable int id,
        @Valid @RequestBody Student studentDetails
    ) {
        Student updated = studentService.updateStudent(id, studentDetails);
        return ResponseEntity.ok(updated);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStudent(@PathVariable int id) {
        studentService.deleteStudent(id);
        return ResponseEntity.noContent().build();
    }
}
```

## Common Mistakes

### 1. Using @ without annotation
```java
// âŒ WRONG
@ public void method() { }

// RIGHT
@Override
public void method() { }
```

### 2. Wrong annotation on wrong element
```java
// âŒ WRONG - @Override on field
@Override
private int age;

// RIGHT - @Override on method
@Override
public void someMethod() { }
```

### 3. Missing parameters in custom annotation
```java
@Author(name = "Alice")  // OK - date has default

@Author()  // âŒ ERROR - name is required
```

## Key Takeaways

- Annotations provide metadata about code
- `@Override` marks method override
- `@Deprecated` marks outdated code
- `@SuppressWarnings` suppresses compiler warnings
- Spring annotations: `@Component`, `@Service`, `@Repository`
- `@Autowired` injects dependencies
- Custom annotations can be created
- Annotations don't affect code execution directly

---


