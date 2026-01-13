# Quarkus Framework

## What is Quarkus?

**Quarkus** - Modern, cloud-native Java framework optimized for:
- Extremely fast startup time (~40ms)
- Low memory footprint (~50MB)
- Instant scalability
- Perfect for containers and serverless

**Comparison:**
- Spring Boot: ~5s startup, ~400MB RAM
- Quarkus: ~40ms startup, ~50MB RAM

## Quick Start

### Create Project

```bash
# Using Maven
mvn create-app com.example:hello-quarkus \
    --quarkus.name=hello-quarkus

cd hello-quarkus

# Or using Gradle (optional)
```

### Project Structure

```
hello-quarkus/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/com/example/
│   │   │   ├── GreetingResource.java
│   │   │   └── GreetingService.java
│   │   └── resources/
│   │       ├── application.properties
│   │       └── META-INF/resources/
│   │           └── index.html
│   └── test/
│       └── java/com/example/
│           └── GreetingResourceTest.java
└── README.md
```

### pom.xml Setup

```xml
<?xml version="1.0"?>
<project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd"
         xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>hello-quarkus</artifactId>
    <version>1.0</version>
    
    <properties>
        <quarkus.version>3.5.0</quarkus.version>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>
    
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>io.quarkus</groupId>
                <artifactId>quarkus-bom</artifactId>
                <version>${quarkus.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
    
    <dependencies>
        <dependency>
            <groupId>io.quarkus</groupId>
            <artifactId>quarkus-rest</artifactId>
        </dependency>
        <dependency>
            <groupId>io.quarkus</groupId>
            <artifactId>quarkus-junit5</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>io.quarkus</groupId>
                <artifactId>quarkus-maven-plugin</artifactId>
                <version>${quarkus.version}</version>
            </plugin>
        </plugins>
    </build>
</project>
```

## Basic REST Endpoint

### Hello World

```java
// GreetingResource.java
package com.example;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/api/greeting")
public class GreetingResource {
    
    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return "Hello from Quarkus!";
    }
}
```

### Run Development Mode

```bash
# Run with live reload
mvn quarkus:dev

# Output:
# __  ____  __  _____   ___  __ ____  ______
# --/ __ \/ / / / _ | / _ \/ //_/ / / / __/
# -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \
# --\___\_\____/_/ |_/_/|_/_/|_|\____/___/
# 2024-01-15 10:30:00,000 INFO  [io.quarkus] Quarkus started in 0.042s
# Listening on: http://localhost:8080
```

### Test Endpoint

```bash
curl http://localhost:8080/api/greeting

# Output:
# Hello from Quarkus!
```

## REST API with CRUD

### Complete Blog API

```java
// Post.java
package com.example.model;

public class Post {
    public Long id;
    public String title;
    public String content;
    public String author;
    
    public Post() { }
    
    public Post(Long id, String title, String content, String author) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.author = author;
    }
}

// PostResource.java
package com.example.resources;

import com.example.model.Post;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

@Path("/api/posts")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class PostResource {
    
    // In-memory storage
    private static List<Post> posts = Collections.synchronizedList(
        new ArrayList<>(Arrays.asList(
            new Post(1L, "First Post", "Hello World!", "Alice"),
            new Post(2L, "Second Post", "Quarkus is fast!", "Bob")
        ))
    );
    private static AtomicLong idCounter = new AtomicLong(3);
    
    // GET all posts
    @GET
    public List<Post> getAllPosts() {
        return posts;
    }
    
    // GET single post
    @GET
    @Path("/{id}")
    public Response getPost(@PathParam("id") Long id) {
        return posts.stream()
            .filter(p -> p.id.equals(id))
            .findFirst()
            .map(p -> Response.ok(p).build())
            .orElse(Response.status(Response.Status.NOT_FOUND).build());
    }
    
    // CREATE post
    @POST
    public Response createPost(Post post) {
        post.id = idCounter.getAndIncrement();
        posts.add(post);
        return Response.status(Response.Status.CREATED).entity(post).build();
    }
    
    // UPDATE post
    @PUT
    @Path("/{id}")
    public Response updatePost(@PathParam("id") Long id, Post updatedPost) {
        return posts.stream()
            .filter(p -> p.id.equals(id))
            .findFirst()
            .map(existingPost -> {
                existingPost.title = updatedPost.title;
                existingPost.content = updatedPost.content;
                existingPost.author = updatedPost.author;
                return Response.ok(existingPost).build();
            })
            .orElse(Response.status(Response.Status.NOT_FOUND).build());
    }
    
    // DELETE post
    @DELETE
    @Path("/{id}")
    public Response deletePost(@PathParam("id") Long id) {
        if (posts.removeIf(p -> p.id.equals(id))) {
            return Response.noContent().build();
        }
        return Response.status(Response.Status.NOT_FOUND).build();
    }
    
    // SEARCH posts
    @GET
    @Path("/search")
    public List<Post> searchPosts(@QueryParam("q") String query) {
        return posts.stream()
            .filter(p -> p.title.toLowerCase().contains(query.toLowerCase()) ||
                       p.content.toLowerCase().contains(query.toLowerCase()))
            .toList();
    }
}
```

