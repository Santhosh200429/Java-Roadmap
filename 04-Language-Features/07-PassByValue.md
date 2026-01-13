# Pass by Value in Java

## What is Pass by Value?

**Java passes all parameters by value** - this means a copy of the value is passed to methods, not the original reference.

**Important distinction:**
- For primitives: copy of the value
- For objects: copy of the reference (not copy of object itself)

## Primitives: Pass by Value

```java
public class PrimitivePassByValue {
    
    public static void main(String[] args) {
        int x = 5;
        
        changeValue(x);
        
        System.out.println(x);  // Output: 5 (unchanged!)
    }
    
    static void changeValue(int value) {
        value = 10;  // Changes only the copy
    }
}

// The parameter 'value' gets a COPY of x
// Modifying value doesn't affect x
```

### Memory Diagram

```
Before call:
Stack: x = 5

Inside changeValue():
Stack: 
  x = 5          (original, in main)
  value = 5      (copy, in method)

value = 10:
Stack:
  x = 5          (unchanged!)
  value = 10     (copy changed)

Return:
Stack: x = 5     (original restored)
```

## Objects: Pass by Value (of Reference)

```java
public class ObjectPassByValue {
    
    static class Person {
        String name;
        int age;
        
        Person(String name, int age) {
            this.name = name;
            this.age = age;
        }
    }
    
    public static void main(String[] args) {
        Person person = new Person("Alice", 25);
        
        modifyPerson(person);
        
        System.out.println(person.name);  // Alice (reference unchanged)
        System.out.println(person.age);   // 26 (object modified!)
    }
    
    static void modifyPerson(Person p) {
        p.age = 26;          // Modifies the object (visible outside!)
        p = new Person("Bob", 30);  // Changes reference (not visible outside)
    }
}

// Output:
// Alice
// 26
```

### Memory Diagram

```
Before call:
Heap:
  Person object: name="Alice", age=25
Stack:
  person → [reference to object]

Inside modifyPerson(Person p):
Stack:
  person → [reference to object]      (main method)
  p → [copy of reference]             (modifyPerson)

p.age = 26:
Heap:
  Person object: name="Alice", age=26  (MODIFIED!)
Stack:
  person → [reference]
  p → [same reference]

p = new Person("Bob", 30):
Heap:
  Person object: name="Alice", age=26
  NEW Person object: name="Bob", age=30
Stack:
  person → [reference to Alice]        (unchanged!)
  p → [reference to Bob]               (local change only)

Return:
Stack:
  person → [reference to Alice]        (unchanged!)
```

## Complete Examples

### 1. Primitives Cannot Change

```java
public class PrimitiveExample {
    
    public static void main(String[] args) {
        int a = 10;
        int b = 20;
        
        swap(a, b);
        
        System.out.println("a: " + a);  // 10 (not swapped!)
        System.out.println("b: " + b);  // 20
    }
    
    static void swap(int x, int y) {
        int temp = x;
        x = y;
        y = temp;
        // x and y swapped, but a and b unchanged
    }
}

// Why doesn't swap work?
// swap() receives COPIES of a and b
// Swapping copies doesn't affect originals
```

### 2. Objects Can Be Modified

```java
public class ObjectModification {
    
    static class BankAccount {
        double balance;
        
        BankAccount(double balance) {
            this.balance = balance;
        }
    }
    
    public static void main(String[] args) {
        BankAccount account = new BankAccount(1000);
        
        deposit(account, 500);
        
        System.out.println(account.balance);  // 1500 (modified!)
    }
    
    static void deposit(BankAccount acc, double amount) {
        acc.balance += amount;  // Modifies the object
    }
}

// Output: 1500
// The object itself is modified (visible outside method)
```

### 3. Reassigning Reference (Not Visible)

```java
public class ReferenceReassignment {
    
    static class Counter {
        int value;
        
        Counter(int value) {
            this.value = value;
        }
    }
    
    public static void main(String[] args) {
        Counter counter = new Counter(0);
        
        resetCounter(counter);
        
        System.out.println(counter.value);  // 0 (original)
    }
    
    static void resetCounter(Counter c) {
        c = new Counter(0);  // Creates NEW object locally
        // Doesn't change the reference in main()
    }
}

// Output: 0
// resetCounter() creates new Counter locally
// The counter in main() still points to original
```

### 4. Array Pass by Reference

