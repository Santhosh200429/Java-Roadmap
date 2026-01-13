# Hibernate: Object-Relational Mapping (ORM)

## What is Hibernate?

**Hibernate** is an ORM framework that converts Java objects to database tables and vice versa. Instead of writing SQL, you work with Java objects.

**Real-world analogy**: Hibernate is a translator - it converts between Java object world and database SQL world.

## JDBC vs Hibernate

### JDBC (Manual SQL)
```java
String sql = "SELECT * FROM students WHERE id = ?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setInt(1, 1);
ResultSet rs = pstmt.executeQuery();
```

### Hibernate (Object-Oriented)
```java
Student student = session.get(Student.class, 1);
```

Much cleaner!

## Why Hibernate?

- **Less boilerplate**: No SQL writing
- **Database agnostic**: Works with any database
- **Type-safe**: Compile-time checking
- **Automatic relationships**: Handles joins automatically
- **Lazy loading**: Load data when needed
- **Transaction management**: Built-in

## Setup

### Add Dependencies

Maven:
```xml
<dependency>
    <groupId>org.hibernate.orm</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>6.2.0.Final</version>
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>
```

Gradle:
```gradle
implementation 'org.hibernate.orm:hibernate-core:6.2.0.Final'
runtimeOnly 'com.mysql:mysql-connector-j:8.0.33'
```

## Configuration

### hibernate.cfg.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-configuration PUBLIC
    "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
    "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">

<hibernate-configuration>
    <session-factory>
        <!-- Database connection -->
        <property name="hibernate.connection.driver_class">
            com.mysql.cj.jdbc.Driver
        </property>
        <property name="hibernate.connection.url">
            jdbc:mysql://localhost:3306/student_db
        </property>
        <property name="hibernate.connection.username">root</property>
        <property name="hibernate.connection.password">password</property>
        
        <!-- Hibernate settings -->
        <property name="hibernate.dialect">
            org.hibernate.dialect.MySQL8Dialect
        </property>
        <property name="hibernate.hbm2ddl.auto">update</property>
        <property name="hibernate.show_sql">true</property>
        
        <!-- Entity classes -->
        <mapping class="com.example.entity.Student"/>
        <mapping class="com.example.entity.Course"/>
    </session-factory>
</hibernate-configuration>
```

## Entity Class

Entity = Java class that maps to database table

```java
import javax.persistence.*;

@Entity
@Table(name = "students")
public class Student {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    @Column(name = "student_name", length = 100)
    private String name;
    
    @Column(name = "email", unique = true)
    private String email;
    
    @Column(name = "gpa")
    private double gpa;
    
    // Constructors
    public Student() {}
    
    public Student(String name, String email, double gpa) {
        this.name = name;
        this.email = email;
        this.gpa = gpa;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public double getGpa() { return gpa; }
    public void setGpa(double gpa) { this.gpa = gpa; }
}
```

## CRUD Operations

### Hibernate Utility Class

```java
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
    private static final SessionFactory sessionFactory;
    
    static {
        try {
            sessionFactory = new Configuration()
                .configure("hibernate.cfg.xml")
                .buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }
    
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
}
```

### Create (Insert)

```java
Student student = new Student("Alice", "alice@email.com", 3.8);

Session session = HibernateUtil.getSessionFactory().openSession();
Transaction txn = session.beginTransaction();

session.persist(student);

txn.commit();
session.close();
```

### Read (Select)

```java
Session session = HibernateUtil.getSessionFactory().openSession();

// Get by ID
Student student = session.get(Student.class, 1);
System.out.println("Name: " + student.getName());

// Get all
List<Student> students = session.createQuery(
    "from Student", 
    Student.class
).list();

for (Student s : students) {
    System.out.println(s.getName());
}

session.close();
```

### Update

```java
Session session = HibernateUtil.getSessionFactory().openSession();
Transaction txn = session.beginTransaction();

Student student = session.get(Student.class, 1);
student.setGpa(3.9);
session.merge(student);

txn.commit();
session.close();
```

### Delete

```java
Session session = HibernateUtil.getSessionFactory().openSession();
Transaction txn = session.beginTransaction();

Student student = session.get(Student.class, 1);
session.remove(student);

txn.commit();
session.close();
```

## HQL Queries

**HQL** (Hibernate Query Language) - queries on objects, not tables

```java
Session session = HibernateUtil.getSessionFactory().openSession();

// Find by name
List<Student> results = session.createQuery(
    "from Student where name = :name",
    Student.class
)
.setParameter("name", "Alice")
.list();

// Find by GPA > 3.5
List<Student> topStudents = session.createQuery(
    "from Student where gpa > :minGpa",
    Student.class
)
.setParameter("minGpa", 3.5)
.list();

// Count students
long count = session.createQuery(
    "select count(*) from Student",
    Long.class
).getSingleResult();

session.close();
```

## Relationships

### One-to-Many (Course has many Students)

```java
@Entity
@Table(name = "courses")
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    private String name;
    
