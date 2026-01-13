# Polymorphism: Many Forms

## What is Polymorphism?

**Polymorphism** means "many forms" - the ability of objects to take multiple forms. Same method call, different behavior based on object type.

## Method Overriding Polymorphism

Different classes can have the same method that behaves differently:

```java
abstract class Animal {
    abstract void makeSound();
}

class Dog extends Animal {
    public void makeSound() {
        System.out.println("Woof!");
    }
}

class Cat extends Animal {
    public void makeSound() {
        System.out.println("Meow!");
    }
}

class Cow extends Animal {
    public void makeSound() {
        System.out.println("Moo!");
    }
}

// Same method, different behavior!
Dog dog = new Dog();
dog.makeSound();  // Woof!

Cat cat = new Cat();
cat.makeSound();  // Meow!

Cow cow = new Cow();
cow.makeSound();  // Moo!
```

## Polymorphic References

Use parent type to reference child objects:

```java
Animal animal1 = new Dog();   // Dog is-an Animal
Animal animal2 = new Cat();   // Cat is-an Animal
Animal animal3 = new Cow();   // Cow is-an Animal

// Call same method - different behavior!
animal1.makeSound();  // Woof!
animal2.makeSound();  // Meow!
animal3.makeSound();  // Moo!
```

## Looping with Polymorphism

```java
Animal[] animals = {
    new Dog(),
    new Cat(),
    new Cow(),
    new Dog()
};

// Each makes its own sound!
for (Animal animal : animals) {
    animal.makeSound();
}

/* Output:
Woof!
Meow!
Moo!
Woof!
*/
```

## Type Casting with Polymorphism

Sometimes you need to access child-specific methods:

```java
Animal animal = new Dog();
animal.makeSound();  // Works (in Animal)

Dog dog = (Dog) animal;  // Cast to Dog
dog.bark();  // Dog-specific method

// But be careful!
Cat cat = (Cat) animal;  // [WRONG] Runtime error - animal is actually Dog!
```

Check type before casting:

```java
Animal animal = new Dog();

if (animal instanceof Dog) {
    Dog dog = (Dog) animal;
    dog.bark();
}

if (animal instanceof Cat) {
    Cat cat = (Cat) animal;
    cat.scratch();
}
```

## Method Overloading Polymorphism

Same method name, different parameters:

```java
public class Calculator {
    public void print(int num) {
        System.out.println("Int: " + num);
    }
    
    public void print(String text) {
        System.out.println("String: " + text);
    }
    
    public void print(double num) {
        System.out.println("Double: " + num);
    }
}

Calculator calc = new Calculator();
calc.print(10);           // Int: 10
calc.print("Hello");      // String: Hello
calc.print(3.14);         // Double: 3.14
```

## Real-World Example: Payment Systems

```java
interface PaymentMethod {
    void pay(double amount);
}

class CreditCard implements PaymentMethod {
    public void pay(double amount) {
        System.out.println("Paying $" + amount + " with Credit Card");
    }
}

class PayPal implements PaymentMethod {
    public void pay(double amount) {
        System.out.println("Paying $" + amount + " with PayPal");
    }
}

class Bitcoin implements PaymentMethod {
    public void pay(double amount) {
        System.out.println("Paying $" + amount + " with Bitcoin");
    }
}

// Payment processor works with ANY payment method
public class Store {
    public void processPayment(PaymentMethod method, double amount) {
        method.pay(amount);  // Works with all payment types!
    }
}

// Use it
Store store = new Store();
store.processPayment(new CreditCard(), 100);  // Credit Card payment
store.processPayment(new PayPal(), 50);       // PayPal payment
store.processPayment(new Bitcoin(), 25);      // Bitcoin payment
```

## Benefits of Polymorphism

1. **Flexibility**: Write code that works with multiple types
2. **Extensibility**: Add new types without changing existing code
3. **Maintainability**: Single code path for multiple behaviors
4. **Loose Coupling**: Code depends on abstractions, not concrete classes

## Key Takeaways

- Polymorphism = many forms, one interface
- Overriding: Same method, different implementation
- Overloading: Same method name, different parameters
- Use parent type to reference child objects
- Check type with instanceof before casting
- Enables flexible, extensible code

---


