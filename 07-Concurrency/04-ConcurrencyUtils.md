# Concurrency Utilities in Java

## Overview

Java provides thread-safe utilities in `java.util.concurrent` package for managing concurrent operations.

**Key Classes:**
- `ExecutorService` - Thread pool management
- `CountDownLatch` - Coordinate multiple threads
- `CyclicBarrier` - Sync point for threads
- `Semaphore` - Resource access control
- `ReentrantLock` - Advanced locking
- `ConcurrentHashMap` - Thread-safe map
- `BlockingQueue` - Thread-safe queue
- `AtomicInteger` - Lock-free operations

## ExecutorService - Thread Pooling

### Create Thread Pool

```java
public class ExecutorExample {
    
    public static void main(String[] args) {
        // Create thread pool with 4 threads
        ExecutorService executor = Executors.newFixedThreadPool(4);
        
        // Submit tasks
        for (int i = 1; i <= 10; i++) {
            int taskId = i;
            executor.submit(() -> {
                System.out.println("Task " + taskId + " by " + 
                    Thread.currentThread().getName());
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            });
        }
        
        // Shutdown
        executor.shutdown();
        
        try {
            if (!executor.awaitTermination(30, TimeUnit.SECONDS)) {
                executor.shutdownNow();  // Force shutdown
            }
        } catch (InterruptedException e) {
            executor.shutdownNow();
        }
    }
}

// Output:
// Task 1 by pool-1-thread-1
// Task 2 by pool-1-thread-2
// Task 3 by pool-1-thread-3
// Task 4 by pool-1-thread-4
// Task 5 by pool-1-thread-1  (reused)
// ...
```

### Types of ExecutorService

```java
// 1. Fixed Thread Pool
ExecutorService fixed = Executors.newFixedThreadPool(4);
// Always has 4 threads, queues extras

// 2. Cached Thread Pool
ExecutorService cached = Executors.newCachedThreadPool();
// Creates new threads as needed, reuses idle ones

// 3. Single Thread Executor
ExecutorService single = Executors.newSingleThreadExecutor();
// Single thread, guaranteed sequential execution

// 4. Virtual Thread Executor (Java 21+)
ExecutorService virtual = Executors.newVirtualThreadPerTaskExecutor();
// Creates virtual thread for each task
```

## CountDownLatch - Wait for Multiple Threads

### Coordinate Startup

```java
public class CountDownLatchExample {
    
    static class Worker implements Runnable {
        private CountDownLatch startLatch;
        private CountDownLatch endLatch;
        private String name;
        
        Worker(String name, CountDownLatch startLatch, CountDownLatch endLatch) {
            this.name = name;
            this.startLatch = startLatch;
            this.endLatch = endLatch;
        }
        
        @Override
        public void run() {
            try {
                System.out.println(name + " waiting to start...");
                startLatch.await();  // Wait for signal
                
                System.out.println(name + " starting work...");
                Thread.sleep(2000);  // Simulate work
                System.out.println(name + " finished!");
                
                endLatch.countDown();  // Signal completion
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
    
    public static void main(String[] args) throws InterruptedException {
        int numWorkers = 3;
        CountDownLatch startLatch = new CountDownLatch(1);
        CountDownLatch endLatch = new CountDownLatch(numWorkers);
        
        // Start workers
        ExecutorService executor = Executors.newFixedThreadPool(numWorkers);
        for (int i = 0; i < numWorkers; i++) {
            executor.submit(new Worker("Worker-" + (i + 1), startLatch, endLatch));
        }
        
        System.out.println("Main: All workers started, waiting 2 seconds...");
        Thread.sleep(2000);
        
        System.out.println("Main: Signaling workers to start!");
        startLatch.countDown();  // Signal all to start
        
        System.out.println("Main: Waiting for workers to finish...");
        endLatch.await();  // Wait for all to finish
        
        System.out.println("Main: All workers done!");
        executor.shutdown();
    }
}

// Output:
// Main: All workers started, waiting 2 seconds...
// Worker-1 waiting to start...
// Worker-2 waiting to start...
// Worker-3 waiting to start...
// Main: Signaling workers to start!
// Worker-1 starting work...
// Worker-2 starting work...
// Worker-3 starting work...
// Main: Waiting for workers to finish...
// Worker-1 finished!
// Worker-2 finished!
// Worker-3 finished!
// Main: All workers done!
```

## CyclicBarrier - Sync Point

### Barrier for All Threads

