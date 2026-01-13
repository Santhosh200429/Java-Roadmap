# ArrayList vs Array in Java

## Quick Comparison

| Feature | Array | ArrayList |
|---------|-------|-----------|
| Size | Fixed | Dynamic (grows) |
| Type | Primitive or Object | Only Objects |
| Syntax | `int[] arr = new int[5]` | `new ArrayList<>()` |
| Performance | Fastest | Slightly slower |
| Memory | No overhead | ~10% overhead |
| Thread-safe | No | No (see Collections.synchronizedList()) |
| Null values | Allowed | Allowed |

## Arrays

### Fixed Size

```java
public class ArrayExample {
    
    public static void main(String[] args) {
        // Create array of size 5
        int[] arr = new int[5];
        arr[0] = 10;
        arr[1] = 20;
        
        System.out.println(arr.length);  // 5
        
        // Cannot add 6th element
        // arr[5] = 30;  // âœ— ArrayIndexOutOfBoundsException
    }
}
```

### Primitives Allowed

```java
// âœ“ Arrays support primitives
int[] numbers = {1, 2, 3};
double[] decimals = {1.5, 2.5};
boolean[] flags = {true, false};

// âœ— ArrayList doesn't support primitives
// ArrayList<int> list = new ArrayList<>();  // âœ— Compiler error

// Must use wrapper classes
ArrayList<Integer> list = new ArrayList<>();  // âœ“ Works
```

### Array Memory Layout

```
int[] arr = {10, 20, 30};

Memory:
â”Œâ”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”
â”‚ 10  â”‚ 20  â”‚ 30  â”‚  (contiguous memory, cache-friendly)
â””â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”˜
  â†‘
arr (reference to start)

Access: O(1) - Direct memory lookup
```

### Array Iteration

```java
int[] arr = {1, 2, 3, 4, 5};

// Traditional for loop
for (int i = 0; i < arr.length; i++) {
    System.out.println(arr[i]);
}

// Enhanced for loop
for (int num : arr) {
    System.out.println(num);
}

// Stream API
Arrays.stream(arr)
    .forEach(System.out::println);
```

## ArrayList

### Dynamic Size

```java
public class ArrayListExample {
    
    public static void main(String[] args) {
        ArrayList<Integer> list = new ArrayList<>();
        
        // Start empty
        System.out.println(list.size());  // 0
        
        // Add elements
        list.add(10);
        list.add(20);
        list.add(30);
        
        System.out.println(list.size());  // 3
        
        // Keep adding
        for (int i = 0; i < 100; i++) {
            list.add(i);
        }
        
        System.out.println(list.size());  // 103 - Grows automatically!
    }
}
```

### Objects Only

```java
// âœ“ Objects
ArrayList<String> strings = new ArrayList<>();
ArrayList<Person> people = new ArrayList<>();

// âœ— Primitives (must use wrapper)
// ArrayList<int> numbers = new ArrayList<>();  // âœ— Error

// âœ“ Wrapper classes (autoboxing)
ArrayList<Integer> numbers = new ArrayList<>();
numbers.add(5);  // Autoboxed to Integer(5)
int value = numbers.get(0);  // Unboxed to int
```

### Internal Array Growth

```
ArrayList grows dynamically by increasing capacity:

Initial: capacity = 0
  []

add(1): capacity = 10
  [1, _, _, _, _, _, _, _, _, _]

add(2-10): capacity = 10
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

add(11): capacity = 15 (grows by 1.5x)
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, _, _, _, _]

add(12-15): capacity = 15
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

add(16): capacity = 22 (grows again)
  [1, 2, 3, ...15, 16, _, _, _, _, _, _, _]
```

### ArrayList Methods

