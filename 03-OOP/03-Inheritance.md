# Inheritance: Reusing Code Through Inheritance

## What is Inheritance?

**Inheritance** is a mechanism where one class can inherit properties and methods from another class. It promotes code reuse and establishes relationships between classes.

Think of it like real-world inheritance:
```
Parent (Grandparent's traits)
  â†“
Child (Inherits Parent's traits + adds own)
  â†“
Grandchild (Inherits Child's traits + adds own)
```

## Why Use Inheritance?

**Without Inheritance** (repetitive):
```java
class Dog {
    String name;
    void eat() { System.out.println("Eating"); }
    void sleep() { System.out.println("Sleeping"); }
}

class Cat {
    String name;
    void eat() { System.out.println("Eating"); }
    void sleep() { System.out.println("Sleeping"); }
}

// Same code repeated!
```

**With Inheritance** (clean):
```java
class Animal {
    String name;
    void eat() { System.out.println("Eating"); }
    void sleep() { System.out.println("Sleeping"); }
}

class Dog extends Animal {
    void bark() { System.out.println("Woof!"); }
}

class Cat extends Animal {
    void meow() { System.out.println("Meow!"); }
}

// Code reused, not repeated!
```

## Parent and Child Classes

### Parent Class (Superclass)

Contains common properties and methods:

```java
public class Animal {
    String name;
    int age;
    
    public void eat() {
        System.out.println(name + " is eating");
    }
    
    public void sleep() {
        System.out.println(name + " is sleeping");
    }
}
```

### Child Class (Subclass)

Inherits from parent and adds its own:

```java
public class Dog extends Animal {
    String breed;
    
    public void bark() {
        System.out.println(name + " says: Woof!");
    }
}
```

The keyword **`extends`** means "inherit from"

## Using Inherited Classes

```java
// Create Dog object
Dog dog = new Dog();
dog.name = "Buddy";      // Inherited property
dog.age = 3;             // Inherited property
dog.breed = "Labrador";  // Own property

dog.eat();               // Inherited method
dog.sleep();             // Inherited method
dog.bark();              // Own method

/* Output:
Buddy is eating
Buddy is sleeping
Buddy says: Woof!
*/
```

## The super Keyword

Access parent class properties and methods:

```java
public class Animal {
    String name = "Animal";
    
    public void introduce() {
        System.out.println("I am " + name);
    }
}

public class Dog extends Animal {
    String name = "Dog";
    
    public void introduce() {
        super.introduce();  // Call parent's introduce()
        System.out.println("I am a " + name);
    }
}

// Use it
Dog dog = new Dog();
dog.introduce();
/* Output:
I am Animal
I am a Dog
*/
```

### super in Constructors

```java
public class Animal {
    String name;
    
    public Animal(String name) {
        this.name = name;
    }
}

public class Dog extends Animal {
    String breed;
    
    public Dog(String name, String breed) {
        super(name);  // Call parent constructor
        this.breed = breed;
    }
}

// Use it
Dog dog = new Dog("Buddy", "Labrador");
System.out.println(dog.name + " is a " + dog.breed);
// Output: Buddy is a Labrador
```

## Method Overriding

A child class can change how a parent method works:

```java
public class Animal {
    public void makeSound() {
        System.out.println("Generic animal sound");
    }
}

public class Dog extends Animal {
    @Override  // Annotation (optional but recommended)
    public void makeSound() {
        System.out.println("Woof!");
    }
}

public class Cat extends Animal {
    @Override
    public void makeSound() {
        System.out.println("Meow!");
    }
}

// Use it
Dog dog = new Dog();
Cat cat = new Cat();
dog.makeSound();  // Woof!
cat.makeSound();  // Meow!
```

The `@Override` annotation tells Java you're intentionally overriding.

## Inheritance Hierarchy

Classes can form hierarchies:

```
              Animal
              /    \
           Dog      Cat
           /
      GoldenRetriever
```

```java
public class Animal { }
public class Dog extends Animal { }
public class GoldenRetriever extends Dog { }

// Create objects
GoldenRetriever gr = new GoldenRetriever();
gr.name = "Buddy";  // Inherited from Animal
gr.bark();          // Inherited from Dog
```

## Access Modifiers

### public
```java
public String name;  // Accessible from everywhere
```

### private
```java
private String ssn;  // Only accessible within class
```

### protected
```java
protected int age;   // Accessible in same class, subclasses, same package
```

For inheritance, often use `protected` for data child classes should access.

```java
public class Animal {
    protected String name;  // Child classes can access
}

public class Dog extends Animal {
    public void setName(String name) {
        this.name = name;  // Can access protected from parent
    }
}
```

## Real-World Example: Vehicle Hierarchy

```java
// Parent class
public class Vehicle {
    String brand;
    String color;
    
    public void drive() {
        System.out.println("Vehicle is driving");
    }
}

// Child classes
public class Car extends Vehicle {
    int numDoors;
    
    @Override
    public void drive() {
        System.out.println("Car with " + numDoors + " doors is driving");
    }
}

public class Motorcycle extends Vehicle {
    boolean hasSidecar;
    
    @Override
    public void drive() {
        System.out.println("Motorcycle is driving");
    }
}

// Use it
Car car = new Car();
car.brand = "Toyota";
car.numDoors = 4;
car.drive();  // Car with 4 doors is driving
```

## Important Rules

### 1. Can Only Extend One Class

```java
public class Dog extends Animal { }  // One parent

public class Dog extends Animal, Pet { }  // âŒ Can't extend multiple
```

### 2. Constructor Must Call super()

```java
public class Dog extends Animal {
    public Dog(String name) {
        super(name);  // Must call parent constructor first
    }
}
```

### 3. Overriding vs Overloading

- **Overriding**: Same method signature, different implementation (parent vs child)
- **Overloading**: Same method name, different parameters (same class)

```java
// Overloading (same class)
public void print(int num) { }
public void print(String text) { }

// Overriding (parent vs child)
class Parent {
    public void greet() { System.out.println("Parent"); }
}
class Child extends Parent {
    public void greet() { System.out.println("Child"); }  // Override
}
```

## Common Mistakes

### Mistake 1: Forgetting super() in Constructor

```java
public class Dog extends Animal {
    public Dog(String name) {
        // âŒ Must call super(name) first
        this.breed = breed;
    }
}
```

### Mistake 2: Trying to Extend Multiple Classes

```java
public class Dog extends Animal, Pet { }  // âŒ Error
public class Dog extends Animal { }       // Correct
```

### Mistake 3: Wrong Method Signature in Override

```java
class Parent {
    public void test(int x) { }
}
class Child extends Parent {
    public void test(String x) { }  // âš ï¸ This is overloading, not overriding!
}
```

## Key Takeaways

- Inheritance allows code reuse
- Child class inherits from parent using `extends`
- Use `super` to access parent class members
- Override methods to change behavior in child class
- Can only extend one class (single inheritance)
- Access modifiers: public, protected, private
- Use `@Override` annotation for clarity

## Next Steps

Learn about [Abstraction](./04-Abstraction.md) to define interfaces.

---


