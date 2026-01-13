# Mockito: Testing with Mocks

## What is Mockito?

**Mockito** is a framework for creating mock objects in tests. Mocks are fake objects that simulate real behavior for testing purposes.

**Why mock?**
- Test in isolation (don't need real database)
- Test error scenarios easily
- Run tests faster
- Test complex interactions

## Why Mocking?

Without mocking:
```java
// [WRONG] Test fails if database is down!
StudentService service = new StudentService(realDatabase);
service.saveStudent(student);  // Depends on real DB
```

With mocking:
```java
// Test works without database
StudentRepository mockRepo = mock(StudentRepository.class);
StudentService service = new StudentService(mockRepo);
service.saveStudent(student);  // Uses fake repo
```

## Setup Mockito

### Add Dependency

Maven:
```xml
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>5.2.0</version>
    <scope>test</scope>
</dependency>
```

Gradle:
```gradle
testImplementation 'org.mockito:mockito-core:5.2.0'
```

## Creating Mocks

### 1. Mock Method

```java
@Test
public void testWithMock() {
    // Create mock
    StudentRepository mockRepo = mock(StudentRepository.class);
    
    // Test with mock
    StudentService service = new StudentService(mockRepo);
    List<Student> students = service.getAllStudents();
}
```

### 2. @Mock Annotation

```java
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
public class StudentServiceTest {
    
    @Mock
    private StudentRepository mockRepository;
    
    @Test
    public void testGetAllStudents() {
        // mockRepository is already created
        StudentService service = new StudentService(mockRepository);
    }
}
```

### 3. @InjectMocks Annotation

Automatically injects mocks into service:

```java
@ExtendWith(MockitoExtension.class)
public class StudentServiceTest {
    
    @Mock
    private StudentRepository repository;
    
    @Mock
    private EmailService emailService;
    
    @InjectMocks
    private StudentService service;  // Mocks auto-injected
    
    @Test
    public void testCreate() {
        // service.repository and service.emailService are mocks
        service.createStudent(student);
    }
}
```

## Stubbing (Setting Behavior)

Tell mock what to return:

```java
@Mock
StudentRepository mockRepo;

// When repo.findById(1) is called, return student
when(mockRepo.findById(1))
    .thenReturn(Optional.of(new Student(1, "Alice", "alice@email.com", 3.8)));

// When repo.findAll() is called, return list
when(mockRepo.findAll())
    .thenReturn(Arrays.asList(
        new Student(1, "Alice", "alice@email.com", 3.8),
        new Student(2, "Bob", "bob@email.com", 3.5)
    ));

// When repo.findById(999) is called, return empty
when(mockRepo.findById(999))
    .thenReturn(Optional.empty());
```

## Exception Stubbing

```java
@Mock
StudentRepository mockRepo;

// Throw exception on save
when(mockRepo.save(any()))
    .thenThrow(new DatabaseException("Connection failed"));

// Test that service handles exception
@Test
public void testSaveThrowsException() {
    StudentService service = new StudentService(mockRepo);
    
    assertThrows(DatabaseException.class, () -> {
        service.createStudent(new Student(/* ... */));
    });
}
```

## Verification

Check if methods were called:

```java
@Test
public void testCreateStudent() {
    StudentRepository mockRepo = mock(StudentRepository.class);
    StudentService service = new StudentService(mockRepo);
    
    Student student = new Student(1, "Alice", "alice@email.com", 3.8);
    service.createStudent(student);
    
    // Verify save was called with student
    verify(mockRepo).save(student);
    
    // Verify called exactly once
    verify(mockRepo, times(1)).save(student);
    
    // Verify never called
    verify(mockRepo, never()).delete(any());
    
    // Verify called at least once
    verify(mockRepo, atLeastOnce()).save(any());
}
```

## Complete Example

```java
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.junit.jupiter.api.extension.ExtendWith;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
public class StudentServiceTest {
    
    @Mock
    private StudentRepository repository;
    
    @Mock
    private EmailService emailService;
    
    @InjectMocks
    private StudentService service;
    
    @Test
    public void testCreateStudent() {
        // Arrange
        Student student = new Student("Alice", "alice@email.com", 3.8);
        Student savedStudent = new Student(1, "Alice", "alice@email.com", 3.8);
        
        when(repository.save(student))
            .thenReturn(savedStudent);
        
        // Act
        Student result = service.createStudent(student);
        
        // Assert
        assertNotNull(result);
        assertEquals(1, result.getId());
        assertEquals("Alice", result.getName());
        
        // Verify
        verify(repository).save(student);
        verify(emailService).sendWelcomeEmail("alice@email.com");
    }
    
    @Test
    public void testGetStudentById() {
        // Arrange
        Student student = new Student(1, "Alice", "alice@email.com", 3.8);
        
        when(repository.findById(1))
            .thenReturn(Optional.of(student));
        
        // Act
        Student result = service.getStudentById(1);
        
        // Assert
        assertEquals("Alice", result.getName());
        
        // Verify
        verify(repository).findById(1);
    }
    
    @Test
    public void testGetStudentByIdNotFound() {
        // Arrange
        when(repository.findById(999))
            .thenReturn(Optional.empty());
        
        // Act & Assert
        assertThrows(StudentNotFoundException.class, () -> {
            service.getStudentById(999);
        });
    }
    
    @Test
    public void testGetAllStudents() {
        // Arrange
        List<Student> students = Arrays.asList(
            new Student(1, "Alice", "alice@email.com", 3.8),
            new Student(2, "Bob", "bob@email.com", 3.5)
        );
        
        when(repository.findAll())
            .thenReturn(students);
        
        // Act
        List<Student> result = service.getAllStudents();
        
        // Assert
        assertEquals(2, result.size());
        assertEquals("Alice", result.get(0).getName());
    }
    
    @Test
    public void testUpdateStudent() {
        // Arrange
        Student existing = new Student(1, "Alice", "alice@email.com", 3.8);
        Student updates = new Student(1, "Alice Updated", "alice.new@email.com", 3.9);
        Student updated = new Student(1, "Alice Updated", "alice.new@email.com", 3.9);
        
        when(repository.findById(1))
            .thenReturn(Optional.of(existing));
        when(repository.save(any(Student.class)))
            .thenReturn(updated);
        
        // Act
        Student result = service.updateStudent(1, updates);
        
        // Assert
        assertEquals("Alice Updated", result.getName());
        
        // Verify
        verify(repository).findById(1);
        verify(repository).save(any(Student.class));
    }
    
    @Test
    public void testDeleteStudent() {
        // Act
        service.deleteStudent(1);
        
        // Verify
        verify(repository).deleteById(1);
    }
}
```

## Argument Matchers

Use matchers for flexible stubbing:

```java
@Mock
StudentRepository mockRepo;

// Match any Student object
when(mockRepo.save(any(Student.class)))
    .thenReturn(new Student(/* ... */));

// Match any Integer
when(mockRepo.findById(anyInt()))
    .thenReturn(Optional.of(student));

// Match any String starting with "ali"
when(mockRepo.findByName(startsWith("ali")))
    .thenReturn(Arrays.asList(student));

// Match specific range
when(mockRepo.findByGpaGreaterThan(doubleThat(gt(3.5))))
    .thenReturn(topStudents);

// Match any list
when(mockRepo.saveAll(anyList()))
    .thenReturn(Arrays.asList(/* ... */));
```

## Spy (Partial Mock)

Call real methods but track calls:

```java
@Test
public void testWithSpy() {
    StudentRepository realRepo = new StudentRepository();
    StudentRepository spyRepo = spy(realRepo);  // Real + trackable
    
    // Real method called
    Student student = spyRepo.findById(1);
    
    // But we can still verify
    verify(spyRepo).findById(1);
    
    // Override specific method
    when(spyRepo.findAll())
        .thenReturn(Arrays.asList(/* mocked list */));
}
```

## Testing with Multiple Mocks

```java
@ExtendWith(MockitoExtension.class)
public class OrderServiceTest {
    
    @Mock
    private StudentRepository studentRepo;
    
    @Mock
    private PaymentService paymentService;
    
    @Mock
    private EmailService emailService;
    
    @InjectMocks
    private OrderService orderService;
    
    @Test
    public void testCompleteOrder() {
        // Arrange
        Student student = new Student(/* ... */);
        when(studentRepo.findById(1))
            .thenReturn(Optional.of(student));
        
        when(paymentService.processPayment(100.0))
            .thenReturn(true);
        
        // Act
        boolean result = orderService.completeOrder(1, 100.0);
        
        // Assert
        assertTrue(result);
        
        // Verify
        verify(studentRepo).findById(1);
        verify(paymentService).processPayment(100.0);
        verify(emailService).sendConfirmation("alice@email.com");
    }
}
```

## Best Practices

1. **Mock only dependencies** - Don't mock the class being tested
2. **Use @InjectMocks** - Automatic injection is cleaner
3. **Stub minimum needed** - Only set up what test needs
4. **Verify behavior** - Check methods were called correctly
5. **Keep tests simple** - One assertion per test (usually)
6. **Use descriptive names** - `testCreateValidStudent()` not `test1()`

## Common Mistakes

### 1. Verifying on Mock Instead of Service
```java
// [WRONG] WRONG
StudentRepository mockRepo = mock(StudentRepository.class);
mockRepo.save(student);  // Directly calling mock

// RIGHT
StudentRepository mockRepo = mock(StudentRepository.class);
StudentService service = new StudentService(mockRepo);
service.createStudent(student);  // Service uses mock
verify(mockRepo).save(student);
```

### 2. Not Using Argument Matchers
```java
// [WRONG] WRONG - brittle test
when(repo.findById(1)).thenReturn(student);
// Only works if exactly 1 is passed

// RIGHT
when(repo.findById(anyInt())).thenReturn(student);
// Works with any ID
```

### 3. Forgetting to Setup Mocks
```java
// [WRONG] WRONG
StudentRepository mockRepo = mock(StudentRepository.class);
List<Student> result = mockRepo.findAll();  // Returns empty!

// RIGHT
when(mockRepo.findAll())
    .thenReturn(Arrays.asList(student1, student2));
List<Student> result = mockRepo.findAll();
```

## Key Takeaways

- Mocks are fake objects for testing
- Use `when()...thenReturn()` to stub behavior
- Use `verify()` to check method calls
- `@InjectMocks` auto-injects dependencies
- Argument matchers for flexible stubbing
- Spies for partial mocking
- Test business logic without external dependencies

---


