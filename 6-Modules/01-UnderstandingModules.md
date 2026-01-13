# Java Module System (Project Jigsaw)

## What is the Module System?

**Modules** are containers for packages that control visibility and dependencies.

**Before modules:**
```
jar file → contains all packages → all publicly accessible
```

**With modules:**
```
module → explicit exports → fine-grained control
```

## Why Modules?

### Problem 1: Classpath Hell
```bash
# Which classes get loaded?
java -cp lib/common.jar:lib/legacy-common.jar:lib/app.jar App

# JAR conflicts are silent!
```

### Problem 2: Weak Encapsulation
```java
// OLD: package-private not really private
package com.mycompany.internal;
class SecretImpl {}  // Can still be accessed!

// NEW: module exports only what's needed
module myapp {
    exports com.mycompany.api;
    // hides com.mycompany.internal
}
```

## Module Declaration

### module-info.java

```java
module my.app {
    // module body
}
```

### Exporting Packages

```java
module my.app {
    // Export for public use
    exports com.mycompany.api;
    exports com.mycompany.service;
    
    // Not exported (hidden)
    // - com.mycompany.internal remains private
}
```

### Requiring Modules

```java
module my.app {
    // Require other modules
    requires java.base;      // Implicit, always required
    requires java.logging;
    requires java.sql;
}
```

### Requiring Transitive Dependencies

```java
module my.api {
    // Other modules that require this
    // will also get json library
    requires transitive com.google.gson;
}

module my.app {
    requires my.api;  // Also gets gson automatically
}
```

## Complete Module Example

### Project Structure

```
calculator/
├── src/
│   ├── calculator.core/
│   │   ├── module-info.java
│   │   └── com/example/calculator/
│   │       ├── Calculator.java (exported)
│   │       └── internal/
│   │           └── MathUtils.java (internal)
│   │
│   └── calculator.ui/
│       ├── module-info.java
│       └── com/example/ui/
│           └── CalculatorApp.java
│
└── compile/
    ├── calculator.core/
    ├── calculator.ui/
    └── modules.list
```

### calculator.core/module-info.java

```java
module calculator.core {
    // Export only public API
    exports com.example.calculator;
    
    // Internal packages are NOT exported
}
```

### com/example/calculator/Calculator.java

```java
package com.example.calculator;

public class Calculator {
    
    public static int add(int a, int b) {
        return a + b;
    }
    
    public static int multiply(int a, int b) {
        return a * b;
    }
}
```

### com/example/calculator/internal/MathUtils.java

```java
package com.example.calculator.internal;

// This is internal - NOT exported!
public class MathUtils {
    public static boolean isPrime(int n) {
        // ...
    }
}
```

### calculator.ui/module-info.java

```java
module calculator.ui {
    // Require the calculator.core module
    requires calculator.core;
}
```

### com/example/ui/CalculatorApp.java

```java
package com.example.ui;

import com.example.calculator.Calculator;
// import com.example.calculator.internal.MathUtils;  // ERROR!

public class CalculatorApp {
    public static void main(String[] args) {
        int result = Calculator.add(5, 3);
        System.out.println("5 + 3 = " + result);
        
        // MathUtils is hidden - cannot access!
        // This code wouldn't compile
    }
}
```

## Qualified Exports

Export package to specific modules only:

```java
module java.base {
    exports java.lang;              // Export to everyone
    exports java.lang.invoke to     // Export only to specific modules
        java.compiler,
        jdk.compiler;
}
```

## Open Modules

Allow reflection on all packages (for frameworks):

```java
open module my.app {
    // Opens all packages for reflection
    // while maintaining explicit exports
    exports com.mycompany.api;
}

// Or open specific packages
module my.app {
    opens com.mycompany.reflection;
    exports com.mycompany.api;
}
```

## Compilation and Execution

### Compile Modules

```bash
# Compile single module
javac -d out --module-source-path src --module my.app

# Compile all modules
javac -d out --module-source-path src $(find src -name "*.java")
```

### Run Module

```bash
# Run main class from module
java --module-path out --module my.app/com.example.Main

# With dependencies
java --module-path out:lib/* --module my.app/com.mycompany.App
```

### List Modules

```bash
# List available modules
java --list-modules

# Find module containing class
java -p lib --describe-module java.base
```

## Module Graph Example

```
calculator.ui
    ↓ requires
calculator.core
    ↓ requires
java.logging
    ↓ requires
java.base (implicit)
```

## Working with Libraries

### Using External Modules

```java
module my.app {
    // Require Google Guava
    requires com.google.common;
    
    // Require Gson
    requires com.google.gson;
    
    // Export your own package
    exports com.mycompany.api;
}
```

