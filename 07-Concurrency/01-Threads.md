# Threads: Introduction to Concurrency

## What is Concurrency?

**Concurrency** means multiple tasks running at the same time. In Java, this is achieved through **threads** - separate execution paths within a single program.

**Real-world analogy**: A restaurant with multiple chefs (threads) cooking different dishes simultaneously.

## What is a Thread?

A **thread** is a lightweight process that runs independently but shares memory with other threads in the same program.

```
Single-threaded:    Task1 -' Task2 -' Task3 (sequential)
Multi-threaded:     Task1 -"
                    Task2 -"  (concurrent)
                    Task3 -"
```

## Creating Threads

### Method 1: Extend Thread Class

```java
public class MyThread extends Thread {
    public void run() {
        // Code executed in thread
        for (int i = 0; i < 5; i++) {
            System.out.println("Thread: " + i);
            try {
                Thread.sleep(1000);  // Wait 1 second
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

// Create and start
MyThread thread = new MyThread();
thread.start();  // Calls run() in separate thread
```

### Method 2: Implement Runnable Interface

```java
public class MyRunnable implements Runnable {
    public void run() {
        for (int i = 0; i < 5; i++) {
            System.out.println("Running: " + i);
        }
    }
}

// Create and start
Thread thread = new Thread(new MyRunnable());
thread.start();
```

**Runnable is preferred** (allows extending other classes)

## Basic Thread Operations

```java
Thread thread = new Thread(() -> {
    System.out.println("Thread started");
    try {
        Thread.sleep(2000);  // Sleep 2 seconds
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    System.out.println("Thread finished");
});

thread.start();              // Start thread
thread.join();               // Wait for thread to finish
System.out.println("Main finished");
```

## Example: Multiple Threads

```java
public class ThreadExample {
    public static void main(String[] args) {
        // Create multiple threads
        for (int i = 1; i <= 3; i++) {
            final int num = i;
            Thread thread = new Thread(() -> {
                for (int j = 0; j < 3; j++) {
                    System.out.println("Thread " + num + ": " + j);
                }
            });
            thread.start();
        }
    }
}

// Output (threads run concurrently - order may vary):
// Thread 1: 0
// Thread 2: 0
// Thread 3: 0
// Thread 1: 1
// Thread 3: 1
// ...
```

## Thread States

```
         start()
          -"
    [Ready] -' [Running] -' [Done]
        -'         -"
        |  sleep()
        |    -"
        """[Waiting]
```

- **New**: Thread created but not started
- **Ready**: Ready to run, waiting for CPU
- **Running**: Currently executing
- **Waiting**: Waiting for something (sleep, I/O)
- **Terminated**: Thread finished

## Thread Safety

When threads access shared data, problems occur:

```java
// [WRONG] Not thread-safe
public class Counter {
    int count = 0;
    
    public void increment() {
        count++;  // Multiple threads can interfere
    }
}

// Thread-safe
public class SafeCounter {
    int count = 0;
    
    public synchronized void increment() {
        count++;  // Only one thread at a time
    }
}
```

## Practical Example: Download Progress

```java
public class Download {
    public static void main(String[] args) {
        Thread downloadThread = new Thread(() -> {
            for (int i = 0; i <= 100; i += 20) {
                System.out.println("Download: " + i + "%");
                try {
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            System.out.println("Download complete!");
        });
        
        downloadThread.start();
        System.out.println("Main thread continues...");
    }
}
```

## Key Takeaways

- Threads enable concurrent execution
- Extend Thread or implement Runnable
- Call start() to begin thread (not run())
- Use join() to wait for thread completion
- Thread.sleep() pauses execution
- Use synchronized for thread safety
- Only one thread accesses synchronized blocks

---


