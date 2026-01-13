# List, Set, and Map Collections

## List - Ordered Collections

**List** maintains insertion order and allows duplicates.

### ArrayList (Most Common)

Dynamic array that grows as needed:

```java
List<String> fruits = new ArrayList<>();
fruits.add("Apple");
fruits.add("Banana");
fruits.add("Orange");

// Access by index
System.out.println(fruits.get(0));  // Apple

// Modify
fruits.set(1, "Blueberry");

// Remove
fruits.remove("Apple");
fruits.remove(0);

// Size
System.out.println(fruits.size());

// Iterate
for (String fruit : fruits) {
    System.out.println(fruit);
}
```

### LinkedList

Better for frequent insertions/deletions at beginning/end:

```java
List<Integer> numbers = new LinkedList<>();
numbers.add(10);
numbers.add(20);
numbers.addFirst(5);    // Add to beginning
numbers.addLast(30);    // Add to end

for (int num : numbers) {
    System.out.println(num);
}
// Output: 5, 10, 20, 30
```

## Set - Unique Values

**Set** doesn't allow duplicates and has no guaranteed order.

### HashSet

Fastest for add/remove/check operations:

```java
Set<String> emails = new HashSet<>();
emails.add("john@example.com");
emails.add("jane@example.com");
emails.add("john@example.com");  // Ignored (duplicate)

System.out.println(emails.size());  // 2

// Check if contains
if (emails.contains("john@example.com")) {
    System.out.println("Found!");
}

// Remove
emails.remove("john@example.com");
```

### TreeSet

Keeps elements sorted:

```java
Set<Integer> numbers = new TreeSet<>();
numbers.add(30);
numbers.add(10);
numbers.add(20);

for (int num : numbers) {
    System.out.println(num);  // 10, 20, 30 (sorted)
}
```

## Map - Key-Value Pairs

**Map** stores unique keys that map to values.

### HashMap

Fast key-value storage:

```java
Map<String, Integer> ages = new HashMap<>();
ages.put("Alice", 25);
ages.put("Bob", 30);
ages.put("Charlie", 22);

// Get value by key
System.out.println(ages.get("Alice"));  // 25

// Check if key exists
if (ages.containsKey("Bob")) {
    System.out.println("Found Bob");
}

// Remove
ages.remove("Charlie");

// Size
System.out.println(ages.size());  // 2

// Iterate over entries
for (Map.Entry<String, Integer> entry : ages.entrySet()) {
    System.out.println(entry.getKey() + ": " + entry.getValue());
}

// Iterate over keys
for (String key : ages.keySet()) {
    System.out.println(key);
}

// Iterate over values
for (int age : ages.values()) {
    System.out.println(age);
}
```

### TreeMap

Keeps keys sorted:

```java
Map<String, Integer> map = new TreeMap<>();
map.put("Charlie", 22);
map.put("Alice", 25);
map.put("Bob", 30);

// Iterates in alphabetical order
for (String key : map.keySet()) {
    System.out.println(key);  // Alice, Bob, Charlie
}
```

## Choosing the Right Collection

### Use ArrayList when:
- Need ordered access by index
- Frequent access, few insertions/deletions

### Use LinkedList when:
- Frequent insertions/deletions at beginning
- Don't need random access

### Use HashSet when:
- Need unique values
- Don't care about order
- Want fastest performance

### Use TreeSet when:
- Need unique, sorted values
- Don't mind slower performance

### Use HashMap when:
- Need key-value associations
- Want fast access by key

### Use TreeMap when:
- Need key-value pairs sorted by key
- Don't mind slower performance

## Generic Types (Type Safety)

Use angle brackets to specify type:

```java
// Type-safe - compiler checks
List<String> strings = new ArrayList<String>();
strings.add("Hello");
String word = strings.get(0);  // No casting needed

// Wrong type - compiler error
strings.add(123);  // âŒ Error - expected String

// Without generics (old way - not recommended)
List list = new ArrayList();  // No type checking
list.add("Hello");
list.add(123);  // Allowed!
String word = (String) list.get(0);  // Need casting
```

## Practical Example: Class Roster

```java
import java.util.*;

public class ClassRoster {
    public static void main(String[] args) {
        // List of students in order of enrollment
        List<String> students = new ArrayList<>();
        students.add("Alice");
        students.add("Bob");
        students.add("Charlie");
        
        // Set of unique grades earned
        Set<String> grades = new HashSet<>();
        grades.add("A");
        grades.add("B");
        grades.add("B");  // Duplicate ignored
        
        // Map of student to grade
        Map<String, String> studentGrades = new HashMap<>();
        studentGrades.put("Alice", "A");
        studentGrades.put("Bob", "B");
        studentGrades.put("Charlie", "A");
        
        // Print roster
        System.out.println("Students: " + students);
        System.out.println("Possible grades: " + grades);
        System.out.println("\nGradebook:");
        for (String student : students) {
            System.out.println(student + ": " + studentGrades.get(student));
        }
    }
}

/* Output:
Students: [Alice, Bob, Charlie]
Possible grades: [A, B]

Gradebook:
Alice: A
Bob: B
Charlie: A
*/
```

## Key Takeaways

- ArrayList = ordered, fast access
- LinkedList = ordered, fast insertion
- HashSet = unique, fast, unordered
- TreeSet = unique, sorted, slower
- HashMap = key-value, fastest
- TreeMap = key-value, sorted
- Use generics for type safety

---


