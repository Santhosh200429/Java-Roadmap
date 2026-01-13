# Math Operations: Working with Numbers

## Java's Math Class

Java provides a built-in **Math class** with ready-made functions for common mathematical operations. You don't need to reinvent the wheel!

### Basic Math Methods

```java
Math.abs(-5);           // 5 (absolute value)
Math.max(10, 20);       // 20 (larger of two)
Math.min(10, 20);       // 10 (smaller of two)
Math.sqrt(16);          // 4.0 (square root)
Math.pow(2, 3);         // 8.0 (2 to the power of 3)
Math.round(3.7);        // 4 (nearest integer)
Math.floor(3.9);        // 3.0 (rounds down)
Math.ceil(3.1);         // 4.0 (rounds up)
```

### Practical Examples

```java
// Distance calculation
double x = 3;
double y = 4;
double distance = Math.sqrt(x*x + y*y);  // 5.0

// Range limiting
int score = 150;
int limitedScore = Math.min(score, 100);  // 100

// Rounding
double pi = 3.14159;
long rounded = Math.round(pi);  // 3

// Random numbers
int random = (int) (Math.random() * 100);  // Random 0-99
```

## Arithmetic Operators Recap

| Operator | Example | Result |
|----------|---------|--------|
| `+` | 10 + 5 | 15 |
| `-` | 10 - 5 | 5 |
| `*` | 10 * 5 | 50 |
| `/` | 10 / 5 | 2 |
| `%` | 10 % 3 | 1 |

### Order of Operations

Java follows PEMDAS (Parentheses, Exponents, Multiplication, Division, Addition, Subtraction):

```java
int result = 2 + 3 * 4;      // 14 (multiply first)
int result = (2 + 3) * 4;    // 20 (parentheses first)
```

## Common Math Patterns

### Calculating Percentage

```java
int totalScore = 85;
int maxScore = 100;
double percentage = (totalScore / maxScore) * 100;
System.out.println(percentage);  // 85.0
```

### Checking if Even/Odd

```java
int number = 7;
if (number % 2 == 0) {
    System.out.println("Even");
} else {
    System.out.println("Odd");  // Prints (7 % 2 = 1, not 0)
}
```

### Finding Average

```java
int score1 = 80;
int score2 = 90;
int score3 = 85;
double average = (score1 + score2 + score3) / 3.0;  // 85.0
System.out.println(average);
```

### Increment/Decrement

```java
int counter = 5;
counter++;  // Now 6
counter--;  // Now 5
counter += 10;  // Now 15
counter -= 5;   // Now 10
```

## Random Numbers

Generate random numbers for games, shuffling, etc.:

```java
// Random double between 0.0 and 1.0
double random1 = Math.random();  // 0.5234... or 0.9123... etc

// Random int between 0 and 9
int random2 = (int) (Math.random() * 10);

// Random int between 1 and 6 (dice)
int dice = (int) (Math.random() * 6) + 1;  // 1-6

// Random int between min and max
int min = 10;
int max = 20;
int randomBetween = (int) (Math.random() * (max - min + 1)) + min;
```

## Real-World Example: Calculator Program

```java
public class SimpleCalculator {
    public static void main(String[] args) {
        double num1 = 25;
        double num2 = 4;
        
        double sum = num1 + num2;
        double difference = num1 - num2;
        double product = num1 * num2;
        double quotient = num1 / num2;
        double remainder = num1 % num2;
        double power = Math.pow(num1, num2);
        
        System.out.println("Number 1: " + num1);
        System.out.println("Number 2: " + num2);
        System.out.println("Sum: " + sum);
        System.out.println("Difference: " + difference);
        System.out.println("Product: " + product);
        System.out.println("Quotient: " + quotient);
        System.out.println("Remainder: " + remainder);
        System.out.println("Power: " + power);
    }
}
```

## Important Math Notes

### Integer vs Decimal Division

```java
int result1 = 7 / 2;      // 3 (integer division)
double result2 = 7.0 / 2; // 3.5 (decimal division)
double result3 = 7 / 2.0; // 3.5 (at least one decimal)
```

### Precision Issues

```java
double result = 0.1 + 0.2;
System.out.println(result);  // 0.30000000000000004 (rounding error!)

// Solution: Use rounding or BigDecimal for financial calculations
result = Math.round(result * 100.0) / 100.0;  // 0.3
```

### Avoiding Division by Zero

```java
int divisor = 0;
if (divisor != 0) {
    int result = 10 / divisor;
} else {
    System.out.println("Cannot divide by zero!");
}
```

## Key Takeaways

- Math class provides built-in math functions
- Follow order of operations (PEMDAS)
- Use parentheses to clarify calculations
- Integer division loses decimals (use double)
- Use % operator for remainder
- Math.random() for random numbers
- Always check for division by zero

## Next Steps

Continue to [Arrays](./06-Arrays.md) to store multiple values.

---


