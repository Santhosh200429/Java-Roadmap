# Records: Immutable Data Classes (Java 17+)

## What is a Record?

A **record** is a special type for creating immutable data holder classes with minimal boilerplate. It automatically generates getters, equals(), hashCode(), and toString().

**Real-world analogy**: Record is like a pre-filled form - you fill it once and can't change it.

## Records vs Classes

### Traditional Class
```java
public class Point {
    private int x;
    private int y;
    
    public Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
    
    public int getX() { return x; }
    public int getY() { return y; }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Point)) return false;
        Point point = (Point) o;
        return x == point.x && y == point.y;
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(x, y);
    }
    
    @Override
    public String toString() {
        return "Point{" + "x=" + x + ", y=" + y + '}';
    }
}
```

### Same as Record
```java
public record Point(int x, int y) { }

// That's it! All methods auto-generated
```

## Basic Record Syntax

```java
public record Student(String name, String email, double gpa) { }

// Usage
Student student = new Student("Alice", "alice@email.com", 3.8);
System.out.println(student.name());      // Alice
System.out.println(student.email());     // alice@email.com
System.out.println(student.gpa());       // 3.8
System.out.println(student);             // Student[name=Alice, ...]
```

## Record Features

### 1. Auto-generated Methods

```java
record Person(String name, int age) { }

Person person = new Person("Bob", 30);

// Getters (note: no "get" prefix!)
person.name();    // "Bob"
person.age();     // 30

// equals()
Person p1 = new Person("Alice", 25);
Person p2 = new Person("Alice", 25);
p1.equals(p2);    // true

// hashCode()
Set<Person> set = new HashSet<>();
set.add(p1);
set.add(p2);      // Only one element (same hash)

// toString()
System.out.println(person);  // Person[name=Bob, age=30]
```

### 2. Immutability

Records are immutable - can't change values:

```java
record Book(String title, String author, int year) { }

Book book = new Book("1984", "Orwell", 1949);
book.title = "New Title";  // âŒ ERROR: can't set field
```

### 3. Constructor Validation

```java
record Temperature(double celsius) {
    // Compact constructor (validation)
    public Temperature {
        if (celsius < -273.15) {
            throw new IllegalArgumentException("Below absolute zero");
        }
    }
}

Temperature temp = new Temperature(25.0);    // OK
Temperature invalid = new Temperature(-300); // ERROR
```

### 4. Custom Methods

```java
record Circle(double radius) {
    // Compact constructor
    public Circle {
        if (radius <= 0) {
            throw new IllegalArgumentException("Radius must be positive");
        }
    }
    
    // Custom methods
    public double area() {
        return Math.PI * radius * radius;
    }
    
    public double circumference() {
        return 2 * Math.PI * radius;
    }
}

Circle circle = new Circle(5.0);
System.out.println("Area: " + circle.area());           // 78.5...
System.out.println("Circumference: " + circle.circumference()); // 31.4...
```

## Complete Examples

### 1. User Record

```java
record User(int id, String username, String email, boolean active) {
    
    // Compact constructor for validation
    public User {
        if (username == null || username.isBlank()) {
            throw new IllegalArgumentException("Username required");
        }
        if (!email.contains("@")) {
            throw new IllegalArgumentException("Invalid email");
        }
    }
    
    // Custom method
    public String displayName() {
        return active ? username : username + " (Inactive)";
    }
}

// Usage
User user = new User(1, "alice", "alice@email.com", true);
System.out.println(user.displayName());  // alice
System.out.println(user.id());           // 1
System.out.println(user);                // User[id=1, username=alice, ...]
```

### 2. Product Record

```java
record Product(String id, String name, double price, int stock) {
    
    // Validation
    public Product {
        if (price < 0) throw new IllegalArgumentException("Price negative");
        if (stock < 0) throw new IllegalArgumentException("Stock negative");
    }
    
    // Is in stock?
    public boolean inStock() {
        return stock > 0;
    }
    
    // Apply discount
    public double discountedPrice(double percentOff) {
        return price * (1 - percentOff / 100);
    }
    
    // Get total value
    public double totalValue() {
        return price * stock;
    }
}

// Usage
Product product = new Product("P001", "Laptop", 999.99, 5);
System.out.println(product.inStock());              // true
System.out.println(product.discountedPrice(10));   // 899.99
System.out.println(product.totalValue());          // 4999.95
```

### 3. Location Record

