# Garbage Collection in Java

## What is Garbage Collection?

**Garbage Collection (GC)** automatically frees memory by removing unreferenced objects.

```
Object Creation
     ↓
Object Usage
     ↓
Object no longer needed (unreachable)
     ↓
GC detects unreachable object
     ↓
Memory reclaimed
```

## Reachability

An object is **reachable** if there's a path from GC roots:

```java
Object root = new Object();           // Reachable
root = null;                          // No longer reachable
// GC can collect it

Object container = new ArrayList<>();
Object obj = new Object();
container.add(obj);                   // Reachable (via container)
container.clear();                    // No longer reachable
```

### GC Roots

```
- Local variables (stack)
- Static variables
- Objects from active threads
- JNI references
```

## Heap Generations

```
Heap
├─ Young Generation (90% of collections happen here)
│  ├─ Eden Space (most objects allocated)
│  ├─ Survivor 0 (survived one collection)
│  └─ Survivor 1 (survived multiple collections)
│
└─ Old Generation (long-lived objects)
```

## GC Algorithms

### 1. Mark and Sweep

```
Step 1: Mark all reachable objects
  Root → A → B → C
         ↓       ↓
         D       E
  (A, B, C, D, E are marked)

Step 2: Sweep unreachable
  F, G, H are unmarked → Reclaimed
```

### 2. Generational GC

```java
// Young collection (fast, frequent)
Object a = new Object();              // Created in Eden
a = null;                             // Soon collected

// Old collection (slow, infrequent)
Object b = new Object();              // In young gen
// Survives multiple collections
// Promoted to old gen
b = null;                             // Collected slowly
```

### 3. Copying GC

```
Before:
Eden: [A, B, C, D]  Survivor0: [E]

Collection:
Copy reachable to Survivor1: [A, B, D, E]

After:
Eden: [empty]  Survivor1: [A, B, D, E]  (C was unreachable)
```

## GC Types in Java

### 1. Serial GC (Single-threaded)

```bash
java -XX:+UseSerialGC MyApp

# All application threads stop during GC
# Good for: Small applications, single processor
# Bad for: Throughput, latency
```

### 2. Parallel GC (Multi-threaded)

```bash
java -XX:+UseParallelGC MyApp

# Multiple GC threads, application pauses
# Good for: Throughput on multi-core
# Bad for: Pause times
```

### 3. Concurrent Mark Sweep (CMS)

```bash
java -XX:+UseConcMarkSweepGC MyApp

# Deprecated in Java 9+
# Application runs during marking
# Good for: Low latency
# Bad for: Complexity, fragmentation
```

### 4. G1 (Garbage First)

```bash
java -XX:+UseG1GC MyApp
# Default in Java 9+

# Divides heap into regions
# Collects regions with most garbage first
# Good for: Large heaps, predictable pauses
# Bad for: Small heaps (<4GB)
```

### 5. ZGC (Z Garbage Collector)

```bash
java -XX:+UseZGC MyApp

# Ultra-low latency (< 10ms pauses)
# Concurrent
# Good for: Real-time, low-latency systems
# Bad for: Memory overhead
```

## Complete GC Example

```java
public class GCDemo {
    
    static class DataObject {
        byte[] data = new byte[1024 * 100];  // 100KB
    }
    
    public static void main(String[] args) throws Exception {
        System.out.println("Starting GC demo");
        
        // Get memory info
        MemoryMXBean memory = ManagementFactory.getMemoryMXBean();
        
        // Create objects
        List<DataObject> objects = new ArrayList<>();
        
        for (int i = 0; i < 10; i++) {
            objects.add(new DataObject());
            System.out.println("Created object " + i);
            
            // Print memory usage
            long used = memory.getHeapMemoryUsage().getUsed() / 1024 / 1024;
            System.out.println("Heap used: " + used + "MB");
        }
        
        System.out.println("\nClearing list (making objects unreachable)");
        objects.clear();
        
        // Suggest GC (not guaranteed)
        System.gc();
        
        Thread.sleep(1000);
        
        long used = memory.getHeapMemoryUsage().getUsed() / 1024 / 1024;
        System.out.println("Heap used after GC: " + used + "MB");
    }
}

// Output:
// Starting GC demo
// Created object 0
// Heap used: 64MB
// Created object 1
// Heap used: 65MB
// ...
// Clearing list (making objects unreachable)
// Heap used after GC: 10MB (memory reclaimed!)
```

## Monitoring GC

### Run with GC Logging

```bash
java -Xmx512m \
     -Xlog:gc:file=gc.log \
     -Xlog:gc:level=debug \
     MyApp

# gc.log output:
# [0.123s][info][gc] GC(0) Pause Young (G1 Evacuation Pause) 64M->32M(512M) 15.234ms
# [0.234s][info][gc] GC(1) Pause Young (G1 Evacuation Pause) 48M->24M(512M) 10.567ms
```

