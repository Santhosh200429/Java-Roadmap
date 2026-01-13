# Initializer Blocks: Code Initialization in Java

## What are Initializer Blocks?

**Initializer blocks** are blocks of code that execute automatically when a class is loaded (static) or when an object is created (instance).

**Use case**: Initialize data without explicitly calling methods.

```java
public class Example {
    
    // Static initializer block - runs when class loads
    static {
        System.out.println("Class loaded!");
    }
    
    // Instance initializer block - runs before constructor
    {
        System.out.println("Object created!");
    }
    
    public Example() {
        System.out.println("Constructor called!");
    }
}

// Output when Example.class is loaded:
// Class loaded!

// Output when new Example() is called:
// Object created!
// Constructor called!
```

## Static Initializer Blocks

### Purpose

Static blocks execute **once** when the class is first loaded by the JVM - before any objects are created.

```java
public class DatabaseConfig {
    
    private static Connection dbConnection;
    private static boolean initialized = false;
    
    // Static initializer - runs once at class load time
    static {
        System.out.println("Initializing database connection...");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            dbConnection = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mydb",
                "root",
                "password"
            );
            initialized = true;
            System.out.println("Database initialized!");
        } catch (Exception e) {
            System.err.println("Failed to initialize database: " + e);
            initialized = false;
        }
    }
    
    public static Connection getConnection() {
        if (!initialized) {
            throw new RuntimeException("Database not initialized");
        }
        return dbConnection;
    }
}

// Usage
public class Main {
    public static void main(String[] args) {
        // Static block already executed when class loaded!
        Connection conn = DatabaseConfig.getConnection();
    }
}
```

### Common Use Cases

```java
// 1. Loading configuration
public class AppConfig {
    static {
        // Load properties file
        Properties props = new Properties();
        props.load(new FileInputStream("app.properties"));
        API_KEY = props.getProperty("api.key");
    }
}

// 2. Setting up logging
public class LoggerSetup {
    static {
        LogManager.getLogManager().readConfiguration(
            LoggerSetup.class.getResourceAsStream("logging.properties")
        );
    }
}

// 3. Initializing constants
public class MathConstants {
    static {
        PI = 3.14159265359;
        E = 2.71828182846;
    }
}
```

## Instance Initializer Blocks

### Purpose

Instance blocks execute **every time** an object is created, before the constructor runs.

```java
public class Student {
    
    private String name;
    private List<String> courses;
    private int enrollmentYear;
    
    // Instance initializer block - runs before constructor
    {
        courses = new ArrayList<>();
        enrollmentYear = LocalDate.now().getYear();
        System.out.println("Student object being created...");
    }
    
    public Student(String name) {
        this.name = name;
        System.out.println("Constructor for: " + name);
    }
    
    public void enroll(String course) {
        courses.add(course);
        System.out.println(name + " enrolled in " + course);
    }
}

// Usage
Student s1 = new Student("Alice");
// Output:
// Student object being created...
// Constructor for: Alice

Student s2 = new Student("Bob");
// Output:
// Student object being created...
// Constructor for: Bob
```

## Execution Order

```java
public class ExecutionOrder {
    
    // 1. STATIC INITIALIZER (class load time)
    static {
        System.out.println("1. Static initializer");
    }
    
    // 2. INSTANCE INITIALIZER (every object creation)
    {
        System.out.println("2. Instance initializer");
    }
    
    // 3. CONSTRUCTOR (every object creation)
    public ExecutionOrder() {
        System.out.println("3. Constructor");
    }
}

// First object creation:
ExecutionOrder obj1 = new ExecutionOrder();
// Output:
// 1. Static initializer (only first time!)
// 2. Instance initializer
// 3. Constructor

// Second object creation:
ExecutionOrder obj2 = new ExecutionOrder();
// Output:
// 2. Instance initializer (static already ran)
// 3. Constructor
```

## Complete Examples

### 1. Game Entity Initialization

```java
public class GameEntity {
    
    // Static: shared game configuration
    private static final Random random = new Random();
    private static int totalEntities = 0;
    private static final List<GameEntity> allEntities = new ArrayList<>();
    
    static {
        System.out.println("Initializing game entity system");
        totalEntities = 0;
    }
    
    // Instance: per-entity setup
    private String id;
    private int x, y;
    private int health;
    private LocalDateTime createdAt;
    
    {
        // Initialize per-entity data
        this.id = "Entity-" + System.nanoTime();
        this.x = random.nextInt(1000);
        this.y = random.nextInt(1000);
        this.health = 100;
        this.createdAt = LocalDateTime.now();
        
        totalEntities++;
        allEntities.add(this);
    }
    
    public GameEntity(String type) {
        System.out.println("Created " + type + " at (" + x + ", " + y + ")");
    }
    
    public static int getTotalEntities() {
        return totalEntities;
    }
    
    public void takeDamage(int damage) {
        health -= damage;
        if (health < 0) health = 0;
    }
}

// Usage
public class Game {
    public static void main(String[] args) {
        new GameEntity("Player");
        new GameEntity("Enemy");
        new GameEntity("NPC");
        
        System.out.println("Total entities: " + GameEntity.getTotalEntities());
    }
}
```

### 2. Spring-like Dependency Injection

