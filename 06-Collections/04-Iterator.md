# Iterator in Java Collections

## What is an Iterator?

An **Iterator** is an interface that lets you traverse through a collection element by element.

```java
public interface Iterator<E> {
    boolean hasNext();      // Check if more elements
    E next();              // Get next element
    void remove();         // Remove current element (optional)
    void forEachRemaining(Consumer<? super E> action);  // Java 8+
}
```

## Getting an Iterator

### From Collections

```java
List<String> list = new ArrayList<>();
list.add("A");
list.add("B");
list.add("C");

// Get iterator
Iterator<String> it = list.iterator();
```

### From All Collection Types

```java
// From List
Iterator<String> it1 = list.iterator();

// From Set
Set<String> set = new HashSet<>();
Iterator<String> it2 = set.iterator();

// From Queue
Queue<String> queue = new LinkedList<>();
Iterator<String> it3 = queue.iterator();

// From Map
Map<String, Integer> map = new HashMap<>();
Iterator<String> it4 = map.keySet().iterator();
```

## Basic Iterator Usage

### hasNext() and next()

```java
public class IteratorBasics {
    
    public static void main(String[] args) {
        List<String> fruits = new ArrayList<>();
        fruits.add("Apple");
        fruits.add("Banana");
        fruits.add("Cherry");
        
        Iterator<String> it = fruits.iterator();
        
        while (it.hasNext()) {
            String fruit = it.next();
            System.out.println(fruit);
        }
    }
}

// Output:
// Apple
// Banana
// Cherry
```

### State Machine

```
Iterator states:
"oe""""""""""""""""""""""""""""""""""""""
" Initial state (before first next()) "
""""""""""""""""""""""""""""""""""""""""
             "
             - next()
        "oe""""""""""""""
        " Element 1   "
        """"""""""""""""
             "    "
             "    - remove() (optional)
             "    """ Element removed
             "
             - next()
        "oe""""""""""""""
        " Element 2   "
        """"""""""""""""
             "
             - hasNext() returns false
        "oe"""""""""""""""""""
        " End of iteration "
        """""""""""""""""""""
```

## Removing Elements

### Using remove()

```java
public class IteratorRemoval {
    
    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>();
        numbers.add(1);
        numbers.add(2);
        numbers.add(3);
        numbers.add(4);
        
        Iterator<Integer> it = numbers.iterator();
        
        while (it.hasNext()) {
            int num = it.next();
            if (num % 2 == 0) {
                it.remove();  // Remove even numbers
            }
        }
        
        System.out.println(numbers);  // [1, 3]
    }
}
```

### Why Use Iterator.remove()?

**Don't do this:**
```java
List<Integer> list = new ArrayList<>();
list.add(1);
list.add(2);
list.add(3);

for (int num : list) {
    if (num == 2) {
        list.remove((Integer) num);  // oe- ConcurrentModificationException!
    }
}
```

**Do this instead:**
```java
Iterator<Integer> it = list.iterator();
while (it.hasNext()) {
    int num = it.next();
    if (num == 2) {
        it.remove();  // oe" Safe removal
    }
}
```

## Iterator vs For Loop

### Traditional For Loop

```java
List<String> list = new ArrayList<>();
list.add("A");
list.add("B");

for (int i = 0; i < list.size(); i++) {
    System.out.println(list.get(i));
}

// Works for: List (indexed access)
// Doesn't work for: Set, Queue (no index)
```

### Enhanced For Loop

```java
List<String> list = new ArrayList<>();
list.add("A");
list.add("B");

for (String item : list) {
    System.out.println(item);
}

// Works for: All Collections (Iterable)
// Behind the scenes: Uses Iterator!
```

### Iterator Loop

```java
List<String> list = new ArrayList<>();
list.add("A");
list.add("B");

Iterator<String> it = list.iterator();
while (it.hasNext()) {
    System.out.println(it.next());
}

// Works for: All Collections
// Advantage: Can call remove()
```

### Comparison

| Feature | For Loop | Enhanced For | Iterator |
|---------|----------|--------------|----------|
| Works with List | oe" | oe" | oe" |
| Works with Set | oe- | oe" | oe" |
| Can remove | oe- | oe- | oe" |
| Can skip index | oe- | oe- | oe" |
| Simple syntax | oe" | oe" | oe- |

## Practical Examples

### 1. Filter During Iteration

```java
public class FilterExample {
    
    public static void main(String[] args) {
        List<String> words = new ArrayList<>();
        words.add("apple");
        words.add("apricot");
        words.add("banana");
        words.add("avocado");
        
        // Remove all words not starting with 'a'
        Iterator<String> it = words.iterator();
        while (it.hasNext()) {
            if (!it.next().startsWith("a")) {
                it.remove();
            }
        }
        
        System.out.println(words);
        // [apple, apricot, avocado]
    }
}
```

### 2. Process Map Entries

```java
public class MapIterator {
    
    public static void main(String[] args) {
        Map<String, Integer> scores = new HashMap<>();
        scores.put("Alice", 85);
        scores.put("Bob", 92);
        scores.put("Charlie", 78);
        
        // Iterate over entries (most efficient)
        Iterator<Map.Entry<String, Integer>> it = 
            scores.entrySet().iterator();
        
        while (it.hasNext()) {
            Map.Entry<String, Integer> entry = it.next();
            System.out.println(entry.getKey() + ": " + entry.getValue());
        }
    }
}

// Output:
// Alice: 85
// Bob: 92
// Charlie: 78
```