### Test the API

```bash
# GET all posts
curl http://localhost:8080/api/posts

# GET single post
curl http://localhost:8080/api/posts/1

# CREATE post
curl -X POST http://localhost:8080/api/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"New Post","content":"Content here","author":"Charlie"}'

# UPDATE post
curl -X PUT http://localhost:8080/api/posts/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Updated Title","content":"Updated content","author":"Alice"}'

# DELETE post
curl -X DELETE http://localhost:8080/api/posts/1

# SEARCH posts
curl "http://localhost:8080/api/posts/search?q=quarkus"
```

## Dependency Injection

### Service Injection

```java
// GreetingService.java
package com.example.service;

import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class GreetingService {
    
    public String greeting(String name) {
        return "Hello " + name + " from Quarkus!";
    }
}

// GreetingResource.java
package com.example;

import com.example.service.GreetingService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;

@Path("/api/hello")
@Produces(MediaType.TEXT_PLAIN)
public class GreetingResource {
    
    @Inject
    GreetingService service;
    
    @GET
    @Path("/{name}")
    public String hello(@PathParam("name") String name) {
        return service.greeting(name);
    }
}
```

### Test

```bash
curl http://localhost:8080/api/hello/Alice

# Output:
# Hello Alice from Quarkus!
```

## Configuration

### application.properties

```properties
# Server
quarkus.http.port=8080
quarkus.application.name=hello-quarkus

# Database (if using)
quarkus.datasource.db-kind=postgresql
quarkus.datasource.username=postgres
quarkus.datasource.password=postgres
quarkus.datasource.jdbc.url=jdbc:postgresql://localhost:5432/quarkus_db

# JPA/Hibernate
quarkus.hibernate-orm.database.generation=update

# Logging
quarkus.log.level=INFO
quarkus.log.console.level=DEBUG

# Production vs Development
%prod.quarkus.http.port=9000
%dev.quarkus.log.console.level=DEBUG
```

### Access Properties

```java
import org.eclipse.microprofile.config.inject.ConfigProperty;

@Path("/api/config")
public class ConfigResource {
    
    @ConfigProperty(name = "app.name", defaultValue = "MyApp")
    String appName;
    
    @GET
    public String getConfig() {
        return "App: " + appName;
    }
}
```

## Building for Production

### Native Build (Ultra-fast)

```bash
# Create native executable
mvn clean package -Pnative

# Run native application
./target/hello-quarkus-1.0-runner

# Output:
# __  ____  __  _____   ___  __ ____  ______
# --/ __ \/ / / / _ | / _ \/ //_/ / / / __/
# -/ /_/ / /_/ / __ |/ , _/ ,< / /_/ /\ \
# --\___\_\____/_/ |_/_/|_/_/|_|\____/___/
# INFO  [io.quarkus] Quarkus started in 0.012s
# Startup time: 12ms
# Memory: 45MB
```

### JAR Build

```bash
# Standard JAR (faster than native, not as optimized)
mvn clean package

# Run
java -jar target/hello-quarkus-1.0-runner.jar

# Startup time: ~400ms
# Memory: ~150MB
```

## Testing

### Unit Tests

