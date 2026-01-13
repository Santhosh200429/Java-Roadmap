# Type Casting: Converting Between Data Types

## What is Type Casting?

**Type casting** is converting a value from one data type to another. Sometimes you have data in one type but need it in another.

**Real-world analogy**: Converting currency - $5 USD to EUR (different form, same value).

## Two Types of Casting

### 1. Widening (Automatic) - Safe Conversion

Converting a smaller type to a larger type. Java does this automatically because no information is lost.

```
byte â†’ short â†’ int â†’ long â†’ float â†’ double
   (smaller)              (larger)
```

**Examples**:
```java
int number = 100;
long bigNumber = number;        // âœ… Automatic - int to long
double decimal = 50;            // âœ… Automatic - int to double
float price = 19.99f;           // Explicit float needed for decimals

System.out.println(bigNumber);  // 100
System.out.println(decimal);    // 50.0
```

### 2. Narrowing (Manual) - Risky Conversion

Converting a larger type to smaller type. You must explicitly cast because information might be lost.

```
double â†’ float â†’ long â†’ int â†’ short â†’ byte
   (larger)              (smaller)
```

**Syntax**:
```java
double decimal = 10.5;
int number = (int) decimal;  // Must use (int) to cast
System.out.println(number);  // Prints: 10 (loses .5)
```

## When Data Loss Occurs

### Decimal Loss

```java
double pi = 3.14159;
int roundedPi = (int) pi;  // Loses .14159
System.out.println(roundedPi);  // Prints: 3
```

### Overflow (Value Too Large)

```java
long bigNumber = 300;
byte smallByte = (byte) bigNumber;  // Loses information
System.out.println(smallByte);  // Prints: 44 (not 300!)
```

When a value doesn't fit, unexpected results occur. Byte holds -128 to 127.

## Casting to Different Types

### int to double

```java
int count = 5;
double decimal = (double) count;  // Or automatic: double decimal = count;
System.out.println(decimal);  // Prints: 5.0
```

### double to int

```java
double price = 19.99;
int dollars = (int) price;  // Explicit cast required
System.out.println(dollars);  // Prints: 19
```

### String to int

```java
String text = "25";
int number = Integer.parseInt(text);  // Convert string to int
System.out.println(number + 5);  // Prints: 30 (not "255")
```

### int to String

```java
int number = 42;
String text = String.valueOf(number);  // Convert int to string
System.out.println("Answer: " + text);  // Prints: Answer: 42
```

## Real-World Example: Temperature Converter

```java
public class TemperatureConverter {
    public static void main(String[] args) {
        // Celsius to Fahrenheit
        double celsius = 25.5;
        double fahrenheit = (celsius * 9/5) + 32;
        
        System.out.println("Celsius: " + celsius);
        System.out.println("Fahrenheit: " + fahrenheit);
        
        // Casting decimal to int for display
        int fahrenheitInt = (int) fahrenheit;
        System.out.println("Fahrenheit (rounded): " + fahrenheitInt);
    }
}

/* Output:
Celsius: 25.5
Fahrenheit: 77.9
Fahrenheit (rounded): 77
*/
```

## Common Casting Mistakes

### Mistake 1: Wrong Direction with Precision Loss

```java
// âŒ Loses decimal part
double result = 10.5;
int value = result;  // Error - can't implicit cast

// âœ… Explicit cast - but lose decimals
int value = (int) result;  // Value is 10
```

### Mistake 2: Casting Non-Numeric Strings

```java
String text = "Hello";
int number = Integer.parseInt(text);  // âŒ Crash! "Hello" isn't a number

String text2 = "25";
int number2 = Integer.parseInt(text2);  // âœ… Works - "25" is a number
```

### Mistake 3: Forgetting Cast Operator

```java
double decimal = 10.5;
int number = decimal;  // âŒ Error - must cast explicitly
int number = (int) decimal;  // âœ… Correct
```

## Key Takeaways

- âœ… Widening (small â†’ large): Automatic, safe
- âœ… Narrowing (large â†’ small): Explicit (int), risky
- âœ… Use parentheses for casting: (type) value
- âœ… Integer division loses decimals
- âœ… Large values overflow when cast to small types
- âœ… String to int: Integer.parseInt()
- âœ… int to String: String.valueOf()

## Next Steps

Proceed to [Math Operations](./05-MathOperations.md) for more advanced calculations.

---

