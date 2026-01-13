# Abstraction: Hiding Complexity

## What is Abstraction?

**Abstraction** means hiding complex implementation details and showing only what's necessary. It's like driving a car - you don't need to know how the engine works, just how to use the steering wheel and pedals.

In Java, abstraction hides internal details and provides a clean interface.

## Abstract Classes

An **abstract class** can't be instantiated (no objects), but serves as a blueprint:

```java
abstract class Animal {
    abstract void makeSound();  // No implementation
    
    void sleep() {
        System.out.println("Sleeping");  // Has implementation
    }
}

// âŒ Can't create: Animal a = new Animal();
```

## Concrete Implementation

Child classes must implement abstract methods:

```java
class Dog extends Animal {
    @Override
    void makeSound() {  // Must implement
        System.out.println("Woof!");
    }
}

// âœ… Can create: Dog d = new Dog();
d.makeSound();  // Woof!
```

## Interfaces

An **interface** is pure abstraction - all methods must be implemented by classes:

```java
interface Animal {
    void makeSound();
    void eat();
}

class Dog implements Animal {
    public void makeSound() {
        System.out.println("Woof!");
    }
    
    public void eat() {
        System.out.println("Eating dog food");
    }
}
```

A class can implement multiple interfaces:

```java
class Dog implements Animal, Pet {
    // Must implement all methods from both interfaces
}
```

## Key Differences

| Abstract Class | Interface |
|---|---|
| Can have actual methods | All methods abstract |
| One parent (extends) | Multiple allowed (implements) |
| Has fields | Only constants |
| Good for "is-a" relationships | Good for "can-do" abilities |

## Benefits of Abstraction

1. **Hide Complexity**: Users don't see implementation details
2. **Change Without Breaking**: Update internal code safely
3. **Standardize Interface**: All subclasses follow same contract
4. **Security**: Hide sensitive information

## Practical Example

```java
abstract class PaymentProcessor {
    abstract void processPayment(double amount);
    
    void confirmTransaction() {
        System.out.println("Transaction confirmed");
    }
}

class CreditCardProcessor extends PaymentProcessor {
    public void processPayment(double amount) {
        System.out.println("Processing credit card: $" + amount);
    }
}

class PayPalProcessor extends PaymentProcessor {
    public void processPayment(double amount) {
        System.out.println("Processing PayPal: $" + amount);
    }
}

// Use it
PaymentProcessor processor = new CreditCardProcessor();
processor.processPayment(100);
processor.confirmTransaction();
```

## Key Takeaways

- âœ… Abstract classes define blueprints
- âœ… Interfaces define contracts
- âœ… Abstraction hides implementation details
- âœ… Use abstract when sharing code (extends)
- âœ… Use interface when defining behavior (implements)
- âœ… Concrete classes implement abstract methods

---

