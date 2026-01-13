# Operators: Performing Operations on Data

## What are Operators?

**Operators** are symbols that perform operations on variables and values. They're like the mathematical symbols you learned in school (+ - - ) but for programming.

Think of them as actions you perform on data:
- `+` adds numbers
- `-` subtracts numbers
- `*` multiplies numbers
- `/` divides numbers
- `==` compares if equal

## Types of Operators

### 1. Arithmetic Operators (Math Operations)

These are used for mathematical calculations:

| Operator | Name | Example | Result |
|----------|------|---------|--------|
| `+` | Addition | `5 + 3` | 8 |
| `-` | Subtraction | `5 - 3` | 2 |
| `*` | Multiplication | `5 * 3` | 15 |
| `/` | Division | `6 / 2` | 3 |
| `%` | Modulus (remainder) | `7 % 3` | 1 |

**Example**:
```java
int a = 10;
int b = 3;

System.out.println(a + b);  // 13
System.out.println(a - b);  // 7
System.out.println(a * b);  // 30
System.out.println(a / b);  // 3 (whole division)
System.out.println(a % b);  // 1 (remainder)
```

#### Important: Integer vs Decimal Division

```java
int result1 = 7 / 2;     // 3 (integer division - ignores decimals)
double result2 = 7 / 2.0;  // 3.5 (decimal division - keeps decimals)

System.out.println(result1);  // Prints: 3
System.out.println(result2);  // Prints: 3.5
```

**Key Point**: If all numbers are `int`, Java does integer division.

#### Modulus (%) - Finding Remainders

```java
// Check if number is even or odd
int number = 5;
if (number % 2 == 0) {
    System.out.println("Even");
} else {
    System.out.println("Odd");  // This prints (5 % 2 = 1)
}

// Get last digit of number
int lastDigit = 12345 % 10;  // Result: 5
```

### 2. Assignment Operators (Storing Values)

These assign (store) values in variables:

| Operator | Meaning | Example | Equivalent |
|----------|---------|---------|------------|
| `=` | Assign | `a = 5` | Store 5 in a |
| `+=` | Add and assign | `a += 3` | `a = a + 3` |
| `-=` | Subtract and assign | `a -= 2` | `a = a - 2` |
| `*=` | Multiply and assign | `a *= 4` | `a = a * 4` |
| `/=` | Divide and assign | `a /= 2` | `a = a / 2` |
| `%=` | Modulus and assign | `a %= 3` | `a = a % 3` |

**Example**:
```java
int score = 10;

score = score + 5;  // score is now 15
// Same as:
score += 5;  // Shorthand - also 15

score -= 3;  // score is now 12
score *= 2;  // score is now 24
```

### 3. Comparison Operators (Testing Conditions)

These compare two values and return `true` or `false`:

| Operator | Meaning | Example | Result |
|----------|---------|---------|--------|
| `==` | Equal to | `5 == 5` | true |
| `!=` | Not equal to | `5 != 3` | true |
| `>` | Greater than | `5 > 3` | true |
| `<` | Less than | `5 < 3` | false |
| `>=` | Greater or equal | `5 >= 5` | true |
| `<=` | Less or equal | `5 <= 3` | false |

**Example**:
```java
int age = 20;

System.out.println(age == 20);   // true
System.out.println(age != 20);   // false
System.out.println(age > 18);    // true
System.out.println(age < 18);    // false
System.out.println(age >= 20);   // true
```

**Important**: Use `==` to compare, not `=` (which assigns):

```java
if (age = 20) { }   // [WRONG] This ASSIGNS 20 to age (wrong!)
if (age == 20) { }  // This COMPARES age to 20 (correct!)
```

### 4. Logical Operators (Combining Conditions)

These combine multiple conditions:

| Operator | Meaning | Example | Explanation |
|----------|---------|---------|-------------|
| `&&` | AND | `a && b` | Both must be true |
| `\|\|` | OR | `a \|\| b` | At least one true |
| `!` | NOT | `!a` | Opposite (inverts true/false) |

**AND (&&)**: Both conditions must be true

```java
int age = 20;
double gpa = 3.5;

if (age >= 18 && gpa >= 3.0) {
    System.out.println("Eligible for scholarship");  // Prints
    // Both conditions true: age 20 >= 18 oe", gpa 3.5 >= 3.0 oe"
}

if (age >= 18 && gpa >= 4.0) {
    System.out.println("Honors scholarship");  // Doesn't print
    // Second condition false: gpa 3.5 NOT >= 4.0 oe-
}
```

**OR (||)**: At least one condition must be true

```java
int age = 20;
boolean hasLicense = false;

if (age >= 25 || hasLicense) {
    System.out.println("Can rent car");  // Prints
    // Second condition true: hasLicense is true oe"
}

if (age >= 25 || hasLicense) {
    System.out.println("Can drive");  // Might print
    // At least one condition true = result is true
}
```

**NOT (!)**: Inverts true/false

