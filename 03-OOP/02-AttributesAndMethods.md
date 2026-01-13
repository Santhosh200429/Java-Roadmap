# Attributes and Methods: Properties and Behavior

## Attributes (Properties)

**Attributes** (also called fields or properties) are variables that store data about an object.

```java
public class Student {
    // Attributes
    String name;
    int age;
    double gpa;
    String studentId;
}
```

### Declaring Attributes

```java
public class Car {
    // Data types for attributes
    String color;           // Text
    int year;              // Number
    double fuelCapacity;   // Decimal
    boolean isRunning;     // True/False
}
```

### Types of Attributes

#### Instance Attributes (For Each Object)

```java
public class Student {
    String name;   // Each student has their own name
    int age;       // Each student has their own age
}

Student s1 = new Student();
Student s2 = new Student();

s1.name = "Alice";
s2.name = "Bob";
// Each student has separate name
```

#### Class Attributes (static - Shared by All)

```java
public class Student {
    static int totalStudents = 0;  // Shared by all students
    String name;                   // Each student's own
}
```

We'll learn more about `static` later.

## Methods

**Methods** are functions that belong to a class. They define what actions an object can perform.

### Method Syntax

```java
public returnType methodName(parameters) {
    // Code to execute
    // Optionally return a value
}
```

### Method Examples

```java
public class Calculator {
    // Method that returns a value
    public int add(int a, int b) {
        return a + b;
    }
    
    // Method that doesn't return anything
    public void printMessage(String message) {
        System.out.println(message);
    }
    
    // Method with no parameters
    public String getVersion() {
        return "1.0";
    }
}
```

## Return Types

### Returning a Value

```java
public class Temperature {
    // Returns double
    public double fahrenheitToCelsius(double fahrenheit) {
        return (fahrenheit - 32) * 5 / 9;
    }
}

// Use it
Temperature temp = new Temperature();
double celsius = temp.fahrenheitToCelsius(86);  // 30.0
```

### Void (No Return)

```java
public class Printer {
    // Returns nothing (void)
    public void printName(String name) {
        System.out.println("Name: " + name);
    }
}

// Use it
Printer p = new Printer();
p.printName("Alice");  // Prints: Name: Alice
```

## Parameters and Arguments

**Parameters**: Variables in method definition  
**Arguments**: Actual values passed when calling method

```java
public class Math {
    // 'a' and 'b' are PARAMETERS
    public int add(int a, int b) {
        return a + b;
    }
}

// 5 and 3 are ARGUMENTS
int result = add(5, 3);  // Returns 8
```

### Multiple Parameters

```java
public class Person {
    public void greet(String name, int age) {
        System.out.println("Hello " + name + ", age " + age);
    }
}

Person p = new Person();
p.greet("Alice", 25);  // Prints: Hello Alice, age 25
```

## Getter and Setter Methods

Used to access private attributes (we'll learn about private soon).

```java
public class Student {
    private String name;  // Private - can't access directly
    
    // Getter - get the value
    public String getName() {
        return name;
    }
    
    // Setter - set the value
    public void setName(String newName) {
        name = newName;
    }
}

// Use it
Student s = new Student();
s.setName("Alice");
System.out.println(s.getName());  // Prints: Alice
```

## Method Examples

### Example 1: Bank Account

```java
public class BankAccount {
    double balance;
    
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposited: $" + amount);
        }
    }
    
    public void withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            System.out.println("Withdrew: $" + amount);
        } else {
            System.out.println("Cannot withdraw");
        }
    }
    
    public double getBalance() {
        return balance;
    }
}
```

### Example 2: Rectangle

```java
public class Rectangle {
    double width;
    double height;
    
    public double getArea() {
        return width * height;
    }
    
    public double getPerimeter() {
        return 2 * (width + height);
    }
    
    public void printInfo() {
        System.out.println("Width: " + width);
        System.out.println("Height: " + height);
        System.out.println("Area: " + getArea());
        System.out.println("Perimeter: " + getPerimeter());
    }
}

// Use it
Rectangle rect = new Rectangle();
rect.width = 5;
rect.height = 3;
rect.printInfo();
```

## Method Overloading

**Overloading** allows multiple methods with the same name but different parameters.

```java
public class Printer {
    // Method 1: Prints int
    public void print(int num) {
        System.out.println("Int: " + num);
    }
    
    // Method 2: Prints String
    public void print(String text) {
        System.out.println("String: " + text);
    }
    
    // Method 3: Prints double
    public void print(double num) {
        System.out.println("Double: " + num);
    }
}

// Use it
Printer p = new Printer();
p.print(10);         // Int: 10
p.print("Hello");    // String: Hello
p.print(3.14);       // Double: 3.14
```

Java figures out which method to call based on argument type.

## Common Mistakes

### Mistake 1: Forgetting 'public'

```java
void printMessage() { }     // âŒ Can't call from outside class
public void printMessage() { } // âœ… Can call from anywhere
```

### Mistake 2: Wrong Return Type

```java
public int getValue() {
    return "Hello";  // âŒ Can't return String when int expected
}

public String getValue() {
    return "Hello";  // âœ… Correct
}
```

### Mistake 3: Forgetting Return Statement

```java
public int add(int a, int b) {
    int sum = a + b;
    // âŒ Missing return statement
}

public int add(int a, int b) {
    int sum = a + b;
    return sum;  // âœ… Correct
}
```

### Mistake 4: Returning from void Method

```java
public void printName(String name) {
    System.out.println(name);
    return name;  // âŒ Can't return from void
}

public void printName(String name) {
    System.out.println(name);
    return;  // âœ… Just 'return' (no value) or omit it
}
```

## Key Takeaways

- âœ… Attributes store object data
- âœ… Methods define object behavior
- âœ… Return type can be any type or void
- âœ… Parameters allow methods to accept data
- âœ… Getters and Setters provide controlled access
- âœ… Overloading allows same method name with different parameters
- âœ… Always specify visibility (public/private)

## Next Steps

Learn about [Inheritance](./03-Inheritance.md) to reuse code.

---

