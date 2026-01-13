# Variables and Data Types: Storing Information

## What is a Variable?

A **variable** is a named container that stores data (information) in your program. Think of it like a box with a label where you can store things.

```
Box labeled "age" contains: 25
Box labeled "name" contains: "John"
Box labeled "score" contains: 95.5
```

### Why Do We Need Variables?

Without variables, we'd have to rewrite data every time we need it:

```java
// âŒ Without variables - repetitive and hard to change
System.out.println("My name is John");
System.out.println("Hello John");
System.out.println(John + " is here");

// âœ… With variables - clean and easy to update
String name = "John";
System.out.println("My name is " + name);
System.out.println("Hello " + name);
System.out.println(name + " is here");
```

If you need to change the name from "John" to "Jane", just change it in one place!

## Declaring and Using Variables

### Basic Syntax

```java
// Step 1: Declare (create) variable
int age;

// Step 2: Initialize (assign value) variable
age = 25;

// Step 3: Use variable
System.out.println(age);  // Prints: 25
```

### Shortcut: Declare and Initialize Together

```java
int age = 25;  // Create variable AND assign value in one line
System.out.println(age); // Prints: 25
```

## Java Data Types

Java is **strongly typed** - every variable must have a data type. Data types tell Java what kind of data the variable will hold.

### Primitive Data Types (Basic Types)

Java has 8 primitive data types:

#### 1. Integer Types (Whole Numbers)

| Type | Range | Example | Size |
|------|-------|---------|------|
| `byte` | -128 to 127 | `byte age = 25;` | 1 byte |
| `short` | -32,768 to 32,767 | `short year = 2024;` | 2 bytes |
| `int` | -2.1B to 2.1B | `int count = 1000;` | 4 bytes â­ **Most Used** |
| `long` | Very large | `long population = 8000000000L;` | 8 bytes |

**When to use**:
- `int`: Most of the time (numbers up to ~2 billion)
- `long`: Very large numbers (add `L` at end)
- `byte`, `short`: Rarely used, only to save memory

```java
int students = 150;         // âœ… Use int for normal numbers
long worldPopulation = 8000000000L;  // âœ… Use L suffix for long
```

#### 2. Floating-Point Types (Decimal Numbers)

| Type | Precision | Example | Size |
|------|-----------|---------|------|
| `float` | ~6-7 decimal places | `float height = 5.9f;` | 4 bytes |
| `double` | ~15-17 decimal places | `double price = 19.99;` | 8 bytes â­ **Most Used** |

**When to use**:
- `double`: Default for decimals (more accurate)
- `float`: Rarely, only to save memory

```java
double price = 19.99;       // âœ… Use double for decimals
float temperature = 98.6f;  // Add 'f' suffix for float
```

#### 3. Character Type

| Type | Stores | Example | Size |
|------|--------|---------|------|
| `char` | Single character | `char grade = 'A';` | 2 bytes |

```java
char letter = 'A';      // âœ… Single character in single quotes
char symbol = '$';
System.out.println(letter);  // Prints: A
```

**Important**: Characters use single quotes `'A'`, not double quotes `"A"`.

#### 4. Boolean Type

| Type | Stores | Example | Size |
|------|--------|---------|------|
| `boolean` | true or false | `boolean isStudent = true;` | 1 byte |

```java
boolean isRaining = true;
boolean isVacation = false;

if (isRaining) {
    System.out.println("Bring an umbrella");
}
```

### Reference Data Types (Complex Types)

**Primitive types** store actual values. **Reference types** store references (memory addresses) to objects:

```java
String name = "John";  // String (reference type)
int[] numbers = {1, 2, 3};  // Arrays (reference type)
```

We'll learn about reference types later.

## Variable Naming Rules and Conventions

### Rules (Must Follow)

```java
int age = 25;              // âœ… Valid - letters, numbers, underscore
int age_of_student = 25;   // âœ… Valid - underscore allowed
int age1 = 25;             // âœ… Valid - number in name (not at start)
int 1age = 25;             // âŒ Can't start with number
int age-old = 25;          // âŒ Can't use hyphen
int age old = 25;          // âŒ Can't use space
```

### Conventions (Should Follow)

Following conventions makes code readable for others:

```java
// âŒ Bad naming
int a = 25;
int x = 3.14;
int ABC = 100;

// âœ… Good naming (camelCase - start lowercase, capitalize new words)
int studentAge = 25;
double pi = 3.14;
int totalScore = 100;
```

## Default Values

