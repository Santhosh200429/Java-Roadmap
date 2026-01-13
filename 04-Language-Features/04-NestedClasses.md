# Nested Classes: Inner, Static, Local & Anonymous Classes

## What are Nested Classes?

**Nested classes** are classes defined inside other classes. They organize code and create logical groupings.

**Real-world analogy**: Like having a specialized department inside a company.

## Types of Nested Classes

```
Nested Classes
â”œâ”€â”€ Static Nested Class (static inner class)
â”œâ”€â”€ Inner Classes (non-static)
â”‚   â”œâ”€â”€ Member Inner Class
â”‚   â”œâ”€â”€ Local Inner Class
â”‚   â””â”€â”€ Anonymous Inner Class
```

## 1. Static Nested Class

```java
public class OuterClass {
    private static String staticVar = "static";
    private String instanceVar = "instance";
    
    // Static nested class
    public static class StaticNested {
        public void display() {
            System.out.println(staticVar);  // âœ… Can access static
            // System.out.println(instanceVar);  // âŒ Can't access instance
        }
    }
}

// Usage
OuterClass.StaticNested nested = new OuterClass.StaticNested();
nested.display();
```

### Real Example: Builder Pattern

```java
public class Student {
    private final String name;
    private final String email;
    private final double gpa;
    private final int year;
    
    // Private constructor - use builder
    private Student(Builder builder) {
        this.name = builder.name;
        this.email = builder.email;
        this.gpa = builder.gpa;
        this.year = builder.year;
    }
    
    // Static nested Builder class
    public static class Builder {
        private String name;
        private String email;
        private double gpa;
        private int year;
        
        public Builder name(String name) {
            this.name = name;
            return this;
        }
        
        public Builder email(String email) {
            this.email = email;
            return this;
        }
        
        public Builder gpa(double gpa) {
            this.gpa = gpa;
            return this;
        }
        
        public Builder year(int year) {
            this.year = year;
            return this;
        }
        
        public Student build() {
            if (name == null || email == null) {
                throw new IllegalStateException("Name and email required");
            }
            return new Student(this);
        }
    }
}

// Usage - very readable
Student student = new Student.Builder()
    .name("Alice")
    .email("alice@email.com")
    .gpa(3.8)
    .year(3)
    .build();
```

## 2. Member Inner Class (Instance Inner Class)

```java
public class Outer {
    private String outerVar = "outer";
    
    // Instance inner class
    public class Inner {
        private String innerVar = "inner";
        
        public void show() {
            System.out.println(outerVar);   // âœ… Access outer instance
            System.out.println(innerVar);   // âœ… Access own variable
        }
    }
}

// Usage - must create Outer first
Outer outer = new Outer();
Outer.Inner inner = outer.new Inner();  // Requires outer instance
inner.show();
```

### Event Handler Example

```java
public class Button {
    private String label;
    private List<ClickListener> listeners = new ArrayList<>();
    
    public Button(String label) {
        this.label = label;
    }
    
    public void click() {
        System.out.println("Button '" + label + "' clicked");
        for (ClickListener listener : listeners) {
            listener.onClicked(label);
        }
    }
    
    public void addClickListener(ClickListener listener) {
        listeners.add(listener);
    }
    
    // Member inner class for events
    public class ClickEvent {
        private final long timestamp = System.currentTimeMillis();
        
        public String getButtonLabel() {
            return label;  // Access outer instance variable
        }
        
        public long getTimestamp() {
            return timestamp;
        }
    }
    
    // Functional interface
    @FunctionalInterface
    public interface ClickListener {
        void onClicked(String buttonLabel);
    }
}

// Usage
Button button = new Button("Submit");
button.addClickListener(label -> System.out.println("User clicked: " + label));
button.click();
```

## 3. Local Inner Class

Defined inside a method:

```java
public class Processor {
    public void process() {
        final String finalVar = "process";
        
        // Local inner class - only exists in this method
        class LocalProcessor {
            public void execute() {
                System.out.println(finalVar);  // âœ… Access final variables
            }
        }
        
        LocalProcessor processor = new LocalProcessor();
        processor.execute();
    }
}

// Usage
Processor p = new Processor();
p.process();
```

### Complete Example: Data Processor

```java
public class DataAnalyzer {
    
    public void analyzeStudentGrades(List<Student> students) {
        // Local inner class
        class GradeAnalyzer {
            private double totalGpa = 0;
            private int count = 0;
            
            public void analyze() {
                for (Student student : students) {
                    totalGpa += student.getGpa();
                    count++;
                }
            }
            
            public double getAverageGpa() {
                return count > 0 ? totalGpa / count : 0;
            }
        }
        
        GradeAnalyzer analyzer = new GradeAnalyzer();
        analyzer.analyze();
        
        System.out.println("Average GPA: " + analyzer.getAverageGpa());
    }
}
```

