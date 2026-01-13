# Interfaces: Defining Contracts

## What is an Interface?

An **interface** is a contract that specifies what methods a class must implement. It's like a blueprint for behavior - "if you want to be a type X, you must have these methods."

```java
interface Drawable {
    void draw();      // Contract: must implement this
}

class Circle implements Drawable {
    public void draw() {
        System.out.println("Drawing circle");
    }
}

class Square implements Drawable {
    public void draw() {
        System.out.println("Drawing square");
    }
}
```

## Declaring Interfaces

```java
public interface Vehicle {
    void start();    // Abstract method
    void stop();     // Abstract method
}
```

## Implementing Interfaces

A class must implement all interface methods:

```java
public class Car implements Vehicle {
    public void start() {
        System.out.println("Car starting");
    }
    
    public void stop() {
        System.out.println("Car stopping");
    }
}
```

## Multiple Interfaces

A class can implement multiple interfaces (unlike classes):

```java
interface Flyable {
    void fly();
}

interface Swimmable {
    void swim();
}

class Duck implements Flyable, Swimmable {
    public void fly() {
        System.out.println("Duck flying");
    }
    
    public void swim() {
        System.out.println("Duck swimming");
    }
}

Duck duck = new Duck();
duck.fly();      // Duck flying
duck.swim();     // Duck swimming
```

## Interface Methods

### Abstract Methods
```java
interface Animal {
    void eat();  // No implementation - must override
}
```

### Default Methods (Java 8+)
```java
interface Animal {
    void eat();  // Abstract
    
    default void sleep() {  // Has implementation
        System.out.println("Sleeping");
    }
}

class Dog implements Animal {
    public void eat() {
        System.out.println("Eating dog food");
    }
    // sleep() is inherited from interface
}
```

### Static Methods
```java
interface Math {
    static int add(int a, int b) {
        return a + b;
    }
}

int result = Math.add(5, 3);  // 8
```

## Interface vs Abstract Class

| Interface | Abstract Class |
|-----------|---|
| Pure contract | Can have implementation |
| Multiple allowed | Single parent only |
| All methods abstract | Can mix abstract/concrete |
| No fields | Can have fields |
| "Can-do" abilities | "Is-a" relationships |

```java
// Interface: "Can be paid"
interface Payable {
    void pay();
}

// Abstract class: "Is an employee"
abstract class Employee {
    String name;
    abstract void work();
}

// Can be both
class Developer extends Employee implements Payable {
    public void work() { }
    public void pay() { }
}
```

## Practical Example: Shape System

```java
interface Shape {
    double getArea();
    double getPerimeter();
    void draw();
}

class Circle implements Shape {
    double radius;
    
    public Circle(double radius) {
        this.radius = radius;
    }
    
    public double getArea() {
        return Math.PI * radius * radius;
    }
    
    public double getPerimeter() {
        return 2 * Math.PI * radius;
    }
    
    public void draw() {
        System.out.println("Drawing circle");
    }
}

class Rectangle implements Shape {
    double width, height;
    
    public Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }
    
    public double getArea() {
        return width * height;
    }
    
    public double getPerimeter() {
        return 2 * (width + height);
    }
    
    public void draw() {
        System.out.println("Drawing rectangle");
    }
}

// Use all shapes uniformly
Shape[] shapes = {
    new Circle(5),
    new Rectangle(4, 6)
};

for (Shape shape : shapes) {
    shape.draw();
    System.out.println("Area: " + shape.getArea());
}
```

## Key Takeaways

- âœ… Interface = contract, class = implementation
- âœ… Classes implement interfaces with `implements`
- âœ… Must implement all interface methods
- âœ… Can implement multiple interfaces
- âœ… Use interface for behavior ("can-do")
- âœ… Use abstract class for shared code ("is-a")

---