```java
public class CyclicBarrierExample {
    
    static class WorkerPhase implements Runnable {
        private CyclicBarrier barrier;
        private String name;
        private int taskId;
        
        WorkerPhase(String name, int taskId, CyclicBarrier barrier) {
            this.name = name;
            this.taskId = taskId;
            this.barrier = barrier;
        }
        
        @Override
        public void run() {
            try {
                for (int phase = 1; phase <= 3; phase++) {
                    System.out.println(name + " Phase " + phase + " started");
                    Thread.sleep(ThreadLocalRandom.current().nextInt(1000, 3000));
                    System.out.println(name + " Phase " + phase + " done");
                    
                    System.out.println(name + " waiting at barrier...");
                    barrier.await();  // Wait for all threads at barrier
                    System.out.println(name + " proceeding to next phase!");
                }
            } catch (InterruptedException | BrokenBarrierException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
    
    public static void main(String[] args) {
        int numWorkers = 3;
        CyclicBarrier barrier = new CyclicBarrier(numWorkers);
        
        ExecutorService executor = Executors.newFixedThreadPool(numWorkers);
        for (int i = 0; i < numWorkers; i++) {
            executor.submit(new WorkerPhase("Worker-" + (i + 1), i, barrier));
        }
        
        executor.shutdown();
    }
}

// Output:
// Worker-1 Phase 1 started
// Worker-2 Phase 1 started
// Worker-3 Phase 1 started
// Worker-1 Phase 1 done
// Worker-1 waiting at barrier...
// Worker-2 Phase 1 done
// Worker-2 waiting at barrier...
// Worker-3 Phase 1 done
// Worker-3 waiting at barrier...
// Worker-1 proceeding to next phase!  (all reached barrier)
// Worker-2 proceeding to next phase!
// Worker-3 proceeding to next phase!
// ... (continues for phases 2, 3)
```

## Semaphore - Control Access

### Limit Resource Access

```java
public class SemaphoreExample {
    
    static class Database {
        private Semaphore connectionPool = new Semaphore(3);  // 3 connections
        
        public void query(String clientName) {
            try {
                System.out.println(clientName + " waiting for connection...");
                connectionPool.acquire();  // Request connection
                
                System.out.println(clientName + " executing query...");
                Thread.sleep(2000);  // Simulate query
                System.out.println(clientName + " finished!");
                
                connectionPool.release();  // Release connection
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
    
    public static void main(String[] args) {
        Database db = new Database();
        ExecutorService executor = Executors.newFixedThreadPool(5);
        
        for (int i = 1; i <= 5; i++) {
            int clientId = i;
            executor.submit(() -> db.query("Client-" + clientId));
        }
        
        executor.shutdown();
    }
}

// Output:
// Client-1 waiting for connection...
// Client-1 executing query...
// Client-2 waiting for connection...
// Client-2 executing query...
// Client-3 waiting for connection...
// Client-3 executing query...
// Client-4 waiting for connection...  (waits for connection)
// Client-5 waiting for connection...  (waits for connection)
// Client-1 finished!  (Client-4 gets connection)
// Client-4 executing query...
// ...
```

## ReentrantLock - Advanced Locking

### Lock with Timeout

```java
public class ReentrantLockExample {
    
    static class SafeCounter {
        private int count = 0;
        private ReentrantLock lock = new ReentrantLock();
        
        public void increment() {
            lock.lock();
            try {
                count++;
            } finally {
                lock.unlock();
            }
        }
        
        public int getCount() {
            lock.lock();
            try {
                return count;
            } finally {
                lock.unlock();
            }
        }
        
        // Lock with timeout
        public boolean incrementWithTimeout() {
            try {
                if (lock.tryLock(1, TimeUnit.SECONDS)) {
                    try {
                        count++;
                        return true;
                    } finally {
                        lock.unlock();
                    }
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            return false;
        }
    }
    
    public static void main(String[] args) throws InterruptedException {
        SafeCounter counter = new SafeCounter();
        
        ExecutorService executor = Executors.newFixedThreadPool(4);
        for (int i = 0; i < 1000; i++) {
            executor.submit(counter::increment);
        }
        
        executor.shutdown();
        executor.awaitTermination(10, TimeUnit.SECONDS);
        
        System.out.println("Final count: " + counter.getCount());  // 1000
    }
}
```

## ConcurrentHashMap - Thread-Safe Map

### Safe Concurrent Access