When you declare a variable without assigning a value, Java gives it a default:

```java
public class DefaultValues {
    int age;              // Default: 0
    double price;         // Default: 0.0
    boolean isActive;     // Default: false
    String name;          // Default: null
    
    public static void main(String[] args) {
        System.out.println(new DefaultValues().age);  // 0
    }
}
```

**Inside main()**: Variables have NO default - you must assign before using.

## Variable Scope

**Scope** is where a variable can be used:

```java
public class ScopeExample {
    int globalVar = 10;  // Can use anywhere in class
    
    public static void main(String[] args) {
        int localVar = 5;  // Can only use in main()
        System.out.println(localVar);  // âœ… Works
    }
    
    public void printVar() {
        System.out.println(globalVar);  // âœ… Works
        System.out.println(localVar);   // âŒ Error - doesn't exist here
    }
}
```

## Constants: Variables That Don't Change

Sometimes you want a variable you can't accidentally change:

```java
final double PI = 3.14159;  // final = can't change
PI = 3.14;  // âŒ Error - can't reassign

// Conventions: constants in ALL_CAPS
final int MAX_STUDENTS = 30;
final String COMPANY_NAME = "Acme Corp";
```

Use `final` for values that never change.

## Type Conversion (Casting)

Sometimes you need to convert one type to another:

### Automatic Conversion (Implicit)

Java automatically converts smaller types to larger types:

```java
int number = 10;
double decimal = number;  // âœ… Automatic - int fits in double
System.out.println(decimal);  // Prints: 10.0
```

### Manual Conversion (Explicit)

Casting forces a conversion:

```java
double decimal = 10.5;
int number = (int) decimal;  // âœ… Cast to int
System.out.println(number);  // Prints: 10 (loses decimal)

// Useful for narrowing down
double price = 19.99;
int dollars = (int) price;  // 19
```

## Practical Example: Calculator Program

```java
public class SimpleCalculator {
    public static void main(String[] args) {
        // Declare variables
        int num1 = 10;
        int num2 = 5;
        
        // Perform calculations
        int sum = num1 + num2;
        int difference = num1 - num2;
        int product = num1 * num2;
        int quotient = num1 / num2;
        
        // Display results
        System.out.println("First number: " + num1);
        System.out.println("Second number: " + num2);
        System.out.println("Sum: " + sum);
        System.out.println("Difference: " + difference);
        System.out.println("Product: " + product);
        System.out.println("Quotient: " + quotient);
    }
}

/* Output:
First number: 10
Second number: 5
Sum: 15
Difference: 5
Product: 50
Quotient: 2
*/
```

## Common Mistakes

### Mistake 1: Wrong Data Type

```java
int age = 25.5;  // âŒ Decimal doesn't fit in int
double age = 25.5;  // âœ… Double accepts decimals
```

### Mistake 2: Forgetting Type

```java
age = 25;  // âŒ Type must be declared first
int age = 25;  // âœ… Include type
```

### Mistake 3: Using Uninitialized Variable

```java
public static void main(String[] args) {
    int age;
    System.out.println(age);  // âŒ age not initialized
    
    int age = 25;
    System.out.println(age);  // âœ… Now it's initialized
}
```

### Mistake 4: Wrong Quote Type for Char

```java
char letter = "A";  // âŒ Double quotes for String
char letter = 'A';  // âœ… Single quotes for char
```

## Practice Problems

### Problem 1: Create Variables

Create variables for a person:
- Name (String)
- Age (int)
- Height (double)
- Is student (boolean)

**Solution**:
```java
String name = "Alice";
int age = 20;
double height = 5.6;
boolean isStudent = true;
```

### Problem 2: Calculate Area

Create a program that calculates a rectangle's area:

```java
public class RectangleArea {
    public static void main(String[] args) {
        int length = 10;
        int width = 5;
        int area = length * width;
        
        System.out.println("Length: " + length);
        System.out.println("Width: " + width);
        System.out.println("Area: " + area);
    }
}
```

## Key Takeaways

- âœ… Variables store data with a name and type
- âœ… 8 primitive types: byte, short, int, long, float, double, char, boolean
- âœ… Use `int` for whole numbers, `double` for decimals
- âœ… Follow camelCase naming convention
- âœ… Variables must be initialized before use
- âœ… Use `final` for constants
- âœ… Larger types can hold smaller types automatically
- âœ… Type casting converts between types (be careful!)

## Next Steps

You now understand variables! Next, learn about [operators](./02-Operators.md) to manipulate data.

---

