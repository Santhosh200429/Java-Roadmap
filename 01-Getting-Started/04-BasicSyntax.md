# Java Basic Syntax: The Fundamentals

## What is Syntax?

**Syntax** is the set of rules that define how to write Java code correctly. It's like grammar in English - if you don't follow the rules, the computer won't understand your instructions.

Just like English has rules (capital letters, punctuation, word order), Java has strict syntax rules that must be followed exactly.

## Basic Structure of a Java Program

Every Java program follows this basic structure:

```java
public class ClassName {
    public static void main(String[] args) {
        // Your code goes here
    }
}
```

### Breaking It Down

| Part | Meaning |
|------|---------|
| `public` | Anyone can access this class |
| `class` | This is a class (we'll learn about classes in OOP) |
| `ClassName` | The name of your class (must match filename) |
| `main` | The method where programs start |
| `String[] args` | Command-line arguments (ignore for now) |
| `{ }` | Braces mark the start and end of blocks |

## Key Syntax Rules

### 1. Every Statement Ends with a Semicolon (;)

```java
System.out.println("Hello");  // Correct
System.out.println("Hello")   // âŒ Wrong - missing semicolon
```

The semicolon tells Java "this instruction is complete."

### 2. Java is Case-Sensitive

```java
println("test");    // âŒ Wrong - must be println
PrintLn("test");    // âŒ Wrong - must be println
System.out.println("test");  // Correct
```

A tiny capitalization difference = big error!

### 3. Matching Braces { }

Every opening brace needs a closing brace:

```java
public class Test {        // { opens a block
    public static void main(String[] args) {  // { opens another block
        System.out.println("Hello");
    }                      // } closes main block
}                          // } closes class block
```

**Pro Tip**: Your IDE automatically adds closing braces.

### 4. Comments Are Ignored

Comments are notes to yourself and other programmers - Java ignores them:

```java
// Single line comment
System.out.println("This runs"); // Comment at end of line

/*
 * Multi-line comment
 * These lines are all ignored by Java
 * Useful for longer explanations
 */

/**
 * Javadoc comment
 * Special comment for documentation
 * Use above classes and methods
 */
```

### 5. Whitespace Doesn't Matter (Usually)

Java ignores extra spaces and blank lines:

```java
// All three are identical to Java:
System.out.println("Hello");
System.out.println(  "Hello"  );
System.out.println("Hello");
```

However, use whitespace to make code readable for humans!

## Basic Output: System.out.println()

The most common first command you'll use:

```java
System.out.println("Hello, World!");
```

This prints text and moves to the next line.

### Different Output Methods

```java
// println - prints and moves to next line
System.out.println("Hello");
System.out.println("World");
// Output:
// Hello
// World

// print - prints without moving to next line
System.out.print("Hello");
System.out.print("World");
// Output: HelloWorld

// printf - formatted printing (advanced, skip for now)
```

### Common Escape Sequences

Special characters for formatting:

| Sequence | Meaning | Example |
|----------|---------|---------|
| `\n` | New line | `"Hello\nWorld"` â†’ prints on 2 lines |
| `\t` | Tab (4 spaces) | `"Name\tJohn"` â†’ Name    John |
| `\\` | Backslash | `"C:\\Users\\"` â†’ C:\\Users\\ |
| `\"` | Double quote | `"Say \"Hi\""` â†’ Say "Hi" |
| `\'` | Single quote | `"It\'s"` â†’ It's |

Example:
```java
System.out.println("Line 1\nLine 2\nLine 3");
// Output:
// Line 1
// Line 2
// Line 3
```

## Naming Conventions

### Class Names (PascalCase)

- Start with capital letter
- Each word capitalized
- No spaces or underscores

```java
public class HelloWorld { }      // Correct
public class helloWorld { }      // âŒ Unconventional
public class hello_world { }     // âŒ Unconventional
public class HELLOWORLD { }      // âŒ Not used
```

### Variable Names (camelCase)

- Start with lowercase letter
- Each new word capitalized
- First letter of first word lowercase

```java
int studentAge = 20;         // Correct
int StudentAge = 20;         // âŒ Wrong convention
int student_age = 20;        // âŒ Wrong convention
int STUDENT_AGE = 20;        // âŒ Only for constants
```

### Method Names (camelCase)

Like variables - start lowercase, capitalize each new word:

```java
public void calculateTotal() { }   // Correct
public void CalculateTotal() { }   // âŒ Wrong
```

## Common Syntax Errors

Here are mistakes beginners make and how to fix them:

### Error 1: Missing Semicolon

```java
System.out.println("Hello")  // âŒ Missing semicolon
System.out.println("Hello"); // Fixed
```

**IDE Hint**: Red squiggly line appears

### Error 2: Wrong Class Name

```java
// File: HelloWorld.java
public class helloWorld { }  // âŒ Doesn't match filename
public class HelloWorld { }  // Matches filename
```

**Rule**: Class name MUST match filename exactly.

### Error 3: Mismatched Braces

```java
public class Test {
    public static void main(String[] args) {
        System.out.println("Hello");
    }  // âŒ Missing closing brace for class
```

**IDE Hint**: Your IDE usually auto-matches braces.

### Error 4: Typos in Built-in Words

```java
System.out.printl("Hello");      // âŒ printl (typo)
System.out.println("Hello");     // println
```

**Case Sensitive!** One letter wrong = error.

### Error 5: Forgetting main() Method

```java
public class Test {
    System.out.println("Hello"); // âŒ Can't run this
}
```

**Rule**: Always include the exact main method signature:
```java
public static void main(String[] args) { }
```

## String Fundamentals

Text in Java is called a **String**. Strings go inside double quotes:

```java
"Hello"              // Simple string
"Hello, World!"      // String with punctuation
"Java 2024"          // String with numbers
""                   // Empty string
```

### String Concatenation (Joining)

Combine strings with `+`:

```java
System.out.println("Hello" + " " + "World");
// Output: Hello World

String name = "John";
System.out.println("My name is " + name);
// Output: My name is John
```

### Common String Operations

```java
String text = "Hello";

// Print text
System.out.println(text);  // Output: Hello

// Combine with other text
System.out.println(text + " World");  // Output: Hello World

// Multiple lines
System.out.println("Line 1\nLine 2");
// Output:
// Line 1
// Line 2
```

## Best Practices for Writing Clean Code

### 1. Indentation (4 spaces per level)

```java
public class Test {           // Level 0
    public static void main(String[] args) {    // Level 1 (4 spaces)
        System.out.println("Hello");            // Level 2 (8 spaces)
    }
}
```

Your IDE usually does this automatically.

### 2. Meaningful Names

```java
// âŒ Bad names
int x = 25;
String n = "John";

// Good names
int studentAge = 25;
String name = "John";
```

### 3. One Statement Per Line

```java
// âŒ Hard to read
System.out.println("A"); System.out.println("B"); System.out.println("C");

// Easy to read
System.out.println("A");
System.out.println("B");
System.out.println("C");
```

### 4. Use Comments Wisely

```java
// âŒ Obvious comment (doesn't help)
int age = 25;  // Set age to 25

// Helpful comment
int age = 25;  // Student must be at least 25 to enroll
```

## Building Your First Program Step-by-Step

Let's create a more complete example:

```java
/**
 * MathQuiz.java
 * A simple program that demonstrates basic syntax
 */
public class MathQuiz {
    public static void main(String[] args) {
        // Display a question
        System.out.println("==== Math Quiz ====");
        System.out.println("What is 2 + 3?");
        System.out.println("The answer is: 5");
        
        // Blank line for readability
        System.out.println();
        
        // Another question
        System.out.println("What is 10 * 5?");
        System.out.println("The answer is: 50");
    }
}
```

**Output**:
```
==== Math Quiz ====
What is 2 + 3?
The answer is: 5

What is 10 * 5?
The answer is: 50
```

## Practice Exercises

### Exercise 1: Fix the Errors

Find what's wrong:
```java
public class Greeting {
    public static void main(String args) {      // Error?
        System.out.println("Hello World")       // Error?
    // Missing something?
}
```

**Answers**:
1. Should be `String[] args` (with brackets)
2. Missing semicolon after println
3. Missing closing brace

### Exercise 2: Write a Program

Create a program that prints:
```
Welcome to Java!
Your name is: Alice
Your age is: 20
```

**Solution**:
```java
public class Introduction {
    public static void main(String[] args) {
        System.out.println("Welcome to Java!");
        System.out.println("Your name is: Alice");
        System.out.println("Your age is: 20");
    }
}
```

## Key Takeaways

- Every Java program needs a class and main method
- Every statement ends with semicolon (;)
- Java is case-sensitive - spelling matters!
- Braces { } must match - opening and closing
- Comments don't execute - they're for humans
- Use meaningful names and proper indentation
- System.out.println() displays output
- Strings go in double quotes ("text")

## Next Steps

1. You understand basic syntax
2. â­ï¸ Next: [Variables and Data Types](../2-Core-Java/01-VariablesAndDataTypes.md)

---

**Master the basics, and everything else becomes easier!**

