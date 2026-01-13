# Classes and Objects: The Foundation of OOP

## What is OOP (Object-Oriented Programming)?

**Object-Oriented Programming** is a way of thinking about code. Instead of writing a sequence of instructions, you organize code into **objects** that represent real-world things.

**Real-world thinking**:
```
Real world: Car, Dog, Person, Bank Account
Programming: Car class, Dog class, Person class, BankAccount class
```

Each class describes what properties and actions that thing has.

## What is a Class?

A **class** is a **blueprint** for creating objects. It defines what properties (data) and methods (actions) objects of that class will have.

Think of it like a cookie cutter:
```
Cookie Cutter (Class) â†’ Many Cookies (Objects)
```

### Creating a Simple Class

```java
public class Car {
    // Properties (what a car has)
    String color;
    String brand;
    int year;
    
    // Method (what a car can do)
    void drive() {
        System.out.println("The car is driving");
    }
}
```

## What is an Object?

An **object** is an **instance** of a class - a specific thing created from the blueprint.

```java
Car myCar = new Car();  // Create an object from Car class
```

### Breaking It Down

```java
Car         myCar       =    new Car();
â”‚           â”‚                â”‚     â”‚
â”‚           â”‚                â”‚     â””â”€ Call Car's constructor
â”‚           â”‚                â””â”€ Keyword to create new object
â”‚           â””â”€ Name of this object (variable)
â””â”€ Type (class name)
```

## Creating and Using Objects

### Step 1: Create an Object

```java
public class Main {
    public static void main(String[] args) {
        // Create object
        Car myCar = new Car();
        
        // Access properties
        myCar.color = "Red";
        myCar.brand = "Toyota";
        myCar.year = 2023;
        
        // Use methods
        myCar.drive();  // Prints: The car is driving
    }
}
```

### Step 2: Multiple Objects from Same Class

```java
Car car1 = new Car();
car1.color = "Red";
car1.brand = "Toyota";

Car car2 = new Car();
car2.color = "Blue";
car2.brand = "Honda";

// Each object is separate
System.out.println(car1.color);  // Red
System.out.println(car2.color);  // Blue
```

## Class Structure

```java
public class Dog {
    // ===== PROPERTIES (State) =====
    String name;
    int age;
    String breed;
    
    // ===== METHODS (Behavior) =====
    void bark() {
        System.out.println(name + " says: Woof!");
    }
    
    void sleep() {
        System.out.println(name + " is sleeping");
    }
    
    void getInfo() {
        System.out.println("Name: " + name);
        System.out.println("Age: " + age);
        System.out.println("Breed: " + breed);
    }
}
```

### Using the Dog Class

```java
public class Main {
    public static void main(String[] args) {
        // Create object
        Dog myDog = new Dog();
        
        // Set properties
        myDog.name = "Buddy";
        myDog.age = 3;
        myDog.breed = "Golden Retriever";
        
        // Call methods
        myDog.bark();      // Prints: Buddy says: Woof!
        myDog.getInfo();   // Prints dog information
        myDog.sleep();     // Prints: Buddy is sleeping
    }
}
```

## Constructors: Initialize Objects

A **constructor** is a special method that runs when you create an object. It initializes properties automatically.

### Constructor Without Parameters

```java
public class Dog {
    String name;
    int age;
    
    // Constructor
    public Dog() {
        name = "Unknown";
        age = 0;
    }
}

// Use it
Dog dog1 = new Dog();  // Constructor runs, sets default values
System.out.println(dog1.name);  // Prints: Unknown
```

### Constructor With Parameters

Much more useful - pass values when creating object:

```java
public class Dog {
    String name;
    int age;
    
    // Constructor with parameters
    public Dog(String dogName, int dogAge) {
        name = dogName;
        age = dogAge;
    }
}

// Use it - much cleaner!
Dog dog1 = new Dog("Buddy", 3);
System.out.println(dog1.name);  // Buddy
System.out.println(dog1.age);   // 3
```

## The 'this' Keyword

Refers to the current object. Useful in constructors:

```java
public class Person {
    String name;
    int age;
    
    public Person(String name, int age) {
        this.name = name;  // this.name = the object's name
        this.age = age;    // age = the parameter
    }
}
```

Without `this`, it's ambiguous which variable you mean.

## Complete Example: Bank Account

```java
public class BankAccount {
    // Properties
    String accountNumber;
    String ownerName;
    double balance;
    
    // Constructor
    public BankAccount(String accountNumber, String ownerName, double initialBalance) {
        this.accountNumber = accountNumber;
        this.ownerName = ownerName;
        this.balance = initialBalance;
    }
    
    // Methods
    void deposit(double amount) {
        balance += amount;
        System.out.println("Deposited: $" + amount);
        System.out.println("New balance: $" + balance);
    }
    
    void withdraw(double amount) {
        if (amount <= balance) {
            balance -= amount;
            System.out.println("Withdrawn: $" + amount);
            System.out.println("New balance: $" + balance);
        } else {
            System.out.println("Insufficient funds");
        }
    }
    
    void getBalance() {
        System.out.println("Account: " + accountNumber);
        System.out.println("Owner: " + ownerName);
        System.out.println("Balance: $" + balance);
    }
}
```

### Using the Bank Account

```java
public class Main {
    public static void main(String[] args) {
        // Create account
        BankAccount account = new BankAccount("12345", "John Doe", 1000);
        
        // Use methods
        account.getBalance();
        account.deposit(500);
        account.withdraw(200);
        account.getBalance();
    }
}

/* Output:
Account: 12345
Owner: John Doe
Balance: $1000.0
Deposited: $500.0
New balance: $1500.0
Withdrawn: $200.0
New balance: $1300.0
Account: 12345
Owner: John Doe
Balance: $1300.0
*/
```

## Common Mistakes

### Mistake 1: Forgetting 'new' Keyword

```java
Dog dog = Dog();      // âŒ Error - missing 'new'
Dog dog = new Dog();  // âœ… Correct
```

### Mistake 2: Objects vs Classes

```java
String name;  // This is a variable (holds object reference)
String = "John";  // âŒ Can't assign to class, only to objects
name = "John";  // âœ… Assign to variable
```

### Mistake 3: Not Initializing Object

```java
Dog dog;  // Declared but not created
dog.name = "Buddy";  // âŒ Error - dog is null
dog = new Dog();  // Create object
dog.name = "Buddy";  // âœ… Now works
```

## Class Visibility and Modifiers

### public vs default

```java
public class Dog { }        // âœ… Can use from anywhere
class Dog { }              // Can use only in same package
```

### public vs private (We'll cover in Encapsulation)

For now, use `public` for everything.

## Key Takeaways

- âœ… Class = blueprint, Object = instance of class
- âœ… Properties store data (state)
- âœ… Methods define actions (behavior)
- âœ… Constructor initializes objects
- âœ… Use `new` keyword to create objects
- âœ… Properties accessed with `.` notation
- âœ… Methods called with `.` notation
- âœ… Each object has its own copy of properties

## Next Steps

Learn about [Attributes and Methods](./02-AttributesAndMethods.md) to deepen your understanding.

---

