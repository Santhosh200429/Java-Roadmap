# Conditionals: Making Decisions in Your Code

## What Are Conditionals?

**Conditionals** allow your program to make decisions. They let code run only when certain conditions are true - just like real life:

"If it's raining, bring an umbrella. Otherwise, wear sunscreen."

In Java: `if` it's raining, `then` bring umbrella, `else` wear sunscreen.

## The if Statement

The simplest way to make decisions:

```java
if (condition) {
    // Code runs ONLY if condition is true
}
```

**Example**:
```java
int age = 20;

if (age >= 18) {
    System.out.println("You can vote");  // Prints (age IS 20)
}
```

### How It Works

```
Check condition: age >= 18
       ↓
    Is it true?
       ↙        ↘
     YES        NO
      ↓          ↓
   Run code    Skip code
   (vote)      (nothing)
```

## The if-else Statement

Do one thing if true, something else if false:

```java
if (condition) {
    // Code if condition is TRUE
} else {
    // Code if condition is FALSE
}
```

**Example**:
```java
int age = 15;

if (age >= 18) {
    System.out.println("You can vote");
} else {
    System.out.println("You cannot vote");  // Prints
}
```

### Multiple Branches with else if

For more than 2 choices, use `else if`:

```java
int score = 75;

if (score >= 90) {
    System.out.println("Grade A");
} else if (score >= 80) {
    System.out.println("Grade B");
} else if (score >= 70) {
    System.out.println("Grade C");  // Prints
} else if (score >= 60) {
    System.out.println("Grade D");
} else {
    System.out.println("Grade F");
}
```

**How else if Works**:
```
Check: score >= 90?  → NO, skip this block
Check: score >= 80?  → NO, skip this block
Check: score >= 70?  → YES, run this block! (prints "Grade C")
Don't check remaining conditions
```

**Important**: Only the first `true` block runs. Once a condition matches, remaining conditions are ignored.

### Tips for if-else if-else

1. **Order matters** - Put most specific conditions first
```java
// ❌ Bad - will never reach second condition
if (age >= 0) {
    System.out.println("Any age");
} else if (age >= 18) {
    System.out.println("Adult");  // Never runs!
}

// ✅ Good - specific first
if (age >= 18) {
    System.out.println("Adult");
} else if (age >= 0) {
    System.out.println("Any age");
}
```

2. **Don't use unnecessary conditions**:
```java
// ❌ Wasteful
if (score >= 90) {
    System.out.println("A");
} else if (score >= 90 && score < 100) {  // Redundant!
    System.out.println("A+");
}

// ✅ Cleaner
if (score >= 95) {
    System.out.println("A+");
} else if (score >= 90) {
    System.out.println("A");
}
```

## Nested if Statements

Put if statements inside other if statements:

```java
int age = 25;
boolean hasLicense = true;

if (age >= 18) {
    if (hasLicense) {
        System.out.println("You can drive");  // Prints
    } else {
        System.out.println("Get a license");
    }
} else {
    System.out.println("Too young to drive");
}
```

Or use logical operators (cleaner):

```java
if (age >= 18 && hasLicense) {
    System.out.println("You can drive");
}
```

## The switch Statement

For many options of the same variable, `switch` is cleaner:

```java
int day = 3;

switch (day) {
    case 1:
        System.out.println("Monday");
        break;
    case 2:
        System.out.println("Tuesday");
        break;
    case 3:
        System.out.println("Wednesday");  // Prints
        break;
    case 4:
        System.out.println("Thursday");
        break;
    default:
        System.out.println("Invalid day");
}
```

### How switch Works

```
Check day value
       ↓
   Is it 1? NO
   Is it 2? NO
   Is it 3? YES → Print "Wednesday", break
   (Skip rest)
```

### Important: break Statement

The `break` statement exits the switch. Without it, code "falls through":

```java
int day = 2;

switch (day) {
    case 1:
        System.out.println("Monday");
        // No break!
    case 2:
        System.out.println("Tuesday");
        // No break!
    case 3:
        System.out.println("Wednesday");
        // No break!
    default:
        System.out.println("Invalid");
}

/* Output:
Tuesday        ← Matched day 2
Wednesday      ← Fell through (no break)
Invalid        ← Still fell through
*/
```

**Always use `break`** to exit switch, unless fall-through is intentional.

### switch vs if-else

| Situation | Use switch | Use if-else |
|-----------|-----------|-----------|
| Many options for one variable | ✅ | Verbose |
| Complex conditions | Difficult | ✅ |
| Ranges (score >= 90) | Difficult | ✅ |
| Simple comparisons | ✅ | Works |

