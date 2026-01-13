# Java Memory Model

## What is the Memory Model?

The **Java Memory Model (JMM)** defines:
- How threads interact through memory
- When changes by one thread become visible to another
- Guarantees about program execution order

**Without JMM:** Programs behavior would be unpredictable on multi-core systems.

## Visibility Problem

### The Issue

```java
public class VisibilityExample {
    
    static boolean flag = false;
    
    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(() -> {
            while (!flag) {
                // Infinite loop?
            }
            System.out.println("Flag is now true!");
        });
        
        t.start();
        Thread.sleep(1000);
        flag = true;  // Change flag
        t.join();
    }
}

// Problem:
// Thread t may cache 'flag' value
// May never see the change in main thread
// Might loop forever!
```

### Without Visibility Guarantee

```
Thread 1                Main Thread
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”      â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ flag = false â”‚      â”‚ Main heap    â”‚
â”‚ (cached)     â”‚      â”‚ flag = false â”‚
â”‚ reads flag   â”‚      â”‚              â”‚
â”‚ flag = false â”‚      â”‚              â”‚
â”‚ reads flag   â”‚      â”‚              â”‚
â”‚ flag = false â”‚      â”‚ (sets flag)  â”‚
â”‚ ...          â”‚      â”‚ flag = true  â”‚
â”‚              â”‚      â”‚              â”‚
â”‚ Never sees   â”‚      â”‚              â”‚
â”‚ the change!  â”‚      â”‚              â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜      â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

## Happens-Before Relationship

**Happens-Before** guarantees that memory writes are visible.

### Simple Happens-Before

```java
public class HappensBeforeExample {
    
    public static void main(String[] args) {
        int x = 5;
        int y = x + 1;  // Happens-before: x = 5 happens before y assignment
        
        System.out.println(y);  // Always 6
    }
}

// Single thread: everything is in order
```

### Multi-Thread Happens-Before

```java
public class MultiThreadExample {
    
    static int x = 0;
    
    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread(() -> {
            x = 5;
            System.out.println("T1: x = " + x);
        });
        
        Thread t2 = new Thread(() -> {
            try {
                t1.join();  // Wait for t1 to finish
                System.out.println("T2: x = " + x);  // âœ“ Always sees x = 5
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        
        t1.start();
        t2.start();
        t2.join();
    }
}

// Happens-before: t1 finish â†’ t1.join() returns â†’ x = 5 visible
```

## Synchronization & Visibility

### volatile - Visibility Without Locking

```java
public class VolatileExample {
    
    static volatile boolean flag = false;  // volatile keyword
    
    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(() -> {
            while (!flag) {
                // Volatile read ensures fresh value
            }
            System.out.println("Flag is now true!");
        });
        
        t.start();
        Thread.sleep(1000);
        flag = true;  // Volatile write is immediately visible
        t.join();
    }
}

// volatile guarantees:
// 1. Write is immediately flushed to main memory
// 2. Read always gets latest value from main memory
// 3. No caching optimization
```

### Memory Visibility with volatile

```
With volatile flag:
Thread 1                Main Thread
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”      â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ reads flag   â”‚      â”‚ Main heap    â”‚
â”‚ from memory  â”‚      â”‚ flag = false â”‚
â”‚ flag = false â”‚      â”‚              â”‚
â”‚ reads flag   â”‚      â”‚              â”‚
â”‚ from memory  â”‚      â”‚ (sets flag)  â”‚
â”‚ flag = false â”‚      â”‚ flag = true  â”‚
â”‚ reads flag   â”‚      â”‚ (flushed!)   â”‚
â”‚ from memory  â”‚      â”‚              â”‚
â”‚ flag = true  â”‚      â”‚              â”‚
â”‚ âœ“ SEES CHANGEâ”‚      â”‚              â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜      â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### synchronized - Lock & Visibility

```java
public class SynchronizedVisibility {
    
    static class Counter {
        private int count = 0;
        
        public synchronized void increment() {
            count++;  // Acquire lock
        }        // Release lock â†’ all changes visible
        
        public synchronized int getCount() {
            return count;  // Acquire lock â†’ see all changes
        }
    }
    
    public static void main(String[] args) throws InterruptedException {
        Counter counter = new Counter();
        
        Thread t = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                counter.increment();
            }
        });
        
        t.start();
        t.join();
        
        System.out.println(counter.getCount());  // 1000 (guaranteed)
    }
}

// synchronized guarantees:
// 1. Lock acquisition = visibility of all previous writes
// 2. Lock release = visibility of all current writes to others
```

## Memory Barriers

**Memory Barrier** - CPU instruction that enforces memory ordering.

### Types of Barriers

```
1. LoadStore: Load before Store
   â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚ Read variable            â”‚
   â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤ â† Barrier
   â”‚ Write variable           â”‚
   â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

2. StoreStore: Store before Store
   â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚ Write variable 1         â”‚
   â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤ â† Barrier
   â”‚ Write variable 2         â”‚
   â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

3. LoadLoad: Load before Load
   â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚ Read variable 1          â”‚
   â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤ â† Barrier
   â”‚ Read variable 2          â”‚
   â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

4. StoreLoad: Store before Load (strongest)
   â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚ Write variable           â”‚
   â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤ â† Barrier
   â”‚ Read variable            â”‚
   â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

## Data Races

### Race Condition Example

```java
public class DataRace {
    
