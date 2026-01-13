# Spring Data JPA: Simplified Database Access

## What is Spring Data JPA?

**Spring Data JPA** simplifies database access by eliminating boilerplate code. Just define an interface - Spring creates the implementation automatically!

**Benefits over plain Hibernate**:
- âœ… No implementation needed
- âœ… Common queries already implemented
- âœ… Method name conventions for queries
- âœ… Pagination and sorting built-in
- âœ… Clean, type-safe code

## JpaRepository Interface

The magic interface that provides all CRUD operations:

```java
public interface StudentRepository extends JpaRepository<Student, Integer> {
    // All CRUD operations included automatically:
    // save(), findById(), findAll(), update(), delete(), etc.
    
    // Add custom methods below
}
```

**Parameters**: `<Entity, PrimaryKeyType>`

## Built-in Methods

JpaRepository provides these methods automatically:

```java
@Autowired
private StudentRepository repo;

// Create/Update
Student saved = repo.save(student);

// Read
Student student = repo.findById(1).orElse(null);
List<Student> all = repo.findAll();

// Delete
repo.deleteById(1);

// Check existence
boolean exists = repo.existsById(1);

// Count
long count = repo.count();
```

## Custom Query Methods

Define methods by naming convention:

```java
public interface StudentRepository extends JpaRepository<Student, Integer> {
    
    // Find by name
    Student findByName(String name);
    List<Student> findByNameContaining(String name);
    
    // Find by GPA
    List<Student> findByGpaGreaterThan(double gpa);
    List<Student> findByGpaLessThan(double gpa);
    
    // Multiple conditions
    Student findByNameAndEmail(String name, String email);
    List<Student> findByNameOrEmail(String name, String email);
    
    // Ordering
    List<Student> findAllByOrderByGpaDesc();  // Descending
    List<Student> findAllByOrderByNameAsc();  // Ascending
    
    // Limiting
    List<Student> findTop5ByOrderByGpaDesc();
    Student findFirstByOrderByGpaDesc();
}
```

## Query Keywords

```
find        â†’ SELECT
read        â†’ SELECT
get         â†’ SELECT
query       â†’ SELECT
count       â†’ COUNT
exists      â†’ EXISTS
delete      â†’ DELETE

Is, Equals
Greater, GreaterThan, GreaterThanEqual
Less, LessThan, LessThanEqual
Before, After
Like, Containing
StartingWith, EndingWith
Between
In
True, False
Null, NotNull
And, Or
Not
```

## @Query Annotation

For complex queries, use @Query:

```java
public interface StudentRepository extends JpaRepository<Student, Integer> {
    
    // JPQL (Java Persistence Query Language)
    @Query("SELECT s FROM Student s WHERE s.gpa > :gpa")
    List<Student> findTopStudents(@Param("gpa") double gpa);
    
    // With multiple conditions
    @Query("SELECT s FROM Student s WHERE s.name LIKE %:name% AND s.gpa > :gpa")
    List<Student> searchStudents(
        @Param("name") String name,
        @Param("gpa") double gpa
    );
    
    // Native SQL
    @Query(value = "SELECT * FROM students WHERE gpa > ?1", 
           nativeQuery = true)
    List<Student> findByGpaSQL(double gpa);
}
```

## Pagination and Sorting

```java
public interface StudentRepository extends JpaRepository<Student, Integer> {
    
    // With Pageable
    Page<Student> findAll(Pageable pageable);
    Page<Student> findByNameContaining(String name, Pageable pageable);
}

// Usage in service
@Service
public class StudentService {
    
    @Autowired
    private StudentRepository repo;
    
    public Page<Student> getStudentsPaginated(int page, int size) {
        // page is 0-indexed
        Pageable pageable = PageRequest.of(page, size);
        return repo.findAll(pageable);
    }
    
    public Page<Student> getStudentsSorted(int page, int size) {
        Pageable pageable = PageRequest.of(
            page, 
            size,
            Sort.by("gpa").descending()
        );
        return repo.findAll(pageable);
    }
}

// Controller usage
@RestController
@RequestMapping("/api/students")
public class StudentController {
    
    @Autowired
    private StudentService service;
    
    // GET /api/students?page=0&size=10
    @GetMapping
    public Page<Student> getStudents(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size
    ) {
        return service.getStudentsPaginated(page, size);
    }
}
```