    @OneToMany(mappedBy = "course")
    private List<Student> students = new ArrayList<>();
    
    // Getters and setters
}

@Entity
@Table(name = "students")
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    private String name;
    
    @ManyToOne
    @JoinColumn(name = "course_id")
    private Course course;
    
    // Getters and setters
}
```

### Many-to-Many (Students and Courses)

```java
@Entity
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    private String name;
    
    @ManyToMany
    @JoinTable(
        name = "student_courses",
        joinColumns = @JoinColumn(name = "student_id"),
        inverseJoinColumns = @JoinColumn(name = "course_id")
    )
    private List<Course> courses = new ArrayList<>();
}

@Entity
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    private String name;
    
    @ManyToMany(mappedBy = "courses")
    private List<Student> students = new ArrayList<>();
}
```

## Complete Example

```java
public class StudentManagement {
    
    // Create
    public void addStudent(String name, String email, double gpa) {
        Student student = new Student(name, email, gpa);
        
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction txn = session.beginTransaction();
        
        session.persist(student);
        
        txn.commit();
        session.close();
        System.out.println("Student added!");
    }
    
    // Read
    public void displayAllStudents() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        
        List<Student> students = session.createQuery(
            "from Student",
            Student.class
        ).list();
        
        System.out.println("\n=== All Students ===");
        for (Student s : students) {
            System.out.println("ID: " + s.getId());
            System.out.println("Name: " + s.getName());
            System.out.println("Email: " + s.getEmail());
            System.out.println("GPA: " + s.getGpa());
            System.out.println();
        }
        
        session.close();
    }
    
    // Update
    public void updateGPA(int studentId, double newGPA) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction txn = session.beginTransaction();
        
        Student student = session.get(Student.class, studentId);
        if (student != null) {
            student.setGpa(newGPA);
            session.merge(student);
            txn.commit();
            System.out.println("GPA updated!");
        }
        
        session.close();
    }
    
    // Delete
    public void removeStudent(int studentId) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction txn = session.beginTransaction();
        
        Student student = session.get(Student.class, studentId);
        if (student != null) {
            session.remove(student);
            txn.commit();
            System.out.println("Student removed!");
        }
        
        session.close();
    }
    
    public static void main(String[] args) {
        StudentManagement sm = new StudentManagement();
        
        sm.addStudent("Alice", "alice@email.com", 3.8);
        sm.addStudent("Bob", "bob@email.com", 3.5);
        sm.displayAllStudents();
        sm.updateGPA(1, 3.9);
        sm.displayAllStudents();
        sm.removeStudent(2);
        sm.displayAllStudents();
    }
}
```

## Common Annotations

| Annotation | Purpose |
|-----------|---------|
| `@Entity` | Mark class as database table |
| `@Table(name="...")` | Specify table name |
| `@Id` | Primary key |
| `@GeneratedValue` | Auto-generate ID |
| `@Column` | Column properties |
| `@OneToMany` | One-to-many relationship |
| `@ManyToOne` | Many-to-one relationship |
| `@ManyToMany` | Many-to-many relationship |
| `@JoinColumn` | Foreign key column |

## Best Practices

1. **Use HQL not SQL**: Database agnostic
2. **Named queries**: Define in entity
3. **Lazy loading**: Load related objects on demand
4. **Caching**: Reduce database hits
5. **Transactions**: Always wrap modifications

## Key Takeaways

- âœ… Hibernate converts Java objects to database
- âœ… @Entity marks class as database table
- âœ… @Id marks primary key
- âœ… HQL queries on objects, not tables
- âœ… Automatic relationship handling
- âœ… Transactions ensure data consistency
- âœ… Less SQL, more Java!

---

