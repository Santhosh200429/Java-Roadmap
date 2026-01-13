# Introduction to Collections Framework

## What are Collections?

**Collections** are containers that store groups of objects. Instead of using arrays, Java provides powerful collection classes for different needs.

**Arrays vs Collections**:
```
Arrays:      Fixed size, one type, basic operations
Collections: Dynamic size, flexible, rich methods, type-safe
```

## Collection Hierarchy

```
Collection (Interface)
â”œâ”€â”€ List (Ordered, allow duplicates)
â”‚   â”œâ”€â”€ ArrayList
â”‚   â”œâ”€â”€ LinkedList
â”‚   â””â”€â”€ Vector
â”œâ”€â”€ Set (Unique values, no duplicates)
â”‚   â”œâ”€â”€ HashSet
â”‚   â”œâ”€â”€ TreeSet
â”‚   â””â”€â”€ LinkedHashSet
â””â”€â”€ Queue
    â”œâ”€â”€ PriorityQueue
    â””â”€â”€ Deque

Map (Key-Value pairs)
â”œâ”€â”€ HashMap
â”œâ”€â”€ TreeMap
â””â”€â”€ LinkedHashMap
```

## When to Use Each

### List - When order matters
```java
List<String> names = new ArrayList<>();
names.add("Alice");
names.add("Bob");
// Order maintained: [Alice, Bob]
```

### Set - When uniqueness matters
```java
Set<String> emails = new HashSet<>();
emails.add("john@example.com");
emails.add("john@example.com");  // Duplicate ignored
// Result: [john@example.com]
```

### Map - When you need key-value pairs
```java
Map<String, Integer> ages = new HashMap<>();
ages.put("Alice", 25);
ages.put("Bob", 30);
System.out.println(ages.get("Alice"));  // 25
```

## Collection Methods

Most collections support:

```java
// Add elements
collection.add(element);
collection.addAll(otherCollection);

// Remove elements
collection.remove(element);
collection.removeAll(otherCollection);
collection.clear();

// Check contents
collection.contains(element);
collection.isEmpty();
collection.size();

// Iterate
for (String item : collection) {
    System.out.println(item);
}
```

## Example: Student Management

```java
import java.util.*;

public class StudentManager {
    public static void main(String[] args) {
        // List of students
        List<String> students = new ArrayList<>();
        students.add("Alice");
        students.add("Bob");
        students.add("Charlie");
        
        // Set of unique grades
        Set<String> grades = new HashSet<>();
        grades.add("A");
        grades.add("B");
        grades.add("A");  // Duplicate ignored
        
        // Map of student ages
        Map<String, Integer> ages = new HashMap<>();
        ages.put("Alice", 20);
        ages.put("Bob", 21);
        ages.put("Charlie", 19);
        
        System.out.println("Students: " + students);
        System.out.println("Grades: " + grades);
        System.out.println("Ages: " + ages);
    }
}
```

## Key Takeaways

- âœ… Collections = flexible containers for objects
- âœ… List = ordered, allows duplicates
- âœ… Set = unique values, no duplicates
- âœ… Map = key-value pairs
- âœ… Use Collections instead of arrays for flexibility
- âœ… Each has different performance characteristics

---

