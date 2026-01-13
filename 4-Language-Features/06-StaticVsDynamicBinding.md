# Static vs Dynamic Binding in Java

## What is Binding?

**Binding** is the process of linking a method call to the actual method that runs.

```
Method Call → Which method actually executes?
              ↓
         Binding decides!
```

## Static Binding (Compile-time)

**Static binding** happens at compile time - the compiler knows exactly which method will run.

```java
public class StaticBindingExample {
    
    // Static methods (always static binding)
    static void greet() {
        System.out.println("Static greeting");
    }
    
    static void call() {
        greet();  // Compiler knows exactly which method
    }
    
    public static void main(String[] args) {
        greet();  // Binding: StaticBindingExample.greet()
        call();   // Binding: StaticBindingExample.call()
    }
}

// Output:
// Static greeting
// Static greeting
```

### When Static Binding Occurs

```java
public class Person {
    
    // Private methods (always static binding)
    private void secret() {
        System.out.println("Secret");
    }
    
    // Final methods (always static binding)
    final void permanent() {
        System.out.println("Cannot override");
    }
    
    // Static methods (always static binding)
    static void common() {
        System.out.println("Static");
    }
    
    public void show() {
        secret();     // Static binding
        permanent();  // Static binding
        common();     // Static binding
    }
}

// Why?
// - private: not inherited, compiler knows exact method
// - final: cannot be overridden, compiler knows exact method
// - static: belongs to class, not instance
```

## Dynamic Binding (Runtime)

**Dynamic binding** happens at runtime - the actual object type determines which method runs.

```java
public class Animal {
    public void sound() {
        System.out.println("Some sound");
    }
}

public class Dog extends Animal {
    @Override
    public void sound() {
        System.out.println("Woof!");
    }
}

public class Cat extends Animal {
    @Override
    public void sound() {
        System.out.println("Meow!");
    }
}

public class DynamicBindingExample {
    
    public static void main(String[] args) {
        Animal dog = new Dog();
        Animal cat = new Cat();
        
        // At compile time: both are Animal type
        // At runtime: JVM checks actual object type
        
        dog.sound();  // Runtime binding → Woof!
        cat.sound();  // Runtime binding → Meow!
    }
}

// Compile time:
//   dog.sound() → looks for sound() in Animal class ✓
//   cat.sound() → looks for sound() in Animal class ✓
//
// Runtime:
//   dog → actual type is Dog → call Dog.sound()
//   cat → actual type is Cat → call Cat.sound()
```

## Complete Examples

### 1. Method Resolution in Inheritance

```java
public class Vehicle {
    
    public void start() {
        System.out.println("Vehicle starting");
    }
    
    public void stop() {
        System.out.println("Vehicle stopping");
    }
}

public class Car extends Vehicle {
    
    @Override
    public void start() {
        System.out.println("Car engine cranking");
    }
    
    // stop() not overridden - inherited version used
}

public class Bike extends Vehicle {
    
    @Override
    public void start() {
        System.out.println("Bike kickstart");
    }
    
    @Override
    public void stop() {
        System.out.println("Bike braking hard");
    }
}

public class TransportationExample {
    
    static void operate(Vehicle v) {
        v.start();  // Dynamic binding!
        v.stop();   // Dynamic binding!
    }
    
    public static void main(String[] args) {
        operate(new Car());
        System.out.println();
        operate(new Bike());
    }
}

// Output:
// Car engine cranking
// Vehicle stopping
//
// Bike kickstart
// Bike braking hard
```

### 2. Interface Implementation