```java
ArrayList<String> list = new ArrayList<>();

// Add
list.add("A");           // Add at end
list.add(0, "First");    // Add at index 0

// Get
String first = list.get(0);

// Remove
list.remove(0);          // Remove by index
list.remove("A");        // Remove by value

// Update
list.set(0, "Updated");

// Query
int size = list.size();
boolean contains = list.contains("A");
int index = list.indexOf("A");

// Clear
list.clear();
```

## Performance Comparison

### Random Access (Get/Set)

```java
public class PerformanceTest {
    
    public static void main(String[] args) {
        int[] arr = new int[1_000_000];
        ArrayList<Integer> list = new ArrayList<>(1_000_000);
        
        // Fill both
        for (int i = 0; i < 1_000_000; i++) {
            arr[i] = i;
            list.add(i);
        }
        
        // Array access
        long start = System.nanoTime();
        int sum = 0;
        for (int i = 0; i < arr.length; i++) {
            sum += arr[i];
        }
        long arrayTime = System.nanoTime() - start;
        
        // ArrayList access
        start = System.nanoTime();
        for (int i = 0; i < list.size(); i++) {
            sum += list.get(i);
        }
        long listTime = System.nanoTime() - start;
        
        System.out.println("Array: " + arrayTime + " ns");
        System.out.println("ArrayList: " + listTime + " ns");
        // Array is typically 2-3x faster
    }
}
```

### Insertion/Deletion

```java
// Array - O(n) very slow
int[] arr = {1, 2, 3, 4, 5};
// Insert 10 at index 1:
// [1, 10, 2, 3, 4, 5] - must shift 2,3,4,5
// Time: O(n)

// ArrayList - O(n) slow
ArrayList<Integer> list = new ArrayList<>();
list.addAll(Arrays.asList(1, 2, 3, 4, 5));
list.add(1, 10);  // Insert at index 1
// Time: O(n)

// LinkedList - O(1) if you have iterator
LinkedList<Integer> linked = new LinkedList<>();
linked.addAll(Arrays.asList(1, 2, 3, 4, 5));
linked.add(1, 10);  // Insert at index 1
// Time: O(n) for index lookup, but O(1) insertion itself
```

## When to Use What

### Use Array When:

```java
// 1. Need primitives (performance critical)
int[] scores = new int[100];  // No wrapper overhead
long[] timestamps = new long[1000];

// 2. Size is known and fixed
int[] matrix = new int[10][10];

// 3. Maximum performance needed
byte[] buffer = new byte[4096];

// 4. Working with legacy code
public void processArray(int[] data) { }
```

### Use ArrayList When:

```java
// 1. Size is unknown or changes
ArrayList<String> userNames = new ArrayList<>();
userNames.add(getNewUserName());

// 2. Need convenience methods
ArrayList<Person> people = new ArrayList<>();
people.remove(person);
people.contains(person);
people.clear();

// 3. Working with objects
ArrayList<User> users = new ArrayList<>();
ArrayList<Map<String, String>> config = new ArrayList<>();

// 4. Need Collections utility
Collections.sort(list);
Collections.shuffle(list);
Collections.reverse(list);
```

## Real-World Examples

### 1. User Management

```java
public class UserManager {
    private ArrayList<User> users = new ArrayList<>();
    
    public void addUser(User user) {
        users.add(user);  // Dynamic size - perfect for ArrayList
    }
    
    public User findUserById(int id) {
        for (User user : users) {
            if (user.getId() == id) {
                return user;
            }
        }
        return null;
    }
    
    public void removeUser(int id) {
        users.removeIf(u -> u.getId() == id);
    }
    
    public List<User> getAllUsers() {
        return new ArrayList<>(users);  // Copy for encapsulation
    }
}
```

### 2. Image Pixel Processing

```java
public class ImageProcessor {
    
    // Array - known fixed size, primitives
    private byte[] pixels;  // 1920 * 1080 pixels
    
    public ImageProcessor(int width, int height) {
        pixels = new byte[width * height];
    }
    
    public void setPixel(int x, int y, byte value) {
        pixels[x + y * 1920] = value;  // Direct array access - fast!
    }
    
    public byte getPixel(int x, int y) {
        return pixels[x + y * 1920];   // O(1) random access
    }
    
    public void applyFilter() {
        // Process all pixels - array iteration is fast
        for (byte pixel : pixels) {
            // Apply filter to each pixel
        }
    }
}
```

