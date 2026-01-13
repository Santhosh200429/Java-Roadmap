# Enums: Fixed Set of Constants

## What is an Enum?

An **enum** is a special type that represents a fixed set of constants. Use it when you have a defined list of options.

**Real-world analogy**: Enum is like a traffic light (only RED, YELLOW, GREEN - nothing else).

## Why Enums?

Instead of this:
```java
// âŒ Error-prone
String status = "PENDING";
String priority = "MODERATE";  // Typo? No compile-time check
```

Use this:
```java
// âœ… Type-safe
Status status = Status.PENDING;
Priority priority = Priority.HIGH;  // Compiler catches typos
```

## Basic Enum

```java
public enum Direction {
    NORTH,
    SOUTH,
    EAST,
    WEST
}

// Usage
Direction dir = Direction.NORTH;
System.out.println(dir);  // NORTH
```

## Enum with Values

```java
public enum Day {
    MONDAY(1),
    TUESDAY(2),
    WEDNESDAY(3),
    THURSDAY(4),
    FRIDAY(5),
    SATURDAY(6),
    SUNDAY(7);
    
    private int dayNumber;
    
    Day(int dayNumber) {
        this.dayNumber = dayNumber;
    }
    
    public int getDayNumber() {
        return dayNumber;
    }
}

// Usage
Day day = Day.MONDAY;
System.out.println(day.getDayNumber());  // 1
```

## Enum with Multiple Values

```java
public enum Size {
    SMALL(1, "$10"),
    MEDIUM(2, "$15"),
    LARGE(3, "$20"),
    EXTRA_LARGE(4, "$25");
    
    private int quantity;
    private String price;
    
    Size(int quantity, String price) {
        this.quantity = quantity;
        this.price = price;
    }
    
    public int getQuantity() { return quantity; }
    public String getPrice() { return price; }
}

// Usage
Size size = Size.LARGE;
System.out.println(size.getPrice());  // $20
```

## Enum Methods

```java
public enum Status {
    PENDING,
    APPROVED,
    REJECTED
}

// Get all values
for (Status s : Status.values()) {
    System.out.println(s);  // PENDING, APPROVED, REJECTED
}

// Get by name
Status status = Status.valueOf("APPROVED");
System.out.println(status);  // APPROVED

// Compare
if (status == Status.APPROVED) {
    System.out.println("Approved!");
}

// Order of definition (ordinal)
System.out.println(Status.PENDING.ordinal());   // 0
System.out.println(Status.APPROVED.ordinal());  // 1
```

## Enum in Switch Statement

```java
public class OrderProcessor {
    
    public void processOrder(Status status) {
        switch (status) {
            case PENDING:
                System.out.println("Processing order...");
                break;
            case APPROVED:
                System.out.println("Order approved!");
                break;
            case REJECTED:
                System.out.println("Order rejected!");
                break;
        }
    }
}
```

## Enum with Methods

```java
public enum PaymentMethod {
    CREDIT_CARD {
        @Override
        public void process(double amount) {
            System.out.println("Processing $" + amount + " via credit card");
        }
    },
    
    PAYPAL {
        @Override
        public void process(double amount) {
            System.out.println("Processing $" + amount + " via PayPal");
        }
    },
    
    BITCOIN {
        @Override
        public void process(double amount) {
            System.out.println("Processing $" + amount + " via Bitcoin");
        }
    };
    
    public abstract void process(double amount);
}

// Usage
PaymentMethod method = PaymentMethod.CREDIT_CARD;
method.process(99.99);  // Output: Processing $99.99 via credit card
```

## Enum with Interfaces

```java
public interface Drawable {
    void draw();
}

public enum Shape implements Drawable {
    CIRCLE {
        @Override
        public void draw() {
            System.out.println("Drawing circle");
        }
    },
    
    SQUARE {
        @Override
        public void draw() {
            System.out.println("Drawing square");
        }
    },
    
    TRIANGLE {
        @Override
        public void draw() {
            System.out.println("Drawing triangle");
        }
    };
}

// Usage
Shape shape = Shape.CIRCLE;
shape.draw();  // Output: Drawing circle
```

## Practical Examples

### User Role Enum

```java
public enum Role {
    ADMIN("Administrator", true),
    USER("Regular User", false),
    GUEST("Guest User", false);
    
    private String description;
    private boolean isAdmin;
    
    Role(String description, boolean isAdmin) {
        this.description = description;
        this.isAdmin = isAdmin;
    }
    
    public String getDescription() { return description; }
    public boolean isAdmin() { return isAdmin; }
    
    public static void main(String[] args) {
        Role role = Role.ADMIN;
        
        System.out.println("Role: " + role);
        System.out.println("Description: " + role.getDescription());
        System.out.println("Is Admin: " + role.isAdmin());
        
        // List all roles
        System.out.println("\nAll roles:");
        for (Role r : Role.values()) {
            System.out.println(r + " - " + r.getDescription());
        }
    }
}

// Output:
// Role: ADMIN
// Description: Administrator
// Is Admin: true
//
// All roles:
// ADMIN - Administrator
// USER - Regular User
// GUEST - Guest User
```