```java
public class ServiceLocator {
    
    // Static registry of services
    private static final Map<Class<?>, Object> services = new HashMap<>();
    
    static {
        // Register all services at startup
        services.put(UserService.class, new UserService());
        services.put(ProductService.class, new ProductService());
        services.put(OrderService.class, new OrderService());
        System.out.println("All services registered");
    }
    
    public static <T> T getService(Class<T> serviceClass) {
        return serviceClass.cast(services.get(serviceClass));
    }
}

public class UserService {}
public class ProductService {}
public class OrderService {}

// Usage
public class Application {
    public static void main(String[] args) {
        UserService users = ServiceLocator.getService(UserService.class);
        ProductService products = ServiceLocator.getService(ProductService.class);
    }
}
```

### 3. Complex Object Initialization

```java
public class DataCache {
    
    private String name;
    private Map<String, String> data;
    private int capacity;
    private LocalDateTime lastUpdated;
    
    // Static: shared thread pool
    private static final ExecutorService executor;
    
    static {
        executor = Executors.newFixedThreadPool(4);
        System.out.println("Cache thread pool initialized");
    }
    
    // Instance: per-cache setup
    {
        data = Collections.synchronizedMap(new LinkedHashMap<String, String>() {
            @Override
            protected boolean removeEldestEntry(Map.Entry eldest) {
                return size() > capacity;
            }
        });
        
        lastUpdated = LocalDateTime.now();
    }
    
    public DataCache(String name, int capacity) {
        this.name = name;
        this.capacity = capacity;
        System.out.println("Cache '" + name + "' created with capacity " + capacity);
    }
    
    public void put(String key, String value) {
        data.put(key, value);
        lastUpdated = LocalDateTime.now();
    }
    
    public String get(String key) {
        return data.get(key);
    }
}

// Usage
DataCache cache1 = new DataCache("Users", 1000);
DataCache cache2 = new DataCache("Products", 500);
```

## Static Initializer Order

When multiple static blocks exist, they execute **in order**:

```java
public class InitializationSequence {
    
    // 1. First
    static {
        System.out.println("Static block 1");
        value1 = 10;
    }
    
    // 2. Second
    static {
        System.out.println("Static block 2");
        value2 = value1 * 2;
    }
    
    // 3. Third
    static {
        System.out.println("Static block 3");
        result = value1 + value2;
    }
    
    private static int value1;
    private static int value2;
    private static int result;
    
    public static void main(String[] args) {
        System.out.println("Result: " + result);
    }
}

// Output:
// Static block 1
// Static block 2
// Static block 3
// Result: 30
```

## Instance Initializer Order

Multiple instance blocks execute **in order** before constructor:

```java
public class InstanceInitOrder {
    
    // 1. First instance block
    {
        System.out.println("Instance block 1");
        x = 5;
    }
    
    // 2. Second instance block
    {
        System.out.println("Instance block 2");
        y = x * 2;
    }
    
    private int x;
    private int y;
    
    // 3. Constructor (after all blocks)
    public InstanceInitOrder() {
        System.out.println("Constructor: x=" + x + ", y=" + y);
    }
}

// Output when new InstanceInitOrder() is called:
// Instance block 1
// Instance block 2
// Constructor: x=5, y=10
```

## When to Use Initializer Blocks

### Use Static Blocks For:
- One-time class setup (database drivers, logging)
- Loading shared resources
- Initializing class-level constants from external sources
- Setting up thread pools or executors

```java
public class DatabaseDriver {
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL driver not found");
        }
    }
}
```

### Use Instance Blocks For:
- Complex initialization common to multiple constructors
- Setting up collections or data structures
- Initialization that shouldn't be duplicated across constructors

```java
public class Person {
    private String name;
    private List<String> hobbies;
    
    {
        hobbies = new ArrayList<>();  // Avoids duplication
    }
    
    public Person(String name) {
        this.name = name;
    }
    
    public Person(String name, String... initialHobbies) {
        this.name = name;
        hobbies.addAll(Arrays.asList(initialHobbies));
    }
}
```

### [WRONG] Avoid Static Blocks For:
- Complex logic (use static methods instead)
- Error-prone initialization
- Things that change (use initialization methods)

## Common Mistakes

### 1. Accessing Instance Variables in Static Block

```java
// [WRONG] WRONG
public class Wrong {
    public int value = 5;
    
    static {
        System.out.println(value);  // ERROR! value is not static
    }
}

// RIGHT
public class Correct {
    public static int value = 5;
    
    static {
        System.out.println(value);  // OK
    }
}
```

### 2. Throwing Checked Exceptions in Static Block

```java
// [WRONG] WRONG
public class Wrong {
    static {
        FileInputStream fis = new FileInputStream("file.txt");  // ERROR!
    }
}

// RIGHT
public class Correct {
    static {
        try {
            FileInputStream fis = new FileInputStream("file.txt");
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        }
    }
}
```

### 3. Overcomplicating Instance Initialization

```java
// [WRONG] WRONG - too complex
public class Complex {
    {
        for (int i = 0; i < 1000; i++) {
            // Do lots of work
        }
    }
}

// RIGHT - use constructor
public class Simple {
    public Simple() {
        initializeData();
    }
    
    private void initializeData() {
        for (int i = 0; i < 1000; i++) {
            // Do lots of work
        }
    }
}
```

## Key Takeaways

- Static blocks run once when class loads
- Instance blocks run before constructor every time
- Multiple blocks execute in declaration order
- Use static blocks for class-level initialization
- Use instance blocks for object-level setup common to multiple constructors
- Generally prefer constructors for clarity
- Never throw checked exceptions in static blocks

---


