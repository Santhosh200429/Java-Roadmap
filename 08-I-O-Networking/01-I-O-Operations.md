# I/O Operations: Reading and Writing Data

## What is I/O?

**I/O (Input/Output)** is how programs read data from sources and write data to destinations.

**Real-world analogy**: I/O is like receiving mail (input) and sending mail (output).

## Streams Concept

A **stream** is a sequence of data flowing from source to destination.

```
Reading File (Input Stream)
File â†’ InputStream â†’ Your Program

Writing File (Output Stream)
Your Program â†’ OutputStream â†’ File
```

## File I/O Types

### 1. Byte Streams (Binary Data)

```java
import java.io.*;

// Read bytes from file
class ReadFile {
    public static void main(String[] args) throws IOException {
        FileInputStream fis = new FileInputStream("data.bin");
        
        int byteValue;
        while ((byteValue = fis.read()) != -1) {  // -1 = EOF
            System.out.println(byteValue);  // Single byte
        }
        fis.close();  // Important!
    }
}
```

### 2. Character Streams (Text Data)

```java
import java.io.*;

// Read characters from text file
class ReadText {
    public static void main(String[] args) throws IOException {
        FileReader fr = new FileReader("data.txt");
        
        int charValue;
        while ((charValue = fr.read()) != -1) {
            System.out.print((char) charValue);  // Single character
        }
        fr.close();
    }
}
```

## Buffered I/O (Efficient Reading)

### Reading with Buffer

```java
import java.io.*;

class ReadWithBuffer {
    public static void main(String[] args) throws IOException {
        // Combine: FileInputStream + BufferedInputStream
        BufferedInputStream bis = new BufferedInputStream(
            new FileInputStream("large_file.txt")
        );
        
        int byteValue;
        while ((byteValue = bis.read()) != -1) {
            System.out.print((char) byteValue);
        }
        bis.close();  // Closes inner stream too
    }
}
```

### Reading Lines Efficiently

```java
import java.io.*;

class ReadLines {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(
            new FileReader("data.txt")
        );
        
        String line;
        while ((line = br.readLine()) != null) {  // Null = EOF
            System.out.println(line);
        }
        br.close();
    }
}
```

## Writing Data

### Write Bytes

```java
import java.io.*;

class WriteBytes {
    public static void main(String[] args) throws IOException {
        FileOutputStream fos = new FileOutputStream("output.bin");
        
        fos.write(72);  // 'H'
        fos.write(105); // 'i'
        fos.close();
    }
}
```

### Write Text

```java
import java.io.*;

class WriteText {
    public static void main(String[] args) throws IOException {
        FileWriter fw = new FileWriter("output.txt");
        
        fw.write("Hello, World!\n");
        fw.write("Java I/O\n");
        fw.close();
    }
}
```

### Buffered Writing

```java
import java.io.*;

class WriteBuffered {
    public static void main(String[] args) throws IOException {
        BufferedWriter bw = new BufferedWriter(
            new FileWriter("output.txt")
        );
        
        bw.write("Line 1");
        bw.newLine();
        bw.write("Line 2");
        bw.newLine();
        bw.flush();  // Force write to disk
        bw.close();
    }
}
```

## Try-with-Resources (Auto-close)

Automatically closes resources:

```java
import java.io.*;

class AutoClose {
    public static void main(String[] args) throws IOException {
        // Resource automatically closed
        try (BufferedReader br = new BufferedReader(
            new FileReader("data.txt")
        )) {
            String line;
            while ((line = br.readLine()) != null) {
                System.out.println(line);
            }
        }  // Auto-closed here
    }
}
```

## Complete Examples

### 1. Copy File

```java
import java.io.*;

public class FileCopier {
    public static void copyFile(String source, String destination) 
            throws IOException {
        try (BufferedInputStream bis = new BufferedInputStream(
                new FileInputStream(source));
             BufferedOutputStream bos = new BufferedOutputStream(
                new FileOutputStream(destination))) {
            
            int byteValue;
            while ((byteValue = bis.read()) != -1) {
                bos.write(byteValue);
            }
            bos.flush();
            System.out.println("File copied successfully");
        }
    }
    
    public static void main(String[] args) throws IOException {
        copyFile("source.txt", "destination.txt");
    }
}
```

### 2. Read File as String

