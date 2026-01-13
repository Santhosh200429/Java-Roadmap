# Streams API: Processing Collections Functionally

## What are Streams?

A **Stream** is a pipeline for processing collections of data. It allows filtering, mapping, and transforming data in a functional way.

**Real-world analogy**: A stream is like an assembly line - data flows through different processing stations.

## Streams vs Collections

### Collections
- Store data in memory
- Access in any order
- Mutable (can change)

### Streams
- Process data on-the-fly
- Can't be reused
- Functional, declarative
- Lazy evaluation

## Stream Pipeline

```
Stream<T>
  â†’ Intermediate operations (filter, map, sorted)
  â†’ Terminal operation (collect, forEach, reduce)
  â†’ Result
```

### Example

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6);

numbers.stream()              // Create stream
    .filter(n -> n > 2)       // Intermediate: keep > 2
    .map(n -> n * n)          // Intermediate: square them
    .forEach(System.out::println);  // Terminal: print

// Output: 9 16 25 36
```

## Creating Streams

```java
// From List
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
Stream<String> stream = names.stream();

// From Array
int[] numbers = {1, 2, 3, 4, 5};
IntStream stream = Arrays.stream(numbers);

// From values
Stream<Integer> stream = Stream.of(1, 2, 3, 4, 5);

// From String
String text = "hello";
stream = text.chars().mapToObj(c -> (char) c);

// Empty stream
Stream<String> empty = Stream.empty();

// Infinite stream (limit it!)
Stream<Integer> infinite = Stream.generate(() -> 1).limit(5);
```

## Intermediate Operations

### filter() - Keep matching elements

```java
List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5, 6);

List<Integer> evens = nums.stream()
    .filter(n -> n % 2 == 0)
    .collect(Collectors.toList());

// Output: [2, 4, 6]
```

### map() - Transform elements

```java
List<String> names = Arrays.asList("alice", "bob", "charlie");

List<String> uppercase = names.stream()
    .map(String::toUpperCase)
    .collect(Collectors.toList());

// Output: [ALICE, BOB, CHARLIE]
```

### sorted() - Sort elements

```java
List<Integer> nums = Arrays.asList(5, 2, 8, 1, 9);

List<Integer> sorted = nums.stream()
    .sorted()
    .collect(Collectors.toList());

// Output: [1, 2, 5, 8, 9]

// Custom sort (descending)
List<Integer> descending = nums.stream()
    .sorted((a, b) -> b - a)
    .collect(Collectors.toList());

// Output: [9, 8, 5, 2, 1]
```

### distinct() - Remove duplicates

```java
List<Integer> nums = Arrays.asList(1, 2, 2, 3, 3, 3);

List<Integer> unique = nums.stream()
    .distinct()
    .collect(Collectors.toList());

// Output: [1, 2, 3]
```

### limit() - Take first N elements

```java
List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5);

List<Integer> first3 = nums.stream()
    .limit(3)
    .collect(Collectors.toList());

// Output: [1, 2, 3]
```

### skip() - Skip first N elements

```java
List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5);

List<Integer> skipFirst2 = nums.stream()
    .skip(2)
    .collect(Collectors.toList());

// Output: [3, 4, 5]
```

## Terminal Operations

### collect() - Gather results

```java
List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5);

// To List
List<Integer> list = nums.stream()
    .filter(n -> n > 2)
    .collect(Collectors.toList());

// To Set
Set<Integer> set = nums.stream()
    .collect(Collectors.toSet());

// To String (joined)
String result = nums.stream()
    .map(String::valueOf)
    .collect(Collectors.joining(", "));
// Output: "1, 2, 3, 4, 5"

// To Map
Map<Integer, Integer> squared = nums.stream()
    .collect(Collectors.toMap(
        n -> n,           // key
        n -> n * n        // value
    ));
```

### forEach() - Execute for each element

```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

names.stream()
    .forEach(name -> System.out.println("Hello " + name));
```

### reduce() - Combine to single value

```java
List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5);

// Sum
int sum = nums.stream()
    .reduce(0, (a, b) -> a + b);
// Output: 15

// Product
int product = nums.stream()
    .reduce(1, (a, b) -> a * b);
// Output: 120

// Max
int max = nums.stream()
    .reduce(Integer.MIN_VALUE, Math::max);
// Output: 5
```

### count() - Count elements

```java
List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5, 6);

long evenCount = nums.stream()
    .filter(n -> n % 2 == 0)
    .count();
// Output: 3
```

### anyMatch() - Any match condition?

```java
List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5);