```java
package com.example;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;

@QuarkusTest
public class GreetingResourceTest {
    
    @Test
    public void testHelloEndpoint() {
        given()
            .when().get("/api/greeting")
            .then()
            .statusCode(200)
            .body(is("Hello from Quarkus!"));
    }
    
    @Test
    public void testHelloWithName() {
        given()
            .when().get("/api/hello/Alice")
            .then()
            .statusCode(200)
            .body(is("Hello Alice from Quarkus!"));
    }
}
```

### Run Tests

```bash
mvn test

# Or in dev mode
mvn quarkus:dev
# Run tests while server is running (in separate terminal)
mvn test
```

## Extensions (Add Features)

### Common Extensions

```bash
# REST
mvn quarkus:add-extension -Dextensions="quarkus-rest"

# Database
mvn quarkus:add-extension -Dextensions="quarkus-jdbc-postgresql"
mvn quarkus:add-extension -Dextensions="quarkus-hibernate-orm"

# Security
mvn quarkus:add-extension -Dextensions="quarkus-security,quarkus-jwt"

# Metrics
mvn quarkus:add-extension -Dextensions="quarkus-micrometer-registry-prometheus"

# JSON Logging
mvn quarkus:add-extension -Dextensions="quarkus-logging-json"
```

### Or Edit pom.xml

```xml
<dependencies>
    <!-- REST -->
    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-rest</artifactId>
    </dependency>
    
    <!-- PostgreSQL -->
    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-jdbc-postgresql</artifactId>
    </dependency>
    
    <!-- Hibernate ORM -->
    <dependency>
        <groupId>io.quarkus</groupId>
        <artifactId>quarkus-hibernate-orm</artifactId>
    </dependency>
</dependencies>
```

## Complete Example: REST API with Database

```java
// User.java (Entity)
package com.example.model;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    
    public String name;
    public String email;
    
    public User() { }
    
    public User(String name, String email) {
        this.name = name;
        this.email = email;
    }
}

// UserRepository.java
package com.example.repository;

import com.example.model.User;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class UserRepository implements PanacheRepository<User> {
    
    public User findByEmail(String email) {
        return find("email", email).firstResult();
    }
}

// UserResource.java
package com.example.resource;

import com.example.model.User;
import com.example.repository.UserRepository;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/api/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserResource {
    
    @Inject
    UserRepository repository;
    
    @GET
    public Response getAllUsers() {
        return Response.ok(repository.listAll()).build();
    }
    
    @GET
    @Path("/{id}")
    public Response getUser(@PathParam("id") Long id) {
        User user = repository.findById(id);
        return user != null ? Response.ok(user).build() 
                           : Response.status(404).build();
    }
    
    @POST
    public Response createUser(User user) {
        repository.persist(user);
        return Response.status(Response.Status.CREATED).entity(user).build();
    }
    
    @PUT
    @Path("/{id}")
    public Response updateUser(@PathParam("id") Long id, User updatedUser) {
        User user = repository.findById(id);
        if (user == null) return Response.status(404).build();
        
        user.name = updatedUser.name;
        user.email = updatedUser.email;
        return Response.ok(user).build();
    }
    
    @DELETE
    @Path("/{id}")
    public Response deleteUser(@PathParam("id") Long id) {
        repository.deleteById(id);
        return Response.noContent().build();
    }
}
```

## Quarkus vs Spring Boot

| Feature | Quarkus | Spring Boot |
|---------|---------|------------|
| Startup | 40ms | 5s |
| Memory | 50MB | 400MB |
| Native Binary | ✓ | ✗ |
| Learning Curve | Easy | Medium |
| Maturity | Growing | Mature |
| Ecosystem | Smaller | Huge |
| Cloud Native | ✓ | ✓ |

## Key Takeaways

- ✅ Quarkus: Ultra-fast startup and low memory
- ✅ Perfect for containers and serverless
- ✅ REST endpoints with simple annotations
- ✅ Dependency injection with @Inject
- ✅ Configuration via application.properties
- ✅ Native builds for maximum performance
- ✅ Database support with JPA/Hibernate
- ✅ Live reload in development mode
- ✅ Easy testing with @QuarkusTest
- ✅ Lighter alternative to Spring Boot

---

**Previous ←** Javalin: [Lightweight Framework](/11-Frameworks/01-Javalin.md)
