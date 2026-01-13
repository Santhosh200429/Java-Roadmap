# Optionals in Java

## What are Optionals?

**Optional** is a container that may or may not contain a non-null value.

**Problem it solves**: Null pointer exceptions (the "billion-dollar mistake")

```java
// âŒ OLD WAY (error-prone)
String name = getUserName(123);
if (name != null) {
    System.out.println(name);
} else {
    System.out.println("Name not found");
}

// NEW WAY (safe and clean)
Optional<String> name = getUserName(123);
name.ifPresentOrElse(
    System.out::println,
    () -> System.out.println("Name not found")
);
```

## Creating Optionals

```java
import java.util.Optional;

public class OptionalCreation {
    
    public static void main(String[] args) {
        // 1. Empty optional
        Optional<String> empty = Optional.empty();
        System.out.println(empty);  // Optional.empty
        
        // 2. Of non-null value (throws if null)
        Optional<String> of = Optional.of("Hello");
        System.out.println(of);  // Optional[Hello]
        
        // 3. OfNullable (handles null)
        Optional<String> nullable = Optional.ofNullable(null);
        System.out.println(nullable);  // Optional.empty
        
        Optional<String> nullable2 = Optional.ofNullable("Value");
        System.out.println(nullable2);  // Optional[Value]
        
        // Common mistake
        try {
            Optional<String> wrong = Optional.of(null);  // NullPointerException!
        } catch (NullPointerException e) {
            System.out.println("Cannot pass null to Optional.of()");
        }
    }
}

// Output:
// Optional.empty
// Optional[Hello]
// Optional.empty
// Optional[Value]
// Cannot pass null to Optional.of()
```

## Checking Values

### ifPresent()

```java
Optional<String> value = Optional.of("John");

// Run code if value exists
value.ifPresent(name -> System.out.println("Name: " + name));
// Output: Name: John

Optional<String> empty = Optional.empty();
empty.ifPresent(name -> System.out.println("Name: " + name));
// Output: (nothing)
```

### isPresent() and isEmpty()

```java
Optional<String> value = Optional.of("John");
Optional<String> empty = Optional.empty();

// Check manually (less preferred)
if (value.isPresent()) {
    System.out.println(value.get());
}

if (empty.isEmpty()) {
    System.out.println("No value");
}

// Preferred: use ifPresent() or ifPresentOrElse()
```

### ifPresentOrElse()

```java
Optional<String> maybeEmail = getEmail(userId);

maybeEmail.ifPresentOrElse(
    email -> sendNotification(email),
    () -> sendDefaultNotification()
);
```

## Getting Values

### get()

```java
Optional<String> value = Optional.of("Success");

// Safe only when you know value exists
String result = value.get();  // "Success"

Optional<String> empty = Optional.empty();
// âŒ DANGER!
empty.get();  // NoSuchElementException!

// Only use get() when you're absolutely sure value exists
```

### getOrElse()

```java
Optional<Integer> score = Optional.of(95);
System.out.println(score.orElse(0));  // 95

Optional<Integer> noScore = Optional.empty();
System.out.println(noScore.orElse(0));  // 0 (default)
```

### orElseThrow()

```java
Optional<User> user = findUser(id);

// Throw exception if empty
User foundUser = user.orElseThrow(() -> 
    new UserNotFoundException("User not found")
);

// Shorthand: throw NoSuchElementException
User u = user.orElseThrow();
```

### orElseGet()

```java
Optional<DatabaseConnection> conn = Optional.empty();

// Only called if empty
DatabaseConnection connection = conn.orElseGet(() -> 
    createNewConnection()
);

// Difference from orElse:
// orElse: always evaluates the argument
// orElseGet: only evaluates if empty (lazy)
```

## Transforming Values

### map()

```java
Optional<String> name = Optional.of("john");

// Transform to uppercase
Optional<String> upper = name.map(String::toUpperCase);
System.out.println(upper);  // Optional[JOHN]

Optional<String> empty = Optional.empty();
Optional<String> upperEmpty = empty.map(String::toUpperCase);
System.out.println(upperEmpty);  // Optional.empty
```

