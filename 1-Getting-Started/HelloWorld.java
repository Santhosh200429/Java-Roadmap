/**
 * HelloWorld.java
 * 
 * This is your first Java program! This file demonstrates:
 * 1. How to create a class
 * 2. How to write the main method (entry point)
 * 3. Basic output to console
 */

public class HelloWorld {
    /**
     * The main method is where Java programs start executing.
     * Every Java program needs this method to run.
     * 
     * public: This method can be accessed from anywhere
     * static: We can call it without creating an object
     * void: This method doesn't return a value
     * String[] args: This accepts command-line arguments (we'll learn later)
     */
    public static void main(String[] args) {
        // This line prints text to the console and moves to the next line
        System.out.println("Hello, World!");
        
        // You can print multiple things
        System.out.println("Welcome to Java!");
        System.out.println("This is my first program!");
    }
}

/*
 * HOW TO RUN THIS PROGRAM:
 * 
 * Method 1: Using IDE (IntelliJ, Eclipse, VS Code)
 * - Click the green play button (▶️) next to the main method
 * - Output appears in the Run panel at the bottom
 * 
 * Method 2: Using Command Line
 * 1. Save this file as HelloWorld.java
 * 2. Open Command Prompt/Terminal in the file's folder
 * 3. Compile: javac HelloWorld.java
 *    (Creates HelloWorld.class file)
 * 4. Run: java HelloWorld
 *    (Program executes and shows output)
 * 
 * EXPECTED OUTPUT:
 * Hello, World!
 * Welcome to Java!
 * This is my first program!
 * 
 */

/*
 * LET'S UNDERSTAND THE KEY PARTS:
 * 
 * 1. CLASS DECLARATION: public class HelloWorld { }
 *    - Defines a class named HelloWorld
 *    - File must be named HelloWorld.java
 *    - "public" means it can be accessed from anywhere
 * 
 * 2. MAIN METHOD: public static void main(String[] args) { }
 *    - This is the starting point of every program
 *    - Java looks for this method when you run the program
 *    - It must be exactly this signature (for now)
 * 
 * 3. PRINTLN: System.out.println("Hello, World!");
 *    - System = the system object
 *    - out = output stream
 *    - println = print line (prints and goes to next line)
 *    - Text goes inside quotation marks
 * 
 */

/*
 * BREAKING DOWN System.out.println():
 * 
 * System.out.println("Hello, World!");
 * │      │   │       │              │
 * │      │   │       │              └─ Ends with semicolon (;)
 * │      │   │       └─ Method that prints text
 * │      │   └─ 'out' object (standard output)
 * │      └─ Part of Java's system package
 * └─ A built-in Java class
 * 
 * Note: EVERY statement in Java ends with a semicolon (;)
 * 
 */

/*
 * IMPORTANT CONCEPTS:
 * 
 * 1. Comments (like this!)
 *    - Single line: // This is ignored
 *    - Multiple line: /* Text */ (what you're reading)
 *    - Javadoc: /** Used for documentation */
 * 
 * 2. Case Sensitivity
 *    - Java is VERY case-sensitive
 *    - HelloWorld ≠ helloworld ≠ HELLOWORLD
 *    - println ≠ PrintLn ≠ PRINTLN
 * 
 * 3. Braces { }
 *    - Open brace: { starts a block
 *    - Close brace: } ends a block
 *    - Every { must have a matching }
 * 
 * 4. Whitespace
 *    - Spaces and line breaks are mostly ignored by Java
 *    - Use them to make code readable!
 * 
 */