## 4. Anonymous Inner Class

No name, created on-the-fly:

```java
// Traditional approach with named class
class PrintListener implements ActionListener {
    @Override
    public void actionPerformed(ActionEvent e) {
        System.out.println("Button clicked");
    }
}
button.addActionListener(new PrintListener());

// Anonymous inner class - same result, shorter code
button.addActionListener(new ActionListener() {
    @Override
    public void actionPerformed(ActionEvent e) {
        System.out.println("Button clicked");
    }
});

// Modern approach - Lambda (preferred)
button.addActionListener(e -> System.out.println("Button clicked"));
```

### Collections Example

```java
public class StudentManager {
    private List<Student> students = new ArrayList<>();
    
    public void printSortedByGpa() {
        Collections.sort(students, new Comparator<Student>() {
            @Override
            public int compare(Student s1, Student s2) {
                return Double.compare(s2.getGpa(), s1.getGpa());
            }
        });
        
        for (Student s : students) {
            System.out.println(s);
        }
    }
    
    // Modern way with Lambda
    public void printSortedByGpaModern() {
        students.sort((s1, s2) -> Double.compare(s2.getGpa(), s1.getGpa()));
        students.forEach(System.out::println);
    }
}
```

## Complete Example: Game Event System

```java
public class Game {
    private String title;
    private List<GameListener> listeners = new ArrayList<>();
    
    public Game(String title) {
        this.title = title;
    }
    
    public void addListener(GameListener listener) {
        listeners.add(listener);
    }
    
    public void startGame() {
        GameStartedEvent event = new GameStartedEvent();
        listeners.forEach(l -> l.onGameStarted(event));
    }
    
    // Member inner class
    public class GameStartedEvent {
        private final long timestamp = System.currentTimeMillis();
        
        public String getGameTitle() {
            return title;  // Access outer class member
        }
        
        public long getStartTime() {
            return timestamp;
        }
    }
    
    // Interface for listeners
    @FunctionalInterface
    public interface GameListener {
        void onGameStarted(GameStartedEvent event);
    }
}

// Usage
Game game = new Game("Chess");

// Anonymous inner class
game.addListener(new Game.GameListener() {
    @Override
    public void onGameStarted(Game.GameStartedEvent event) {
        System.out.println("Game " + event.getGameTitle() + " started at " + 
                          event.getStartTime());
    }
});

// Lambda (preferred)
game.addListener(event -> 
    System.out.println("Game started: " + event.getGameTitle())
);

game.startGame();
```

## Comparison

| Type | Access to Outer | Can be Static | Use Case |
|------|-----------------|---------------|----------|
| Static Nested | Only static members | Yes | Builder pattern, utilities |
| Member Inner | All members | No | Logically grouped classes |
| Local Inner | Final variables | No | Method-specific logic |
| Anonymous | Final variables | No | One-time implementations |

## Common Mistakes

### 1. Trying to Access Non-Final Variable in Local Class

```java
// âŒ WRONG
public void process() {
    String var = "value";  // Not final
    var = "changed";
    
    class Local {
        void show() {
            System.out.println(var);  // ERROR: var must be final
        }
    }
}

// âœ… RIGHT
public void process() {
    final String var = "value";  // Final
    
    class Local {
        void show() {
            System.out.println(var);  // OK
        }
    }
}
```

### 2. Instance Inner Without Outer Instance

```java
// âŒ WRONG
Outer.Inner inner = new Outer.Inner();  // No outer instance

// âœ… RIGHT
Outer outer = new Outer();
Outer.Inner inner = outer.new Inner();  // Create with outer
```

### 3. Overcomplicating with Anonymous Classes

```java
// âŒ COMPLEX - unnecessary anonymous class
button.setOnClickListener(new Button.ClickListener() {
    @Override
    public void onClick() {
        doSomething();
    }
});

// âœ… SIMPLE - use lambda
button.setOnClickListener(() -> doSomething());
```

## When to Use

âœ… **Use Nested Classes for:**
- Builder pattern
- Event listeners and handlers
- Comparison/filtering logic
- Logical grouping of related classes

âŒ **Don't Use for:**
- Regular application logic (use separate classes)
- If complexity increases significantly
- Deep nesting (limits readability)

## Key Takeaways

- âœ… Static nested class: standalone class inside another class
- âœ… Member inner class: associated with outer instance
- âœ… Local inner class: defined inside method
- âœ… Anonymous inner class: no name, created inline
- âœ… Local/anonymous classes can access final variables
- âœ… Lambdas are preferred over anonymous classes now
- âœ… Builder pattern uses static nested class

---