## Complete Repository Example

```java
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface StudentRepository extends JpaRepository<Student, Integer> {
    
    // Simple finds
    Student findByEmail(String email);
    List<Student> findByName(String name);
    
    // Greater than / Less than
    List<Student> findByGpaGreaterThan(double gpa);
    
    // Between
    List<Student> findByGpaBetween(double min, double max);
    
    // Ordering
    List<Student> findTop10ByOrderByGpaDesc();
    List<Student> findByNameContainingOrderByGpaDesc(String name);
    
    // Custom JPQL query
    @Query("SELECT s FROM Student s WHERE s.gpa >= :minGpa")
    List<Student> findTopStudents(@Param("minGpa") double minGpa);
    
    // Count custom
    @Query("SELECT COUNT(s) FROM Student s WHERE s.gpa > :gpa")
    long countTopStudents(@Param("gpa") double gpa);
    
    // Delete custom
    @Query("DELETE FROM Student s WHERE s.gpa < :threshold")
    void deleteLowGPAStudents(@Param("threshold") double threshold);
}
```

## Service Layer Pattern

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class StudentService {
    
    @Autowired
    private StudentRepository repository;
    
    // Get all
    public List<Student> getAllStudents() {
        return repository.findAll();
    }
    
    // Get by ID
    public Student getStudentById(Integer id) {
        return repository.findById(id)
            .orElseThrow(() -> new StudentNotFoundException("Student not found"));
    }
    
    // Get by email
    public Student getByEmail(String email) {
        return repository.findByEmail(email);
    }
    
    // Get top students
    public List<Student> getTopStudents(double minGpa) {
        return repository.findByGpaGreaterThan(minGpa);
    }
    
    // Get with pagination
    public Page<Student> getStudentsPaginated(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        return repository.findAll(pageable);
    }
    
    // Create
    public Student createStudent(Student student) {
        return repository.save(student);
    }
    
    // Update
    public Student updateStudent(Integer id, Student details) {
        Student student = getStudentById(id);
        student.setName(details.getName());
        student.setEmail(details.getEmail());
        student.setGpa(details.getGpa());
        return repository.save(student);
    }
    
    // Delete
    public void deleteStudent(Integer id) {
        repository.deleteById(id);
    }
    
    // Search
    public List<Student> searchStudents(String name) {
        return repository.findByNameContaining(name);
    }
    
    // Statistics
    public long getHighGPACount(double threshold) {
        return repository.countTopStudents(threshold);
    }
}
```

## Complete REST Controller

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/students")
public class StudentController {
    
    @Autowired
    private StudentService studentService;
    
    // Get all students
    @GetMapping
    public ResponseEntity<List<Student>> getAllStudents() {
        return ResponseEntity.ok(studentService.getAllStudents());
    }
    
    // Get with pagination
    @GetMapping("/paginated")
    public ResponseEntity<Page<Student>> getPaginatedStudents(
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size
    ) {
        Page<Student> students = studentService.getStudentsPaginated(page, size);
        return ResponseEntity.ok(students);
    }
    
    // Get by ID
    @GetMapping("/{id}")
    public ResponseEntity<Student> getStudent(@PathVariable Integer id) {
        return ResponseEntity.ok(studentService.getStudentById(id));
    }
    
    // Search by name
    @GetMapping("/search")
    public ResponseEntity<List<Student>> searchStudents(
        @RequestParam String name
    ) {
        return ResponseEntity.ok(studentService.searchStudents(name));
    }
    
    // Get top students
    @GetMapping("/top")
    public ResponseEntity<List<Student>> getTopStudents(
        @RequestParam(defaultValue = "3.5") double minGpa
    ) {
        return ResponseEntity.ok(studentService.getTopStudents(minGpa));
    }
    
    // Create
    @PostMapping
    public ResponseEntity<Student> createStudent(
        @RequestBody Student student
    ) {
        Student created = studentService.createStudent(student);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
    
    // Update
    @PutMapping("/{id}")
    public ResponseEntity<Student> updateStudent(
        @PathVariable Integer id,
        @RequestBody Student details
    ) {
        return ResponseEntity.ok(studentService.updateStudent(id, details));
    }
    
    // Delete
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStudent(@PathVariable Integer id) {
        studentService.deleteStudent(id);
        return ResponseEntity.noContent().build();
    }
}
```

