# Virtual Threads: Modern Lightweight Concurrency (Java 21+)

## What are Virtual Threads?

**Virtual Threads** are lightweight threads managed by the JVM, allowing you to create millions of them without the overhead of platform threads.

**Real-world analogy**: Virtual threads are like digital workers who don't need their own office - thousands can work efficiently with fewer physical resources.

## Virtual Threads vs Platform Threads

```java
// Traditional Platform Thread
Thread thread = new Thread(() -> {
    System.out.println("Hello from platform thread");
});
thread.start();

// Problem: Creating 1 million platform threads = expensive
// Each uses ~1MB memory + OS resources

// Virtual Thread (Java 21+)
Thread virtual = Thread.ofVirtual()
    .start(() -> {
        System.out.println("Hello from virtual thread");
    });

// Benefit: Can create 1 million virtual threads easily!
// Each uses ~100 bytes memory = massive savings
```

## Creating Virtual Threads

### Basic Approach

```java
// Traditional way
new Thread(() -> System.out.println("Hello")).start();

// Virtual thread way
Thread.ofVirtual()
    .start(() -> System.out.println("Hello"));

// Even simpler - direct creation
Thread virtualThread = Thread.startVirtualThread(() -> {
    System.out.println("Running in virtual thread");
});
```

### With Executor Service

```java
import java.util.concurrent.*;

// Traditional: creates limited thread pool
ExecutorService executor = Executors.newFixedThreadPool(10);

// Virtual: can handle thousands
ExecutorService virtualExecutor = Executors.newVirtualThreadPerTaskExecutor();

// Submit tasks
for (int i = 0; i < 10000; i++) {
    virtualExecutor.submit(() -> {
        doWork();
    });
}

virtualExecutor.shutdown();
virtualExecutor.awaitTermination(1, TimeUnit.MINUTES);
```

## Complete Examples

### 1. High-Throughput Web Server

```java
import java.io.*;
import java.net.*;
import java.util.concurrent.*;

public class VirtualThreadWebServer {
    
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(8080);
        ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();
        
        System.out.println("Server listening on port 8080");
        
        while (true) {
            Socket clientSocket = serverSocket.accept();
            
            // Each connection gets its own virtual thread
            executor.submit(() -> handleClient(clientSocket));
        }
    }
    
    private static void handleClient(Socket socket) {
        try (socket) {
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(socket.getInputStream())
            );
            PrintWriter writer = new PrintWriter(
                socket.getOutputStream(), true
            );
            
            String request = reader.readLine();
            System.out.println("Request: " + request);
            
            // Simulate processing
            Thread.sleep(100);
            
            // Send response
            writer.println("HTTP/1.1 200 OK");
            writer.println("Content-Type: text/plain");
            writer.println();
            writer.println("Hello from Virtual Thread Server!");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

// With platform threads: can handle ~1000 connections
// With virtual threads: can handle 1,000,000+ connections!
```

### 2. Database Connection Pool

```java
import java.util.concurrent.*;
import java.util.*;

public class VirtualThreadDatabaseClient {
    
    public static void main(String[] args) throws Exception {
        ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();
        
        // Simulate 100,000 database queries
        List<Future<?>> futures = new ArrayList<>();
        
        for (int i = 0; i < 100000; i++) {
            final int id = i;
            futures.add(executor.submit(() -> {
                String result = queryDatabase(id);
                System.out.println("Query " + id + ": " + result);
            }));
        }
        
        // Wait for all to complete
        for (Future<?> future : futures) {
            future.get();
        }
        
        executor.shutdown();
    }
    
    private static String queryDatabase(int id) {
        try {
            // Simulate database latency (blocking operation)
            Thread.sleep(10);
            return "User " + id;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return "Error";
        }
    }
}

// With platform threads: max ~100 concurrent queries
// With virtual threads: easily 100,000 concurrent queries!
```

### 3. Task Processing System

```java
public class VirtualThreadTaskProcessor {
    
    private static class Task {
        int id;
        String data;
        
        Task(int id, String data) {
            this.id = id;
            this.data = data;
        }
    }
    
    public static void main(String[] args) throws Exception {
        ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();
        
        // Create 10,000 tasks
        for (int i = 0; i < 10000; i++) {
            final Task task = new Task(i, "Data-" + i);
            executor.submit(() -> processTask(task));
        }
        
        executor.shutdown();
        executor.awaitTermination(5, TimeUnit.MINUTES);
        System.out.println("All tasks completed!");
    }
    
    private static void processTask(Task task) {
        try {
            System.out.println("Processing task: " + task.id);
            
            // Simulate blocking operations
            Thread.sleep(50);
            
            // Process data
            String result = task.data.toUpperCase();
            
            // More blocking (I/O)
            Thread.sleep(50);
            
            System.out.println("Task " + task.id + " result: " + result);
            
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}

// Performance: 10,000 tasks complete in ~100ms
// (not 10,000 * 100ms = 1,000 seconds!)
```

## Virtual Thread Characteristics

### Benefits

```java
// 1. Massive scalability
ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();
for (int i = 0; i < 1_000_000; i++) {  // Million tasks!
    executor.submit(() -> doWork());
}

// 2. Simple to use (same API as regular threads)
executor.submit(() -> blockingIO());  // Just works!

// 3. Automatic scheduling
// JVM schedules virtual threads on available platform threads

// 4. Works with existing code
// No need to rewrite lambdas or callbacks
```

