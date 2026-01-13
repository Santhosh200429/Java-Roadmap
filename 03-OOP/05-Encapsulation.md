# Encapsulation: Controlling Access

## What is Encapsulation?

**Encapsulation** is bundling data (attributes) and methods together, then hiding internal details using access modifiers (public/private).

It's like a capsule - the outside sees the interface, the inside is hidden.

## Access Modifiers

### private
Only accessible within the class itself:

```java
public class Student {
    private String socialSecurityNumber;  // Hide sensitive data
}

// Outside class:
Student s = new Student();
s.socialSecurityNumber = "123-45-6789";  // ❌ Error - can't access private
```

### public
Accessible from anywhere:

```java
public class Student {
    public String name;  // Anyone can access
}

// Outside class:
Student s = new Student();
s.name = "Alice";  // ✅ OK
```

### protected
Accessible within class, subclasses, and same package:

```java
public class Animal {
    protected String name;  // Child classes can access
}

public class Dog extends Animal {
    public void setName(String name) {
        this.name = name;  // ✅ Can access protected from parent
    }
}
```

### default (no modifier)
Accessible only in same package:

```java
class Helper {  // Default - package private
    void help() { }
}
```

## Getters and Setters

Provide controlled access to private data:

```java
public class Student {
    private int age;
    
    // Getter - get the value
    public int getAge() {
        return age;
    }
    
    // Setter - set the value with validation
    public void setAge(int newAge) {
        if (newAge > 0 && newAge < 120) {
            age = newAge;
        } else {
            System.out.println("Invalid age");
        }
    }
}

// Use it
Student s = new Student();
s.setAge(20);          // ✅ Valid
s.setAge(150);         // ❌ Invalid - controlled access!
System.out.println(s.getAge());  // 20
```

## Benefits of Encapsulation

1. **Data Protection**: Prevent invalid data
2. **Flexibility**: Change internal implementation without affecting users
3. **Validation**: Control what values are set
4. **Hide Complexity**: Users don't need to know implementation

## Example: Bank Account

Without encapsulation (bad):
```java
public class BankAccount {
    public double balance = 1000;  // Anyone can change!
}

BankAccount account = new BankAccount();
account.balance = -500;  // ❌ Negative balance - disaster!
```

With encapsulation (good):
```java
public class BankAccount {
    private double balance = 1000;  // Protected
    
    public double getBalance() {
        return balance;
    }
    
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
        }
    }
    
    public void withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
        }
    }
}

BankAccount account = new BankAccount();
account.withdraw(500);           // ✅ Allowed
account.deposit(-100);           // ❌ Rejected - validation!
System.out.println(account.getBalance());  // 500
```

## Complete Example

```java
public class Person {
    // Private attributes
    private String name;
    private int age;
    private String email;
    
    // Getters
    public String getName() {
        return name;
    }
    
    public int getAge() {
        return age;
    }
    
    public String getEmail() {
        return email;
    }
    
    // Setters with validation
    public void setName(String name) {
        if (name != null && !name.isEmpty()) {
            this.name = name;
        }
    }
    
    public void setAge(int age) {
        if (age > 0 && age < 150) {
            this.age = age;
        }
    }
    
    public void setEmail(String email) {
        if (email.contains("@")) {
            this.email = email;
        }
    }
}

// Use it
Person p = new Person();
p.setName("Alice");
p.setAge(25);
p.setEmail("alice@example.com");

System.out.println(p.getName());    // Alice
System.out.println(p.getAge());     // 25
System.out.println(p.getEmail());   // alice@example.com
```

## Key Takeaways

- ✅ Use private for sensitive data
- ✅ Provide public getters and setters
- ✅ Validate in setters
- ✅ Hide implementation details
- ✅ Control what users can access
- ✅ Encapsulation = data safety

---

**Encapsulation protects your data and provides a clean interface.**