```java
interface PaymentMethod {
    void pay(double amount);
    void refund(double amount);
}

class CreditCard implements PaymentMethod {
    public void pay(double amount) {
        System.out.println("Charging credit card: $" + amount);
    }
    
    public void refund(double amount) {
        System.out.println("Refunding to credit card: $" + amount);
    }
}

class PayPal implements PaymentMethod {
    public void pay(double amount) {
        System.out.println("PayPal payment: $" + amount);
    }
    
    public void refund(double amount) {
        System.out.println("PayPal refund: $" + amount);
    }
}

class Wallet implements PaymentMethod {
    public void pay(double amount) {
        System.out.println("Wallet payment: $" + amount);
    }
    
    public void refund(double amount) {
        System.out.println("Wallet refund: $" + amount);
    }
}

public class PaymentProcessor {
    
    static void processPayment(PaymentMethod method, double amount) {
        method.pay(amount);      // Dynamic binding!
        // ... later ...
        method.refund(amount);   // Dynamic binding!
    }
    
    public static void main(String[] args) {
        processPayment(new CreditCard(), 100);
        System.out.println();
        processPayment(new PayPal(), 50);
        System.out.println();
        processPayment(new Wallet(), 25);
    }
}

// Output:
// Charging credit card: $100.0
// Refunding to credit card: $100.0
//
// PayPal payment: $50.0
// PayPal refund: $50.0
//
// Wallet payment: $25.0
// Wallet refund: $25.0
```

### 3. Shape Example (Classic)

```java
abstract class Shape {
    
    abstract double calculateArea();
    
    abstract double calculatePerimeter();
    
    final void printInfo() {
        // Final: always static binding
        System.out.println("Area: " + calculateArea());
        System.out.println("Perimeter: " + calculatePerimeter());
    }
}

class Circle extends Shape {
    private double radius;
    
    Circle(double radius) {
        this.radius = radius;
    }
    
    @Override
    double calculateArea() {
        return Math.PI * radius * radius;
    }
    
    @Override
    double calculatePerimeter() {
        return 2 * Math.PI * radius;
    }
}

class Rectangle extends Shape {
    private double length, width;
    
    Rectangle(double length, double width) {
        this.length = length;
        this.width = width;
    }
    
    @Override
    double calculateArea() {
        return length * width;
    }
    
    @Override
    double calculatePerimeter() {
        return 2 * (length + width);
    }
}

class Triangle extends Shape {
    private double a, b, c;
    
    Triangle(double a, double b, double c) {
        this.a = a;
        this.b = b;
        this.c = c;
    }
    
    @Override
    double calculateArea() {
        // Heron's formula
        double s = (a + b + c) / 2;
        return Math.sqrt(s * (s - a) * (s - b) * (s - c));
    }
    
    @Override
    double calculatePerimeter() {
        return a + b + c;
    }
}

public class GeometryApp {
    
    public static void main(String[] args) {
        Shape circle = new Circle(5);
        Shape rectangle = new Rectangle(4, 6);
        Shape triangle = new Triangle(3, 4, 5);
        
        Shape[] shapes = {circle, rectangle, triangle};
        
        for (Shape shape : shapes) {
            shape.printInfo();  // Final method: static binding
            // But calls to calculateArea/Perimeter: dynamic binding!
            System.out.println();
        }
    }
}

// Output:
// Area: 78.53981633974483
// Perimeter: 31.41592653589793
//
// Area: 24.0
// Perimeter: 20.0
//
// Area: 6.0
// Perimeter: 12.0
```

## Static vs Dynamic: Side-by-Side

```java
public class ComparisonExample {
    
    static class Parent {
        static void staticMethod() {
            System.out.println("Parent static");
        }
        
        void instanceMethod() {
            System.out.println("Parent instance");
        }
        
        final void finalMethod() {
            System.out.println("Parent final");
        }
    }
    
    static class Child extends Parent {
        static void staticMethod() {
            // Shadows parent (not override)
            System.out.println("Child static");
        }
        
        @Override
        void instanceMethod() {
            System.out.println("Child instance");
        }
        
        // Cannot override final method
    }
    
    public static void main(String[] args) {
        Parent p = new Child();
        
        // Static method: static binding (compile time)
        p.staticMethod();
        // Output: Parent static (NOT Child static!)
        // Reason: static methods bound to reference type (Parent)
        
        // Instance method: dynamic binding (runtime)
        p.instanceMethod();
        // Output: Child instance
        // Reason: instance methods use actual object type
        
        // Final method: static binding (compile time)
        p.finalMethod();
        // Output: Parent final
        // Reason: final methods cannot be overridden
    }
}

// Binding Rules:
// Static methods      → Static binding (reference type)
// Private methods     → Static binding (reference type)
// Final methods       → Static binding (reference type)
// Instance methods    → Dynamic binding (actual object type)
// Variables           → Static binding (reference type)
```

