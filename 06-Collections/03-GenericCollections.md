# Generic Collections: Type-Safe Programming

## What are Generics?

**Generics** allow you to specify the type of elements in a collection at compile-time. This provides type safety and eliminates casting.

## Why Use Generics?

### Without Generics (Unsafe)
```java
List list = new ArrayList();
list.add("Hello");
list.add(123);         // Mixed types!
list.add(true);

String word = (String) list.get(0);  // Must cast
Integer number = (Integer) list.get(1);
```

### With Generics (Safe)
```java
List<String> list = new ArrayList<String>();
list.add("Hello");
list.add(123);  // ❌ Compile error - wrong type!

String word = list.get(0);  // No casting needed
```

## Generic Collection Syntax

```java
// List<Type>
List<String> names = new ArrayList<String>();
List<Integer> numbers = new ArrayList<Integer>();

// Shorthand (Java 7+) - compiler infers type
List<String> names = new ArrayList<>();

// Set<Type>
Set<Double> prices = new HashSet<Double>();

// Map<Key, Value>
Map<String, Integer> ages = new HashMap<String, Integer>();
```

## Common Generic Patterns

```java
// List of students
List<String> students = new ArrayList<>();
students.add("Alice");

// Set of unique ages
Set<Integer> uniqueAges = new HashSet<>();
uniqueAges.add(25);

// Map of student to GPA
Map<String, Double> gpas = new HashMap<>();
gpas.put("Alice", 3.8);

// List of Objects (more flexible)
class Student { String name; int age; }
List<Student> roster = new ArrayList<>();
roster.add(new Student());
```

## Type Parameters

Use any type as parameter:

```java
// Primitive types (must use wrapper classes)
List<Integer> integers = new ArrayList<>();   // int
List<Double> doubles = new ArrayList<>();     // double
List<Boolean> booleans = new ArrayList<>();   // boolean

// Classes
List<String> strings = new ArrayList<>();
List<Date> dates = new ArrayList<>();
List<Student> students = new ArrayList<>();
```

## Creating Generic Methods

```java
public class Utils {
    // Generic method - works with any type
    public static <T> void printList(List<T> list) {
        for (T item : list) {
            System.out.println(item);
        }
    }
    
    // Usage
    printList(new ArrayList<String>());  // String
    printList(new ArrayList<Integer>()); // Integer
    printList(new ArrayList<Double>());  // Double
}
```

## Creating Generic Classes

```java
public class Container<T> {
    private T value;
    
    public void set(T value) {
        this.value = value;
    }
    
    public T get() {
        return value;
    }
}

// Usage
Container<String> stringBox = new Container<>();
stringBox.set("Hello");
String result = stringBox.get();  // "Hello"

Container<Integer> intBox = new Container<>();
intBox.set(42);
Integer number = intBox.get();  // 42
```

## Wildcard Types

```java
// ? allows any type
void printList(List<?> list) {
    for (Object item : list) {
        System.out.println(item);
    }
}

// ? extends Type - upper bound
void processNumbers(List<? extends Number> list) {
    // List can contain Integer, Double, etc.
}

// ? super Type - lower bound
void addNumbers(List<? super Number> list) {
    list.add(42);
    list.add(3.14);
}
```

## Type Erasure

Java erases generic types at runtime (for compatibility):

```java
List<String> stringList = new ArrayList<>();
List<Integer> intList = new ArrayList<>();

// At runtime, both are just List - type info is erased
stringList.getClass() == intList.getClass();  // true!
```

This is why you can't do:
```java
if (obj instanceof List<String>) { }  // ❌ Error - can't check generic type
if (obj instanceof List) { }          // ✅ OK
```

## Benefits of Generics

1. **Type Safety**: Errors caught at compile-time, not runtime
2. **No Casting**: Get values directly without casting
3. **Cleaner Code**: Intent is clear from declaration
4. **Better Performance**: No runtime type checking
5. **Reusability**: One generic class works with many types

## Practical Example

```java
import java.util.*;

public class GenericExample {
    public static void main(String[] args) {
        // Type-safe collections
        List<String> fruits = new ArrayList<>();
        fruits.add("Apple");
        fruits.add("Banana");
        
        Set<Integer> primes = new HashSet<>();
        primes.add(2);
        primes.add(3);
        primes.add(5);
        
        Map<String, Double> prices = new HashMap<>();
        prices.put("Apple", 1.50);
        prices.put("Banana", 0.75);
        
        // No casting needed
        for (String fruit : fruits) {
            double price = prices.get(fruit);
            System.out.println(fruit + ": $" + price);
        }
    }
}
```

## Key Takeaways

- ✅ Generics provide type safety
- ✅ Specify type in angle brackets: List<Type>
- ✅ No casting needed with generics
- ✅ Can create generic methods and classes
- ✅ Wildcard ? allows flexible types
- ✅ Always use generics for collections

---

**Generics make collections type-safe and your code more reliable!**
