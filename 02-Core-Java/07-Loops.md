# Loops: Repeating Code Multiple Times

## What are Loops?

A **loop** repeats a block of code multiple times. Instead of writing the same code 100 times, loops do it automatically.

**Real-world analogy**: A loop is like reading a checklist - do the same item for each element on the list.

## Loop Types

### 1. For Loop (When you know how many times)

```java
for (int i = 0; i < 5; i++) {
    System.out.println("Count: " + i);
}

// Output:
// Count: 0
// Count: 1
// Count: 2
// Count: 3
// Count: 4
```

**Structure**: `for (initialization; condition; increment)`

- **i = 0**: Start value
- **i < 5**: Continue while true
- **i++**: Add 1 each time

### Practical Example

```java
// Print multiplication table
public class MultiplicationTable {
    public static void main(String[] args) {
        int num = 5;
        
        for (int i = 1; i <= 10; i++) {
            System.out.println(num + " Ã— " + i + " = " + (num * i));
        }
    }
}

// Output:
// 5 Ã— 1 = 5
// 5 Ã— 2 = 10
// 5 Ã— 3 = 15
// ... up to 10
```

### Loop Through Arrays

```java
int[] numbers = {10, 20, 30, 40, 50};

// Using index
for (int i = 0; i < numbers.length; i++) {
    System.out.println("Index " + i + ": " + numbers[i]);
}

// Output:
// Index 0: 10
// Index 1: 20
// Index 2: 30
// ... etc
```

### 2. While Loop (When you don't know the count)

```java
int count = 0;
while (count < 5) {
    System.out.println("Count: " + count);
    count++;
}
```

**Use case**: Process until some condition becomes false

```java
// Read user input until valid
Scanner scanner = new Scanner(System.in);
int age = -1;

while (age < 0 || age > 120) {
    System.out.print("Enter age (0-120): ");
    age = scanner.nextInt();
    
    if (age < 0 || age > 120) {
        System.out.println("Invalid age!");
    }
}

System.out.println("Valid age: " + age);
```

### 3. Do-While Loop (Execute at least once)

```java
int count = 0;
do {
    System.out.println("Count: " + count);
    count++;
} while (count < 5);
```

**Difference**: Code runs first, then checks condition

```java
// Menu that runs at least once
int choice = 0;

do {
    System.out.println("\n=== Menu ===");
    System.out.println("1. View profile");
    System.out.println("2. Edit profile");
    System.out.println("3. Exit");
    System.out.print("Choose: ");
    
    choice = scanner.nextInt();
    
    switch (choice) {
        case 1:
            System.out.println("Viewing profile...");
            break;
        case 2:
            System.out.println("Editing profile...");
            break;
        case 3:
            System.out.println("Goodbye!");
            break;
        default:
            System.out.println("Invalid choice!");
    }
} while (choice != 3);
```

### 4. Enhanced For Loop (Easiest for collections)

```java
int[] numbers = {10, 20, 30, 40, 50};

for (int num : numbers) {
    System.out.println("Number: " + num);
}

// Works with Lists too
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
for (String name : names) {
    System.out.println("Name: " + name);
}
```

**Advantage**: No index needed, cleaner code

## Loop Control

### Break Statement (Exit loop)

```java
for (int i = 0; i < 10; i++) {
    if (i == 5) {
        break;  // Exit loop immediately
    }
    System.out.println(i);
}

// Output: 0 1 2 3 4 (stops at 5)
```

**Real example**: Search for student

```java
int[] studentIds = {101, 102, 103, 104, 105};
int searchId = 103;
boolean found = false;

for (int id : studentIds) {
    if (id == searchId) {
        found = true;
        break;
    }
}

System.out.println("Found: " + found);
```

### Continue Statement (Skip to next iteration)

```java
for (int i = 0; i < 10; i++) {
    if (i % 2 == 0) {
        continue;  // Skip even numbers
    }
    System.out.println(i);
}

// Output: 1 3 5 7 9 (only odd)
```

## Nested Loops (Loop inside loop)

```java
// Print multiplication table grid
for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
        System.out.print(i * j + "\t");
    }
    System.out.println();  // New line
}

// Output:
// 1    2    3
// 2    4    6
// 3    6    9
```

### 2D Array with Nested Loops

```java
int[][] matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

// Print all elements
for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
        System.out.print(matrix[i][j] + " ");
    }
    System.out.println();
}
```

## Complete Example: Grade Calculator

```java
public class GradeCalculator {
    public static void main(String[] args) {
        int[] marks = {85, 92, 78, 95, 88};
        int sum = 0;
        int count = 0;
        
        // Calculate sum
        for (int mark : marks) {
            sum += mark;
            count++;
        }
        
        // Calculate average
        double average = sum / (double) count;
        
        // Count grades
        int aCount = 0, bCount = 0, cCount = 0;
        
        for (int mark : marks) {
            if (mark >= 90) {
                aCount++;
            } else if (mark >= 80) {
                bCount++;
            } else {
                cCount++;
            }
        }
        
        System.out.println("Average: " + average);
        System.out.println("A grade: " + aCount);
        System.out.println("B grade: " + bCount);
        System.out.println("C grade: " + cCount);
    }
}
```

## Common Mistakes

### 1. Infinite Loop
```java
// âŒ WRONG - i never changes
while (true) {
    System.out.println("Infinite");
    // No break statement!
}

// RIGHT
for (int i = 0; i < 5; i++) {
    System.out.println(i);
}
```

### 2. Off-by-One Error
```java
// âŒ WRONG - prints 1,2,3,4,5,6 (6 times)
for (int i = 1; i <= 5; i++) {
    System.out.println(i);
}

// RIGHT
for (int i = 0; i < 5; i++) {
    System.out.println(i);
}
```

### 3. Using Wrong Loop Type
```java
// âŒ Awkward
int count = 0;
while (count < 5) {
    System.out.println(count);
    count++;
}

// Better
for (int count = 0; count < 5; count++) {
    System.out.println(count);
}
```

## Loop Comparison

| Loop | Use When | Example |
|------|----------|---------|
| **For** | Know count | Print 1-100 |
| **While** | Unknown count | Read until valid |
| **Do-While** | Must run once | Menu system |
| **Enhanced For** | Iterate collection | Loop array |

## Key Takeaways

- `for` loops: use when you know count
- `while` loops: use when count unknown
- `do-while`: runs at least once
- `break`: exits loop immediately
- `continue`: skips to next iteration
- Enhanced `for` cleanest for arrays/lists
- Nested loops for multi-dimensional data

---


