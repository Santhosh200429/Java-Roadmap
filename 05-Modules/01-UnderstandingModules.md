# Understanding Java Modules

## Overview
Java Modules (introduced in Java 9 with Project Jigsaw) provide a way to organize and encapsulate code into reusable components. Modules allow you to explicitly define dependencies and what parts of your code are publicly available.

## What is a Module?

A **module** is a self-contained unit of code that:
- Contains packages and classes
- Declares what it requires (dependencies)
- Declares what it exports (public API)
- Has a clearly defined interface

## Module System Benefits

### 1. **Encapsulation**
- Hide internal implementation details
- Expose only necessary public interfaces

### 2. **Explicit Dependencies**
- Clearly declare what other modules your module needs
- Prevent accidental circular dependencies

### 3. **Reliable Configuration**
- Detect missing dependencies at compile time
- Better error messages

### 4. **Custom Runtime Images**
- Create smaller, optimized runtime images with only needed modules
- Reduce memory footprint and startup time

### 5. **Platform Independence**
- Modularize large codebases
- Easier maintenance and testing

## Module Structure

### Directory Layout
```
myapp/
â”œâ”€â”€ src/
â”‚   â”œâ”€â”€ com/example/module1/
â”‚   â”‚   â”œâ”€â”€ Main.java
â”‚   â”‚   â””â”€â”€ Helper.java
â”‚   â””â”€â”€ module-info.java
â”œâ”€â”€ build/
â””â”€â”€ pom.xml (or build.gradle)
```

### module-info.java
The **module descriptor** file that defines:
- Module name
- Requirements (requires)
- Public packages (exports)

Example:
```java
module com.example.myapp {
    requires java.base;              // Dependency
    exports com.example.api;         // Public packages
    exports com.example.util to com.example.other;  // Qualified export
}
```

## Key Directives

### `requires`
Declares a module dependency:
```java
module myapp {
    requires java.sql;
    requires transitive com.database;  // Transitively required
}
```

### `exports`
Makes a package publicly available:
```java
module myapp {
    exports com.example.api;           // Public export
    exports com.example.internal to com.other.module;  // Qualified export
}
```

### `opens`
Allows reflective access to packages:
```java
module myapp {
    opens com.example.reflection;
}
```

### `uses` and `provides`
Service provider pattern:
```java
module myapp {
    uses com.example.spi.Service;
    provides com.example.spi.Service with com.example.impl.ServiceImpl;
}
```

## Module Types

### 1. **Named Modules**
Have an explicit module-info.java file:
```java
module com.example.app {
    requires java.base;
    exports com.example.api;
}
```

### 2. **Automatic Modules**
JARs on the module path without module-info.java (treated as modules):
```
--module-path /lib/mylib.jar
```

### 3. **Unnamed Module**
Classpath JARs (backward compatibility)

## Module Path vs Class Path

### Module Path (`--module-path`)
- For modular applications
- Enforces module boundaries
- Better encapsulation

### Class Path (`--class-path`)
- Traditional approach
- No module boundaries
- Backward compatible

## Example: Simple Modular Application

### File: module-info.java
```java
module com.example.greeting {
    exports com.example.greeting.api;
}
```

### File: com/example/greeting/api/Greeter.java
```java
package com.example.greeting.api;

public class Greeter {
    public String greet(String name) {
        return "Hello, " + name;
    }
}
```

### File: com/example/greeting/impl/GreeterImpl.java
```java
package com.example.greeting.impl;

public class GreeterImpl {
    // Internal implementation - not exported
}
```

## Building Modular Applications

### With Maven
```xml
<properties>
    <maven.compiler.source>11</maven.compiler.source>
    <maven.compiler.target>11</maven.compiler.target>
</properties>
```

### With Gradle
```gradle
java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}
```

## Compiling Modular Code
```bash
javac --module-path /path/to/modules -d out src/module-info.java src/**/*.java
```

## Running Modular Applications
```bash
java --module-path out -m com.example.app/com.example.Main
```

## Common Issues and Solutions

### Issue: "Module not found"
- Check module name spelling
- Verify module-info.java exists
- Check --module-path configuration

### Issue: "Package not visible"
- Verify package is exported in module-info.java
- Check that module is required in dependent module

### Issue: "Circular module dependency"
- Restructure modules to eliminate cycles
- Use services or interfaces to decouple

## Best Practices

1. **Keep modules focused** - One responsibility per module
2. **Minimize exports** - Only export what's necessary
3. **Use qualified exports** - Limit visibility when appropriate
4. **Document dependencies** - Make requirements explicit
5. **Test module boundaries** - Ensure proper encapsulation

## Migration Path

### From Traditional to Modular
1. Keep code in automatic modules first
2. Gradually convert to named modules
3. Update dependencies progressively
4. Use --add-modules for backward compatibility

## See Also
- [Module Info Java](module-info.java)
- [Exports and Requires](03-exports-and-requires.md)
- JDK Module System Documentation

## References
- Project Jigsaw: https://openjdk.org/projects/jigsaw/
