# Exports and Requires in Java Modules

## Module Declaration Basics

Every module needs a `module-info.java` file in the root of its source directory.

```java
// src/module-info.java
module calculator.core {
    exports com.calculator;
}
```

## Exports: Making APIs Public

**exports** makes a package available to other modules.

### Simple Export

```java
module myapp.core {
    exports com.myapp.api;  // Makes api package public
}
```

**Result:**
- Other modules can use classes in `com.myapp.api`
- Other packages in same module can also use it
- Internal packages (not exported) are hidden

### Example Project

```
calculator-app/
├── calculator.core/
│   ├── src/module-info.java
│   └── src/com/calculator/
│       ├── Calculator.java (public)
│       └── internal/
│           └── MathUtil.java (hidden)
├── calculator.ui/
│   ├── src/module-info.java
│   └── src/com/calculator/ui/
│       └── CalculatorUI.java
```

### module-info.java for calculator.core

```java
module calculator.core {
    exports com.calculator;  // Only the public package exported
}
```

**What's visible to calculator.ui:**
- ✅ `com.calculator.Calculator` (exported)
- ❌ `com.calculator.internal.MathUtil` (hidden)

```java
// In calculator.ui
import com.calculator.Calculator;  // ✓ Works!
import com.calculator.internal.MathUtil;  // ✗ Compilation error!
```

## Requires: Declaring Dependencies

**requires** declares that a module depends on another module.

### Simple Requires

```java
module calculator.ui {
    requires calculator.core;  // Depends on calculator.core
}
```

### Multiple Dependencies

```java
module myapp.service {
    requires java.base;        // Standard module (implicit)
    requires java.logging;     // Java logging module
    requires myapp.core;       // Our custom module
    requires myapp.data;       // Another custom module
}
```

## Requires Transitive

**requires transitive** makes dependencies available to other modules using this module.

### Without Transitive

```java
// module A
module a {
    exports com.a;
}

// module B (depends on A)
module b {
    requires a;
    exports com.b;
}

// module C (depends on B)
module c {
    requires b;
}

// In module C code:
import com.b.*;    // ✓ Works (B exports it)
import com.a.*;    // ✗ Error! (A not transitively exported)
```

### With Transitive

```java
// module A
module a {
    exports com.a;
}

// module B (depends on A, transitive)
module b {
    requires transitive a;  // Re-exports A's exports
    exports com.b;
}

// module C (depends on B)
module c {
    requires b;
}

// In module C code:
import com.b.*;    // ✓ Works
import com.a.*;    // ✓ Now works! (transitive makes it available)
```

### Real-World Example: API Stack

```java
// Security module (core security)
module security.core {
    exports com.security.cipher;
    exports com.security.hash;
}

// Auth module (depends on security, re-exports it)
module auth {
    requires transitive security.core;
    exports com.auth.jwt;
    exports com.auth.oauth;
}

// App module (only depends on auth)
module myapp {
    requires auth;  // One requires statement
}

// In myapp code:
import com.auth.jwt.*;           // ✓ Direct dependency
import com.security.cipher.*;    // ✓ Transitive dependency!
```

### When to Use Transitive

```java
// ✓ Use transitive when:
// 1. Dependency is fundamental to your module's API
module database.connection {
    requires transitive java.sql;  // SQL is core to our API
    exports com.db.connection;
}

// 2. Dependency is re-exported
module payment.gateway {
    requires transitive money.api;  // We export Money classes
    exports com.payment;
}

// ✗ Don't use transitive for:
// 1. Internal implementation details
module utils {
    requires logging;  // Keep logging internal, don't expose
    exports com.utils.string;
}

// 2. Plugin/Optional dependencies
module core {
    requires analytics;  // Analytics is optional
    exports com.core;
}
```

## Qualified Exports

**exports to** - Export a package only to specific modules.

### Syntax

```java
module api.server {
    exports com.api to client.app, test.client;
}
```

**Result:**
- `com.api` is available to `client.app` and `test.client`
- Other modules cannot use `com.api`

### Real-World Example: White-listed Clients

```java
// banking.core
module banking.core {
    // Only banking.mobile and banking.web can use internals
    exports com.banking.security to banking.mobile, banking.web;
    // General API available to everyone
    exports com.banking.api;
}

// In banking.mobile - OK
import com.banking.security.*;  // ✓ Works (white-listed)

// In banking.analytics - ERROR
import com.banking.security.*;  // ✗ Not in white-list
```