### Monitor via Code

```java
import java.lang.management.*;

public class GCMonitor {
    
    public static void main(String[] args) {
        List<GarbageCollectorMXBean> gcBeans = 
            ManagementFactory.getGarbageCollectorMXBeans();
        
        System.out.println("GC Collectors:");
        for (GarbageCollectorMXBean gc : gcBeans) {
            System.out.println("\n" + gc.getName());
            System.out.println("  Collection count: " + gc.getCollectionCount());
            System.out.println("  Collection time: " + gc.getCollectionTime() + "ms");
            System.out.println("  Memory pools: " + 
                Arrays.toString(gc.getMemoryPoolNames()));
        }
    }
}

// Output example:
// GC Collectors:
//
// G1 Young Generation
//   Collection count: 5
//   Collection time: 125ms
//   Memory pools: [G1 Eden Space, G1 Survivor Space]
//
// G1 Old Generation
//   Collection count: 0
//   Collection time: 0ms
//   Memory pools: [G1 Old Gen, G1 Humongous Objects]
```

## Tuning GC

### Heap Sizing

```bash
# Small heap = frequent GC
java -Xms128m -Xmx128m MyApp

# Large heap = infrequent GC but longer pauses
java -Xms2g -Xmx2g MyApp

# Balanced (3/4 of system RAM)
# System has 8GB: use -Xmx6g
```

### Young Generation Sizing

```bash
# Default: 1/3 of heap
# Increase for many short-lived objects
java -Xms2g -Xmx2g -Xmn800m MyApp

# Decrease for long-lived objects
java -Xms2g -Xmx2g -Xmn400m MyApp
```

### Parallel GC

```bash
# Number of GC threads
java -XX:ParallelGCThreads=8 MyApp

# Number of concurrent mark threads
java -XX:ConcGCThreads=2 MyApp
```

## Avoiding GC Issues

### 1. Avoid Full GC

```java
// ❌ Creates garbage frequently
public void badMethod() {
    for (int i = 0; i < 1_000_000; i++) {
        String s = "Value: " + i;  // Creates millions of objects
    }
}

// ✅ Better approach
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 1_000_000; i++) {
    sb.append("Value: ").append(i).append("\n");
}
```

### 2. Avoid Memory Leaks

```java
// ❌ Memory leak - references keep growing
static List<String> cache = new ArrayList<>();

public void addToCache(String value) {
    cache.add(value);  // Never removed!
}

// ✅ Better - use LinkedHashMap with max size
static Map<String, String> cache = new LinkedHashMap<String, String>(100) {
    protected boolean removeEldestEntry(Map.Entry eldest) {
        return size() > 100;
    }
};
```

### 3. Avoid Long Object References

```java
// ❌ Keeps old objects in memory
class Node {
    Object value;
    Node next;
    
    void clear() {
        next = null;  // Important!
    }
}

// ✅ Better - use try-with-resources
try (Resource resource = new Resource()) {
    // Use resource
    // Automatically closed and GC'd
}
```

## GC Pause Prediction

```java
public class GCPausePrediction {
    
    public static void main(String[] args) throws Exception {
        // Monitor GC pauses
        for (int i = 0; i < 5; i++) {
            long before = System.nanoTime();
            System.gc();  // Force GC
            long after = System.nanoTime();
            
            long pauseMs = (after - before) / 1_000_000;
            System.out.println("GC pause: " + pauseMs + "ms");
            
            Thread.sleep(1000);
        }
    }
}

// Output:
// GC pause: 15ms
// GC pause: 12ms
// GC pause: 18ms
// GC pause: 14ms
// GC pause: 16ms
```

## Real-time Example: Streaming API

```java
public class StreamingProcessor {
    
    public static void main(String[] args) {
        // Process 1 million items without loading all in memory
        IntStream.range(1, 1_000_001)
            .filter(n -> n % 2 == 0)              // Keep evens
            .map(n -> n * n)                      // Square them
            .limit(100)                           // Take first 100
            .forEach(n -> System.out.println(n)); // Print
        
        // No arrays created, lazy evaluation
        // GC has minimal work to do
    }
}
```

## Key Takeaways

- ✅ GC automatically reclaims unreachable memory
- ✅ Young generation collects frequently and fast
- ✅ Old generation collects rarely and slowly
- ✅ G1 is good default for most applications
- ✅ ZGC for ultra-low latency requirements
- ✅ Avoid creating excessive objects
- ✅ Avoid memory leaks and long-lived references
- ✅ Monitor GC with logging and tools
- ✅ Tune heap size based on application needs
- ✅ Streaming APIs reduce GC pressure

---

**Next →** Complete! Java Learning Roadmap 100% done! 🎉