### flatMap()

```java
// flatMap for nested optionals
Optional<User> user = Optional.of(new User("Alice", 25));

// Without flatMap (gets Optional<Optional<Integer>>)
Optional<Optional<Integer>> nestedAge = user.map(User::getAge);

// With flatMap (gets Optional<Integer>)
Optional<Integer> age = user.flatMap(User::getAge);
System.out.println(age);  // Optional[25]
```

### filter()

```java
Optional<Integer> age = Optional.of(25);

// Keep if condition true, empty otherwise
Optional<Integer> adult = age.filter(a -> a >= 18);
System.out.println(adult);  // Optional[25]

Optional<Integer> child = age.filter(a -> a < 18);
System.out.println(child);  // Optional.empty
```

## Complete Examples

### 1. User Repository Pattern

```java
import java.util.Optional;

class User {
    int id;
    String name;
    String email;
    
    User(int id, String name, String email) {
        this.id = id;
        this.name = name;
        this.email = email;
    }
}

interface UserRepository {
    Optional<User> findById(int id);
    Optional<User> findByEmail(String email);
}

class InMemoryUserRepository implements UserRepository {
    private static final Map<Integer, User> users = new HashMap<>();
    
    static {
        users.put(1, new User(1, "Alice", "alice@example.com"));
        users.put(2, new User(2, "Bob", "bob@example.com"));
    }
    
    @Override
    public Optional<User> findById(int id) {
        return Optional.ofNullable(users.get(id));
    }
    
    @Override
    public Optional<User> findByEmail(String email) {
        return users.values().stream()
            .filter(u -> u.email.equals(email))
            .findFirst();
    }
}

public class RepositoryExample {
    
    public static void main(String[] args) {
        UserRepository repo = new InMemoryUserRepository();
        
        // Safe lookup
        repo.findById(1)
            .ifPresentOrElse(
                user -> System.out.println("Found: " + user.name),
                () -> System.out.println("User not found")
            );
        
        // Chain operations
        repo.findById(2)
            .map(User::getEmail)
            .ifPresent(email -> sendEmail(email));
        
        // Provide default
        String name = repo.findById(999)
            .map(User::getName)
            .orElse("Unknown");
        System.out.println("Name: " + name);
    }
}
```

### 2. Configuration Loading

```java
import java.util.Optional;
import java.util.Properties;

public class ConfigLoader {
    
    private Properties properties;
    
    public ConfigLoader(Properties props) {
        this.properties = props;
    }
    
    // Safe getters using Optional
    public Optional<String> getString(String key) {
        return Optional.ofNullable(properties.getProperty(key));
    }
    
    public Optional<Integer> getInteger(String key) {
        return getString(key)
            .flatMap(value -> {
                try {
                    return Optional.of(Integer.parseInt(value));
                } catch (NumberFormatException e) {
                    return Optional.empty();
                }
            });
    }
    
    public Optional<Boolean> getBoolean(String key) {
        return getString(key)
            .map(Boolean::parseBoolean);
    }
}

public class ConfigExample {
    
    public static void main(String[] args) {
        Properties props = new Properties();
        props.setProperty("app.name", "MyApp");
        props.setProperty("app.port", "8080");
        props.setProperty("app.debug", "true");
        
        ConfigLoader config = new ConfigLoader(props);
        
        // Safe configuration access
        String appName = config.getString("app.name")
            .orElse("DefaultApp");
        
        int port = config.getInteger("app.port")
            .orElse(3000);
        
        boolean debug = config.getBoolean("app.debug")
            .orElse(false);
        
        System.out.println("App: " + appName);
        System.out.println("Port: " + port);
        System.out.println("Debug: " + debug);
    }
}

// Output:
// App: MyApp
// Port: 8080
// Debug: true
```

### 3. Chaining Operations