### Order Status Workflow

```java
public enum OrderStatus {
    CREATED("Order created", true, false),
    PROCESSING("Being processed", true, false),
    SHIPPED("Shipped to customer", true, false),
    DELIVERED("Delivered successfully", false, false),
    CANCELLED("Order cancelled", false, true);
    
    private String description;
    private boolean canShip;
    private boolean canCancel;
    
    OrderStatus(String description, boolean canShip, boolean canCancel) {
        this.description = description;
        this.canShip = canShip;
        this.canCancel = canCancel;
    }
    
    public String getDescription() { return description; }
    public boolean canShip() { return canShip; }
    public boolean canCancel() { return canCancel; }
}

// Usage
OrderStatus status = OrderStatus.PROCESSING;
System.out.println(status.getDescription());  // Being processed

if (status.canShip()) {
    System.out.println("Ready to ship!");
}

if (status.canCancel()) {
    System.out.println("Can still cancel");
} else {
    System.out.println("Cannot cancel");
}
```

### Priority Levels

```java
public enum Priority implements Comparable<Priority> {
    LOW(1),
    MEDIUM(2),
    HIGH(3),
    CRITICAL(4);
    
    private int level;
    
    Priority(int level) {
        this.level = level;
    }
    
    public int getLevel() { return level; }
    
    @Override
    public int compareTo(Priority other) {
        return Integer.compare(this.level, other.level);
    }
}

// Usage
List<Priority> tasks = Arrays.asList(
    Priority.LOW,
    Priority.CRITICAL,
    Priority.MEDIUM,
    Priority.HIGH
);

Collections.sort(tasks);
System.out.println(tasks);  // [LOW, MEDIUM, HIGH, CRITICAL]
```

## Complete Example: Traffic Light

```java
public enum TrafficLight {
    RED(30, "Stop") {
        @Override
        public TrafficLight next() {
            return GREEN;
        }
    },
    
    YELLOW(5, "Slow Down") {
        @Override
        public TrafficLight next() {
            return RED;
        }
    },
    
    GREEN(25, "Go") {
        @Override
        public TrafficLight next() {
            return YELLOW;
        }
    };
    
    private int duration;  // seconds
    private String action;
    
    TrafficLight(int duration, String action) {
        this.duration = duration;
        this.action = action;
    }
    
    public int getDuration() { return duration; }
    public String getAction() { return action; }
    
    public abstract TrafficLight next();
    
    public void display() {
        System.out.println(this + ": " + action + " (" + duration + "s)");
    }
}

// Usage
public class TrafficController {
    public static void main(String[] args) {
        TrafficLight light = TrafficLight.RED;
        
        // Simulate traffic light
        for (int i = 0; i < 3; i++) {
            light.display();
            System.out.println("---");
            light = light.next();
        }
        
        // Output:
        // RED: Stop (30s)
        // ---
        // GREEN: Go (25s)
        // ---
        // YELLOW: Slow Down (5s)
    }
}
```

## Enum Comparisons

```java
Day day1 = Day.MONDAY;
Day day2 = Day.MONDAY;
Day day3 = Day.TUESDAY;

// Equality
System.out.println(day1 == day2);   // true (safe to use ==)
System.out.println(day1.equals(day2));  // true

// Inequality
System.out.println(day1 == day3);   // false

// Switch (compile-time check)
switch (day1) {
    case MONDAY:
        System.out.println("Start of week");
        break;
    case FRIDAY:
        System.out.println("Almost weekend");
        break;
}
```

## Common Mistakes

### 1. Creating Enum Instances (Can't!)
```java
// âŒ WRONG
Direction dir = new Direction.NORTH;

// âœ… RIGHT
Direction dir = Direction.NORTH;
```

### 2. Comparing with String
```java
// âŒ WRONG
String status = "PENDING";
if (status == Status.PENDING) { }  // Always false

// âœ… RIGHT
if (Status.PENDING.toString().equals(status)) { }
// OR
Status status = Status.valueOf("PENDING");
```

### 3. Empty Enum
```java
// âŒ WRONG
enum Empty { }  // No constants

// âœ… RIGHT
enum Status {
    ACTIVE,
    INACTIVE
}
```

## Key Takeaways

- âœ… Enums represent fixed set of constants
- âœ… Type-safe - compiler checks values
- âœ… Can have fields, methods, constructors
- âœ… Use in switch statements
- âœ… Compare with ==
- âœ… Use .values() to get all
- âœ… Can implement interfaces

---

