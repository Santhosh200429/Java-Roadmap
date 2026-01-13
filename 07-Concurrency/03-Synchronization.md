# Thread Synchronization: Thread-Safe Code

## What is Synchronization?

**Synchronization** ensures that multiple threads don't corrupt data by accessing/modifying it simultaneously.

**Real-world analogy**: Like a bathroom with one lock - only one person can use it at a time to prevent chaos.

## The Problem: Race Conditions

```java
class BankAccount {
    private int balance = 1000;
    
    public void withdraw(int amount) {
        // UNSAFE - multiple threads can race here
        if (balance >= amount) {
            balance -= amount;  // This is NOT atomic!
        }
    }
}

// Scenario with 2 threads, balance = 1000
Thread 1: Check balance >= 100? YES
Thread 2: Check balance >= 100? YES
Thread 1: Deduct 100 -' balance = 900
Thread 2: Deduct 100 -' balance = 900  // WRONG! Should be 800
```

## Synchronized Methods

```java
class BankAccount {
    private int balance = 1000;
    
    // Only one thread can execute at a time
    public synchronized void withdraw(int amount) {
        if (balance >= amount) {
            balance -= amount;
        }
    }
    
    public synchronized int getBalance() {
        return balance;
    }
}

// Now thread-safe
BankAccount account = new BankAccount();
Thread t1 = new Thread(() -> account.withdraw(100));
Thread t2 = new Thread(() -> account.withdraw(100));
t1.start();
t2.start();
// Result: balance = 800 (correct!)
```

## How Synchronized Works

Each object has an **intrinsic lock** (monitor):

```java
class Counter {
    private int count = 0;
    
    public synchronized void increment() {
        // Thread must acquire lock
        count++;
        // Lock released when method exits
    }
}

// Thread 1: Tries to acquire lock
// If lock available -' enters -' increments -' releases
// If lock taken -' waits until available
// Thread 2: Same process (must wait for Thread 1)
```

## Synchronized Blocks

Lock specific code instead of entire method:

```java
class BankAccount {
    private int balance;
    private String name;  // Non-critical
    
    public void withdraw(int amount) {
        System.out.println(name);  // Not synchronized
        
        // Only balance modification is critical
        synchronized(this) {
            if (balance >= amount) {
                balance -= amount;
            }
        }
    }
}

// More efficient - only lock critical section
```

## Different Locks

### Instance Lock

```java
class SafeCounter {
    private int count = 0;
    
    public synchronized void increment() {
        count++;
    }
}

// Each instance has its own lock
SafeCounter c1 = new SafeCounter();
SafeCounter c2 = new SafeCounter();

c1.increment();  // Locks c1
c2.increment();  // Different lock, no wait
```

### Class Lock (Static)

```java
class GlobalCounter {
    private static int count = 0;
    
    // Static = locks class, not instance
    public static synchronized void increment() {
        count++;
    }
}

// Only one thread can call this, ever
Thread t1 = new Thread(() -> GlobalCounter.increment());
Thread t2 = new Thread(() -> GlobalCounter.increment());
```

## Complete Examples

### 1. Thread-Safe Counter

```java
public class ThreadSafeCounter {
    private int count = 0;
    
    public synchronized void increment() {
        count++;
    }
    
    public synchronized void decrement() {
        count--;
    }
    
    public synchronized int getValue() {
        return count;
    }
}

// Usage
ThreadSafeCounter counter = new ThreadSafeCounter();

Thread t1 = new Thread(() -> {
    for (int i = 0; i < 1000; i++) {
        counter.increment();
    }
});

Thread t2 = new Thread(() -> {
    for (int i = 0; i < 1000; i++) {
        counter.increment();
    }
});

t1.start();
t2.start();
t1.join();
t2.join();

System.out.println("Count: " + counter.getValue());  // 2000 (correct!)
```

### 2. Bank Account Simulation

```java
public class BankAccount {
    private double balance;
    private String accountNumber;
    
    public BankAccount(String accountNumber, double initialBalance) {
        this.accountNumber = accountNumber;
        this.balance = initialBalance;
    }
    
    public synchronized boolean withdraw(double amount) {
        if (balance >= amount) {
            try {
                Thread.sleep(10);  // Simulate processing
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            balance -= amount;
            return true;
        }
        return false;
    }
    
    public synchronized void deposit(double amount) {
        try {
            Thread.sleep(10);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        balance += amount;
    }
    
    public synchronized double getBalance() {
        return balance;
    }
}

// Usage
BankAccount account = new BankAccount("ACC123", 1000);

Thread t1 = new Thread(() -> {
    for (int i = 0; i < 5; i++) {
        account.withdraw(100);
    }
});

Thread t2 = new Thread(() -> {
    for (int i = 0; i < 3; i++) {
        account.deposit(50);
    }
});

t1.start();
t2.start();
t1.join();
t2.join();

System.out.println("Final balance: " + account.getBalance());  // 650
```

