# JUnit: Testing Java Code

## What is JUnit?

**JUnit** is a framework for writing and running automated tests for Java code. Tests verify that your code works correctly.

## Why Test?

- **Catch bugs early**: Find problems before production
- **Regression prevention**: Ensure changes don't break existing functionality
- **Documentation**: Tests show how code should be used
- **Confidence**: Deploy with confidence
- **Faster development**: Tests catch issues immediately

## JUnit Setup

### Add Dependency to pom.xml

```xml
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
    <scope>test</scope>
</dependency>
```

Or for JUnit 5:

```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.9.2</version>
    <scope>test</scope>
</dependency>
```

## Writing Tests

### Simple Test Class

```java
import org.junit.Test;
import static org.junit.Assert.*;

public class CalculatorTest {
    
    private Calculator calc = new Calculator();
    
    @Test
    public void testAdd() {
        int result = calc.add(2, 3);
        assertEquals(5, result);  // Expected = 5, Actual = result
    }
    
    @Test
    public void testSubtract() {
        int result = calc.subtract(10, 3);
        assertEquals(7, result);
    }
    
    @Test
    public void testMultiply() {
        int result = calc.multiply(4, 5);
        assertEquals(20, result);
    }
    
    @Test
    public void testDivide() {
        int result = calc.divide(20, 4);
        assertEquals(5, result);
    }
}
```

### Code Being Tested

```java
public class Calculator {
    public int add(int a, int b) {
        return a + b;
    }
    
    public int subtract(int a, int b) {
        return a - b;
    }
    
    public int multiply(int a, int b) {
        return a * b;
    }
    
    public int divide(int a, int b) {
        if (b == 0) throw new IllegalArgumentException("Cannot divide by zero");
        return a / b;
    }
}
```

## Common Assertions

```java
// Equality
assertEquals(expected, actual);
assertNotEquals(unexpected, actual);

// Boolean
assertTrue(condition);
assertFalse(condition);

// Objects
assertNull(object);
assertNotNull(object);
assertSame(expected, actual);      // Same object reference
assertNotSame(unexpected, actual);

// Collections
assertEquals(Arrays.asList(1,2,3), actualList);
```

## Setup and Teardown

```java
public class TestSetup {
    private Database db;
    
    @Before
    public void setUp() {
        // Runs before each test
        db = new Database();
        db.connect();
    }
    
    @After
    public void tearDown() {
        // Runs after each test
        db.disconnect();
    }
    
    @BeforeClass
    public static void setUpClass() {
        // Runs once before all tests
    }
    
    @AfterClass
    public static void tearDownClass() {
        // Runs once after all tests
    }
    
    @Test
    public void testQuery() {
        // Test code
    }
}
```

## Testing Exceptions

```java
@Test(expected = IllegalArgumentException.class)
public void testDivideByZero() {
    Calculator calc = new Calculator();
    calc.divide(10, 0);  // Should throw exception
}

// Or with try-catch
@Test
public void testDivideByZeroAlt() {
    try {
        calc.divide(10, 0);
        fail("Should have thrown exception");
    } catch (IllegalArgumentException e) {
        // Expected
    }
}
```

## Complete Example

```java
import org.junit.*;
import static org.junit.Assert.*;

public class StringUtilsTest {
    
    private StringUtils utils;
    
    @Before
    public void setUp() {
        utils = new StringUtils();
    }
    
    @Test
    public void testReverse() {
        String result = utils.reverse("hello");
        assertEquals("olleh", result);
    }
    
    @Test
    public void testIsPalindrome() {
        assertTrue(utils.isPalindrome("racecar"));
        assertFalse(utils.isPalindrome("hello"));
    }
    
    @Test
    public void testCapitalize() {
        String result = utils.capitalize("hello");
        assertEquals("Hello", result);
    }
    
    @Test
    public void testCountVowels() {
        int result = utils.countVowels("hello");
        assertEquals(2, result);
    }
}

class StringUtils {
    public String reverse(String str) {
        return new StringBuilder(str).reverse().toString();
    }
    
    public boolean isPalindrome(String str) {
        return str.equals(reverse(str));
    }
    
    public String capitalize(String str) {
        return str.substring(0, 1).toUpperCase() + str.substring(1);
    }
    
    public int countVowels(String str) {
        int count = 0;
        for (char c : str.toLowerCase().toCharArray()) {
            if ("aeiou".contains(String.valueOf(c))) {
                count++;
            }
        }
        return count;
    }
}
```

## Running Tests

### Command Line

```bash
# Run all tests
mvn test

# Run specific test
mvn test -Dtest=CalculatorTest

# Run specific method
mvn test -Dtest=CalculatorTest#testAdd
```

### In IDE

- Right-click test class â†’ Run Tests
- Or use keyboard shortcut (usually Ctrl+Shift+F10)

## Test Coverage

Check what code is tested:

```bash
mvn jacoco:report
```

Generates coverage report showing which lines are tested.

## Best Practices

1. **Arrange-Act-Assert Pattern**
```java
@Test
public void testAdd() {
    // Arrange
    Calculator calc = new Calculator();
    
    // Act
    int result = calc.add(2, 3);
    
    // Assert
    assertEquals(5, result);
}
```

2. **One assertion per test** (usually)
3. **Meaningful test names**: `testAddPositiveNumbers()`
4. **Test edge cases**: Empty strings, null, zero, negative
5. **Keep tests simple**: If complex, code is hard to test

## Key Takeaways

- âœ… JUnit tests verify code correctness
- âœ… @Test marks test methods
- âœ… Assertions check expected values
- âœ… @Before/@After setup and teardown
- âœ… Test exceptions with @Test(expected=...)
- âœ… Run tests with `mvn test`
- âœ… Aim for high code coverage

---