### 3. Custom Iterator Implementation

```java
public class CustomIteratorExample {
    
    static class SimpleList<E> {
        private Object[] elements = new Object[100];
        private int size = 0;
        
        public void add(E element) {
            elements[size++] = element;
        }
        
        public Iterator<E> iterator() {
            return new SimpleIterator();
        }
        
        private class SimpleIterator implements Iterator<E> {
            private int index = 0;
            
            @Override
            public boolean hasNext() {
                return index < size;
            }
            
            @Override
            @SuppressWarnings("unchecked")
            public E next() {
                if (!hasNext()) {
                    throw new NoSuchElementException();
                }
                return (E) elements[index++];
            }
        }
    }
    
    public static void main(String[] args) {
        SimpleList<String> list = new SimpleList<>();
        list.add("A");
        list.add("B");
        list.add("C");
        
        Iterator<String> it = list.iterator();
        while (it.hasNext()) {
            System.out.println(it.next());
        }
    }
}
```

### 4. ListIterator (Bidirectional)

```java
public class ListIteratorExample {
    
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("A");
        list.add("B");
        list.add("C");
        
        // ListIterator allows backward traversal
        ListIterator<String> it = list.listIterator(list.size());
        
        // Iterate backward
        while (it.hasPrevious()) {
            System.out.println(it.previous());
        }
    }
}

// Output:
// C
// B
// A
```

## Iterator Methods (Java 8+)

### forEachRemaining()

```java
List<String> list = new ArrayList<>();
list.add("A");
list.add("B");
list.add("C");

Iterator<String> it = list.iterator();

// Process remaining elements
it.forEachRemaining(item -> System.out.println(item));

// Output:
// A
// B
// C
```

## Common Patterns

### Pattern 1: Safe Removal

```java
public static <T> void removeIf(Collection<T> collection, 
                                 Predicate<T> condition) {
    Iterator<T> it = collection.iterator();
    while (it.hasNext()) {
        if (condition.test(it.next())) {
            it.remove();
        }
    }
}

// Usage
List<Integer> numbers = new ArrayList<>(Arrays.asList(1,2,3,4,5));
removeIf(numbers, n -> n % 2 == 0);  // Remove even numbers
System.out.println(numbers);  // [1, 3, 5]
```

### Pattern 2: Safe Modification

```java
public static <T> void transform(List<T> list, 
                                  Function<T, T> transformer) {
    // Cannot use iterator to modify List values
    // Use traditional for loop or stream
    for (int i = 0; i < list.size(); i++) {
        list.set(i, transformer.apply(list.get(i)));
    }
}

// Usage
List<String> names = new ArrayList<>(Arrays.asList("alice", "bob"));
transform(names, String::toUpperCase);
System.out.println(names);  // [ALICE, BOB]
```

### Pattern 3: Conditional Iteration

```java
public static void processUntil(List<Integer> numbers, 
                                Predicate<Integer> condition) {
    Iterator<Integer> it = numbers.iterator();
    
    while (it.hasNext()) {
        Integer num = it.next();
        if (!condition.test(num)) {
            break;  // Stop iteration
        }
        System.out.println(num);
    }
}

// Usage
List<Integer> nums = Arrays.asList(1, 2, 3, 4, 5);
processUntil(nums, n -> n < 4);  // Process 1, 2, 3 only
```

## Key Differences: Set, List, Queue

### Set Iterator (Unordered)

```java
Set<String> set = new HashSet<>();
set.add("B");
set.add("A");
set.add("C");

Iterator<String> it = set.iterator();
while (it.hasNext()) {
    System.out.println(it.next());
    // Order unpredictable: C, A, B (or any order)
}
```

### List Iterator (Ordered)

```java
List<String> list = new ArrayList<>();
list.add("B");
list.add("A");
list.add("C");

Iterator<String> it = list.iterator();
while (it.hasNext()) {
    System.out.println(it.next());
    // Order guaranteed: B, A, C
}
```

### Queue Iterator (FIFO)

```java
Queue<String> queue = new LinkedList<>();
queue.add("B");
queue.add("A");
queue.add("C");

Iterator<String> it = queue.iterator();
while (it.hasNext()) {
    System.out.println(it.next());
    // Order: B, A, C (insertion order)
}
```

## Iterator vs Stream

```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

// Iterator - Imperative
Iterator<Integer> it = numbers.iterator();
while (it.hasNext()) {
    int num = it.next();
    if (num % 2 == 0) {
        System.out.println(num);
    }
}

// Stream - Functional (Modern)
numbers.stream()
    .filter(n -> n % 2 == 0)
    .forEach(System.out::println);

// Both output: 2, 4
```

## Key Takeaways

- Iterator traverses collections element by element
- Use `hasNext()` to check if more elements exist
- Use `next()` to get next element
- Use `remove()` for safe removal during iteration
- Never modify collection directly while iterating
- Works with all Collections (List, Set, Queue, Map)
- Enhanced for loop uses Iterator behind the scenes
- ListIterator allows bidirectional traversal
- Streams are modern alternative for functional style
- ConcurrentModificationException thrown if collection modified

---