### 3. Producer-Consumer with wait/notify

```java
public class ProducerConsumer {
    private Queue<Integer> buffer = new LinkedList<>();
    private final int capacity = 10;
    
    public synchronized void produce(int value) throws InterruptedException {
        // Wait if buffer full
        while (buffer.size() == capacity) {
            wait();
        }
        
        buffer.add(value);
        System.out.println("Produced: " + value);
        
        // Notify waiting consumer
        notifyAll();
    }
    
    public synchronized int consume() throws InterruptedException {
        // Wait if buffer empty
        while (buffer.isEmpty()) {
            wait();
        }
        
        int value = buffer.remove();
        System.out.println("Consumed: " + value);
        
        // Notify waiting producer
        notifyAll();
        return value;
    }
}

// Usage
ProducerConsumer pc = new ProducerConsumer();

Thread producer = new Thread(() -> {
    try {
        for (int i = 1; i <= 20; i++) {
            pc.produce(i);
            Thread.sleep(100);
        }
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
});

Thread consumer = new Thread(() -> {
    try {
        for (int i = 0; i < 20; i++) {
            pc.consume();
            Thread.sleep(200);
        }
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
});

producer.start();
consumer.start();
```

## wait() and notify()

Use with synchronized blocks for thread coordination:

```java
class PrintBuffer {
    private String data = "";
    
    // Wait for data
    public synchronized String getData() throws InterruptedException {
        while (data.isEmpty()) {
            wait();  // Release lock, wait for notification
        }
        String result = data;
        data = "";
        notifyAll();  // Wake up waiting writers
        return result;
    }
    
    // Write data
    public synchronized void putData(String s) throws InterruptedException {
        while (!data.isEmpty()) {
            wait();  // Buffer full, wait
        }
        data = s;
        notifyAll();  // Wake up waiting readers
    }
}
```

## Common Mistakes

### 1. Forgetting to Synchronize All Access
```java
// [WRONG] WRONG - balance accessed unsynchronized
class Account {
    private int balance;
    
    public synchronized void withdraw(int amt) {
        balance -= amt;
    }
    
    public int getBalance() {  // NOT synchronized!
        return balance;  // Race condition
    }
}

// RIGHT
class Account {
    private int balance;
    
    public synchronized void withdraw(int amt) {
        balance -= amt;
    }
    
    public synchronized int getBalance() {  // Synchronized
        return balance;
    }
}
```

### 2. Synchronizing Too Much
```java
// [WRONG] INEFFICIENT - locks entire class
public class DataProcessor {
    public synchronized void process() {
        readFile();           // No thread issues
        synchronized(this) {  // But locks whole thing
            updateDatabase(); // Real critical section
        }
        writeLog();           // No thread issues
    }
}

// BETTER - lock only critical section
public class DataProcessor {
    private Object lock = new Object();
    
    public void process() {
        readFile();           // Not locked
        synchronized(lock) {  // Only database update
            updateDatabase();
        }
        writeLog();           // Not locked
    }
}
```

### 3. Calling wait() Without Loop
```java
// [WRONG] WRONG
synchronized void getData() throws InterruptedException {
    if (data == null) {  // What if notified spuriously?
        wait();
    }
    return data;  // Data still null!
}

// RIGHT
synchronized void getData() throws InterruptedException {
    while (data == null) {  // Keep checking
        wait();
    }
    return data;  // Guaranteed non-null
}
```

## Performance Considerations

```java
// Synchronized method - coarse-grained lock
public synchronized void updateMany() {
    updateField1();  // Wait for lock
    updateField2();  // Wait for lock
    updateField3();  // Wait for lock
}

// Synchronized block - fine-grained lock
private Object lock1 = new Object();
private Object lock2 = new Object();

public void updateMany() {
    synchronized(lock1) {
        updateField1();  // Lock 1
    }
    synchronized(lock2) {
        updateField2();  // Lock 2
    }
    // More parallelism, less waiting
}
```

## Key Takeaways

- Synchronization prevents race conditions
- `synchronized` method/block acquires object lock
- Only one thread executes synchronized block at a time
- `wait()` releases lock and waits for notification
- `notifyAll()` wakes up waiting threads
- Synchronize all shared variable access
- Only synchronize critical sections for performance

---