```java
public class ArrayPassByValue {
    
    public static void main(String[] args) {
        int[] arr = {1, 2, 3};
        
        modifyArray(arr);
        
        System.out.println(Arrays.toString(arr));
        // [10, 2, 3] - MODIFIED!
    }
    
    static void modifyArray(int[] array) {
        array[0] = 10;  // Modifies the actual array
    }
}

// Why does it work?
// arr contains a REFERENCE to array object
// modifyArray() gets a COPY of that reference
// Both copies point to SAME array object
// So modifications are visible!
```

## Common Confusion Points

### Confusion 1: String Modifications

```java
public class StringConfusion {
    
    public static void main(String[] args) {
        String name = "Alice";
        
        changeName(name);
        
        System.out.println(name);  // Alice (unchanged!)
    }
    
    static void changeName(String str) {
        str = "Bob";  // str now points to different String
        // Doesn't affect original reference
    }
}

// Strings are immutable!
// str = "Bob" creates NEW String object
// Original reference unchanged
// Output: Alice
```

### Confusion 2: List Modifications

```java
public class ListConfusion {
    
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("A");
        
        modifyList(list);
        
        System.out.println(list);  // [A, B] - MODIFIED!
    }
    
    static void modifyList(List<String> l) {
        l.add("B");  // Modifies the actual list
    }
}

// Why does it work?
// list contains reference to ArrayList
// modifyList() gets copy of that reference
// Both point to same ArrayList
// Adding to list modifies original
// Output: [A, B]
```

### Confusion 3: Reassigning List (Not Visible)

```java
public class ListReassignment {
    
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("A");
        
        replaceList(list);
        
        System.out.println(list);  // [A] - unchanged!
    }
    
    static void replaceList(List<String> l) {
        l = new ArrayList<>();      // NEW list created locally
        l.add("B");                 // B added to LOCAL list
    }
}

// Output: [A]
// replaceList() creates NEW ArrayList locally
// Original list reference unchanged
```

## Visual Comparison

```java
// SCENARIO 1: Primitive
int x = 5;
modifyInt(x);
// Parameter gets COPY of 5
// Original x unchanged

// SCENARIO 2: Object - Modify Content
Person p = new Person();
modifyPerson(p);
// Parameter gets COPY of reference
// Both point to SAME object
// Object modifications visible

// SCENARIO 3: Object - Reassign Reference
Person p = new Person();
replacePerson(p);
// Parameter gets COPY of reference
// Reassigning parameter doesn't affect original
// Original p still points to original object
```

## Key Rules

```java
// Rule 1: Primitives never change
int a = 5;
method(a);
// a is always 5

// Rule 2: Objects can be modified
List<String> list = new ArrayList<>();
method(list);
// list can be modified by method

// Rule 3: References cannot be changed
Person person = new Person();
method(person);
// person still points to original Person

// Rule 4: This applies to all parameters
method(5, "hello", new ArrayList<>(), someObject);
// ALL parameters passed by value
// Copies of primitives AND references
```

## Complete Real-World Example

```java
public class BankTransfer {
    
    static class Account {
        String owner;
        double balance;
        
        Account(String owner, double balance) {
            this.owner = owner;
            this.balance = balance;
        }
    }
    
    // This works - modifying objects
    static void transfer(Account from, Account to, double amount) {
        from.balance -= amount;     // Modifies 'from' object ✓
        to.balance += amount;       // Modifies 'to' object ✓
    }
    
    // This doesn't work - reassigning references
    static void swapAccounts(Account a, Account b) {
        Account temp = a;
        a = b;           // Changes LOCAL reference only
        b = temp;        // Changes LOCAL reference only
        // Original references in main() unchanged!
    }
    
    public static void main(String[] args) {
        Account alice = new Account("Alice", 1000);
        Account bob = new Account("Bob", 500);
        
        // Transfer works
        transfer(alice, bob, 200);
        System.out.println("Alice: " + alice.balance);   // 800
        System.out.println("Bob: " + bob.balance);       // 700
        
        // Swap doesn't work
        swapAccounts(alice, bob);
        System.out.println("Alice still: " + alice.balance);  // 800
        System.out.println("Bob still: " + bob.balance);      // 700
    }
}
```

## Key Takeaways

- ✅ Java always passes by value
- ✅ For primitives: copy of value
- ✅ For objects: copy of reference
- ✅ Object contents can be modified
- ✅ Reassigning parameter doesn't affect original reference
- ✅ Strings are immutable (reassignment creates new object)
- ✅ Arrays/Collections can be modified
- ✅ This is why null checks sometimes fail
- ✅ Understanding this prevents common bugs

---

**Next →** Optionals: [Null Safety](/4-Language-Features/08-Optionals.md)