    static int counter = 0;  // â† Data race!
    
    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                counter++;  // Read-Modify-Write (3 steps!)
            }
        });
        
        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                counter++;
            }
        });
        
        t1.start();
        t2.start();
        t1.join();
        t2.join();
        
        System.out.println(counter);  // Expected: 2000, Actual: 1234!
    }
}

// Data race: Two threads access counter without synchronization
// Result: Unpredictable!
```

### Why counter++ is not atomic

```
counter++; is actually three operations:
1. Load counter value from memory
2. Add 1 to value
3. Store back to memory

Thread 1              Thread 2
load counter=5
add 1 â†’ 6
                     load counter=5 (hasn't seen write yet!)
                     add 1 â†’ 6
store counter=6
                     store counter=6

Result: counter=6 (should be 7!)
```

## Fix 1: Using volatile

```java
public class VolatileFix {
    
    static volatile int counter = 0;  // volatile doesn't fix atomicity!
    
    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                counter++;  // Still not atomic!
            }
        });
        
        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                counter++;
            }
        });
        
        t1.start();
        t2.start();
        t1.join();
        t2.join();
        
        System.out.println(counter);  // Still wrong! ~1400
    }
}

// volatile only guarantees visibility, not atomicity
```

## Fix 2: Using synchronized

```java
public class SynchronizedFix {
    
    static int counter = 0;
    
    public static void increment() {
        synchronized (SynchronizedFix.class) {
            counter++;
        }
    }
    
    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                increment();
            }
        });
        
        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                increment();
            }
        });
        
        t1.start();
        t2.start();
        t1.join();
        t2.join();
        
        System.out.println(counter);  // âœ“ Always 2000
    }
}

// synchronized ensures:
// 1. Only one thread executes at a time
// 2. All changes visible after release
```

## Fix 3: Using AtomicInteger

```java
public class AtomicFix {
    
    static AtomicInteger counter = new AtomicInteger(0);
    
    public static void main(String[] args) throws InterruptedException {
        Thread t1 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                counter.incrementAndGet();
            }
        });
        
        Thread t2 = new Thread(() -> {
            for (int i = 0; i < 1000; i++) {
                counter.incrementAndGet();
            }
        });
        
        t1.start();
        t2.start();
        t1.join();
        t2.join();
        
        System.out.println(counter);  // âœ“ Always 2000
    }
}

// AtomicInteger uses hardware CAS (Compare-And-Swap)
// No lock needed, very fast
```

## Happens-Before Rules

```
1. Program Order Rule
   a = 5;
   b = a + 1;  // a = 5 happens-before b = a + 1

2. Monitor Lock Rule
   synchronized(lock) { ... }  // Lock acquisition sees previous writes

3. Volatile Variable Rule
   volatile int x;
   x = 5;      // Write happens-before
   int y = x;  // Future read

4. Thread Start Rule
   t.start();  // Code before start() happens-before code in thread

5. Thread Termination Rule
   t.join();   // Code in thread happens-before code after join()

6. Transitivity
   A happens-before B AND B happens-before C
   â†’ A happens-before C
```

## Memory Model in Practice

### Safe Double-Checked Locking

```java
public class Singleton {
    
    static volatile Singleton instance;  // volatile!
    
    public static Singleton getInstance() {
        if (instance == null) {          // First check (fast)
            synchronized (Singleton.class) {
                if (instance == null) {  // Second check (safe)
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}

// volatile makes this safe
// Without volatile: double-checked locking is broken!
```

### Publishing Objects Safely

```java
public class SafePublication {
    
    static class Configuration {
        final String host;      // final = always visible
        final int port;
        
        Configuration(String host, int port) {
            this.host = host;
            this.port = port;
        }
    }
    
    static volatile Configuration config;  // volatile reference
    
    public static void setConfig(Configuration cfg) {
        config = cfg;  // âœ“ Safe write
    }
    
    public static Configuration getConfig() {
        return config;  // âœ“ Safe read
    }
}

// Combination of final + volatile = safe publication
```

## Immutability & Visibility

```java
public class ImmutableExample {
    
    static final class Point {
        final int x;
        final int y;
        
        Point(int x, int y) {
            this.x = x;
            this.y = y;
        }
    }
    
    static Point point = new Point(5, 10);
    
    public static void main(String[] args) throws InterruptedException {
        Thread t = new Thread(() -> {
            System.out.println("x: " + point.x + ", y: " + point.y);
            // âœ“ Always sees initial values
        });
        
        t.start();
        t.join();
    }
}

// Immutable = no visibility issues
// No synchronization needed!
```

## Key Takeaways

- âœ… Memory Model ensures multi-thread safety
- âœ… Without it: unpredictable behavior on multi-core
- âœ… Happens-Before relationship: guarantees visibility
- âœ… volatile: visibility without locking (fast)
- âœ… synchronized: visibility + atomicity (safe)
- âœ… AtomicInteger: lock-free atomicity (fastest)
- âœ… Data races cause unpredictable results
- âœ… volatile doesn't guarantee atomicity
- âœ… Immutability eliminates visibility issues
- âœ… Final fields always visible

---

