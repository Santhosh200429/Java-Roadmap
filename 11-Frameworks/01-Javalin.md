# Javalin Web Framework

## What is Javalin?

**Javalin** is a lightweight, easy-to-use web framework for Java and Kotlin.

**Key Features:**
- Minimal and intuitive API
- Built on Jetty (proven web server)
- Works with Java and Kotlin
- RESTful by default
- Lightweight (~2MB JAR)

## Why Javalin?

```
Framework      | LOC for Hello World | Focus
---------------|-------------------|------------------
Spring Boot    | 20+                | Full framework
Quarkus        | 15+                | Cloud-native
Javalin        | 5-8                | Simplicity â­
Vert.x         | 15+                | Reactive
```

## Setting Up Javalin

### Maven Dependency

```xml
<dependency>
    <groupId>io.javalin</groupId>
    <artifactId>javalin</artifactId>
    <version>5.4.2</version>
</dependency>

<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-simple</artifactId>
    <version>2.0.5</version>
</dependency>
```

### Gradle Dependency

```gradle
dependencies {
    implementation 'io.javalin:javalin:5.4.2'
    implementation 'org.slf4j:slf4j-simple:2.0.5'
}
```

## Hello World

```java
import io.javalin.Javalin;

public class HelloWorld {
    public static void main(String[] args) {
        Javalin app = Javalin.create().start(7070);
        
        app.get("/", ctx -> ctx.result("Hello World!"));
        
        // Visit http://localhost:7070
    }
}
```

## REST API Basics

### CRUD Operations

```java
import io.javalin.Javalin;

public class StudentAPI {
    
    static class Student {
        int id;
        String name;
        int age;
        
        Student(int id, String name, int age) {
            this.id = id;
            this.name = name;
            this.age = age;
        }
    }
    
    static Map<Integer, Student> students = new HashMap<>();
    
    static {
        students.put(1, new Student(1, "Alice", 20));
        students.put(2, new Student(2, "Bob", 21));
    }
    
    public static void main(String[] args) {
        Javalin app = Javalin.create().start(7070);
        
        // GET all
        app.get("/students", ctx -> {
            ctx.json(students.values());
        });
        
        // GET by ID
        app.get("/students/:id", ctx -> {
            int id = ctx.pathParamAsClass("id", Integer.class).get();
            Student student = students.get(id);
            
            if (student != null) {
                ctx.json(student);
            } else {
                ctx.status(404).result("Not found");
            }
        });
        
        // POST (create)
        app.post("/students", ctx -> {
            Student student = ctx.bodyAsClass(Student.class);
            students.put(student.id, student);
            ctx.status(201).json(student);
        });
        
        // PUT (update)
        app.put("/students/:id", ctx -> {
            int id = ctx.pathParamAsClass("id", Integer.class).get();
            Student updated = ctx.bodyAsClass(Student.class);
            students.put(id, updated);
            ctx.json(updated);
        });
        
        // DELETE
        app.delete("/students/:id", ctx -> {
            int id = ctx.pathParamAsClass("id", Integer.class).get();
            students.remove(id);
            ctx.status(204);
        });
    }
}
```

## Request/Response Handling

### Path Parameters

```java
app.get("/users/:id/posts/:postId", ctx -> {
    String userId = ctx.pathParam("id");
    String postId = ctx.pathParam("postId");
    ctx.result("User: " + userId + ", Post: " + postId);
});

// Typed parameters
app.get("/items/:id", ctx -> {
    int id = ctx.pathParamAsClass("id", Integer.class).get();
    // id is now Integer
});
```

### Query Parameters

```java
app.get("/search", ctx -> {
    String query = ctx.queryParam("q");              // Optional
    String category = ctx.queryParamAsClass("cat", String.class)
                          .getOrNull();              // Can be null
    
    ctx.result("Query: " + query + ", Category: " + category);
});

// Multiple values
app.get("/filter", ctx -> {
    List<String> tags = ctx.queryParams("tag");      // All tags
    ctx.json(tags);
});
```

### Headers

```java
app.get("/headers", ctx -> {
    String auth = ctx.header("Authorization");
    String contentType = ctx.contentType();
    
    ctx.header("Custom-Header", "value");
    ctx.result("Got auth: " + auth);
});
```

### JSON Body

```java
class Product {
    int id;
    String name;
    double price;
}

app.post("/products", ctx -> {
    Product product = ctx.bodyAsClass(Product.class);
    ctx.status(201).json(product);
});
```

## Complete REST API Example