```java
import java.util.Optional;

class Product {
    String name;
    Optional<Discount> discount;
    
    Product(String name, Discount discount) {
        this.name = name;
        this.discount = Optional.ofNullable(discount);
    }
}

class Discount {
    int percent;
    
    Discount(int percent) {
        this.percent = percent;
    }
}

public class ChainingExample {
    
    static Optional<Product> getProduct(int id) {
        if (id == 1) {
            return Optional.of(
                new Product("Laptop", new Discount(10))
            );
        } else if (id == 2) {
            return Optional.of(
                new Product("Mouse", null)  // No discount
            );
        }
        return Optional.empty();
    }
    
    static double calculatePrice(Product product, double basePrice) {
        return product.discount
            .map(d -> basePrice * (100 - d.percent) / 100)
            .orElse(basePrice);
    }
    
    public static void main(String[] args) {
        // Product with discount
        getProduct(1)
            .ifPresent(product -> {
                double price = calculatePrice(product, 1000);
                System.out.println(product.name + ": $" + price);
            });
        
        // Product without discount
        getProduct(2)
            .ifPresent(product -> {
                double price = calculatePrice(product, 50);
                System.out.println(product.name + ": $" + price);
            });
        
        // Non-existent product
        getProduct(999)
            .ifPresentOrElse(
                product -> System.out.println(product.name),
                () -> System.out.println("Product not found")
            );
    }
}

// Output:
// Laptop: $900.0
// Mouse: $50.0
// Product not found
```

### 4. Optional with Streams

```java
import java.util.*;

public class OptionalWithStreams {
    
    public static void main(String[] args) {
        List<Optional<String>> optionals = Arrays.asList(
            Optional.of("Alice"),
            Optional.empty(),
            Optional.of("Bob"),
            Optional.empty(),
            Optional.of("Charlie")
        );
        
        // Filter out empty optionals
        optionals.stream()
            .flatMap(Optional::stream)
            .forEach(System.out::println);
        
        System.out.println("---");
        
        // Another approach
        optionals.stream()
            .filter(Optional::isPresent)
            .map(Optional::get)
            .forEach(System.out::println);
    }
}

// Output:
// Alice
// Bob
// Charlie
// ---
// Alice
// Bob
// Charlie
```

## Common Mistakes

### 1. Using get() Without Check

```java
// âŒ WRONG
Optional<String> value = Optional.empty();
String result = value.get();  // NoSuchElementException!

// RIGHT
String result = value.orElse("default");
```

### 2. Using Optional.of() With Null

```java
// âŒ WRONG
Optional<String> opt = Optional.of(null);  // NullPointerException!

// RIGHT
Optional<String> opt = Optional.ofNullable(null);  // Optional.empty
```

### 3. Optional as Method Parameter

```java
// âŒ NOT RECOMMENDED
void process(Optional<String> name) {
    // Complicated to use
}

// RECOMMENDED
void process(String name) {
    Optional.ofNullable(name)
        .ifPresent(n -> doSomething(n));
}
```

### 4. Using Optional for Collections

```java
// âŒ WRONG - for lists use empty list
Optional<List<String>> items = Optional.of(new ArrayList<>());

// RIGHT - use empty collection directly
List<String> items = new ArrayList<>();
if (!items.isEmpty()) { ... }
```

## When to Use Optional

### Perfect For:
- Return values from methods (indicates value may be absent)
- Stream operations (filtering, mapping)
- Chaining transformations
- Replacing null checks

### âŒ Avoid Using For:
- Method parameters (confuses API)
- Instance variables (unnecessary overhead)
- Collections (use empty collections instead)
- Performance-critical code (small overhead)

## Key Takeaways

- Optional prevents null pointer exceptions
- Use Optional.of() for non-null values
- Use Optional.ofNullable() for values that might be null
- Use ifPresent() or ifPresentOrElse() instead of isPresent() + get()
- Use map() and flatMap() to transform values
- Use orElse(), orElseGet(), orElseThrow() to handle empty cases
- Don't use Optional as method parameter
- Never call get() without checking first

---


