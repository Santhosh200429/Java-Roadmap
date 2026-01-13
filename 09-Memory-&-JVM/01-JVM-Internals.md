# JVM Internals

## What is the JVM?

**JVM** (Java Virtual Machine) is an abstract computing machine that:
1. Reads Java bytecode (.class files)
2. Interprets or compiles it to machine code
3. Executes it on any platform

```
Java Code      Java Code
(.java)        (.java)
   â†“              â†“
Compiler     Compiler
   â†“              â†“
Bytecode     Bytecode
(.class)     (.class)
   â†“              â†“
â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        JVM
        â†“
    Machine Code
        â†“
   Execution
```

## Bytecode

Bytecode is platform-independent instructions. Example:

```java
public class Simple {
    public int add(int a, int b) {
        return a + b;
    }
}
```

Compiles to bytecode:

```
public int add(int, int);
  Code:
    0: iload_1              // Load parameter 1 (a)
    1: iload_2              // Load parameter 2 (b)
    2: iadd                 // Add them
    3: ireturn              // Return result
```

### View Bytecode

```bash
# Compile
javac Simple.java

# View bytecode
javap -c Simple
```

## JVM Architecture

### Stack-based Execution

```
Method Stack Frames
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Method 3        â”‚
â”‚ Local vars: [z] â”‚
â”‚ Operand Stack   â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Method 2        â”‚
â”‚ Local vars: [y] â”‚
â”‚ Operand Stack   â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Method 1        â”‚
â”‚ Local vars: [x] â”‚
â”‚ Operand Stack   â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### Bytecode Instructions

```
iload    - Load integer from local variable
istore   - Store integer to local variable
iadd     - Add two integers
imul     - Multiply two integers
ireturn  - Return integer
aload    - Load reference from local variable
astore   - Store reference to local variable
invokespecial - Invoke constructor/private method
invokevirtual - Invoke instance method
invokestatic  - Invoke static method
```

## Example: Understanding Bytecode

```java
public class Counter {
    public static int count(int n) {
        int sum = 0;
        for (int i = 0; i < n; i++) {
            sum += i;
        }
        return sum;
    }
}
```

Bytecode:

```
public static int count(int);
  Code:
    0: iconst_0              // push 0
    1: istore_1              // sum = 0
    2: iconst_0              // push 0
    3: istore_2              // i = 0
    4: goto 15
    7: iload_1               // load sum
    8: iload_2               // load i
    9: iadd                  // sum + i
   10: istore_1              // sum = result
   11: iinc 2, 1             // i++
   14: goto 4                // loop back
   15: iload_1               // load sum
   16: ireturn               // return sum
```

## Class Loading

### Three Phases

```
1. Loading
   â”œâ”€ Bootstrap ClassLoader (loads rt.jar)
   â”œâ”€ Extension ClassLoader (loads jdk extensions)
   â””â”€ Application ClassLoader (loads app classes)

2. Linking
   â”œâ”€ Verify (check valid bytecode)
   â”œâ”€ Prepare (allocate memory)
   â””â”€ Resolve (resolve symbolic references)

3. Initialization
   â””â”€ Execute static blocks and initializers
```

### Class Loader Example

```java
public class ClassLoaderExample {
    