```java
import io.javalin.Javalin;
import java.util.*;

public class CompleteAPI {
    
    static class Post {
        int id;
        String title;
        String content;
        String author;
        
        Post() {}
        
        Post(int id, String title, String content, String author) {
            this.id = id;
            this.title = title;
            this.content = content;
            this.author = author;
        }
    }
    
    static class BlogAPI {
        Map<Integer, Post> posts = new HashMap<>();
        int nextId = 1;
        
        BlogAPI() {
            // Sample data
            posts.put(1, new Post(1, "First Post", "Hello World", "Alice"));
            posts.put(2, new Post(2, "Second Post", "Javalin is great", "Bob"));
            nextId = 3;
        }
        
        public void setupRoutes(Javalin app) {
            // GET all posts
            app.get("/posts", ctx -> {
                ctx.json(posts.values());
            });
            
            // GET single post
            app.get("/posts/:id", ctx -> {
                int id = ctx.pathParamAsClass("id", Integer.class).get();
                Post post = posts.get(id);
                
                if (post == null) {
                    ctx.status(404).json(Map.of("error", "Post not found"));
                } else {
                    ctx.json(post);
                }
            });
            
            // CREATE post
            app.post("/posts", ctx -> {
                Post post = ctx.bodyAsClass(Post.class);
                post.id = nextId++;
                posts.put(post.id, post);
                ctx.status(201).json(post);
            });
            
            // UPDATE post
            app.put("/posts/:id", ctx -> {
                int id = ctx.pathParamAsClass("id", Integer.class).get();
                
                if (!posts.containsKey(id)) {
                    ctx.status(404).json(Map.of("error", "Post not found"));
                    return;
                }
                
                Post updated = ctx.bodyAsClass(Post.class);
                updated.id = id;
                posts.put(id, updated);
                ctx.json(updated);
            });
            
            // DELETE post
            app.delete("/posts/:id", ctx -> {
                int id = ctx.pathParamAsClass("id", Integer.class).get();
                
                if (posts.remove(id) == null) {
                    ctx.status(404).json(Map.of("error", "Post not found"));
                } else {
                    ctx.status(204);
                }
            });
            
            // SEARCH posts
            app.get("/posts/search/by-author", ctx -> {
                String author = ctx.queryParam("author");
                
                List<Post> results = posts.values().stream()
                    .filter(p -> p.author.equalsIgnoreCase(author))
                    .toList();
                
                ctx.json(results);
            });
        }
    }
    
    public static void main(String[] args) {
        Javalin app = Javalin.create().start(8080);
        
        BlogAPI api = new BlogAPI();
        api.setupRoutes(app);
        
        System.out.println("API running on http://localhost:8080");
    }
}
```

## Middleware and Filters

### Before/After Handlers

```java
app.before(ctx -> {
    System.out.println("Before: " + ctx.method() + " " + ctx.path());
});

app.after(ctx -> {
    System.out.println("After: Status " + ctx.status());
});

// For specific paths
app.before("/api/*", ctx -> {
    System.out.println("API request");
});
```

### Custom Middleware

```java
app.before(ctx -> {
    String token = ctx.header("Authorization");
    if (token == null) {
        ctx.status(401).result("Unauthorized");
        ctx.skipRemainingHandlers();
    }
});

app.get("/protected", ctx -> {
    ctx.result("This is protected");
});
```

## Error Handling

```java
app.exception(IllegalArgumentException.class, (e, ctx) -> {
    ctx.status(400).json(Map.of("error", e.getMessage()));
});

app.exception(Exception.class, (e, ctx) -> {
    ctx.status(500).json(Map.of("error", "Internal server error"));
    e.printStackTrace();
});

// Custom error page
app.error(404, ctx -> {
    ctx.result("Resource not found");
});

app.error(500, ctx -> {
    ctx.result("Server error");
});
```

## Configuration

```java
Javalin app = Javalin.create(config -> {
    config.plugins.enableCors(cors -> {
        cors.add(it -> it
            .allowHost("localhost:3000")
            .allowCredentials(true)
        );
    });
    
    config.plugins.enableSwaggerDocs(swagger -> {
        swagger.setDocsUrl("/docs");
    });
    
    config.routing.basePath = "/api";
    config.http.prefer405over404 = true;
});
```

## Comparison with Spring Boot

### Javalin Simplicity
```java
// Javalin: 5 lines
Javalin app = Javalin.create().start(7070);
app.get("/hello", ctx -> ctx.result("Hello"));
app.post("/data", ctx -> ctx.json(ctx.bodyAsClass(Data.class)));
```

### Spring Boot Complexity
```java
// Spring Boot: More setup required
@SpringBootApplication
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}

@RestController
public class Controller {
    @GetMapping("/hello")
    public String hello() { return "Hello"; }
    
    @PostMapping("/data")
    public Data postData(@RequestBody Data data) { return data; }
}
```

## Production Considerations

```java
public class ProductionAPI {
    public static void main(String[] args) {
        Javalin app = Javalin.create(config -> {
            config.http.maxRequestSize = 10_000_000;  // 10MB
            config.router.treatMultipleSlashesAsSingleSlash = true;
            config.bundledPlugins.enableDevLogging();
            config.plugins.register(new LoggingPlugin());
        });
        
        app.start(Integer.parseInt(System.getenv("PORT") ?? "8080"));
    }
}
```

## Key Takeaways

- âœ… Javalin is lightweight and simple
- âœ… Perfect for REST APIs
- âœ… Minimal boilerplate code
- âœ… Easy routing with path/query parameters
- âœ… Built on proven Jetty server
- âœ… JSON support out of box
- âœ… Good error handling
- âœ… Works in Java and Kotlin
- âœ… Production-ready
- âœ… Ideal for microservices

---