```java
public class ConcurrentHashMapExample {
    
    public static void main(String[] args) throws InterruptedException {
        // Not thread-safe
        Map<String, Integer> unsafeMap = new HashMap<>();
        
        // Thread-safe
        ConcurrentHashMap<String, Integer> safeMap = new ConcurrentHashMap<>();
        
        ExecutorService executor = Executors.newFixedThreadPool(4);
        
        // Multiple threads updating map
        for (int i = 0; i < 100; i++) {
            int count = i;
            executor.submit(() -> {
                String key = "Key-" + (count % 5);
                safeMap.putIfAbsent(key, 0);
                safeMap.compute(key, (k, v) -> v + 1);
            });
        }
        
        executor.shutdown();
        executor.awaitTermination(10, TimeUnit.SECONDS);
        
        System.out.println("Map: " + safeMap);
        // Key-0 appears 20 times, Key-1 20 times, etc.
    }
}

// Output:
// Map: {Key-0=20, Key-1=20, Key-2=20, Key-3=20, Key-4=20}
```

## BlockingQueue - Thread-Safe Queue

### Producer-Consumer Pattern

```java
public class BlockingQueueExample {
    
    static class Producer implements Runnable {
        private BlockingQueue<String> queue;
        
        Producer(BlockingQueue<String> queue) {
            this.queue = queue;
        }
        
        @Override
        public void run() {
            try {
                for (int i = 1; i <= 5; i++) {
                    String item = "Item-" + i;
                    System.out.println("Producer: producing " + item);
                    queue.put(item);  // Block if queue full
                    Thread.sleep(500);
                }
                queue.put("DONE");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
    
    static class Consumer implements Runnable {
        private BlockingQueue<String> queue;
        
        Consumer(BlockingQueue<String> queue) {
            this.queue = queue;
        }
        
        @Override
        public void run() {
            try {
                while (true) {
                    String item = queue.take();  // Block if queue empty
                    if ("DONE".equals(item)) {
                        System.out.println("Consumer: done!");
                        break;
                    }
                    System.out.println("Consumer: consuming " + item);
                    Thread.sleep(1000);
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
    
    public static void main(String[] args) {
        BlockingQueue<String> queue = new LinkedBlockingQueue<>(2);
        
        ExecutorService executor = Executors.newFixedThreadPool(2);
        executor.submit(new Producer(queue));
        executor.submit(new Consumer(queue));
        
        executor.shutdown();
    }
}

// Output:
// Producer: producing Item-1
// Consumer: consuming Item-1
// Producer: producing Item-2
// Consumer: consuming Item-2
// ...
// Producer: producing Item-5
// Consumer: consuming Item-5
// Consumer: done!
```

## AtomicInteger - Lock-Free Operations

### Safe Counter Without Locks

```java
public class AtomicIntegerExample {
    
    static class Counter {
        private AtomicInteger count = new AtomicInteger(0);
        
        public void increment() {
            count.incrementAndGet();
        }
        
        public int getCount() {
            return count.get();
        }
        
        // Atomic operations
        public void atomicAdd(int value) {
            count.addAndGet(value);
        }
        
        public boolean compareAndSet(int expect, int update) {
            return count.compareAndSet(expect, update);
        }
    }
    
    public static void main(String[] args) throws InterruptedException {
        Counter counter = new Counter();
        
        ExecutorService executor = Executors.newFixedThreadPool(4);
        for (int i = 0; i < 10000; i++) {
            executor.submit(counter::increment);
        }
        
        executor.shutdown();
        executor.awaitTermination(10, TimeUnit.SECONDS);
        
        System.out.println("Count: " + counter.getCount());  // 10000
    }
}
```

## Comparison Table

| Tool | Purpose | Usage |
|------|---------|-------|
| ExecutorService | Thread pool | Task execution |
| CountDownLatch | Wait for completion | Start/End coordination |
| CyclicBarrier | Sync point | Phase coordination |
| Semaphore | Control access | Resource limiting |
| ReentrantLock | Advanced locking | Timeout locks |
| ConcurrentHashMap | Thread-safe map | Shared data |
| BlockingQueue | Thread-safe queue | Producer-consumer |
| AtomicInteger | Lock-free counter | High-performance counters |

## Key Takeaways

- ExecutorService manages thread pools efficiently
- CountDownLatch coordinates multiple threads
- CyclicBarrier synchronizes at checkpoints
- Semaphore controls resource access
- ReentrantLock provides timeout support
- ConcurrentHashMap is thread-safe for maps
- BlockingQueue implements producer-consumer
- AtomicInteger provides lock-free counters
- Always use these instead of manual synchronization
- Prefer concurrent collections over synchronized wrappers

---