boolean hasEven = nums.stream()
    .anyMatch(n -> n % 2 == 0);
// true

boolean allPositive = nums.stream()
    .allMatch(n -> n > 0);
// true

boolean noneNegative = nums.stream()
    .noneMatch(n -> n < 0);
// true
```

## Practical Examples

### Student Grade Processing

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
    new Student("Bob", 3.2),
    new Student("Charlie", 3.9),
    new Student("Diana", 3.5)
);

// Get high achievers (GPA >= 3.7)
List<Student> topStudents = students.stream()
    .filter(s -> s.gpa >= 3.7)
    .sorted((s1, s2) -> Double.compare(s2.gpa, s1.gpa))
    .collect(Collectors.toList());

// Get names of top students
List<String> topNames = students.stream()
    .filter(s -> s.gpa >= 3.7)
    .map(s -> s.name)
    .collect(Collectors.toList());

// Average GPA
double avgGPA = students.stream()
    .mapToDouble(s -> s.gpa)
    .average()
    .orElse(0.0);

// Group by GPA range
Map<String, List<Student>> grouped = students.stream()
    .collect(Collectors.groupingBy(s -> 
        s.gpa >= 3.7 ? "Excellent" : 
        s.gpa >= 3.5 ? "Good" : 
        "Needs Improvement"
    ));
```

### Data Transformation

```java
List<String> text = Arrays.asList(
    "hello world",
    "java streams",
    "functional programming"
);

// Get all unique words
Set<String> words = text.stream()
    .flatMap(line -> Arrays.stream(line.split(" ")))
    .collect(Collectors.toSet());

// Output: {world, hello, streams, programming, functional, java}

// Count word lengths
Map<Integer, Long> wordLengths = words.stream()
    .collect(Collectors.groupingBy(
        String::length,
        Collectors.counting()
    ));
```

## Complete Example

```java
public class StreamExample {
    public static void main(String[] args) {
        // Sample data
        List<Integer> numbers = Arrays.asList(
            15, 20, 35, 22, 14, 30, 25, 18
        );
        
        System.out.println("Original: " + numbers);
        
        // Requirement 1: Get numbers > 20
        List<Integer> greaterThan20 = numbers.stream()
            .filter(n -> n > 20)
            .collect(Collectors.toList());
        System.out.println("Greater than 20: " + greaterThan20);
        
        // Requirement 2: Double numbers > 20
        List<Integer> doubled = numbers.stream()
            .filter(n -> n > 20)
            .map(n -> n * 2)
            .collect(Collectors.toList());
        System.out.println("Doubled (>20): " + doubled);
        
        // Requirement 3: Sort in descending order
        List<Integer> sorted = numbers.stream()
            .sorted((a, b) -> b - a)
            .collect(Collectors.toList());
        System.out.println("Sorted (desc): " + sorted);
        
        // Requirement 4: Sum of all
        int sum = numbers.stream()
            .reduce(0, Integer::sum);
        System.out.println("Sum: " + sum);
        
        // Requirement 5: Average
        double average = numbers.stream()
            .mapToDouble(Integer::doubleValue)
            .average()
            .orElse(0);
        System.out.println("Average: " + average);
        
        // Requirement 6: Count even numbers
        long evenCount = numbers.stream()
            .filter(n -> n % 2 == 0)
            .count();
        System.out.println("Even numbers: " + evenCount);
    }
}
```

## Common Mistakes

### 1. Reusing Stream
```java
// âŒ WRONG
Stream<Integer> stream = nums.stream();
stream.filter(n -> n > 2);
stream.map(n -> n * 2);  // ERROR: stream closed

// RIGHT
nums.stream()
    .filter(n -> n > 2)
    .map(n -> n * 2)
    .collect(Collectors.toList());
```

### 2. Forgetting Terminal Operation
```java
// âŒ WRONG - no output
nums.stream()
    .filter(n -> n > 2);  // Only intermediate, does nothing

// RIGHT
nums.stream()
    .filter(n -> n > 2)
    .forEach(System.out::println);  // Terminal operation
```

### 3. Side Effects
```java
// âŒ Avoid
nums.stream()
    .forEach(n -> System.out.println(n));  // Impure

// Better
nums.stream()
    .forEach(System.out::println);
```

## Key Takeaways

- Streams process collections functionally
- Intermediate operations: filter, map, sorted
- Terminal operations: collect, forEach, reduce
- Lazy evaluation - intermediate ops don't execute until terminal op
- Pipelines can be chained
- Can't reuse a stream
- Great for data transformation

---


