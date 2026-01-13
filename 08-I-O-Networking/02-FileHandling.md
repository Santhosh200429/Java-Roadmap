# File Handling: Reading and Writing Files

## Reading Files

### Reading Text File Line-by-Line

```java
import java.io.*;

public class FileReader {
    public static void main(String[] args) {
        try {
            BufferedReader reader = new BufferedReader(new java.io.FileReader("file.txt"));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### Reading Entire File (Java 11+)

```java
import java.nio.file.*;

String content = Files.readString(Paths.get("file.txt"));
System.out.println(content);
```

## Writing Files

### Writing Text to File

```java
import java.io.*;

public class FileWriter {
    public static void main(String[] args) {
        try {
            PrintWriter writer = new PrintWriter(new java.io.FileWriter("output.txt"));
            writer.println("Hello, World!");
            writer.println("Java File I/O");
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### Writing with NIO (Modern)

```java
import java.nio.file.*;

Files.writeString(Paths.get("output.txt"), "Hello, World!");
```

## Working with Directories

```java
import java.io.*;
import java.nio.file.*;

// List files in directory
File dir = new File("src");
for (File file : dir.listFiles()) {
    System.out.println(file.getName());
}

// Check if directory exists
if (Files.exists(Paths.get("data"))) {
    System.out.println("Directory exists");
}

// Create directory
Files.createDirectory(Paths.get("newdir"));

// Delete file
Files.delete(Paths.get("file.txt"));
```

## Practical Example: Log File Writer

```java
import java.io.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Logger {
    private PrintWriter writer;
    
    public Logger(String filename) throws IOException {
        writer = new PrintWriter(new FileWriter(filename, true));  // append mode
    }
    
    public void log(String message) {
        String timestamp = LocalDateTime.now()
            .format(DateTimeFormatter.ISO_LOCAL_TIME);
        writer.println("[" + timestamp + "] " + message);
        writer.flush();
    }
    
    public void close() {
        writer.close();
    }
    
    public static void main(String[] args) throws IOException {
        Logger logger = new Logger("app.log");
        logger.log("Application started");
        logger.log("User logged in");
        logger.log("Application stopped");
        logger.close();
    }
}
```

## Key Takeaways

- âœ… BufferedReader for reading files
- âœ… PrintWriter for writing files
- âœ… Use try-catch for IOException handling
- âœ… Always close files with close()
- âœ… Modern Java has Files class for simpler I/O
- âœ… Check if file exists before reading
- âœ… Create directories before creating files

---

