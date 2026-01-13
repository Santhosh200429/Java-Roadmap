# TestNG: Advanced Testing Framework

## What is TestNG?

**TestNG** is a testing framework more powerful than JUnit with advanced features for organizing and running tests.

**Real-world analogy**: TestNG is like JUnit with superpowers - better organization, parallel execution, and dependency management.

## Dependencies

Add to `pom.xml`:

```xml
<dependency>
    <groupId>org.testng</groupId>
    <artifactId>testng</artifactId>
    <version>7.8.1</version>
    <scope>test</scope>
</dependency>
```

## Basic Test

### Simple Test Method

```java
import org.testng.annotations.*;
import static org.testng.Assert.*;

public class CalculatorTest {
    
    private Calculator calculator;
    
    @BeforeMethod
    public void setUp() {
        calculator = new Calculator();
    }
    
    @Test
    public void testAddition() {
        int result = calculator.add(5, 3);
        assertEquals(result, 8);
    }
    
    @Test
    public void testSubtraction() {
        int result = calculator.subtract(5, 3);
        assertEquals(result, 2);
    }
    
    @AfterMethod
    public void tearDown() {
        calculator = null;
    }
}
```

## Annotations

### Lifecycle Annotations

```java
public class LifecycleTest {
    
    // Once before all tests in class
    @BeforeClass
    public static void setUpClass() {
        System.out.println("Before all tests");
    }
    
    // Before each test method
    @BeforeMethod
    public void setUp() {
        System.out.println("Before test");
    }
    
    @Test
    public void test1() {
        System.out.println("Test 1");
    }
    
    @Test
    public void test2() {
        System.out.println("Test 2");
    }
    
    // After each test method
    @AfterMethod
    public void tearDown() {
        System.out.println("After test");
    }
    
    // Once after all tests
    @AfterClass
    public static void tearDownClass() {
        System.out.println("After all tests");
    }
}

// Output:
// Before all tests
// Before test
// Test 1
// After test
// Before test
// Test 2
// After test
// After all tests
```

### Test Groups

```java
public class GroupedTests {
    
    @Test(groups = {"unit"})
    public void unitTest1() {
        // Fast unit test
    }
    
    @Test(groups = {"unit"})
    public void unitTest2() {
        // Fast unit test
    }
    
    @Test(groups = {"integration"})
    public void integrationTest1() {
        // Slower integration test
    }
    
    @Test(groups = {"database"})
    public void databaseTest1() {
        // Database test
    }
}

// Run in testng.xml:
// <groups>
//   <run>
//     <include name="unit"/>
//   </run>
// </groups>
```

## Data-Driven Testing

### Parameters

```java
public class ParameterizedTest {
    
    // Test with parameters
    @Test
    @Parameters({"username", "password"})
    public void testLogin(String username, String password) {
        assertTrue(validateCredentials(username, password));
    }
}

// testng.xml:
// <test name="Login Tests">
//   <parameter name="username" value="alice"/>
//   <parameter name="password" value="pass123"/>
//   <classes>
//     <class name="ParameterizedTest"/>
//   </classes>
// </test>
```

### Data Provider (Multiple Test Cases)

```java
public class DataProviderTest {
    
    // Provide test data
    @DataProvider(name = "loginData")
    public Object[][] getLoginData() {
        return new Object[][] {
            {"alice", "password123", true},
            {"bob", "password456", true},
            {"charlie", "wrong", false},
            {"", "password", false}
        };
    }
    
    // Test with each data set
    @Test(dataProvider = "loginData")
    public void testLogin(String username, String password, boolean expected) {
        boolean result = loginUser(username, password);
        assertEquals(result, expected);
    }
    
    private boolean loginUser(String username, String password) {
        // Simplified login logic
        return !username.isEmpty() && password.length() > 5;
    }
}

// This runs 4 tests with different data
```

## Assertions

```java
import static org.testng.Assert.*;

public class AssertionTest {
    
    @Test
    public void testAssertions() {
        // Equality
        assertEquals(5, 5);
        assertNotEquals(5, 3);
        
        // Boolean
        assertTrue(true);
        assertFalse(false);
        
        // Null
        assertNull(null);
        assertNotNull("value");
        
        // Same reference
        Object obj1 = new Object();
        assertSame(obj1, obj1);
        
        // Array assertions
        int[] array = {1, 2, 3};
        assertEquals(array.length, 3);
    }
}
```

## Exception Testing

```java
public class ExceptionTest {
    
    // Test that exception is thrown
    @Test(expectedExceptions = IllegalArgumentException.class)
    public void testExceptionThrown() {
        if (true) {
            throw new IllegalArgumentException("Invalid input");
        }
    }
    
    // Test exception with verification
    @Test
    public void testExceptionMessage() {
        try {
            throw new IllegalArgumentException("Invalid GPA");
        } catch (IllegalArgumentException e) {
            assertEquals(e.getMessage(), "Invalid GPA");
        }
    }
}
```

## Complete Examples

### 1. Student Service Tests