## Virtual Method Invocation

```java
public class VirtualMethodExample {
    
    class Animal {
        void eat() {
            System.out.println("Animal eating");
        }
    }
    
    class Dog extends Animal {
        @Override
        void eat() {
            System.out.println("Dog eating kibble");
        }
    }
    
    public void feedAnimal(Animal animal) {
        // Virtual method invocation (dynamic)
        animal.eat();  // Actual object type decides!
    }
    
    public static void main(String[] args) {
        VirtualMethodExample example = new VirtualMethodExample();
        
        Animal a = new Animal();
        example.feedAnimal(a);  // Output: Animal eating
        
        Dog d = new Dog();
        example.feedAnimal(d);  // Output: Dog eating kibble
        
        // Same method called, different behavior
        // All decided at runtime!
    }
}
```

## Common Mistakes

### 1. Expecting Static Binding Override

```java
// ❌ WRONG - static methods not overridden
class Parent {
    static void test() {
        System.out.println("Parent");
    }
}

class Child extends Parent {
    static void test() {
        System.out.println("Child");
    }
}

Parent p = new Child();
p.test();  // Output: Parent (NOT Child!)
// Static binding uses reference type (Parent)
```

### 2. Forgetting about Method Hiding

```java
// This is method HIDING, not overriding
class A {
    static void show() {
        System.out.println("A static");
    }
}

class B extends A {
    static void show() {
        System.out.println("B static");
    }
}

A a = new B();
a.show();  // Output: A static (hides B's version)
```

### 3. Confusing Variable Binding

```java
class Parent {
    int value = 10;
}

class Child extends Parent {
    int value = 20;
}

Parent p = new Child();
System.out.println(p.value);  // Output: 10 (NOT 20!)
// Variables use static binding (reference type)
// Only methods use dynamic binding!
```

## When to Use Dynamic Binding

```java
// ✅ Use dynamic binding for:

// 1. Strategy pattern
interface Strategy {
    void execute();
}

class AggressiveStrategy implements Strategy {
    public void execute() { /* attack! */ }
}

class DefensiveStrategy implements Strategy {
    public void execute() { /* defend! */ }
}

void fight(Strategy strategy) {
    strategy.execute();  // Dynamic!
}

// 2. Factory pattern
Vehicle createVehicle(String type) {
    if (type.equals("car")) return new Car();
    else return new Bike();
}

Vehicle v = createVehicle("car");
v.start();  // Dynamic binding!
```

## Performance Impact

```java
// Dynamic binding has minimal overhead (microseconds)
// Modern JVMs optimize with:
// - Inline caching
// - Devirtualization
// - JIT compilation

// So don't avoid it for performance reasons!
// Use it for better design.
```

## Key Takeaways

- ✅ Static binding: compile-time, method clearly known
- ✅ Dynamic binding: runtime, actual object type decides
- ✅ Static methods: always static binding
- ✅ Private methods: always static binding
- ✅ Final methods: always static binding
- ✅ Instance methods: usually dynamic binding
- ✅ Variables: always static binding
- ✅ Use dynamic binding for flexibility and extensibility
- ✅ Modern JVMs optimize dynamic calls efficiently

---

**Next →** PassByValue: [Parameter Passing](/4-Language-Features/07-PassByValue.md)