```java
boolean isRaining = true;

if (!isRaining) {
    System.out.println("Go outside");  // Doesn't print
}

if (isRaining) {
    System.out.println("Stay inside");  // Prints
}

// Equivalent to:
if (!(!isRaining)) {  // Double negative = positive
    System.out.println("Go outside");  // Doesn't print
}
```

### 5. Increment and Decrement Operators

Quickly add 1 or subtract 1:

| Operator | Meaning | Example | Equivalent |
|----------|---------|---------|------------|
| `++` | Increment by 1 | `a++` or `++a` | `a = a + 1` |
| `--` | Decrement by 1 | `a--` or `--a` | `a = a - 1` |

**Example**:
```java
int count = 5;

count++;        // count is now 6
count--;        // count is now 5
++count;        // count is now 6 (increment first)
--count;        // count is now 5 (decrement first)
```

**Pre vs Post** (advanced, usually doesn't matter):

```java
int a = 5;
int b = a++;  // Post: b = 5, then a = 6
System.out.println(a + " " + b);  // Prints: 6 5

int c = 5;
int d = ++c;  // Pre: c = 6, then d = 6
System.out.println(c + " " + d);  // Prints: 6 6
```

### 6. Ternary Operator (Shorthand If-Else)

Short way to make a decision:

```
condition ? value_if_true : value_if_false
```

**Example**:
```java
int age = 20;

// Regular if-else
String status;
if (age >= 18) {
    status = "Adult";
} else {
    status = "Minor";
}

// Ternary operator (same result)
String status = (age >= 18) ? "Adult" : "Minor";

System.out.println(status);  // Prints: Adult
```

## Operator Precedence (Order of Operations)

Just like in math (PEMDAS), operators are evaluated in order:

```
1. Parentheses: ( )
2. Multiplication/Division: *, /, %
3. Addition/Subtraction: +, -
4. Comparison: ==, !=, <, >, <=, >=
5. Logical AND: &&
6. Logical OR: ||
7. Assignment: =, +=, -=, etc.
```

**Example**:
```java
int result = 2 + 3 * 4;  // Multiply first, then add
System.out.println(result);  // Prints: 14 (not 20)
// Because: 3 * 4 = 12, then 2 + 12 = 14

// Use parentheses if unsure
int result2 = (2 + 3) * 4;  // Add first, then multiply
System.out.println(result2);  // Prints: 20
```

## Practical Example: Comparing Numbers

```java
public class NumberComparison {
    public static void main(String[] args) {
        int num1 = 15;
        int num2 = 10;
        
        // Arithmetic operations
        System.out.println("Sum: " + (num1 + num2));          // 25
        System.out.println("Difference: " + (num1 - num2));   // 5
        System.out.println("Product: " + (num1 * num2));      // 150
        System.out.println("Quotient: " + (num1 / num2));     // 1
        
        // Comparisons
        System.out.println("num1 > num2: " + (num1 > num2));  // true
        System.out.println("num1 == num2: " + (num1 == num2)); // false
        
        // Logical operations
        System.out.println("num1 > 12 && num2 < 15: " + 
                          (num1 > 12 && num2 < 15));  // true && true = true
    }
}
```

## Common Mistakes

### Mistake 1: Using = Instead of ==

```java
if (age = 20) { }   // [WRONG] Assigns 20 (wrong!)
if (age == 20) { }  // Compares (correct!)
```

### Mistake 2: Integer Division Loses Decimals

```java
double result = 7 / 2;      // 3.0 (not 3.5!)
double result = 7.0 / 2;    // 3.5 (correct!)
double result = 7 / 2.0;    // 3.5 (correct!)
```

### Mistake 3: Forgetting Parentheses in Complex Logic

```java
if (age > 18 && hasLicense || isRestricted) { }  // Confusing!
if ((age > 18 && hasLicense) || isRestricted) { } // Clear!
```

### Mistake 4: Wrong Operator for Strings

```java
String name1 = "John";
String name2 = "John";

if (name1 = name2) { }   // [WRONG] Assigns (wrong!)
if (name1 == name2) { }  // , Compares references (not values!)
if (name1.equals(name2)) { } // Compares actual text (correct!)
```

For Strings, use `.equals()` method, not `==`.

## Practice Exercises

### Exercise 1: Basic Operations

Write a program that stores two numbers and prints:
- Their sum
- Their difference
- Their product
- Whether first > second

### Exercise 2: Conditional Logic

Write a program that:
- Asks age (store as variable)
- Prints "Adult" if >= 18
- Prints "Minor" if < 18
- Prints "Senior" if >= 65

## Key Takeaways

- Arithmetic operators: + - * / %
- Assignment operators: = += -= *= /=
- Comparison operators: == != > < >= <=
- Logical operators: && || !
- Use == to compare (not = which assigns)
- Operator precedence matters (use parentheses when unsure)
- Increment/decrement: ++ and --
- Ternary operator: condition ? true : false

## Next Steps

Now that you understand operators, learn about [Conditionals](./03-Conditionals.md) to control program flow based on conditions.

---


