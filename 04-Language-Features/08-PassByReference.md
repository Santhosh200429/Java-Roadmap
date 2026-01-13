# Pass By Reference in Java

## Overview
While Java is often said to be **"pass by value only"**, understanding how references work is crucial for writing correct Java code. This document clarifies the distinction between pass by value and pass by reference behavior in Java.

## Key Concept
Java passes **copies of references** (not the reference itself), which creates behavior that resembles pass-by-reference for objects.

## Pass By Value vs Pass By Reference

### Primitive Types - Clearly Pass By Value
```java
public class PrimitiveExample {
    public static void modifyPrimitive(int num) {
        num = 100;  // Only modifies the local copy
    }
    
    public static void main(String[] args) {
        int value = 5;
        modifyPrimitive(value);
        System.out.println(value);  // Output: 5 (unchanged)
    }
}
```

### Objects - Pass By Reference Behavior
```java
public class Person {
    public String name;
    
    public Person(String name) {
        this.name = name;
    }
}

public class ReferenceExample {
    public static void modifyObject(Person person) {
        person.name = "Modified";  // Modifies the actual object
    }
    
    public static void main(String[] args) {
        Person p = new Person("Original");
        modifyObject(p);
        System.out.println(p.name);  // Output: Modified
    }
}
```

## Important Distinction: Reference Reassignment

While you can modify an object's state, you **cannot reassign the reference itself**:

```java
public class ReferenceReassignment {
    public static void reassignReference(Person person) {
        person = new Person("New Person");  // Only modifies local reference copy
    }
    
    public static void main(String[] args) {
        Person p = new Person("Original");
        reassignReference(p);
        System.out.println(p.name);  // Output: Original (unchanged)
        // p still points to the original object
    }
}
```

## Memory Explanation

### When Object Reference is Passed:
```
main() stack:           modifyObject() stack:
┌─────────────┐        ┌──────────────────┐
│ p ──┐       │        │ person ──┐       │
│     │       │        │          │       │
└─────┼───────┘        └──────────┼───────┘
      │                            │
      └────────────→ Heap         │
               ┌──────────────┐   │
               │ Person obj   │←──┘
               │ name: "Orig" │
               └──────────────┘
```

Both `p` and `person` reference the same object in the heap.

## Common Misconceptions

### ❌ Myth: Java has pass-by-reference
**Reality:** Java only has pass-by-value, but values can be object references.

### ❌ Myth: You can use a method to change which object a variable points to
**Reality:** Only the local copy of the reference changes, not the original.

```java
public class Counter {
    private int count = 0;
    
    public Counter(int count) {
        this.count = count;
    }
}

public class Demo {
    public static void replaceObject(Counter counter) {
        counter = new Counter(10);  // Doesn't affect the caller's reference
    }
    
    public static void main(String[] args) {
        Counter c = new Counter(5);
        replaceObject(c);
        // c still points to the original Counter with count = 5
    }
}
```

## Practical Implications

### Modifying Object State Works ✓
```java
List<String> list = new ArrayList<>();
modifyList(list);  // list is modified

public static void modifyList(List<String> list) {
    list.add("item");  // Works - modifying the object
}
```

### Reassigning Reference Doesn't Work ✗
```java
String str = "Hello";
replaceString(str);  // str still = "Hello"

public static void replaceString(String str) {
    str = "World";  // Doesn't work - only local copy changes
}
```

## Summary Table

| Aspect | Behavior |
|--------|----------|
| Primitive values | Pass by value (copy of value) |
| Object references | Pass by value (copy of reference) |
| Modifying object state | Works (affects original object) |
| Reassigning reference | Doesn't work (only affects local copy) |
| Method return for reassignment | Use return value instead |

## Best Practices

1. **Don't rely on reassigning references** - Use return values instead
   ```java
   person = updatePerson(person);  // Better approach
   ```

2. **Be aware of null pointer exceptions** when passing mutable objects
   
3. **Use immutable objects** when you don't want state changes
   ```java
   String name = "Original";  // Strings are immutable
   changeName(name);          // Will not affect original
   ```

4. **Document whether methods modify their parameters** to avoid confusion

## See Also
- [Pass By Value](07-PassByValue.md)
- [Object Oriented Programming](../3-OOP/01-ClassesAndObjects.md)
- Java Memory Model and Object References