```java
public class StudentServiceTest {
    
    private StudentService service;
    private StudentRepository repository;
    
    @BeforeMethod
    public void setUp() {
        repository = mock(StudentRepository.class);
        service = new StudentService(repository);
    }
    
    // Test with data provider
    @DataProvider(name = "studentData")
    public Object[][] getStudentData() {
        return new Object[][] {
            {"Alice", "alice@email.com", 3.8},
            {"Bob", "bob@email.com", 3.5},
            {"Charlie", "charlie@email.com", 3.2}
        };
    }
    
    @Test(dataProvider = "studentData")
    public void testCreateStudent(String name, String email, double gpa) {
        Student student = new Student(name, email, gpa);
        when(repository.save(student)).thenReturn(student);
        
        Student result = service.createStudent(student);
        
        assertEquals(result.getName(), name);
        assertEquals(result.getEmail(), email);
        assertEquals(result.getGpa(), gpa);
    }
    
    @Test(groups = {"unit"})
    public void testValidateGPA() {
        // Valid GPA
        assertTrue(service.validateGPA(3.5));
        
        // Invalid GPA
        assertFalse(service.validateGPA(-1));
        assertFalse(service.validateGPA(5));
    }
    
    @Test(expectedExceptions = IllegalArgumentException.class)
    public void testCreateStudentWithNullName() {
        service.createStudent(null);
    }
}
```

### 2. Grouped Test Suite

```java
public class PaymentProcessingTest {
    
    private PaymentService paymentService;
    
    @BeforeClass
    public static void setUpClass() {
        System.out.println("Setting up payment test suite");
    }
    
    @BeforeMethod
    public void setUp() {
        paymentService = new PaymentService();
    }
    
    // Unit tests - fast
    @Test(groups = {"unit"})
    public void testValidateCreditCard() {
        assertTrue(paymentService.validateCard("4532-1234-5678-9010"));
        assertFalse(paymentService.validateCard("invalid"));
    }
    
    @Test(groups = {"unit"})
    public void testCalculateTax() {
        double tax = paymentService.calculateTax(100);
        assertEquals(tax, 8.5);  // 8.5% tax
    }
    
    // Integration tests - slower
    @Test(groups = {"integration"})
    public void testProcessPayment() {
        boolean result = paymentService.processPayment(100, "valid-card");
        assertTrue(result);
    }
    
    @Test(groups = {"database"})
    public void testSaveTransaction() {
        Transaction transaction = new Transaction(100, "card");
        paymentService.saveTransaction(transaction);
        // Verify in database
    }
}
```

### 3. Parameter and Group Combination

```java
public class AdvancedTestExample {
    
    @DataProvider(name = "validUsers")
    public Object[][] getValidUsers() {
        return new Object[][] {
            {"alice", "alice@email.com"},
            {"bob", "bob@email.com"},
            {"charlie", "charlie@email.com"}
        };
    }
    
    @Test(dataProvider = "validUsers", groups = {"unit"})
    public void testValidUserCreation(String name, String email) {
        User user = new User(name, email);
        assertEquals(user.getName(), name);
        assertEquals(user.getEmail(), email);
    }
    
    @Test(dataProvider = "validUsers", groups = {"integration"})
    public void testValidUserPersistence(String name, String email) {
        User user = new User(name, email);
        // Save to database
        assertTrue(userRepository.save(user) != null);
    }
}
```

## Parallel Execution

### testng.xml Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">

<suite name="Test Suite" parallel="tests" thread-count="4">
    
    <!-- Test 1: Unit tests (fast) -->
    <test name="Unit Tests" parallel="methods" thread-count="8">
        <groups>
            <run>
                <include name="unit"/>
            </run>
        </groups>
        <classes>
            <class name="com.myapp.CalculatorTest"/>
            <class name="com.myapp.ValidatorTest"/>
        </classes>
    </test>
    
    <!-- Test 2: Integration tests (slower) -->
    <test name="Integration Tests" parallel="methods" thread-count="2">
        <groups>
            <run>
                <include name="integration"/>
            </run>
        </groups>
        <classes>
            <class name="com.myapp.PaymentTest"/>
            <class name="com.myapp.DatabaseTest"/>
        </classes>
    </test>
    
</suite>
```

## TestNG vs JUnit

| Feature | TestNG | JUnit 5 |
|---------|--------|--------|
| Annotations | @Test, @BeforeMethod | @Test, @BeforeEach |
| Groups | Yes | No |
| Data Provider | Yes | @ParameterizedTest |
| Parallel | Easy | Complex |
| Dependency | Yes | No |
| Learning Curve | Steeper | Gentler |

## Assertions Comparison

```java
// JUnit
assertEquals(5, result);

// TestNG
assertEquals(result, 5);  // Note: order reversed!
```

## Common Mistakes

### 1. Confusing Parameter Order

```java
// âŒ WRONG - TestNG order is (actual, expected)
@Test(dataProvider = "data")
public void testAdd(int a, int b, int expected) {
    assertEquals(expected, a + b);  // Wrong order!
}

// âœ… RIGHT
assertEquals(a + b, expected);
```

### 2. Not Using Data Provider for Multiple Cases

```java
// âŒ WRONG - separate test for each case
@Test
public void testAdd1() { assertEquals(5, add(2,3)); }
@Test
public void testAdd2() { assertEquals(7, add(3,4)); }

// âœ… RIGHT - use DataProvider
@DataProvider
public Object[][] addData() {
    return new Object[][] {{2,3,5}, {3,4,7}};
}
@Test(dataProvider = "addData")
public void testAdd(int a, int b, int expected) {
    assertEquals(a+b, expected);
}
```

### 3. Not Cleaning Up Resources

```java
// âŒ WRONG - resources leaked
@BeforeMethod
public void setUp() {
    connection = createConnection();
}

// âœ… RIGHT - clean up
@AfterMethod
public void tearDown() {
    connection.close();
}
```

## Key Takeaways

- âœ… TestNG is more powerful than JUnit for complex tests
- âœ… Groups organize tests (unit, integration, database)
- âœ… DataProvider enables data-driven testing
- âœ… Parallel execution speeds up test suite
- âœ… Better control over test lifecycle
- âœ… Assertions are powerful with messaging
- âœ… Excellent for enterprise applications
- âœ… Good for testing complex business logic

---