### 3. CSV Parser

```java
public class CSVParser {
    
    public List<Map<String, String>> parseCSV(String filePath) {
        ArrayList<Map<String, String>> rows = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            String[] headers = null;
            
            while ((line = reader.readLine()) != null) {
                if (headers == null) {
                    headers = line.split(",");  // Array for headers
                } else {
                    String[] values = line.split(",");
                    Map<String, String> row = new LinkedHashMap<>();
                    
                    for (int i = 0; i < headers.length; i++) {
                        row.put(headers[i], values[i]);
                    }
                    
                    rows.add(row);  // ArrayList for dynamic rows
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return rows;
    }
}
```

## Memory Usage

### Array Memory

```java
int[] arr = new int[1000];

Memory:
- 1000 * 4 bytes (int size) = 4000 bytes
- No wrapper overhead
- No extra capacity
- Compact layout
```

### ArrayList Memory

```java
ArrayList<Integer> list = new ArrayList<>(1000);
for (int i = 0; i < 1000; i++) {
    list.add(i);
}

Memory:
- Internal array: 1000 capacity
- Each Integer object: ~16 bytes (object header + value)
- Plus ArrayList overhead: ~24 bytes
- Total: 1000 * 16 + 24 = ~16KB
- Array storage: 1000 * 4 = 4KB
- Overhead: ~12KB (3x more!)

But:
- ArrayList is generic and reusable
- More convenient methods
- Less error-prone
```

## ArrayList Construction Options

```java
// Empty, default capacity
ArrayList<String> list1 = new ArrayList<>();

// With initial capacity (reduces resizing)
ArrayList<String> list2 = new ArrayList<>(100);

// Copy from collection
ArrayList<String> list3 = new ArrayList<>(Arrays.asList("A", "B", "C"));

// Initialization (anonymous)
ArrayList<String> list4 = new ArrayList<String>() {{
    add("A");
    add("B");
    add("C");
}};

// Or use List.of() (Java 9+)
List<String> list5 = List.of("A", "B", "C");  // Immutable
```

## Common Mistakes

### Mistake 1: Primitives in ArrayList

```java
// âœ— Wrong
ArrayList<int> numbers = new ArrayList<>();  // Compilation error!

// âœ“ Correct
ArrayList<Integer> numbers = new ArrayList<>();
```

### Mistake 2: Modifying While Iterating

```java
// âœ— Wrong
for (String item : list) {
    if (item.equals("remove")) {
        list.remove(item);  // ConcurrentModificationException!
    }
}

// âœ“ Correct
Iterator<String> it = list.iterator();
while (it.hasNext()) {
    if (it.next().equals("remove")) {
        it.remove();  // Safe!
    }
}
```

### Mistake 3: Forgetting Null Check

```java
// âœ— Risk
Integer value = list.get(index);
int result = value + 10;  // NullPointerException if value is null!

// âœ“ Safe
Integer value = list.get(index);
if (value != null) {
    int result = value + 10;
}
```

## Key Takeaways

- âœ… Arrays are fixed-size, faster, support primitives
- âœ… ArrayList is dynamic, flexible, object-only
- âœ… Use Array for performance-critical code with known size
- âœ… Use ArrayList for convenience and unknown size
- âœ… Array random access: O(1)
- âœ… ArrayList insertion/deletion: O(n)
- âœ… Arrays don't grow; ArrayList does automatically
- âœ… ArrayList has no wrapper for primitives (use Integer, Long, etc.)
- âœ… Never modify collection while iterating (use Iterator)
- âœ… ArrayList is usually better for normal code; Array for performance

---