    public static void main(String[] args) {
        String className = "java.lang.String";
        
        try {
            Class<?> clazz = Class.forName(className);
            
            System.out.println("Class: " + clazz.getName());
            System.out.println("ClassLoader: " + clazz.getClassLoader());
            System.out.println("Module: " + clazz.getModule());
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}

// Output:
// Class: java.lang.String
// ClassLoader: null (means bootstrap loader)
// Module: java.base
```

## Method Resolution Order (MRO)

When calling a method, JVM searches:

```java
class Animal {
    void sound() { System.out.println("Some sound"); }
}

class Dog extends Animal {
    void sound() { System.out.println("Woof"); }
}

// Bytecode dispatch
Dog dog = new Dog();
dog.sound();

// Search order:
// 1. Check Dog class
// 2. Check Animal (parent)
// 3. Check Object (always exists)
```

## Memory Layout of Objects

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚   Object Header            â”‚
â”‚ â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”‚
â”‚ â”‚ Mark Word (8 bytes)  â”‚   â”‚ Metadata for GC, locking
â”‚ â”‚ Class Pointer (8)    â”‚   â”‚ Points to class metadata
â”‚ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚   Instance Variables       â”‚
â”‚ â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”‚
â”‚ â”‚ int age        (4)   â”‚   â”‚
â”‚ â”‚ boolean active (1)   â”‚   â”‚
â”‚ â”‚ padding        (3)   â”‚   â”‚ Alignment padding
â”‚ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚   Reference Fields         â”‚
â”‚ â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”‚
â”‚ â”‚ String name (8)      â”‚   â”‚
â”‚ â”‚ List data (8)        â”‚   â”‚
â”‚ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

## Execution Engine

### Just-In-Time (JIT) Compilation

```
Bytecode Execution
        â†“
    Interpreted (slow)
        â†“
    Profiling counter increments
        â†“
    Method called enough times?
        â†“
    JIT compile to native code
        â†“
    Native code execution (fast!)
```

### Tiered Compilation

```
Tier 0: Interpreter (all code)
         â†“ (hot code)
Tier 1: C1 Compiler (quick compilation)
         â†“ (very hot code)
Tier 2-4: C2 Compiler (aggressive optimization)
```

## Optimization Techniques

### 1. Inlining

```java
// Before
public class Math {
    public static int add(int a, int b) {
        return a + b;
    }
}

public class App {
    public void process() {
        int result = Math.add(5, 3);  // Method call
    }
}

// After JIT (inlined)
public void process() {
    int result = 5 + 3;  // Direct computation
}
```

### 2. Dead Code Elimination

```java
// Before
public void optimize() {
    int x = 5;
    if (false) {
        System.out.println(x);  // Dead code
    }
}

// After JIT
public void optimize() {
    // Dead code eliminated
}
```

### 3. Loop Unrolling

```java
// Before
for (int i = 0; i < 4; i++) {
    process(i);
}

// After JIT
process(0);
process(1);
process(2);
process(3);
```

## Monitoring JVM

### Example: Watching JIT Compilation

```bash
# Show JIT compilation
java -XX:+UnlockDiagnosticVMOptions \
     -XX:+PrintCompilation \
     -XX:+PrintInlining \
     MyApp

# Output:
# 123   1    b  java.lang.Object::<init> (1 bytes)
# 124   2    n  MyApp::process (50 bytes)
# 125   3    n  MyApp::main (100 bytes)
```

### Example: Memory Usage

```java
import java.lang.management.*;

public class MemoryMonitor {
    
    public static void main(String[] args) {
        MemoryMXBean memoryBean = ManagementFactory.getMemoryMXBean();
        
        // Heap memory
        MemoryUsage heap = memoryBean.getHeapMemoryUsage();
        System.out.println("Heap Used: " + heap.getUsed() / 1024 / 1024 + "MB");
        System.out.println("Heap Max: " + heap.getMax() / 1024 / 1024 + "MB");
        
        // Non-heap (metaspace)
        MemoryUsage nonHeap = memoryBean.getNonHeapMemoryUsage();
        System.out.println("Metaspace: " + nonHeap.getUsed() / 1024 / 1024 + "MB");
    }
}

// Output:
// Heap Used: 64MB
// Heap Max: 512MB
// Metaspace: 32MB
```

## JVM Flags

### Heap Configuration

```bash
# Set initial and max heap
java -Xms512m -Xmx2g MyApp
#     â””â”€ 512MB initial   â””â”€ 2GB maximum

# Set new generation size
java -Xms512m -Xmx2g -Xmn256m MyApp
#                      â””â”€ 256MB young generation

# Metaspace
java -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m MyApp
```

### GC Selection

```bash
# Garbage Collection
java -XX:+UseG1GC MyApp                    # G1 Collector
java -XX:+UseParallelGC MyApp              # Parallel Collector
java -XX:+UseConcMarkSweepGC MyApp         # CMS (deprecated)
java -XX:+UseZGC MyApp                     # Z Garbage Collector
```

### Performance Profiling

```bash
# Enable profiling
java -XX:+UnlockDiagnosticVMOptions \
     -XX:+DebugNonSafepoints \
     -XX:StartFlightRecording=delay=5s,duration=30s,filename=profile.jfr \
     MyApp

# Analyze with jcmd
jcmd <pid> JFR.check
jcmd <pid> JFR.dump filename=dump.jfr

# View with JFR viewer
jmc profile.jfr
```

## Intrinsic Methods

Some methods are optimized at bytecode level:

```java
// These are intrinsic
Math.abs(x)              // Single CPU instruction
System.arraycopy()       // Optimized memory copy
Object.hashCode()        // Direct computation
Integer.bitCount()       // CPU instruction
```

## Example: Observing JVM Behavior

```java
public class JVMBehavior {
    
    public static void main(String[] args) {
        System.out.println("JVM Info:");
        System.out.println("Version: " + System.getProperty("java.version"));
        System.out.println("Vendor: " + System.getProperty("java.vendor"));
        System.out.println("VM Name: " + System.getProperty("java.vm.name"));
        System.out.println("VM Version: " + System.getProperty("java.vm.version"));
        System.out.println("JIT Compiler: " + System.getProperty("sun.jit.enabled"));
        
        // Available processors
        System.out.println("Processors: " + Runtime.getRuntime().availableProcessors());
        
        // Memory
        Runtime rt = Runtime.getRuntime();
        System.out.println("Total Memory: " + rt.totalMemory() / 1024 / 1024 + "MB");
        System.out.println("Free Memory: " + rt.freeMemory() / 1024 / 1024 + "MB");
        System.out.println("Max Memory: " + rt.maxMemory() / 1024 / 1024 + "MB");
    }
}

// Output example:
// JVM Info:
// Version: 21
// Vendor: Oracle Corporation
// VM Name: OpenJDK 64-Bit Server VM
// VM Version: 21.0.1+12-39
// JIT Compiler: true
// Processors: 8
// Total Memory: 128MB
// Free Memory: 64MB
// Max Memory: 512MB
```

## Key Takeaways

- JVM executes bytecode on any platform
- Bytecode is intermediate representation
- Three ClassLoaders load classes hierarchically
- Method resolution searches class hierarchy
- JIT compilation optimizes hot code
- Stack-based execution with stack frames
- Objects have headers and instance variables
- Tiered compilation optimizes code progressively
- Intrinsic methods get special optimization
- Monitor JVM with flags and diagnostic tools

---