```java
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FileReader {
    
    // Modern approach with Files utility
    public static String readFile(String path) throws IOException {
        return new String(Files.readAllBytes(Paths.get(path)));
    }
    
    // Traditional approach
    public static String readFileTraditional(String path) 
            throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
            new java.io.FileReader(path))) {
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
        }
        return sb.toString();
    }
}

// Usage
String content = FileReader.readFile("data.txt");
System.out.println(content);
```

### 3. Count Lines in File

```java
import java.io.*;

public class LineCounter {
    public static int countLines(String filePath) throws IOException {
        int count = 0;
        try (BufferedReader br = new BufferedReader(
            new FileReader(filePath))) {
            while (br.readLine() != null) {
                count++;
            }
        }
        return count;
    }
    
    public static void main(String[] args) throws IOException {
        int lines = countLines("document.txt");
        System.out.println("Total lines: " + lines);
    }
}
```

### 4. Write CSV File

```java
import java.io.*;

public class CSVWriter {
    public static void writeCSV(String filename, String[][] data) 
            throws IOException {
        try (BufferedWriter bw = new BufferedWriter(
            new FileWriter(filename))) {
            
            for (String[] row : data) {
                bw.write(String.join(",", row));
                bw.newLine();
            }
        }
    }
    
    public static void main(String[] args) throws IOException {
        String[][] data = {
            {"Name", "Age", "City"},
            {"Alice", "25", "New York"},
            {"Bob", "30", "London"},
            {"Charlie", "28", "Paris"}
        };
        
        writeCSV("output.csv", data);
        System.out.println("CSV written");
    }
}
```

### 5. Append to File

```java
import java.io.*;

public class FileAppender {
    public static void appendToFile(String filename, String content) 
            throws IOException {
        // true = append mode
        try (BufferedWriter bw = new BufferedWriter(
            new FileWriter(filename, true))) {
            bw.write(content);
            bw.newLine();
        }
    }
    
    public static void main(String[] args) throws IOException {
        appendToFile("log.txt", "New log entry");
        appendToFile("log.txt", "Another entry");
    }
}
```

## Stream vs Reader/Writer

| Task | Stream | Reader/Writer |
|------|--------|---------------|
| Binary files | âœ… Use Stream | âŒ No |
| Text files | âš ï¸ Works but harder | âœ… Use Reader/Writer |
| Character encoding | âŒ Not automatic | âœ… Automatic |
| Performance | âš ï¸ Slower | âœ… Faster |

## Common Mistakes

### 1. Forgetting to Close

```java
// âŒ WRONG - resource leak
public void readFile() throws IOException {
    BufferedReader br = new BufferedReader(
        new FileReader("data.txt")
    );
    String line = br.readLine();
    // Never closed! File locked, memory leak
}

// âœ… RIGHT - try-with-resources
public void readFile() throws IOException {
    try (BufferedReader br = new BufferedReader(
        new FileReader("data.txt"))) {
        String line = br.readLine();
    }  // Auto-closed
}
```

### 2. Wrong Encoding

```java
// âŒ WRONG - assumes default encoding
FileReader fr = new FileReader("utf8_file.txt");

// âœ… RIGHT - specify encoding
InputStreamReader isr = new InputStreamReader(
    new FileInputStream("utf8_file.txt"), 
    StandardCharsets.UTF_8
);
BufferedReader br = new BufferedReader(isr);
```

### 3. Not Handling EOF Properly

```java
// âŒ WRONG - doesn't handle end-of-file
BufferedReader br = new BufferedReader(
    new FileReader("data.txt")
);
String line = br.readLine();
// Crashes if file empty!
System.out.println(line.length());

// âœ… RIGHT
String line;
while ((line = br.readLine()) != null) {
    System.out.println(line.length());
}
```

## Modern NIO (New I/O)

Java NIO provides channel-based approach:

```java
import java.nio.file.*;

// Modern way to read entire file
public class ModernFileIO {
    public static void main(String[] args) throws IOException {
        // Read as list of lines
        List<String> lines = Files.readAllLines(
            Paths.get("data.txt")
        );
        
        // Write lines
        Files.write(Paths.get("output.txt"), lines);
        
        // Read as string
        String content = Files.readString(Paths.get("data.txt"));
    }
}
```

## Key Takeaways

- âœ… Byte streams for binary, Reader/Writer for text
- âœ… Use BufferedInputStream/Reader for efficiency
- âœ… Always close resources (use try-with-resources)
- âœ… Handle EOF condition (-1 or null)
- âœ… Modern Files utility for simple operations
- âœ… Specify encoding for text files
- âœ… Append mode for logging files

---