### Compiling with Libraries

```bash
javac -d out \
    -p lib/* \
    --module-source-path src \
    -m my.app
```

## Module Info Examples

### Minimal Module

```java
module my.simple {
    // No exports - internal only
}
```

### API Module

```java
module my.api {
    exports com.mycompany.model;
    exports com.mycompany.service;
    
    requires transitive com.google.gson;
    requires java.logging;
}
```

### Application Module

```java
module my.application {
    requires my.api;
    requires my.database;
    requires spring.core;
    requires spring.web;
    requires transitive java.sql;
    
    exports com.mycompany.app;
}
```

### Framework Module (with reflection)

```java
module my.framework {
    exports com.mycompany.framework;
    exports com.mycompany.framework.api;
    
    // Allow reflection on internal packages
    opens com.mycompany.framework.internal;
    opens com.mycompany.framework.annotations;
    
    requires java.logging;
    requires java.base;
}
```

## Benefits of Modules

### 1. Strong Encapsulation

```java
// Before modules: Nothing truly private
// After modules: Only exported packages visible

module my.lib {
    exports com.public.api;
    // com.internal.* is completely hidden
}
```

### 2. Explicit Dependencies

```java
// At a glance, see what's required
module my.app {
    requires java.logging;
    requires java.sql;
    requires google.guava;
    requires my.common;
}
```

### 3. Faster Startup

```
// Smaller classloader scope
// Fewer classes to scan
// Faster JVM startup
```

### 4. Better IDE Support

```
IDE now knows:
- Valid imports
- Available packages
- Dependency conflicts
```

## Module Commands

```bash
# Show module information
java --show-module-resolution --module my.app

# Check module consistency
jdeps --module-path out out/my.app

# List module dependencies
jdeps -m my.app

# Generate module-info.java
jdeps --generate-module-info out my.jar
```

## Splitting Modules

### Bad: Giant Module

```java
module giant.app {
    // Too many responsibilities!
    exports com.app.payment;
    exports com.app.user;
    exports com.app.report;
    exports com.app.admin;
}
```

### Good: Focused Modules

```java
module app.payment {
    exports com.app.payment;
    requires java.logging;
}

module app.user {
    exports com.app.user;
    requires java.logging;
}

module app.report {
    exports com.app.report;
    requires app.user;
}

module app.admin {
    exports com.app.admin;
    requires app.user;
    requires app.payment;
}
```

## Java Platform Modules

Java itself is modular:

```java
module my.app {
    // Core
    requires java.base;          // Automatic
    
    // Networking
    requires java.net.http;
    
    // Database
    requires java.sql;
    
    // Logging
    requires java.logging;
    
    // Collections/Streams
    requires java.base;
    
    // Reflection
    opens com.internal to java.base;
}
```

## Transitive Dependencies

```java
module my.core {
    exports com.core.api;
}

module my.service {
    requires transitive my.core;  // Implicit when using my.service
    exports com.service.api;
}

module my.app {
    requires my.service;  // Automatically gets my.core too
}
```

## Module Versioning

```bash
# Jar with module info
jar --create \
    --file=app.jar \
    --module-version=1.0 \
    --main-class=com.App \
    -C out .

# Check version
jar --describe-module --file=app.jar
```

## Common Mistakes

### 1. Circular Dependencies

```java
// ❌ WRONG
module a { requires b; }
module b { requires a; }  // Circular!

// ✅ RIGHT
module a { requires b; }
module b { }  // b doesn't depend on a
```

### 2. Forgetting Exports

```java
// ❌ WRONG - Package not visible to others
module my.lib {
    // Nothing exported!
}

// ✅ RIGHT
module my.lib {
    exports com.mycompany.api;
}
```

### 3. Over-opening Modules

```java
// ❌ WRONG - Breaks encapsulation
open module my.app {
    // Opens everything to reflection
}

// ✅ RIGHT
module my.app {
    opens com.internal;  // Only what's needed
    exports com.public;
}
```

## Migration Path

```
Step 1: Create module-info.java
Step 2: Add exports for public packages
Step 3: Add requires for dependencies
Step 4: Test with --module-path
Step 5: Package as modular JAR
```

## Key Takeaways

- ✅ Modules provide strong encapsulation
- ✅ module-info.java declares module metadata
- ✅ exports makes packages public
- ✅ requires declares dependencies
- ✅ Transitive requires for dependency chains
- ✅ opens for framework reflection
- ✅ Hidden packages are truly private
- ✅ Better IDE support and error detection
- ✅ Faster startup with focused classloading
- ✅ Foundation for Java platform

---

**Next →** Memory and JVM: [Java Memory Model](/9-Memory-&-JVM/01-JVM-Internals.md)
