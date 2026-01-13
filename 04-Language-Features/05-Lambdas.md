# Lambda Expressions: Functional Programming in Java

## What are Lambda Expressions?

A **lambda** is a short, anonymous function (no name). It lets you write code more concisely.

**Real-world analogy**: Lambda is like a quick note instead of a long document.

## Before and After

### Without Lambda (Old Way)
```java
// Anonymous class - verbose
Runnable task = new Runnable() {
    @Override
    public void run() {
        System.out.println("Hello!");
    }
};

task.run();
```

### With Lambda (Modern Way)
```java
// Lambda - concise
Runnable task = () -> System.out.println("Hello!");
task.run();
```

Much shorter!

## Lambda Syntax

```
(parameters) -> { body }
```

### Examples

```java
// No parameters
() -> System.out.println("Hello")

// One parameter
x -> x * 2

// Multiple parameters
(x, y) -> x + y

// Multiple statements
(x, y) -> {
    int sum = x + y;
    return sum;
}

// With types (optional)
(int x, int y) -> x + y
```

## Functional Interfaces

A **functional interface** has exactly one abstract method. Lambdas work with functional interfaces.

### Built-in Functional Interfaces

```java
// Runnable - no parameters, no return
@FunctionalInterface
public interface Runnable {
    void run();
}

Runnable task = () -> System.out.println("Running");


// Callable - no parameters, returns value
@FunctionalInterface
public interface Callable<V> {
    V call();
}

Callable<Integer> getValue = () -> 42;


// Predicate - takes input, returns boolean
@FunctionalInterface
public interface Predicate<T> {
    boolean test(T t);
}

Predicate<Integer> isPositive = n -> n > 0;
isPositive.test(5);  // true


// Function - takes input, returns output
@FunctionalInterface
public interface Function<T, R> {
    R apply(T t);
}

Function<Integer, Integer> square = n -> n * n;
square.apply(5);  // 25


// Consumer - takes input, returns nothing
@FunctionalInterface
public interface Consumer<T> {
    void accept(T t);
}

Consumer<String> printer = s -> System.out.println(s);
printer.accept("Hello");


// Supplier - no parameters, returns value
@FunctionalInterface
public interface Supplier<T> {
    T get();
}

Supplier<Double> random = () -> Math.random();
```

## Practical Examples

### Filter List

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6);

// Old way - loops
List<Integer> evens = new ArrayList<>();
for (Integer n : numbers) {
    if (n % 2 == 0) {
        evens.add(n);
    }
}

// New way - lambda
List<Integer> evens = numbers.stream()
    .filter(n -> n % 2 == 0)
    .collect(Collectors.toList());
```

### Transform Data

```java
List<String> names = Arrays.asList("alice", "bob", "charlie");

// Convert to uppercase
List<String> uppercase = names.stream()
    .map(String::toUpperCase)
    .collect(Collectors.toList());

// Output: [ALICE, BOB, CHARLIE]
```

### Sort Objects

```java
class Student {
    String name;
    double gpa;
    
    Student(String name, double gpa) {
        this.name = name;
        this.gpa = gpa;
    }
}

List<Student> students = Arrays.asList(
    new Student("Alice", 3.8),
    new Student("Bob", 3.5),
    new Student("Charlie", 3.9)
);

// Sort by GPA (descending)
students.sort((s1, s2) -> 
    Double.compare(s2.gpa, s1.gpa)
);
```

## Method References

Shorthand for lambdas calling existing methods.

```java
// Lambda
list.forEach(s -> System.out.println(s));

// Method reference (equivalent)
list.forEach(System.out::println);
```

### Types of Method References

```java
// Static method
Function<Integer, Integer> square = n -> Math.abs(n);
// Shorthand:
Function<Integer, Integer> square = Math::abs;


// Instance method
String str = "hello";
Supplier<Integer> len = () -> str.length();
// Shorthand:
Supplier<Integer> len = str::length;


// Constructor
Supplier<Student> create = () -> new Student("", 0);
// Shorthand:
Supplier<Student> create = Student::new;
```

## Custom Functional Interface

```java
@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);
}

// Use with lambda
Calculator add = (a, b) -> a + b;
Calculator multiply = (a, b) -> a * b;

System.out.println(add.calculate(5, 3));      // 8
System.out.println(multiply.calculate(5, 3)); // 15
```

## Lambda with Collections

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

// forEach with lambda
numbers.forEach(n -> System.out.println(n));

// removeIf with lambda
numbers.removeIf(n -> n < 3);  // Remove numbers less than 3

// replaceAll with lambda
numbers.replaceAll(n -> n * 2);  // Double all numbers
```

## Complete Example

```java
public class StudentFilter {
    
    static class Student {
        String name;
        int age;
        double gpa;
        
        Student(String name, int age, double gpa) {
            this.name = name;
            this.age = age;
            this.gpa = gpa;
        }
        
        @Override
        public String toString() {
            return name + " (GPA: " + gpa + ")";
        }
    }
    
    public static void main(String[] args) {
        List<Student> students = Arrays.asList(
            new Student("Alice", 20, 3.8),
            new Student("Bob", 22, 3.2),
            new Student("Charlie", 21, 3.9),
            new Student("Diana", 20, 3.5)
        );
        
        // Filter high GPA (>= 3.5)
        List<Student> highGPA = students.stream()
            .filter(s -> s.gpa >= 3.5)
            .collect(Collectors.toList());
        
        System.out.println("High GPA students: " + highGPA);
        // Output: [Alice (GPA: 3.8), Charlie (GPA: 3.9), Diana (GPA: 3.5)]
        
        // Get all names
        List<String> names = students.stream()
            .map(s -> s.name)
            .collect(Collectors.toList());
        
        System.out.println("Names: " + names);
        // Output: [Alice, Bob, Charlie, Diana]
        
        // Check if any GPA >= 3.9
        boolean hasTopStudent = students.stream()
            .anyMatch(s -> s.gpa >= 3.9);
        
        System.out.println("Has 3.9+ student: " + hasTopStudent);
    }
}
```

## Common Mistakes

### 1. No Curly Braces when Multiple Statements
```java
// âŒ WRONG
List<Integer> nums = Arrays.asList(1, 2, 3);
nums.forEach(n -> 
    int x = n * 2;  // ERROR: need braces
    System.out.println(x);
);

// RIGHT
nums.forEach(n -> {
    int x = n * 2;
    System.out.println(x);
});
```

### 2. Forgetting Return Statement
```java
// âŒ WRONG
Function<Integer, Integer> square = x -> { x * x; };

// RIGHT
Function<Integer, Integer> square = x -> x * x;
// OR
Function<Integer, Integer> square = x -> { return x * x; };
```

### 3. Wrong Functional Interface
```java
// âŒ WRONG - Predicate returns boolean, not String
Predicate<Integer> check = n -> "value";

// RIGHT
Predicate<Integer> check = n -> n > 0;
```

## Key Takeaways

- Lambdas are short, anonymous functions
- `(params) -> body` syntax
- Work with functional interfaces
- Often used with Streams
- Method references can simplify lambdas
- Cleaner code than anonymous classes
- Braces needed for multiple statements

---