## Exception Handling

```java
public class StudentNotFoundException extends RuntimeException {
    public StudentNotFoundException(String message) {
        super(message);
    }
}

@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(StudentNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(
        StudentNotFoundException ex
    ) {
        ErrorResponse error = new ErrorResponse(
            404,
            ex.getMessage(),
            System.currentTimeMillis()
        );
        return ResponseEntity.status(404).body(error);
    }
    
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneral(Exception ex) {
        ErrorResponse error = new ErrorResponse(
            500,
            "Internal server error",
            System.currentTimeMillis()
        );
        return ResponseEntity.status(500).body(error);
    }
}

class ErrorResponse {
    int status;
    String message;
    long timestamp;
    
    public ErrorResponse(int status, String message, long timestamp) {
        this.status = status;
        this.message = message;
        this.timestamp = timestamp;
    }
    
    // Getters and setters
}
```

## Key Differences: JdbcTemplate vs Hibernate vs Spring Data JPA

| Feature | JdbcTemplate | Hibernate | Spring Data JPA |
|---------|-------------|-----------|-----------------|
| **SQL** | Manual | Generated | Generated |
| **Boilerplate** | High | Medium | Minimal |
| **Learning Curve** | Easy | Medium | Easy |
| **Flexibility** | High | Medium | Medium |
| **Performance** | Fast | Good | Good |
| **Best For** | Simple queries | Complex logic | Standard CRUD |

## Common Mistakes

### 1. Forgetting @Repository
```java
// âŒ WRONG
public interface StudentRepository extends JpaRepository<Student, Integer> {
}

// âœ… RIGHT
@Repository
public interface StudentRepository extends JpaRepository<Student, Integer> {
}
```

### 2. Wrong Type for PrimaryKey
```java
// âŒ WRONG - Student ID is Integer, not String
public interface StudentRepository extends JpaRepository<Student, String> {
}

// âœ… RIGHT
public interface StudentRepository extends JpaRepository<Student, Integer> {
}
```

### 3. Missing @Param in @Query
```java
// âŒ WRONG
@Query("SELECT s FROM Student s WHERE s.name = :name")
List<Student> findByName(String name);  // name not bound

// âœ… RIGHT
@Query("SELECT s FROM Student s WHERE s.name = :name")
List<Student> findByName(@Param("name") String name);
```

## Best Practices

1. **Use method naming convention** when possible (simpler)
2. **Use @Query for complex queries** (clarity)
3. **Implement pagination** for large datasets
4. **Add proper exception handling**
5. **Use @Transactional** for write operations
6. **Implement caching** for frequently accessed data

## Key Takeaways

- âœ… Extend JpaRepository to get CRUD operations
- âœ… Method naming conventions create queries automatically
- âœ… @Query for complex custom queries
- âœ… Pagination with Page and Pageable
- âœ… Service layer between controller and repository
- âœ… Exception handling for robust code
- âœ… Cleaner than plain JDBC/Hibernate

---

