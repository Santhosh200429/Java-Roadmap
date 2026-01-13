# JDBC: Database Connectivity

## What is JDBC?

**JDBC** (Java Database Connectivity) is a Java API for connecting to databases. It provides a standard interface to work with any SQL database.

```
Java Program → JDBC Driver → Database
```

## Database Setup

### Download MySQL JDBC Driver

1. Download MySQL Connector/J from mysql.com
2. Add JAR file to your project classpath
3. You're ready to connect!

## Connecting to Database

### Step 1: Load Driver

```java
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
} catch (ClassNotFoundException e) {
    e.printStackTrace();
}
```

### Step 2: Create Connection

```java
import java.sql.*;

String url = "jdbc:mysql://localhost:3306/mydb";
String user = "root";
String password = "yourpassword";

try {
    Connection connection = DriverManager.getConnection(url, user, password);
    System.out.println("Connected to database!");
} catch (SQLException e) {
    e.printStackTrace();
}
```

## Executing Queries

### SELECT Query

```java
String query = "SELECT * FROM students";
Statement statement = connection.createStatement();
ResultSet resultSet = statement.executeQuery(query);

while (resultSet.next()) {
    int id = resultSet.getInt("id");
    String name = resultSet.getString("name");
    int age = resultSet.getInt("age");
    
    System.out.println(id + " - " + name + " - " + age);
}
```

### INSERT Query

```java
String query = "INSERT INTO students (name, age) VALUES (?, ?)";
PreparedStatement statement = connection.prepareStatement(query);
statement.setString(1, "Alice");
statement.setInt(2, 20);

int rows = statement.executeUpdate();
System.out.println(rows + " row inserted");
```

### UPDATE Query

```java
String query = "UPDATE students SET age = ? WHERE name = ?";
PreparedStatement statement = connection.prepareStatement(query);
statement.setInt(1, 21);
statement.setString(2, "Alice");

int rows = statement.executeUpdate();
System.out.println(rows + " rows updated");
```

### DELETE Query

```java
String query = "DELETE FROM students WHERE id = ?";
PreparedStatement statement = connection.prepareStatement(query);
statement.setInt(1, 1);

int rows = statement.executeUpdate();
System.out.println(rows + " rows deleted");
```

## Using PreparedStatement (Preferred)

Prevents SQL injection and is more efficient:

```java
String query = "SELECT * FROM students WHERE age > ? AND name LIKE ?";
PreparedStatement statement = connection.prepareStatement(query);
statement.setInt(1, 18);
statement.setString(2, "A%");  // Names starting with A

ResultSet resultSet = statement.executeQuery();
while (resultSet.next()) {
    System.out.println(resultSet.getString("name"));
}
```

## Complete Example: Student Database

```java
import java.sql.*;

public class StudentDB {
    static final String URL = "jdbc:mysql://localhost:3306/school";
    static final String USER = "root";
    static final String PASSWORD = "password";
    
    public static void main(String[] args) {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
            // Insert
            insertStudent(conn, "Alice", 20);
            
            // Display all
            displayStudents(conn);
            
            // Update
            updateStudent(conn, 1, 21);
            
            // Delete
            deleteStudent(conn, 1);
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    static void insertStudent(Connection conn, String name, int age) throws SQLException {
        String query = "INSERT INTO students (name, age) VALUES (?, ?)";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, name);
        stmt.setInt(2, age);
        stmt.executeUpdate();
        System.out.println("Student inserted");
    }
    
    static void displayStudents(Connection conn) throws SQLException {
        String query = "SELECT * FROM students";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        
        while (rs.next()) {
            System.out.println(rs.getInt("id") + " - " + 
                             rs.getString("name") + " - " + 
                             rs.getInt("age"));
        }
    }
    
    static void updateStudent(Connection conn, int id, int age) throws SQLException {
        String query = "UPDATE students SET age = ? WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setInt(1, age);
        stmt.setInt(2, id);
        stmt.executeUpdate();
        System.out.println("Student updated");
    }
    
    static void deleteStudent(Connection conn, int id) throws SQLException {
        String query = "DELETE FROM students WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setInt(1, id);
        stmt.executeUpdate();
        System.out.println("Student deleted");
    }
}
```

## Best Practices

```java
// ✅ Use try-with-resources (auto-close)
try (Connection conn = DriverManager.getConnection(url, user, password);
     PreparedStatement stmt = conn.prepareStatement(query)) {
    // Code here
} catch (SQLException e) {
    e.printStackTrace();
}

// ✅ Use PreparedStatement (prevents SQL injection)
String query = "SELECT * FROM users WHERE email = ?";
PreparedStatement stmt = conn.prepareStatement(query);
stmt.setString(1, email);

// ❌ Never do this (vulnerable)
String query = "SELECT * FROM users WHERE email = '" + email + "'";
```

## Key Takeaways

- ✅ JDBC connects Java to databases
- ✅ Use PreparedStatement for queries
- ✅ Always close connections
- ✅ Handle SQLExceptions appropriately
- ✅ Use try-with-resources for auto-closing
- ✅ Avoid SQL injection with parameterized queries
- ✅ Check ResultSet with next() before accessing

---

**JDBC enables Java to work with any SQL database.**