```java
record Location(double latitude, double longitude, String name) {
    
    public Location {
        if (latitude < -90 || latitude > 90) {
            throw new IllegalArgumentException("Invalid latitude");
        }
        if (longitude < -180 || longitude > 180) {
            throw new IllegalArgumentException("Invalid longitude");
        }
    }
    
    // Distance to another location
    public double distanceTo(Location other) {
        double lat1 = Math.toRadians(latitude);
        double lon1 = Math.toRadians(longitude);
        double lat2 = Math.toRadians(other.latitude);
        double lon2 = Math.toRadians(other.longitude);
        
        double dLat = lat2 - lat1;
        double dLon = lon2 - lon1;
        
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                   Math.cos(lat1) * Math.cos(lat2) *
                   Math.sin(dLon / 2) * Math.sin(dLon / 2);
        
        return 2 * 6371 * Math.asin(Math.sqrt(a)); // Earth radius
    }
}

// Usage
Location nyc = new Location(40.7128, -74.0060, "New York");
Location la = new Location(34.0522, -118.2437, "Los Angeles");
System.out.println("Distance: " + nyc.distanceTo(la) + " km");
```

## Records vs Alternatives

### Record vs Class
```java
// Record - concise, immutable
record Point(int x, int y) { }

// Class - flexible, mutable
class MutablePoint {
    private int x;
    private int y;
    public void setX(int x) { this.x = x; }
}

// Use record for: Data holders, immutable objects
// Use class for: Complex behavior, mutable objects
```

### Record vs Data Class
```java
// Record (Java 17+)
record Student(String name, double gpa) { }

// Data class (non-record alternative)
@Data  // Lombok annotation
class StudentData {
    private String name;
    private double gpa;
}

// Records are built-in, no dependencies needed
```

## Records in Collections

```java
record Grade(String subject, int score) { }

List<Grade> grades = Arrays.asList(
    new Grade("Math", 95),
    new Grade("Science", 87),
    new Grade("English", 92)
);

// Stream processing
grades.stream()
    .filter(g -> g.score() >= 90)
    .forEach(System.out::println);

// Create map
Map<String, Integer> gradeMap = grades.stream()
    .collect(Collectors.toMap(Grade::subject, Grade::score));
```

## Records with Inheritance

Records can't extend classes (but can implement interfaces):

```java
interface Nameable {
    String getName();
}

record Employee(String name, int id, double salary) implements Nameable {
    @Override
    public String getName() {
        return name;
    }
}

// Usage
Nameable emp = new Employee("Alice", 1, 50000);
System.out.println(emp.getName());  // Alice
```

## Sealed Records (Advanced)

Restrict which classes can extend:

```java
sealed record Result permits SuccessResult, ErrorResult {
}

record SuccessResult(Object value) extends Result { }
record ErrorResult(String error) extends Result { }

// Usage
Result result = new SuccessResult("Data");
if (result instanceof SuccessResult sr) {
    System.out.println(sr.value());
}
```

## Common Mistakes

### 1. Trying to Modify Record
```java
// âŒ WRONG
record Point(int x, int y) { }
Point p = new Point(1, 2);
p.x = 5;  // ERROR: can't modify

// RIGHT - Create new record
Point p2 = new Point(5, p.y());
```

### 2. Wrong Constructor Usage
```java
// âŒ WRONG - no setter methods
record User(String name) { }
User u = new User("Alice");
// u.setName("Bob");  // No setter!

// RIGHT - immutable
User u2 = new User("Bob");
```

### 3. Forgetting Compact Constructor
```java
// âŒ WRONG - verbose
record Age(int years) {
    public Age(int years) {
        if (years < 0) throw new Exception();
        this.years = years;  // Can't assign!
    }
}

// RIGHT - compact constructor
record Age(int years) {
    public Age {
        if (years < 0) throw new Exception();
    }
}
```

## When to Use Records

**Use Records for:**
- Data transfer objects (DTOs)
- API responses/requests
- Immutable data holders
- Value objects
- Configuration objects

âŒ **Don't Use Records for:**
- Complex business logic
- Mutable data
- Entities with many relationships
- Legacy compatibility needs

## Key Takeaways

- Records are immutable data classes
- Auto-generates constructors, getters, equals(), hashCode(), toString()
- Compact constructor syntax for validation
- Can have custom methods
- Can implement interfaces
- Java 17+ feature
- Perfect for DTOs and value objects

---