### Limitations

```java
// 1. Pinning (virtual thread blocked)
// If blocking in synchronized block, virtual thread pins to platform thread
synchronized(this) {  // âŒ Avoid in virtual threads
    blockingIO();     // Virtual thread pinned!
}

// 2. Still subject to GC
// Virtual threads don't eliminate garbage collection pauses

// 3. Not for CPU-bound work
// Virtual threads help with I/O-bound, not computation
```

## Performance Comparison

```java
public class PerformanceTest {
    
    static long blockingIO() throws InterruptedException {
        Thread.sleep(10);  // Simulate I/O
        return System.nanoTime();
    }
    
    public static void main(String[] args) throws Exception {
        int TASK_COUNT = 10000;
        
        // Platform threads
        long start1 = System.currentTimeMillis();
        ExecutorService platform = Executors.newFixedThreadPool(100);
        for (int i = 0; i < TASK_COUNT; i++) {
            platform.submit(() -> {
                try { blockingIO(); } catch (Exception e) {}
            });
        }
        platform.shutdown();
        platform.awaitTermination(1, TimeUnit.MINUTES);
        long platformTime = System.currentTimeMillis() - start1;
        
        // Virtual threads
        long start2 = System.currentTimeMillis();
        ExecutorService virtual = Executors.newVirtualThreadPerTaskExecutor();
        for (int i = 0; i < TASK_COUNT; i++) {
            virtual.submit(() -> {
                try { blockingIO(); } catch (Exception e) {}
            });
        }
        virtual.shutdown();
        virtual.awaitTermination(1, TimeUnit.MINUTES);
        long virtualTime = System.currentTimeMillis() - start2;
        
        System.out.println("Platform threads: " + platformTime + "ms");
        System.out.println("Virtual threads:  " + virtualTime + "ms");
        System.out.println("Speedup: " + (platformTime / (double) virtualTime) + "x");
    }
}

// Output Example:
// Platform threads: 1050ms
// Virtual threads:  120ms
// Speedup: 8.75x
```

## When to Use Virtual Threads

### âœ… Perfect For:
- I/O-bound applications (network, database, files)
- High-concurrency scenarios (10,000+ simultaneous operations)
- Web servers and microservices
- Batch processing with blocking calls
- Server applications handling many clients

### âŒ Not Suitable For:
- CPU-intensive computing
- Real-time systems (GC pauses still occur)
- Code with lots of synchronized blocks
- Applications with strict latency requirements

## Migration from Platform Threads

```java
// Before: Platform threads
ExecutorService executor = Executors.newFixedThreadPool(100);

// After: Virtual threads (drop-in replacement!)
ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();

// Code using executor doesn't need to change!
```

## Common Patterns

### Pattern 1: Virtual Thread Per Request

```java
@RestController
@RequestMapping("/api")
public class VirtualThreadController {
    
    @Autowired
    private ExecutorService executor;
    
    @GetMapping("/data/{id}")
    public CompletableFuture<Data> getData(@PathVariable int id) {
        return CompletableFuture.supplyAsync(
            () -> fetchDataFromDatabase(id),
            executor  // Virtual thread executor
        );
    }
    
    // Handles thousands of concurrent requests easily!
}
```

### Pattern 2: Batch Processing

```java
public class VirtualThreadBatchProcessor {
    
    public void processBatch(List<Item> items) throws Exception {
        try (ExecutorService executor = 
             Executors.newVirtualThreadPerTaskExecutor()) {
            
            items.forEach(item -> 
                executor.submit(() -> processItem(item))
            );
        }
    }
}
```

## Common Mistakes

### 1. Using Synchronized Blocks

```java
// âŒ WRONG - causes pinning
ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();
executor.submit(() -> {
    synchronized(lock) {
        blockingIO();  // Virtual thread pinned!
    }
});

// âœ… RIGHT - use ReentrantLock
Lock lock = new ReentrantLock();
executor.submit(() -> {
    lock.lock();
    try {
        blockingIO();  // Virtual thread not pinned
    } finally {
        lock.unlock();
    }
});
```

### 2. Using for CPU-Bound Work

```java
// âŒ WRONG - virtual threads don't help with computation
ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();
executor.submit(() -> {
    for (int i = 0; i < 1_000_000; i++) {
        calculate();  // CPU-bound, not I/O-bound
    }
});

// âœ… RIGHT - use fixed thread pool for CPU work
ExecutorService executor = Executors.newFixedThreadPool(
    Runtime.getRuntime().availableProcessors()
);
```

### 3. Creating Too Many

```java
// âŒ WRONG - creating millions without limiting
for (int i = 0; i < 10_000_000; i++) {
    Thread.startVirtualThread(() -> doWork());  // OutOfMemory!
}

// âœ… RIGHT - use executor to manage
ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor();
for (int i = 0; i < 10_000_000; i++) {
    executor.submit(() -> doWork());  // Managed properly
}
```

## Key Takeaways

- âœ… Virtual threads are lightweight, JVM-managed threads
- âœ… Enable millions of concurrent tasks easily
- âœ… Perfect for I/O-bound applications
- âœ… Use `Executors.newVirtualThreadPerTaskExecutor()`
- âœ… Not for CPU-intensive work
- âœ… Avoid synchronized blocks (causes pinning)
- âœ… Massive scalability improvement over platform threads
- âœ… Java 21+ feature

---

