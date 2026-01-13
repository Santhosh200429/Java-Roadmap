# Arrays: Storing Multiple Values

## What is an Array?

An **array** is a container that holds multiple values of the same type. Think of it as a list or series of boxes, each containing a value.

```
Box 0: [10]
Box 1: [20]
Box 2: [30]
Box 3: [40]
Box 4: [50]
```

Without arrays, you'd need many variables:
```java
int score1 = 10;
int score2 = 20;
int score3 = 30;
int score4 = 40;
int score5 = 50;
```

With an array:
```java
int[] scores = {10, 20, 30, 40, 50};
```

Much cleaner!

## Creating Arrays

### Method 1: Declare and Initialize with Values

```java
int[] numbers = {10, 20, 30, 40, 50};
String[] names = {"Alice", "Bob", "Charlie"};
double[] prices = {19.99, 29.99, 39.99};
boolean[] flags = {true, false, true};
```

### Method 2: Declare and Create Empty Array

```java
int[] numbers = new int[5];  // Array of 5 integers
String[] names = new String[3];  // Array of 3 strings

// Access and set values
numbers[0] = 10;
numbers[1] = 20;
names[0] = "Alice";
```

## Understanding Array Indexes

Arrays are **zero-indexed**, meaning the first element is at position 0:

```
Array: [10, 20, 30, 40, 50]
Index:  0   1   2   3   4

numbers[0] = 10
numbers[1] = 20
numbers[4] = 50
numbers[5] = ERROR (out of bounds!)
```

### Accessing Elements

```java
int[] scores = {85, 90, 78, 92, 88};

int firstScore = scores[0];   // 85
int lastScore = scores[4];    // 88
scores[2] = 95;               // Change element at index 2

System.out.println(scores[0]);  // Prints: 85
```

## Array Length

Get how many elements in an array with `.length`:

```java
int[] numbers = {10, 20, 30, 40, 50};
System.out.println(numbers.length);  // Prints: 5

// Loop through array
for (int i = 0; i < numbers.length; i++) {
    System.out.println(numbers[i]);
}
```

## Looping Through Arrays

### Using for Loop

```java
int[] scores = {85, 90, 78, 92, 88};

for (int i = 0; i < scores.length; i++) {
    System.out.println("Score " + (i+1) + ": " + scores[i]);
}

/* Output:
Score 1: 85
Score 2: 90
Score 3: 78
Score 4: 92
Score 5: 88
*/
```

### Using Enhanced for Loop (foreach)

Cleaner syntax for going through all elements:

```java
int[] scores = {85, 90, 78, 92, 88};

for (int score : scores) {
    System.out.println(score);
}
```

**Read as**: "for each score in scores, print score"

## Common Array Operations

### Finding Maximum Value

```java
int[] numbers = {45, 78, 23, 90, 56};
int max = numbers[0];

for (int i = 1; i < numbers.length; i++) {
    if (numbers[i] > max) {
        max = numbers[i];
    }
}

System.out.println("Maximum: " + max);  // 90
```

### Finding Sum of Elements

```java
int[] scores = {85, 90, 78, 92, 88};
int sum = 0;

for (int score : scores) {
    sum += score;
}

System.out.println("Total: " + sum);  // 433
double average = sum / (double) scores.length;  // 86.6
```

### Searching for Element

```java
int[] numbers = {10, 20, 30, 40, 50};
int target = 30;
boolean found = false;

for (int num : numbers) {
    if (num == target) {
        found = true;
        break;
    }
}

System.out.println(found ? "Found" : "Not found");
```

## 2D Arrays (Arrays of Arrays)

Store data in rows and columns:

```
     Col 0  Col 1  Col 2
Row 0: [10]   [20]   [30]
Row 1: [40]   [50]   [60]
Row 2: [70]   [80]   [90]
```

### Creating 2D Arrays

```java
// Method 1: With values
int[][] matrix = {
    {10, 20, 30},
    {40, 50, 60},
    {70, 80, 90}
};

// Method 2: Empty array
int[][] grid = new int[3][4];  // 3 rows, 4 columns
```

### Accessing 2D Elements

```java
int[][] matrix = {
    {10, 20, 30},
    {40, 50, 60},
    {70, 80, 90}
};

System.out.println(matrix[0][0]);  // 10 (row 0, col 0)
System.out.println(matrix[1][2]);  // 60 (row 1, col 2)
System.out.println(matrix[2][1]);  // 80 (row 2, col 1)
```

### Looping Through 2D Arrays

```java
int[][] matrix = {
    {10, 20, 30},
    {40, 50, 60}
};

for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
        System.out.print(matrix[i][j] + " ");
    }
    System.out.println();
}

/* Output:
10 20 30
40 50 60
*/
```

## Common Mistakes

### Mistake 1: Array Index Out of Bounds

```java
int[] numbers = {10, 20, 30};
System.out.println(numbers[3]);  // ❌ Error! Index 3 doesn't exist
System.out.println(numbers[2]);  // ✅ Last element (index is 0-2)
```

### Mistake 2: Starting Index from 1

```java
int[] scores = {85, 90, 78};
System.out.println(scores[1]);   // 90 (second element, not first!)
System.out.println(scores[0]);   // 85 (first element)
```

### Mistake 3: Forgetting Array Type

```java
int[] numbers = {"10", "20", "30"};  // ❌ Strings in int array
int[] numbers = {10, 20, 30};        // ✅ Correct
```

### Mistake 4: Uninitialized Elements

```java
String[] names = new String[3];
System.out.println(names[0]);  // null (empty, not empty string)
names[0] = "Alice";
System.out.println(names[0]);  // "Alice"
```

## Practical Example: Test Scores

```java
public class TestScores {
    public static void main(String[] args) {
        int[] scores = {85, 92, 78, 95, 88, 76, 90};
        
        // Calculate sum
        int sum = 0;
        for (int score : scores) {
            sum += score;
        }
        
        // Calculate average
        double average = sum / (double) scores.length;
        
        // Find highest and lowest
        int highest = scores[0];
        int lowest = scores[0];
        for (int score : scores) {
            if (score > highest) highest = score;
            if (score < lowest) lowest = score;
        }
        
        // Display results
        System.out.println("Scores: " + java.util.Arrays.toString(scores));
        System.out.println("Sum: " + sum);
        System.out.println("Average: " + average);
        System.out.println("Highest: " + highest);
        System.out.println("Lowest: " + lowest);
    }
}

/* Output:
Scores: [85, 92, 78, 95, 88, 76, 90]
Sum: 604
Average: 86.28571428571429
Highest: 95
Lowest: 76
*/
```

## Key Takeaways

- ✅ Array holds multiple values of same type
- ✅ Arrays are zero-indexed (first element is index 0)
- ✅ Use `.length` to get array size
- ✅ Loop through with `for` or enhanced `for` loop
- ✅ 2D arrays are like matrices (rows and columns)
- ✅ Check array bounds before accessing
- ✅ All elements initialized to default value (0, false, null)

## Next Steps

Continue learning OOP concepts. Arrays are just the beginning!

---

**Arrays organize data efficiently. Master them for real programs!**