**Example**: Switch better for days

```java
// ✅ switch (clean)
switch (day) {
    case 1: System.out.println("Monday"); break;
    case 2: System.out.println("Tuesday"); break;
}

// ❌ if-else (verbose)
if (day == 1) {
    System.out.println("Monday");
} else if (day == 2) {
    System.out.println("Tuesday");
}
```

**Example**: if-else better for ranges

```java
// ✅ if-else (clean)
if (score >= 90) {
    System.out.println("A");
} else if (score >= 80) {
    System.out.println("B");
}

// ❌ switch (weird)
switch (score) {
    case 90:
    case 91:
    case 92:
    ...  // List all 11 cases!
}
```

## Ternary Operator (Quick Decisions)

For simple if-else, use the ternary operator:

```java
int age = 20;

// if-else style
String status;
if (age >= 18) {
    status = "Adult";
} else {
    status = "Minor";
}

// Ternary style (same result)
String status = (age >= 18) ? "Adult" : "Minor";

System.out.println(status);  // Adult
```

**When to use**:
- Simple conditions only
- Assigning values
- Too complex? Use regular if-else instead

## Logical Operators in Conditions

Combine multiple conditions:

```java
int age = 25;
double gpa = 3.5;
boolean isResident = true;

// AND - all must be true
if (age >= 18 && gpa >= 3.0 && isResident) {
    System.out.println("Eligible for scholarship");  // Prints
}

// OR - at least one must be true
if (age >= 30 || gpa >= 3.8 || isResident) {
    System.out.println("Special consideration");  // Prints
}

// NOT - inverts condition
if (!isResident) {
    System.out.println("International student");  // Doesn't print
}

// Complex combinations
if ((age >= 18 && gpa >= 3.0) || isResident) {
    System.out.println("Meets requirements");  // Prints
}
```

## Practical Example: Grade Calculator

```java
public class GradeCalculator {
    public static void main(String[] args) {
        int score = 85;
        char grade;
        
        if (score >= 90) {
            grade = 'A';
        } else if (score >= 80) {
            grade = 'B';
        } else if (score >= 70) {
            grade = 'C';
        } else if (score >= 60) {
            grade = 'D';
        } else {
            grade = 'F';
        }
        
        System.out.println("Score: " + score);
        System.out.println("Grade: " + grade);
        
        // Additional feedback
        if (grade == 'A' || grade == 'B') {
            System.out.println("Excellent work!");
        } else if (grade == 'C') {
            System.out.println("Good effort");
        } else {
            System.out.println("Need improvement");
        }
    }
}

/* Output:
Score: 85
Grade: B
Excellent work!
*/
```

## Common Mistakes

### Mistake 1: Forgetting Braces

```java
if (age >= 18)
    System.out.println("Adult");
    System.out.println("Vote");  // Always runs!

// ✅ Correct - braces group statements
if (age >= 18) {
    System.out.println("Adult");
    System.out.println("Vote");
}
```

### Mistake 2: Comparing Objects with ==

```java
String name1 = "John";
String name2 = "John";

if (name1 == name2) { }      // ❌ Might fail (compares reference)
if (name1.equals(name2)) { } // ✅ Correct (compares content)
```

### Mistake 3: Forgetting break in switch

```java
switch (day) {
    case 1:
        System.out.println("Monday");
        // ❌ Missing break - falls through!
    case 2:
        System.out.println("Tuesday");
}
```

### Mistake 4: Impossible Conditions

```java
if (age >= 18 && age < 18) {  // Impossible! Nothing is >= 18 AND < 18
    System.out.println("Never runs");
}
```

## Practice Exercises

### Exercise 1: Simple if-else

Write a program that:
- Takes a number
- Prints "positive" if > 0
- Prints "negative" if < 0
- Prints "zero" if == 0

### Exercise 2: Grade Calculation

Write a program that calculates letter grade from numeric score.

### Exercise 3: Day of Week

Use switch to print day name from number (1=Monday, etc.)

## Key Takeaways

- ✅ `if`: Do something if true
- ✅ `if-else`: Do one thing or another
- ✅ `else if`: Multiple choices
- ✅ `switch`: Many options for one variable
- ✅ Logical operators: && (and), || (or), ! (not)
- ✅ Ternary operator: Simple if-else shorthand
- ✅ Always use break in switch (unless intentional fall-through)
- ✅ Order matters in if-else if chains

## Next Steps

Master conditionals - they're fundamental! Next, learn about [Loops](./Loops.md) to repeat code.

---

**Conditionals let your programs think. Practice them!**