## Opens: Reflection Access

**opens** allows other modules to use reflection on a package.

### Without Opens

```java
module myapp.core {
    exports com.myapp;
}

// Another module tries to use reflection
public class Configurer {
    public static void configure() {
        Class<?> clz = Class.forName("com.myapp.ConfigImpl");
        // ✗ IllegalAccessException - reflection not allowed!
    }
}
```

### With Opens

```java
module myapp.core {
    exports com.myapp;
    opens com.myapp;  // Allow reflection
}

// Now reflection works
public class Configurer {
    public static void configure() {
        Class<?> clz = Class.forName("com.myapp.ConfigImpl");
        // ✓ Works - reflection allowed
    }
}
```

### Open Modules

**open module** - Opens all packages for reflection.

```java
// Great for frameworks that need reflection
open module spring.core {
    exports org.springframework.core;
    // All packages implicitly open
}
```

## Complete Multi-Module Example

### Project Structure

```
banking-app/
├── banking.api/
│   ├── src/module-info.java
│   └── src/com/bank/api/
│       ├── Account.java
│       ├── Transaction.java
│       └── internal/
│           └── Utils.java
├── banking.impl/
│   ├── src/module-info.java
│   └── src/com/bank/impl/
│       └── AccountImpl.java
└── banking.app/
    ├── src/module-info.java
    └── src/com/bank/app/
        └── BankingApp.java
```

### banking.api/src/module-info.java

```java
module banking.api {
    exports com.bank.api;  // Public API
}
```

### banking.impl/src/module-info.java

```java
module banking.impl {
    requires transitive banking.api;  // Depends on and re-exports API
    exports com.bank.impl;
}
```

### banking.app/src/module-info.java

```java
module banking.app {
    requires banking.api;   // Only needs API
    requires banking.impl;  // And implementation
}
```

### Compilation & Running

```bash
# Compile all modules
javac -d out \
  --module-source-path src \
  -m banking.api,banking.impl,banking.app \
  src/**/*.java

# Run application
java --module-path out \
  -m banking.app/com.bank.app.BankingApp

# Show module info
jdeps --module-path out banking.app
```

## Dependency Diagram

```
Without Transitive:
banking.api
    ↑
    │ requires
    │
banking.impl
    ↑
    │ requires
    │
banking.app

banking.app cannot see banking.api directly!

---

With Transitive (requires transitive):
banking.api
    ↑
    │ requires transitive
    │
banking.impl
    ↑
    │ requires
    │
banking.app

banking.app CAN see banking.api!
```

## Complete Real-World Example

```java
// weather.core/src/module-info.java
module weather.core {
    requires java.net;
    exports com.weather.api;
    exports com.weather.model;
}

// weather.api/src/module-info.java
module weather.api {
    requires transitive weather.core;
    exports com.weather.service;
}

// weather.ui/src/module-info.java
module weather.ui {
    requires weather.api;
    exports com.weather.ui;
}

// weather.app/src/module-info.java
module weather.app {
    requires weather.ui;
    requires java.logging;
}
```

## Module Resolution Process

```
1. Read module-info.java
2. Find all required modules
3. Check exports/requires consistency
4. Build module graph
5. Validate no cycles
6. Ensure all requires are satisfied
7. Load module (if all checks pass)
8. Execute code
```

## Common Errors

### Error 1: Export Not Found

```
error: package com.myapp.internal is not exported from module myapp
```

**Solution:** Add to module-info.java:
```java
exports com.myapp.internal;
```

### Error 2: Module Not Required

```
error: package com.utils is not visible
```

**Solution:** Add to module-info.java:
```java
requires utils;
```

### Error 3: Circular Dependency

```
error: module graph has a cycle: myapp -> utils -> myapp
```

**Solution:** Reorganize modules to eliminate cycle

## Key Takeaways

- ✅ **exports** - Makes package available to other modules
- ✅ **requires** - Declares dependency on another module
- ✅ **requires transitive** - Re-exports dependency
- ✅ **exports to** - Restricts export to specific modules
- ✅ **opens** - Allows reflection access
- ✅ **open module** - Opens all packages for reflection
- ✅ All module-info.java must be in module root
- ✅ Module names follow Java naming conventions
- ✅ No cyclic dependencies allowed
- ✅ All dependencies must be satisfied at compile/runtime

---

**Previous ←** Understanding Modules: [Module System](/5-Modules/01-UnderstandingModules.md)
